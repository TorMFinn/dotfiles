#!/bin/sh

# Start sxhkd for keyboard shortcuts
exec sxhkd -c ~/.config/sxhkd/sxhkdrc_wmaker &

# The best ever window manager
exec wmaker
