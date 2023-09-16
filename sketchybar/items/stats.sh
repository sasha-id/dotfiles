
sketchybar --add alias "Stats,Disk_mini" right \
           --set "Stats,Disk_mini" paddng_right=-15 padding_left=-10 label.width=0 \
                 click_script="open -a /System/Applications/Utilities/Disk\ Utility.app"

sketchybar --add alias "Stats,RAM_mini" right \
           --set "Stats,RAM_mini" paddng_right=-15 padding_left=-10 label.width=0 \
                 click_script="open -a /System/Applications/Utilities/Activity\ Monitor.app"

sketchybar --add alias "Stats,CPU_mini" right \
           --set "Stats,CPU_mini" paddng_right=-15 padding_left=0 label.width=0 \
                 click_script="open -a /System/Applications/Utilities/Activity\ Monitor.app"

sketchybar --add alias "Stats,Network_speed" right  \
           --set "Stats,Network_speed" paddng_right=0 padding_left=0 label.width=0 \
                 click_script="open -a /System/Applications/Utilities/Activity\ Monitor.app"


