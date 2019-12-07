<!--lint disable list-item-indent-->
<!--lint disable list-item-bullet-indent-->

# Setup
here i will collect all information about what scripts or tools to use
to get to a nice working overall experience...



## touch & pen input

copy config (and reboot)

```bash
sudo cp 99-touch_pen_input.conf /usr/share/X11/xorg.conf.d/
```

this setups the touchscreens to work on there own screen-area.
and setups the pen input to be handled by the wacom / Graphic-Tablet driver.
the IDs are [submitted to the libwacom team](https://github.com/linuxwacom/libwacom/pull/186).
but it can take some time till it lands in the official packages...
if you want to try directly copy the two files
- [elan-29b6.tablet](https://github.com/s-light/libwacom/blob/ASUS_ZenBook_Pro_Duo/data/elan-29b6.tablet)
- [elan-29a1.tablet](https://github.com/s-light/libwacom/blob/ASUS_ZenBook_Pro_Duo/data/elan-29a1.tablet)


### enable multitouch input in firefox

```bash
$ echo -e "\n# setup firefox multitouch \nMOZ_USE_XINPUT2=1\n" >> ~/.profile
```
