#!/usr/bin/env sh

# Startup Xvfb
Xvfb -ac :0 -screen 0 1280x1024x16 > /dev/null 2>&1 &

# Wait for Xvfb to start
sleep 2

# Export some variables
export DISPLAY=:0
export DBUS_SESSION_BUS_ADDRESS=autolaunch:
export $(dbus-launch)
export NSS_USE_SHARED_DB=ENABLED

# start dbus service manually
mkdir -p /var/run/dbus && dbus-daemon --config-file=/usr/share/dbus-1/system.conf --print-address
service dbus start

# symlink to create expected machine-id folder
rm -f /etc/machine-id
ln -s /var/lib/dbus/machine-id /etc/machine-id

# Set XAUTHORITY environment variable
export XAUTHORITY=/root/.Xauthority

# Run commands
cmd=$@
echo "Running '$cmd'!"
if $cmd; then
    # no op
    echo "Successfully ran '$cmd'"
else
    exit_code=$?
    echo "Failure running '$cmd', exited with $exit_code"
    exit $exit_code
fi