#!/usr/bin/env bash

# Exit if hyprctl not found
if ! command -v hyprctl &>/dev/null; then
  exit 0
fi

workspace_info=$(hyprctl activeworkspace 2>/dev/null)
workspace_name=$(echo "$workspace_info" | head -n1 | awk '{print $2}')
windows=$(echo "$workspace_info" | grep -Po '(?<=windows: )\d+')

if [[ "$windows" -ne 1 ]]; then
  exit 0
fi



# Gather and print system info
HOSTNAME=$(hostname)
OS="NixOS $(nixos-version | cut -d' ' -f1-2)"
KERNEL=$(uname -r)
UPTIME=$(uptime | sed 's/.*up \([^,]*\), .*/\1/')
DE="${XDG_CURRENT_DESKTOP:-Hyprland}"
SHELL_NAME=$(basename "$SHELL")
TERMINAL=${TERM_PROGRAM:-$TERM}
CPU=$(lscpu | grep 'Model name' | sed 's/Model name:\s*//')
GPU=$(lspci | grep -E 'VGA|3D' | cut -d ':' -f3 | sed -n 's/.*\[\([^]]*\)\].*/\1/p' | sed ':a;N;$!ba;s/\n/, /g')
RAM=$(free -h | awk '/Mem:/ {print $3 " / " $2}')
DISK=$(df -h / | awk 'NR==2 {print $3 " / " $2}')


# ASCII Art
ascii_art=$(cat <<EOF
                                     .....                                     
                     .       .',,,,'.......,,,,,.       '. .                   
                .l,ld.    ,;,.   ............   .,;,.    ;ddo.                 
             ' 'kkl.   .:,. ..,d.........;d..ck...  .:,    .cx. ;              
            l. :'    'c. .................'.......... .;;     . ;o             
         ' ;k.'.   .c. ..............o;............cl.. .c'   .;lk,.;          
         d dkl.   ,c .....'c......;..'............o...... ,:    .c: d.         
        ,k '     ;; ......,o..c'..x:.......,.......::c,... .c    .  k, .       
      l ,kc,;   ,: ........................0,.,:.'.'lc..,l. .c   .lxk. l       
      k. xd,    d .c:...................'oKMNoc:.o;x;k';co'. :'    .; .x       
    . od.  '   :' .''...........c.....::..,N;l,:c.....,k'...  o   ';.'x;  .    
    o .xkox.   d  ..;x.........o0o'...dc...:....o,;oc..,.k;.. l.   .ok:  l.    
    co  cc     x .......d..;coOMM0o:,.l:..c;.lKcl............ :'     .  oc     
   . dx.  ..   x ..,.......',;dMMkclc.:x.....,c;,,......l.... :'   ,:.;x: ,    
   :;.lkool    o  .xl'...';....d0...o;;:k..d,Xl'..'o......... o.    'xd..o,    
    od'.c;  .  ,; .cO;.......;;;,l..,.,..c:lKMNd;.......''.. .o   ;   .lx'     
     lkx:. c;   o  ......;..:..';...:'ll.'...X'.........;;.. l.   ;dcxkl.      
      .okkkx    .l .c;..,x'ccc;.:o:...:c'o.;.,............. ;;  .. ox:. ';     
     :c...,. ;.  .l  .....''...;.lc......:c;.........l,... ,;   'o  .,lx;      
      .dkd:''k'   .l. ..:,;..ocl.......oo..o............  :'    .kkkkx:        
        .cxkkk. '   ;:  ..:;...;........;,............. ':.   :  l:,.          
            ..  o.    :;. ..........................  ':.     x,..',.          
          .;colokc .,   ,;'. ............ll......  .;;.   ,; .doc;.            
              .',' ,k.     ';;'.    .......   ..,;,.     .kd'....              
              .;codkkx         .,,,,,,,,,,,,,,'.      .  .ccc:,.               
                   ..  .:ol:;,'...           .',,''',:;,.                      
                                 .;l:     cc,.                                 
                              .;:;'.       .';;;..                             
"Hostname: $HOSTNAME"
"OS: $OS"
"Kernel: $KERNEL"
"Uptime: $UPTIME"
"Desktop Env: $DE"
"Shell: $SHELL_NAME"
"Terminal: $TERMINAL"
"CPU: $CPU"
"GPU: $GPU"
"RAM: $RAM"
"Disk: $DISK"

"Accessing Starfleet Terminal Interface..."
"Verifying identity: Officer on deck."
"Kitty terminal: READY"


EOF
)

# Print the ASCII art using lolcat (animated rainbow effect)
echo "$ascii_art" | lolcat --force 2>/dev/null
