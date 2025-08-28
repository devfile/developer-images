#!/bin/bash

# Replace /home/tooling/* path to /home/user/* path
replace_user_home() {
  echo "$1" | sed "s|^/home/tooling|$HOME|"
}

# Ensure $HOME exists when starting
if [ ! -d "${HOME}" ]; then
  mkdir -p "${HOME}"
fi

# Configure container builds to use vfs or fuse-overlayfs
if [ ! -d "${HOME}/.config/containers" ]; then
  mkdir -p ${HOME}/.config/containers
  if [ -c "/dev/fuse" ] && [ -f "/usr/bin/fuse-overlayfs" ]; then
    (echo '[storage]';echo 'driver = "overlay"';echo '[storage.options.overlay]';echo 'mount_program = "/usr/bin/fuse-overlayfs"') > ${HOME}/.config/containers/storage.conf
  else
    (echo '[storage]';echo 'driver = "vfs"') > "${HOME}"/.config/containers/storage.conf
  fi
fi

# Setup $PS1 for a consistent and reasonable prompt
if [ -w "${HOME}" ] && [ ! -f "${HOME}"/.bashrc ]; then
  echo "PS1='[\u@\h \W]\$ '" > "${HOME}"/.bashrc
fi

# Add current (arbitrary) user to /etc/passwd and /etc/group
if ! whoami &> /dev/null; then
  if [ -w /etc/passwd ]; then
    echo "${USER_NAME:-user}:x:$(id -u):0:${USER_NAME:-user} user:${HOME}:/bin/bash" >> /etc/passwd
    echo "${USER_NAME:-user}:x:$(id -u):" >> /etc/group
  fi
fi

source kubedock_setup


# Stow
## Required for https://github.com/eclipse/che/issues/22412

# /home/user/ will be mounted to by a PVC if persistUserHome is enabled
mountpoint -q /home/user/; HOME_USER_MOUNTED=$?

# This file will be created after stowing, to guard from executing stow everytime the container is started
STOW_COMPLETE=/home/user/.stow_completed

if [ $HOME_USER_MOUNTED -eq 0 ] && [ ! -f $STOW_COMPLETE ]; then
    # There may be regular, non-symlink files in /home/user that match the
    # pathing of files in /home/tooling. Stow will error out when it tries to
    # stow on top of that. Instead, we can append to the current
    # /home/tooling/.stow-local-ignore file to ignore pre-existing,
    # non-symlinked files in /home/user that match those in /home/tooling before
    # we run stow.
    #
    # Create two text files containing a sorted path-based list of files in
    # /home/tooling and /home/user. Cut off "/home/user" and "/home/tooling" and
    # only get the sub-paths so we can do a proper comparison
    #
    # In the case of /home/user, we want regular file types and not symbolic
    # links. 
    find /home/user -type f -xtype f -print  | sort | sed 's|/home/user||g' > /tmp/user.txt
    find /home/tooling -print | sort | sed 's|/home/tooling||g' > /tmp/tooling.txt
    # We compare the two files, trying to find files that exist in /home/user
    # and /home/tooling. Being that the files that get flagged here are not
    # already synlinks, we will want to ignore them.
    IGNORE_FILES="$(comm -12 /tmp/user.txt /tmp/tooling.txt)"
    # We no longer require the file lists, so remove them
    rm /tmp/user.txt /tmp/tooling.txt
    # For each file we need to ignore, append them to
    # /home/tooling/.stow-local-ignore.
    for f in $IGNORE_FILES; do echo "${f}" >> /home/tooling/.stow-local-ignore;done
    # We are now ready to run stow
    #
    # Create symbolic links from /home/tooling/ -> /home/user/
    stow . -t /home/user/ -d /home/tooling/ --no-folding -v 2 > /tmp/stow.log 2>&1
    touch $STOW_COMPLETE
fi

# Read .copy-files and copy files from /home/tooling to /home/user
if [ -f "/home/tooling/.copy-files" ]; then
    echo "Processing .copy-files..."
    while IFS= read -r line || [[ -n "$line" ]]; do
        # Skip empty and commented lines
        [[ -z "$line" || "$line" == \#* ]] && continue

        if [ -e "/home/tooling/$line" ]; then
            tooling_path=$(realpath "/home/tooling/$line")
            
            # Determine target path based on whether source is a directory
            if [ -d "$tooling_path" ]; then
                # For directories: copy to parent directory (e.g., dir1/dir2 -> /home/user/dir1/)
                target_parent=$(dirname "${HOME}/${line}")
                target_full="$target_parent/$(basename "$tooling_path")"
                
                # Skip if target directory already exists
                if [ -d "$target_full" ]; then
                    echo "Directory $target_full already exists, skipping..."
                    continue
                fi
                
                echo "Copying directory $tooling_path to $target_parent/"
                mkdir -p "$target_parent"
                cp --no-clobber -r "$tooling_path" "$target_parent/"
            else
                # For files: copy to exact target path
                target_full="${HOME}/${line}"
                target_parent=$(dirname "$target_full")

                # Skip if target file already exists
                if [ -e "$target_full" ]; then
                    echo "File $target_full already exists, skipping..."
                    continue
                fi
                
                echo "Copying file $tooling_path to $target_full"
                mkdir -p "$target_parent"
                cp --no-clobber -r "$tooling_path" "$target_full"
            fi
        else
            echo "Warning: /home/tooling/$line does not exist, skipping..."
        fi
    done < /home/tooling/.copy-files
    echo "Finished processing .copy-files."
else
    echo "No .copy-files found, skipping copy operation."
fi

# Create symlinks from /home/tooling/.config to /home/user/.config
# Only create symlinks for files that don't already exist in destination.
# This is done because stow ignores the .config directory.
if [ -d /home/tooling/.config ]; then
    echo "Creating .config symlinks for files that don't already exist..."
    
    # Find all files recursively in /home/tooling/.config
    find /home/tooling/.config -type f | while read -r file; do
        # Get the relative path from /home/tooling/.config
        relative_path="${file#/home/tooling/.config/}"
        
        # Determine target path in /home/user/.config
        target_file="${HOME}/.config/${relative_path}"
        target_dir=$(dirname "$target_file")
        
        # Only create symlink if target file doesn't exist
        if [ ! -e "$target_file" ]; then
            # Create target directory if it doesn't exist
            mkdir -p "$target_dir"
            # Create symbolic link
            ln -s "$file" "$target_file"
            echo "Created symlink: $target_file -> $file"
        else
            echo "File $target_file already exists, skipping..."
        fi
    done
    
    echo "Finished creating .config symlinks."
fi

exec "$@"
