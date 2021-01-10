#!/usr/bin/env bash

# Original concept copied and modified from
# lawleagle: https://github.com/lawleagle/oled-linux
# Plippo: https://github.com/s-light/ASUS-ZenBook-Pro-Duo-UX581GV/issues/1
# by Natrinicle

# where is the backlight directory?
backlight_dir="/sys/class/backlight/intel_backlight/"

# OLED screen brightness range
min_oled_brightness=10
max_oled_brightness=100

# Screenpad brightness range
min_screenpad_brightness=2
max_screenpad_brightness=100

req_files=( "/proc/acpi/call" "${backlight_dir}/brightness" "${backlight_dir}/max_brightness" )
for req_file in "${req_files[@]}"; do
	if ! test -f "${req_file}"; then
		echo "ERROR: Required file ${req_file} does not exist."
		exit 1
	fi
done

req_cmds=( "awk" "bc" "getent" "inotifywait" "sed" "xauth" "xrandr" )
for cmd in "${req_cmds[@]}"; do
  if ! command -v ${cmd} > /dev/null; then
  	echo "ERROR: Dependency '${cmd}' is not installed. Sorry, but this script cannot run without ${cmd}"
  	exit 1
  fi
done

# Merge all the X11 Xauthority files on the local machine
for home_dir in $(getent passwd | cut -d: -f6); do
	if [ -f ${home_dir}/.Xauthority ]; then
		xauth merge ${home_dir}/.Xauthority
	fi
done

# Scale number from old range to new range
# scale_num_to_range number old_range_lower old_range_upper new_range_lower new_range_upper
# https://stackoverflow.com/questions/12959371/how-to-scale-numbers-values
function scale_num_to_range() {
	echo "${4} + (${5} - ${4}) * (${1} - ${2}) / (${3} - ${2})" | bc -l
}

function dec_to_hex() {
	echo "obase=16; ibase=10; ${1}" | bc -l
}

percent=$(echo "$(cat ${backlight_dir}/brightness) / $(cat ${backlight_dir}/max_brightness) * 100" | bc -l)

oled_percent=$(scale_num_to_range ${percent} 0 100 ${min_oled_brightness} ${max_oled_brightness})
oled_bright=$(echo "${oled_percent} / 100" | bc -l)

screenpad_percent=$(scale_num_to_range ${percent} 0 100 ${min_screenpad_brightness} ${max_screenpad_brightness})
screenpad_bright=$(scale_num_to_range ${screenpad_percent} 0 100 0 255 | awk '{printf("%d\n",$1 + 0.5)}' | bc)
screnpad_hex=$(dec_to_hex ${screenpad_bright} | sed -e :a -e 's/^.\{1,1\}$/0&/;ta')

# Run xrandr on all the X11 displays targeting the correct output for the Asus ZenBook OLED display
for x11_display in $(for x in /tmp/.X11-unix/X*; do echo ":${x#/tmp/.X11-unix/X}"; done); do
	DISPLAY=${x11_display} xrandr --output eDP-1 --brightness ${oled_bright} > /dev/null 2>&1
done

echo "\_SB.ATKD.WMNB 0x0 0x53564544 b32000500${screnpad_hex}000000" > /proc/acpi/call
