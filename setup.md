<!--lint disable list-item-indent-->
<!--lint disable list-item-bullet-indent-->

# Setup
here i will collect all information about what scripts or tools to use
to get to a nice working overall experience...



## touch & pen input

copy config & and reboot.

```bash
sudo cp 99-touch_pen_input.conf /usr/share/X11/xorg.conf.d/
```
<!--
copy rules & reload to activate.

```bash
sudo cp 99-touch_pen_input.rules /etc/udev/rules.d/
sudo udevadm control --reload-rules
``` -->
