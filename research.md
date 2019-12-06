<!--lint disable list-item-indent-->
<!--lint disable list-item-bullet-indent-->

# research
collection for what worked and what did not and so on...


## touch & pen input


good base information in this askubuntu answer:
[Touchscreen calibration with dual monitors (NVidia and xinput)](https://askubuntu.com/a/923158/207905)

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
