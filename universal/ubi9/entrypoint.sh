#!/bin/bash

source kubedock_setup

# Stow
## Required for https://github.com/eclipse/che/issues/22412

# /home/user/ will be mounted to by a PVC if persistUserHome is enabled
mountpoint -q /home/user/; HOME_USER_MOUNTED=$?

# This file will be created after stowing, to guard from executing stow everytime the container is started
STOW_COMPLETE=/home/user/.stow_completed

if [ $HOME_USER_MOUNTED -eq 0 ] && [ ! -f $STOW_COMPLETE ]; then
    # Create symbolic links from /home/tooling/ -> /home/user/
    stow . -t /home/user/ -d /home/tooling/ --no-folding -v 2 > /tmp/stow.log 2>&1
    # Vim does not permit .viminfo to be a symbolic link for security reasons, so manually copy it
    cp /home/tooling/.viminfo /home/user/.viminfo
    # We have to restore bash-related files back onto /home/user/ (since they will have been overwritten by the PVC)
    # but we don't want them to be symbolic links (so that they persist on the PVC)
    cp /home/tooling/.bashrc /home/user/.bashrc
    cp /home/tooling/.bash_profile /home/user/.bash_profile
    touch $STOW_COMPLETE
fi

exec "$@"
