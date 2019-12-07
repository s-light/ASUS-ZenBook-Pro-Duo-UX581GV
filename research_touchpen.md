<!--lint disable list-item-indent-->
<!--lint disable list-item-bullet-indent-->
# multi touch & pen input
all research regarding (multi) touch & pen input

<!-- TOC depthFrom:1 depthTo:6 withLinks:1 updateOnSave:1 orderedList:0 -->

- [multi touch & pen input](#multi-touch-pen-input)
- [test your devices](#test-your-devices)
- [find props](#find-props)
- [mapping](#mapping)
- [multitouch](#multitouch)
	- [find device path](#find-device-path)
	- [test](#test)
	- [GUI test](#gui-test)
	- [Firefox](#firefox)

<!-- /TOC -->

---

good base information in this askubuntu answer:
[Touchscreen calibration with dual monitors (NVidia and xinput)](https://askubuntu.com/a/923158/207905)

link collection:
- [xorg.conf INPUTDEVICE SECTION](https://www.x.org/releases/current/doc/man/man5/xorg.conf.5.xhtml#heading8)
- [How to set xinput properties triggered by udev device connection?](https://unix.stackexchange.com/a/439528/77378)
- [archlinux Touchscreen](https://wiki.archlinux.org/index.php/Touchscreen)
- [How to configure the TrackPoint](http://www.thinkwiki.org/wiki/How_to_configure_the_TrackPoint)
- [ELAN & wacom driver](https://www.reddit.com/r/linuxhardware/comments/9098wd/bamboo_ink_button_3_not_working/e2qubkz)





# test your devices

list all your devices:
```bash
$ xinput
⎡ Virtual core pointer                          id=2    [master pointer  (3)]
⎜   ↳ Virtual core XTEST pointer                id=4    [slave  pointer  (2)]
⎜   ↳ Logitech USB Laser Mouse                  id=10   [slave  pointer  (2)]
⎜   ↳ ELAN9009:00 04F3:29A1                     id=17   [slave  pointer  (2)]
⎜   ↳ ELAN1406:00 04F3:3101 Touchpad            id=13   [slave  pointer  (2)]
⎜   ↳ ELAN9008:00 04F3:29B6                     id=15   [slave  pointer  (2)]
⎜   ↳ ELAN9009:00 04F3:29A1 Pen (0)             id=21   [slave  pointer  (2)]
⎜   ↳ ELAN9008:00 04F3:29B6 Pen (0)             id=22   [slave  pointer  (2)]
⎣ Virtual core keyboard                         id=3    [master keyboard (2)]
    ↳ Virtual core XTEST keyboard               id=5    [slave  keyboard (3)]
    ↳ Power Button                              id=6    [slave  keyboard (3)]
    ↳ Video Bus                                 id=7    [slave  keyboard (3)]
    ↳ Video Bus                                 id=8    [slave  keyboard (3)]
    ↳ Power Button                              id=9    [slave  keyboard (3)]
    ↳ USB2.0 HD IR UVC WebCam: USB2.0           id=11   [slave  keyboard (3)]
    ↳ ELAN1406:00 04F3:3101 Keyboard            id=14   [slave  keyboard (3)]
    ↳ ELAN9008:00 04F3:29B6                     id=16   [slave  keyboard (3)]
    ↳ ELAN9009:00 04F3:29A1                     id=18   [slave  keyboard (3)]
    ↳ AT Translated Set 2 keyboard              id=20   [slave  keyboard (3)]
    ↳ USB2.0 HD IR UVC WebCam: USB2.0           id=12   [slave  keyboard (3)]
    ↳ Asus WMI hotkeys                          id=19   [slave  keyboard (3)]
```

test pen input
```bash
$ xinput test 21
motion a[0]=10982684 a[1]=11576141 a[2]=0
motion a[0]=10984263 a[1]=11573411 a[2]=0
motion a[0]=10987421 a[1]=11565220 a[2]=0
motion a[0]=11002423 a[1]=11532458 a[2]=0
motion a[0]=11037163 a[1]=11456012 a[2]=0
```




# find props

get props
```bash
xinput --list-props "pointer:ELAN9008:00 04F3:29B6"
```

test mapping:
```bash
$ xinput map-to-output  "pointer:ELAN9008:00 04F3:29B6" eDP-1-1
$ xinput --list-props "pointer:ELAN9008:00 04F3:29B6"
Device 'ELAN9008:00 04F3:29B6':
        Device Enabled (175):   1
        Coordinate Transformation Matrix (177): 1.000000, 0.000000, 0.000000, 0.000000, 0.662577, 0.000000, 0.000000, 0.000000, 1.000000
        libinput Calibration Matrix (345):      1.000000, 0.000000, 0.000000, 0.000000, 1.000000, 0.000000, 0.000000, 0.000000, 1.000000
        libinput Calibration Matrix Default (346):      1.000000, 0.000000, 0.000000, 0.000000, 1.000000, 0.000000, 0.000000, 0.000000, 1.000000
        libinput Send Events Modes Available (297):     1, 0
        libinput Send Events Mode Enabled (298):        0, 0
        libinput Send Events Mode Enabled Default (299):        0, 0
        Device Node (300):      "/dev/input/event9"
        Device Product ID (301):        1267, 10678
```

```bash
$ xinput --list-props "ELAN9008:00 04F3:29B6 Pen (0)"
Device 'ELAN9008:00 04F3:29B6 Pen (0)':
        Device Enabled (175):   1
        Coordinate Transformation Matrix (177): 1.000000, 0.000000, 0.000000, 0.000000, 1.000000, 0.000000, 0.000000, 0.000000, 1.000000
        Device Node (300):      "/dev/input/event10"
        Device Product ID (301):        1267, 10678
        libinput Tablet Tool Pressurecurve (680):       0.000000, 0.000000, 0.000000, 0.000000, 1.000000, 1.000000, 1.000000, 1.000000

```

# mapping

[InputCoordinateTransformation](https://wiki.ubuntu.com/X/InputCoordinateTransformation)

check logfile: [/var/log/Xorg.0.log](/var/log/Xorg.0.log)

experiments:
```bash
$ xinput set-prop "pointer:ELAN9008:00 04F3:29B6" 'Coordinate Transformation Matrix' 1.000000 0.000000 0.000000 0.000000 0.662577 0.000000 0.000000 0.000000 1.000000
$ xinput set-prop "ELAN9008:00 04F3:29B6 Pen (0)" 'Coordinate Transformation Matrix' 1.000000 0.000000 0.000000 0.000000 0.662577 0.000000 0.000000 0.000000 1.000000
```

99-touch_pen_input.conf
```
Section "InputClass"
        Identifier                      "TopTouchScreen_Mapping"
        MatchProduct                    "ELAN9008:00 04F3:29B6"
        MatchIsTouchscreen  "on"
        # Option  "CoordinateTransformationMatrix"  "1.000000 0.000000 0.000000 0.000000 0.662577 0.000000 0.000000 0.000000 1.000000"
        Option  "CalibrationMatrix"  "1.000000 0.000000 0.000000 0.000000 0.662577 0.000000 0.000000 0.000000 1.000000"
EndSection
```
`CoordinateTransformationMatrix` does not work -
it is not part of libinput.
i dont know if it is possible to set it with the InputClass section.



## 'wacom' support

the [ASUS ZenBook Pro Duo UX581GV](https://www.asus.com/Laptops/ZenBook-Pro-Duo-UX581GV/Tech-Specs/) has two internal screens -
- top/main OLED screen (345mm x 194mm → 13.59in x 7.64in)
- bottom/secondary TFT screen (345mm x 99mm → 13.59in x 3.9in)
both with touch and pen support.

[sysinfo.yzHeVK384m.tar.gz](https://github.com/linuxwacom/wacom-hid-descriptors/files/3934973/sysinfo.yzHeVK384m.tar.gz)












# multitouch

[test for multitouch support](https://wiki.ubuntu.com/Multitouch/Testing/CheckingMTDevice)


add yourself to the input group
```bash
$ sudo usermod -a -G input $USER
```
now log out and log in again to activate..

install needed tools
```bash
sudo  install input-utils mtdev-tools
```

## find device path

```bash
$ lsinput
/dev/input/event0
   ...
/dev/input/event1
   ...
/dev/input/event2
   ...
/dev/input/event3
   ...
/dev/input/event4
   ...
/dev/input/event5
   ...
/dev/input/event6
   ...
/dev/input/event7
   ...
/dev/input/event8
   ...

/dev/input/event9
   bustype : BUS_I2C
   vendor  : 0x4f3
   product : 0x29b6
   version : 256
   name    : "ELAN9008:00 04F3:29B6"
   phys    : "i2c-ELAN9008:00"
   uniq    : ""
   bits ev : (null) (null) (null) (null)

/dev/input/event10
   bustype : BUS_I2C
   vendor  : 0x4f3
   product : 0x29b6
   version : 256
   name    : "ELAN9008:00 04F3:29B6"
   phys    : "i2c-ELAN9008:00"
   uniq    : ""
   bits ev : (null) (null) (null) (null)

/dev/input/event11
   bustype : BUS_I2C
   vendor  : 0x4f3
   product : 0x29a1
   version : 256
   name    : "ELAN9009:00 04F3:29A1"
   phys    : "i2c-ELAN9009:00"
   uniq    : ""
   bits ev : (null) (null) (null) (null)

/dev/input/event12
   bustype : BUS_I2C
   vendor  : 0x4f3
   product : 0x29a1
   version : 256
   name    : "ELAN9009:00 04F3:29A1"
   phys    : "i2c-ELAN9009:00"
   uniq    : ""
   bits ev : (null) (null) (null) (null)

/dev/input/event13
   ...
/dev/input/event23
   ...
/dev/input/event24
   ...
/dev/input/event25
   ...
/dev/input/event26
   ...
/dev/input/event27
   ...
/dev/input/event28
   ...
/dev/input/event29
   ...

/dev/input/event30
   bustype : BUS_I2C
   vendor  : 0x4f3
   product : 0x3101
   version : 256
   name    : "ELAN1406:00 04F3:3101 Touchpad"
   phys    : "i2c-ELAN1406:00"
   uniq    : ""
   bits ev : (null) (null) (null) (null)

/dev/input/event31
   bustype : BUS_I2C
   vendor  : 0x4f3
   product : 0x3101
   version : 256
   name    : "ELAN1406:00 04F3:3101 Keyboard"
   phys    : "i2c-ELAN1406:00"
   uniq    : ""
   bits ev : (null) (null) (null) (null) (null)

```

## test
```bash
$ input-events 30
/dev/input/event30
   bustype : BUS_I2C
   vendor  : 0x4f3
   product : 0x3101
   version : 256
   name    : "ELAN1406:00 04F3:3101 Touchpad"
   phys    : "i2c-ELAN1406:00"
   uniq    : ""
   bits ev : (null) (null) (null) (null)

waiting for events
19:00:50.354795: (null) ??? 0
19:00:50.354795: (null) ??? 22
19:00:50.354795: (null) ??? 815
19:00:50.354795: (null) ??? 799
19:00:50.354795: (null) ??? (0x14a) pressed
19:00:50.354795: (null) ??? (0x145) pressed
19:00:50.354795: (null) ??? 815
19:00:50.354795: (null) ??? 799
19:00:50.354795: (null) ??? 0
....
19:00:50.452432: (null) ??? -1
19:00:50.452432: (null) ??? (0x14a) released
19:00:50.452432: (null) ??? (0x145) released
19:00:50.452432: (null) ??? 93000
19:00:50.452432: (null) code=0 value=0
timeout, quitting
```


```bash
$ mtdev-test /dev/input/event9
supported mt events:
   ABS_MT_SLOT
   ABS_MT_TOUCH_MAJOR
   ABS_MT_TOUCH_MINOR
   ABS_MT_ORIENTATION
   ABS_MT_POSITION_X
   ABS_MT_POSITION_Y
   ABS_MT_TRACKING_ID
016edc558269 00 3 002f 0
016edc558269 00 3 0039 121
016edc558269 00 3 0035 3019
016edc558269 00 3 0036 1017
016edc558269 00 3 003c 3019
016edc558269 00 3 003d 1017
```



## GUI test

we will use the [Kivy example `./examples/demo/touchtracer`](https://kivy.org/doc/stable/gettingstarted/examples.html) :-)

install kivy
```bash
$ sudo apt install python3-venv python3-kivy
```

make folder for kivy test  
create venv
```bash
$ mkdir kivy
$ cd kivy
create venv for kivy experiments
$ python3 -m venv kivy_testing
```

activate venv  
install examples
exit venv
```bash
$ source kivy_testing/bin/activate
$ pip install kivy_examples
$ deactivate
```

start
```bash
kivy$ python3  ./kivy_testing/share/kivy-examples/demo/touchtracer/main.py      
[INFO   ] [Logger      ] Record log in /home/stefan/.kivy/logs/kivy_19-12-06_2.txt
[INFO   ] [Kivy        ] v1.10.1
[INFO   ] [Python      ] v3.7.5 (default, Nov 20 2019, 09:21:52)
[GCC 9.2.1 20191008]
[INFO   ] [Factory     ] 194 symbols loaded
[INFO   ] [Image       ] Providers: img_tex, img_dds, img_sdl2, img_pil, img_gif (img_ffpyplayer ignored)
[INFO   ] [Text        ] Provider: sdl2
[INFO   ] [Window      ] Provider: sdl2(['window_egl_rpi'] ignored)
[INFO   ] [GL          ] Using the "OpenGL" graphics system
[INFO   ] [GL          ] Backend used <gl>
[INFO   ] [GL          ] OpenGL version <b'4.6.0 NVIDIA 435.21'>
[INFO   ] [GL          ] OpenGL vendor <b'NVIDIA Corporation'>
[INFO   ] [GL          ] OpenGL renderer <b'GeForce RTX 2060/PCIe/SSE2'>
[INFO   ] [GL          ] OpenGL parsed version: 4, 6
[INFO   ] [GL          ] Shading version <b'4.60 NVIDIA'>
[INFO   ] [GL          ] Texture max size <32768>
[INFO   ] [GL          ] Texture max units <32>
[INFO   ] [Window      ] auto add sdl2 input provider
[INFO   ] [Window      ] virtual keyboard not allowed, single mode, not docked
[INFO   ] [GL          ] NPOT texture support is available
[INFO   ] [ProbeSysfs  ] device match: /dev/input/event12
[INFO   ] [MTD         ] Read event from </dev/input/event12>
[INFO   ] [ProbeSysfs  ] device match: /dev/input/event30
[INFO   ] [MTD         ] Read event from </dev/input/event30>
[INFO   ] [ProbeSysfs  ] device match: /dev/input/event10
[INFO   ] [MTD         ] Read event from </dev/input/event10>
[INFO   ] [Base        ] Start application main loop
[INFO   ] [MTD         ] </dev/input/event12> range position X is 0 - 3984
[INFO   ] [MTD         ] </dev/input/event30> range position X is 0 - 1792
[INFO   ] [MTD         ] </dev/input/event10> range position X is 0 - 3984
[INFO   ] [MTD         ] </dev/input/event12> range position Y is 0 - 1152
[INFO   ] [MTD         ] </dev/input/event30> range position Y is 0 - 2500
[INFO   ] [MTD         ] </dev/input/event10> range position Y is 0 - 2256
[INFO   ] [MTD         ] </dev/input/event12> range touch major is 0 - 255
[INFO   ] [MTD         ] </dev/input/event30> range touch major is 0 - 0
[INFO   ] [MTD         ] </dev/input/event10> range touch major is 0 - 255
[INFO   ] [MTD         ] </dev/input/event12> range touch minor is 0 - 255
[INFO   ] [MTD         ] </dev/input/event30> range touch minor is 0 - 0
[INFO   ] [MTD         ] </dev/input/event10> range touch minor is 0 - 255
[INFO   ] [MTD         ] </dev/input/event12> range pressure is 0 - 255
[INFO   ] [MTD         ] </dev/input/event30> range pressure is 0 - 255
[INFO   ] [MTD         ] </dev/input/event10> range pressure is 0 - 255
[INFO   ] [MTD         ] </dev/input/event12> axes invertion: X is 0, Y is 0
[INFO   ] [MTD         ] </dev/input/event30> axes invertion: X is 0, Y is 0
[INFO   ] [MTD         ] </dev/input/event30> rotation set to 0
[INFO   ] [MTD         ] </dev/input/event12> rotation set to 0
[INFO   ] [MTD         ] </dev/input/event10> axes invertion: X is 0, Y is 0
[INFO   ] [MTD         ] </dev/input/event10> rotation set to 0
[INFO   ] [Base        ] Leaving application in progress...
```


## Firefox

enable xinput:
```bash
$ MOZ_USE_XINPUT2=1 /usr/bin/firefox
```
source:
- [archlinux Firefox Enable touchscreen gestures](https://wiki.archlinux.org/index.php/Firefox/Tweaks#Enable_touchscreen_gestures)
- [How can I get Firefox to recognize multitouch gestures on a touch screen?](https://askubuntu.com/questions/536663/how-can-i-get-firefox-to-recognize-multitouch-gestures-on-a-touch-screen/1193861)
- [How to enable touchscreen gestures for Firefox](https://support.mozilla.org/en-US/questions/1091627)
enable for ever ;-)
```bash
$ echo -e "\n# setup firefox multitouch \nexport MOZ_USE_XINPUT2=1\n" >> ~/.profile
```

- [Firefox Touch Events Demo](https://mdn.mozillademos.org/en-US/docs/Web/API/Touch_events$samples/Example) (seems there is a bug in the code..)
    - [same demo as jsfiddle](http://jsfiddle.net/Darbicus/z3Xdx/10/) [result only](http://fiddle.jshell.net/Darbicus/z3Xdx/10/show/)
- [touch example](http://dev.openlayers.org/examples/multitouch.html)
- [Multitouch Canvas Fingerpaint Demo](https://www.paulirish.com/demo/multi)
- [PaperJS demo](http://sketch.paperjs.org/#V/0.12.3/S/lVOxbsIwEP0VKwtGoIShE2mGCrF1QGLoQBic+AIWiR3ZThBC/Ht9TigpRW3x4vPde3fn5/M5kKyCYB6sD2DzfTANcsXxHEVvWrMTsYoYqzQQCUdSM7s3qWyZ7kySkM02TmUqi0bmVijp8E2+X1umLYV2TM6pJG4hw0cAOdCG/SHuwlG00MDsrQipoSfc+N6feMjKmXTck9EfGqvVARaqVNph/B5qJrmqHuE+BPe5XgYhE9aN2VM0kXH5eatKtfDUpVYaWpDWdCiSNVlWCrnrwqKgPT4sQe6wnyTpO+kcX4VwFUpTLChcqVnstlfyne58k8l4wLjTzWfeiG38AKGEtA7SCjiGO7BL7HqFzmuLjje+I3o5GefUs++jPhXX7EiHkUtnXh7Ku5Qc1f1D3Ku2y6rGMfFTyG6T6uaO1FrlYAxxz6V/03o2VOvbPA+b5CpvKqdHmCl+wgt7dd6FsSBB05FP7AuPpoPpn5KClQbw9v/KgMN1TYD2s3yQ/Ep3Qg7Y7ktn7nMd/DOZYL7ZXj4B)
