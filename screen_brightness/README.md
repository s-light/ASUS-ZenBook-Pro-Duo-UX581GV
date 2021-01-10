# Screen Brightness Helpers

## Overview
The script ux581_brightness.sh reads the currently requested brightness
and the maximum brightness and generates a percent representation. There
is a min/max percent brightness for both the OLED and Screenpad displays
and the percentage is scaled accordingly. The Screenpad brightness is
then scaled to 0-255 (0x00-0xFF) for the /proc/acpi/call request that
Plippo documented in s-light#1

The path and service files have been included for SystemD to set up
inotifywatch on the brightness file and an INSTALL text file has been
included to show where to place the files and what to run to enable them
on startup.

Since this is reading the kernel values directly, it is unnecessary to
make any custom hotkey bindings or set up any custom scripts that need
to be manually called to change the brightness.

Note that this only currently works with X11. I don't have a system set
up yet with Wayland and so am not sure if there's an equivalent command
to xrandr to change the brightness of the OLED screen.

## Required Dependencies
- acpi_call (kernel module)
- awk
- bc
- getent
- inotifywait
- sed
- xauth
- xrandr

To install these with Debian based systems
```
sudo apt install acpi-call-dkms bc inotify-tools libc-bin sed xauth x11-xserver-utils
```

Make sure the acpi_call module is loaded
```
sudo modprobe acpi_call
```
and load this module on startup by appending the following line into `/etc/modules-load.d/modules.conf`
```
acpi_call
```

## Additional info and resources
- https://github.com/lawleagle/oled-linux
- https://github.com/s-light/ASUS-ZenBook-Pro-Duo-UX581GV/issues/1
