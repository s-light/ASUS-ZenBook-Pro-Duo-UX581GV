#!/usr/bin/env bash

# Original concept copied and modified from
# lawleagle: https://github.com/lawleagle/oled-linux
# Plippo: https://github.com/s-light/ASUS-ZenBook-Pro-Duo-UX581GV/issues/1
# by Natrinicle

# where is the backlight directory?
backlight_dir="/sys/class/backlight/intel_backlight/"

# OLED screen brightness range & search
min_oled_brightness=10
max_oled_brightness=100
oled_monitor_regex="eDP[0-9\-]+"

# Screenpad brightness range & adjustment
# Mapping is percent called for:Percent screenpad should be lit
# e.g. 50:75 means when 50% brightness is asked for, set the screenpad to 75%
screenpad_mapping=( "0:10" "5:13" "50:128" "75:235" "100:255" )

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
for uid in $(getent passwd | cut -d: -f3); do
	if [ -f /run/user/${uid}/gdm/Xauthority ]; then
		xauth merge /run/user/${uid}/gdm/Xauthority
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

# screenpad_percent=$(echo "${percent} * ${screenpad_brightness_scalar} | bc -l")
max_screenpad_map="${screenpad_mapping[${#screenpad_mapping[@]}-1]}"
if [ "$(echo "${percent} >= ${max_screenpad_map%%:*}" | bc)" -eq "1" ]; then
	# Set to max
	screenpad_percent="${max_screenpad_map##*:}"
elif [ "$(echo "${percent} <= ${screenpad_mapping[0]%%:*}" | bc)" -eq "1" ]; then
	screenpad_percent="${screenpad_mapping[0]##*:}"
else
	last_x="${screenpad_mapping[0]%%:*}"
	last_y="${screenpad_mapping[0]##*:}"
  for mapping in "${screenpad_mapping[@]}"; do
  	x="${mapping%%:*}"
  	y="${mapping##*:}"
		if [ "$(echo "${x} <= 0" | bc)" -eq 1 ] || [ "$(echo "${y} <= 0" | bc)" -eq 1 ]; then
			# Avoid divide by 0
			continue
		fi
    if [ "$(echo "${percent} > ${x}" | bc)" -eq 1 ]; then
			screenpad_percent="$(echo "${last_y} + (${percent} - ${last_x}) * (${y} - ${last_y}) / (${x} - ${last_x})" | bc -l)"
		fi
		last_x=${x}
		last_y=${y}
  done
fi
screenpad_bright=$(echo "${screenpad_percent}" | awk '{printf("%d\n",$1 + 0.5)}' | bc)
screnpad_hex=$(dec_to_hex ${screenpad_bright} | sed -e :a -e 's/^.\{1,1\}$/0&/;ta')

# Run xrandr on all the X11 displays targeting the correct output for the Asus ZenBook OLED display
for x11_display in $(for x in /tmp/.X11-unix/X*; do echo ":${x#/tmp/.X11-unix/X}"; done); do
	MONITOR=$(DISPLAY=${x11_display} xrandr --listmonitors | grep -Po "${oled_monitor_regex}" | head -1)
	DISPLAY=${x11_display} xrandr --output ${MONITOR} --brightness ${oled_bright} > /dev/null 2>&1
done

echo "\_SB.ATKD.WMNB 0x0 0x53564544 b32000500${screnpad_hex}000000" > /proc/acpi/call
