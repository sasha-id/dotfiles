sketchybar --add alias "iStat Menus Status,com.bjango.istatmenus.cpu" right \
           --set "iStat Menus Status,com.bjango.istatmenus.cpu" padding_right=5 label.width=0 \
                 click_script="open -a /System/Applications/Utilities/Activity\ Monitor.app"

sketchybar --add alias "iStat Menus Status,com.bjango.istatmenus.memory" right \
           --set "iStat Menus Status,com.bjango.istatmenus.memory" paddng_right=5 label.width=0 \
                 click_script="open -a /System/Applications/Utilities/Activity\ Monitor.app"

sketchybar --add alias "iStat Menus Status,com.bjango.istatmenus.network" right  \
           --set "iStat Menus Status,com.bjango.istatmenus.network" padding_right=0 label.width=0 \
                 click_script="open -a /System/Applications/Utilities/Activity\ Monitor.app"


