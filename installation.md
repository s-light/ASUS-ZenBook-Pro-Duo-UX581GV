<!--lint disable list-item-indent-->
<!--lint disable list-item-bullet-indent-->

# Installation



## prepare DualBoot
if you want to use windows in dual-boot mode do these preparations:
- boot windows
    - deactivate BitLocker
        - open Start Menu
        - search for `BitLocker`
        - then `Turn Off`
    - Click on Start-Menu - Power
    - Shift-Click on `Restart`
    - Choose `Troubleshoot` - `Advanced Options` - `Start-up Settings` - `Restart`
    - This restarts the PC - and you have to go directly into the BIOS settings..

## BIOS settings
- `F2` to get into bios.
    - `F7` to activate Advanced Mode
    - Tab `Advanced`
        - `SATA Configuration`
            - `SATA Mode Selection` to `AHCI`
    - Tab `Boot`
        - `Fast Boot` to `Disabled`
    - Tab `Security`
        - `Secure Boot Control` to `Disabled`
    - `F10` to save

## check
- boot windows - this time it boots in safe mode.
    just shutdown or restart.
    This is needed to get windows to use the new SATA Mode.
- boot again to check if all is still working

## install
- insert your Kubuntu 19.10 Live USB-Stick
- push power button, Press `F2` to go into BIOS
- `F8` to show boot options: choose your USB-Stick.
- go through the installation...

## adjustments
- start Kubuntu
- setup display orientation & scaling
    - `Alt+Space` `displays`
    - move second display to bottom
    - click `Scale Display` → i used `1.7`
    - restart
- if you have chosen to not install proprietary drivers
    - connect the device to the Internet with cable or with mobile-broadband
    - setup this connection in the network manager
    - make updates
    - restart
- for me now WIFI also worked

with this the installation is completed.
now have a look at [setup](setup.md) to do adjustments and additional configurations.
