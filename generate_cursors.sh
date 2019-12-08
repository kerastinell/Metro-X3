#!/bin/bash

# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program. If not, see <https://www.gnu.org/licenses/>.

root_dir="$1"
find "$root_dir" -mindepth 2 -type d | while read -r cursor_dir; do
    echo "Changing into ${cursor_dir}"
    cd "$cursor_dir"
    
    cursor_color=$(basename "$cursor_dir")
    cursor_type=$(basename "`dirname "$cursor_dir"`") # Bold, Light
    
    echo "-> Generating .ico and .xcg files"
    find "$cursor_dir" -type f -name "*.ani" | while read -r "ani_file"; do
        base_name=$(basename "$ani_file" ".ani")
        ico_file=${ani_file//\.ani/1\.ico}
        png_file="${base_name}1.png"
        xcg_file=${ani_file//\.ani/\.xcg} # xcg = X Cursor Gen
        hotpoint_x=$((16#` xxd -p -l1 -s 0x8C "$ani_file"`))
        hotpoint_y=$((16#` xxd -p -l1 -s 0x8E "$ani_file"`))
        
        if [ "$base_name" == "X3_busy" ] || [ "$base_name" == "X3_working" ]; then
            for i in `seq 1 10`; do
                png_file="${base_name}${i}.png"
                echo "32 ${hotpoint_x} ${hotpoint_y} ${png_file} 100" >> "$xcg_file"
            done
        else
            echo "32 ${hotpoint_x} ${hotpoint_y} ${png_file}" >> "$xcg_file"
        fi
        
        ani2ico "$ani_file"
    done
    
    echo "-> Generating .png images"
    mogrify -format png *.ico
    
    echo "-> Generating additional cursor images"
    convert -rotate "90" "X3_up1.png" "X3_right1.png" && echo "32 26 15 X3_right1.png" >> "X3_right.xcg"
    convert -rotate "180" "X3_up1.png" "X3_down1.png" && echo "32 16 26 X3_down1.png" >> "X3_down.xcg"
    convert -rotate "270" "X3_up1.png" "X3_left1.png" && echo "32 5 16 X3_left1.png" >> "X3_left.xcg"
    convert -flop "X3_arrow1.png" "X3_arrow_right1.png" && echo "32 31 0 X3_arrow_right1.png" >> X3_arrow_right.xcg
    
    echo "-> Generating X11 cursors and creating links"
    xcursorgen X3_unavail.xcg X_cursor
        ln -s X_cursor pirate
    xcursorgen X3_nwse.xcg bd_double_arrow
        ln -s bd_double_arrow c7088f0f3e6c8088236ef8e1e3e70000
        ln -s bd_double_arrow bottom_right_corner
        ln -s bd_double_arrow top_left_corner
        ln -s bd_double_arrow lr_angle
        ln -s bd_double_arrow ul_angle
    xcursorgen X3_nesw.xcg bottom_left_corner
        ln -s bottom_left_corner top_right_corner
        ln -s bottom_left_corner fd_double_arrow
        ln -s bottom_left_corner fcf1c3c7cd4491d801f1e1c78f100000
        ln -s bottom_left_corner ll_angle
        ln -s bottom_left_corner ur_angle
    xcursorgen X3_ns.xcg bottom_side
        ln -s bottom_side top_side
        ln -s bottom_side sb_v_double_arrow
        ln -s bottom_side 00008160000006810000408080010102
        ln -s bottom_side 2870a09082c103050810ffdffffe0204
        ln -s bottom_side double_arrow
        ln -s bottom_side v_double_arrow
    xcursorgen X3_unavail.xcg circle
        ln -s circle crossed_circle
        ln -s circle 03b6e0fcb3499374a867c041f52298f0
    xcursorgen X3_arrow.xcg copy
        ln -s copy 1081e37283d90000800003c07f3ef6bf
        ln -s copy 6407b0e94181790501fd1e167b474872
        ln -s copy left_ptr
        ln -s copy arrow
        ln -s copy top_left_arrow
        ln -s copy link
        ln -s copy 3085a0e285430894940527032f8b26df
        ln -s copy 640fb0e74195791501fd1ed57b41487f
    xcursorgen X3_precision.xcg cross
        ln -s cross tcross
        ln -s cross crosshair
        ln -s cross cross_reverse
        ln -s cross diamond_cross
    xcursorgen X3_links.xcg hand2
        ln -s hand2 9d800788f1b08800ae810202380a0822
        ln -s hand2 e29285e634086352946a0e7090d73106
        ln -s hand2 hand
        ln -s hand2 hand1
    xcursorgen X3_working.xcg left_ptr_watch
        ln -s left_ptr_watch 08e8e1c95fe2fc01f976f1e063a24ccd
        ln -s left_ptr_watch 3ecb610c1bf2410f44200f48c40d3599
    xcursorgen X3_ew.xcg left_side
        ln -s left_side right_side
        ln -s left_side sb_h_double_arrow
        ln -s left_side 028006030e0e7ebffc7f7070c0600140
        ln -s left_side 14fef782d02440884392942c11205230
        ln -s left_side h_double_arrow
    xcursorgen X3_move.xcg move
        ln -s move 4498f0e0c1937ffe01fd06f973665830
        ln -s move 9081237383d90e509aa00f00170e968f
        ln -s move grabbing
        ln -s move fleur
    xcursorgen X3_pen.xcg pencil
    xcursorgen X3_help.xcg help
        ln -s help question_arrow
        ln -s help 5c6cd98b3f3ebcb1f9c7f1c204630408
        ln -s help d9ce0ab605698f320427677b458ad60b
        ln -s help left_ptr_help
    xcursorgen X3_arrow_right.xcg right_ptr
        ln -s right_ptr draft_large
        ln -s right_ptr draft_small
    xcursorgen X3_down.xcg sb_down_arrow
    xcursorgen X3_left.xcg sb_left_arrow
    xcursorgen X3_right.xcg sb_right_arrow
    xcursorgen X3_up.xcg sb_up_arrow
    xcursorgen X3_busy.xcg watch
    xcursorgen X3_beam.xcg xterm
    
    echo "-> Cleaning up intermediate files"
    rm *.inf
    rm *.png
    rm *.ani
    rm *.ico
    rm *.xcg
    
    echo "-> Creating cursors directory"
    mkdir cursors/
    mv * cursors/ 2>/dev/null
    
    echo "-> Generating .theme files"
    {
        echo "[Icon Theme]"
        echo "Name=Metro X3 ${cursor_color} (${cursor_type})"
        echo "Inherits=DMZ-White"
    } >> cursor.theme
    {
        echo "[Icon Theme]"
        echo "Name=Metro X3 ${cursor_color} (${cursor_type})"
        echo "Comment=Made by Rei AJ Browning (https://www.deviantart.com/exsess); Converted for X11 by kerastinell (https://github.com/kerastinell); Licensed under CC BY-NC-SA 3.0"
    } >> index.theme
    
    echo "-> Creating cursor theme directory"
    cd .. && mv "$cursor_dir" "${root_dir}/Metro X3 ${cursor_color} (${cursor_type})"
    
    echo
done

echo "Cleaning up"
cd "$root_dir"
rm -rf Bold/ Light/
rm -f Preview.jpg Readme.txt
