#!/usr/bin/env bash


getstatus() {
  local output="${1}"
  local line=''

  status=$(xrandr | grep "^${output} \(dis\)\?connected " | cut -d ' ' -f 2)
  printf -- '%s\n' "${status}"
}


extend() {
  local primary="${1}"
  local secondary="${2}"
  local hdmi="${3}"

  primarystatus=$(getstatus ${primary})
  secondarystatus=$(getstatus ${secondary})
  hdmistatus=$(getstatus ${hdmi})
  printf 'primary   %s\n' "${primarystatus}"
  printf 'secondary %s\n' "${secondarystatus}"
  printf 'hdmi      %s\n' "${hdmistatus}"

  xset r rate 250 100

  if [ "${secondarystatus}" = 'connected' ]; then
    #xrandr --output ${primary} --off --output ${secondary} --auto --primary
    # Disable all screens
    xrandr \
      --output ${primary} --off \
      --output ${hdmi} --off \
      --output ${secondary} --auto --primary

    # Fix brightness
    #sudo ~/bin/luminous -l 400

    i3-msg restart

    # Re-enable, with external monitor as primary
    xrandr \
      --output ${primary} --auto --left-of ${secondary} \
      --output ${secondary} --auto --primary

    i3-msg restart

  elif [ "${hdmistatus}" = 'connected' ]; then
    #xrandr --output ${primary} --off --output ${secondary} --auto --primary
      #--output ${primary} --auto --below ${hdmi} \
    xrandr \
      --output ${primary} --auto --right-of ${hdmi}\
      --output ${hdmi} --auto --primary

    # Fix brightness
    #sudo ~/bin/luminous -l 150
  else
    xrandr \
      --output ${primary} --primary --auto \
      --output ${secondary} --off \
      --output ${hdmi} --off

    i3-msg restart
  fi

  i3-msg restart
}



main() {
  # Laptop
  local primary=DP-2
  # Secondary display when connected to hub
  local secondary=DP-1
  # Directly connected to hdmi monitor
  local hdmi=HDMI-0

  extend "${primary}" "${secondary}" "${hdmi}"
}

main ${@}
