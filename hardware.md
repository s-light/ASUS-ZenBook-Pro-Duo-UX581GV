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

[manufacturer website](http://www.emc.com.tw/emc/en/Product/Solution/PenAndTouchInputSolutions)

### Top Screen
touch: `ELAN9008:00 04F3:29B6`
pen: `ELAN9008:00 04F3:29B6 Pen (0)`

### Bottom Screen
touch: `ELAN9009:00 04F3:29A1`
pen: `ELAN9009:00 04F3:29A1 Pen (0)`

### TouchPad
`ELAN1406:00 04F3:3101 Touchpad`

change driver to use evid multitouch instead of libinput?!
or better add 'wacom' support?!

### Pen / Stylus
Label:
Product: Active stylus
Model: `SPEN-ASU-05`
Manufacturer: Sunwoda Electronic Co., Ltd.
and [looks like this one](https://fccid.io/NCC/CCAI18LP0230T1/fWgpDt4ifGc=)





the [ASUS ZenBook Pro Duo UX581GV](https://www.asus.com/Laptops/ZenBook-Pro-Duo-UX581GV/Tech-Specs/) has two internal screens -
- top/main oled screen (345mm x 194mm → 13.59in x 7.64in)
- bottom/secondary TFT screen (345mm x 99mm → 13.59in x 3.9in)
both with touch and pen support.

the pen that was with the laptop has this info on the label:
Product: Active stylus
Model: SPEN-ASU-05
Manufacturer: Sunwoda Electronic Co., Ltd.
and [the FCC / NCC id can be found with corresponding pictures](https://fccid.io/NCC/CCAI18LP0230T1/fWgpDt4ifGc=)

i have also added the files in libwacom as pullrequest:
https://github.com/linuxwacom/libwacom/pull/186

[sysinfo.yzHeVK384m.tar.gz](https://github.com/linuxwacom/wacom-hid-descriptors/files/3934973/sysinfo.yzHeVK384m.tar.gz)




## other things
