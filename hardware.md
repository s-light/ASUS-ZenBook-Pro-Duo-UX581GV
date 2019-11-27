<!--lint disable list-item-indent-->
<!--lint disable list-item-bullet-indent-->

# Hardware Information
collection of hardware / driver related things...

## cam
P:  Vendor=13d3 ProdID=56e4 Rev=19.54
S:  Manufacturer=Azurewave
S:  Product=USB2.0 HD IR UVC WebCam
S:  SerialNumber=200901010001
[manufacturer website](http://www.azurewave.com/camera-modules.html)


## touch screen

### Top Screen
touch: `ELAN9008:00 04F3:29B6`
pen: `ELAN9008:00 04F3:29B6 Pen (0)`

### Bottom Screen
touch: `ELAN9009:00 04F3:29A1`
pen: `ELAN9009:00 04F3:29A1 Pen (0)`


### map
```
xinput map-to-output  "pointer:ELAN9008:00 04F3:29B6" eDP-1-1
xinput map-to-output  "ELAN9008:00 04F3:29B6 Pen (0)" eDP-1-1
xinput map-to-output  "pointer:ELAN9009:00 04F3:29A1" DP-1-2
xinput map-to-output  "ELAN9009:00 04F3:29A1 Pen (0)" DP-1-2
```

### TouchPad
`ELAN1406:00 04F3:3101 Touchpad`

change driver to use evid multitouch instead of libinput:
?!





## other things
