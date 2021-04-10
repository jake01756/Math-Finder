Scrolling Menu CE v1.1.1
MENU.8xp
by Alex P.

Scrolling Menu CE is a mimic of the menus built into the TI-84pce meant for use with TI-BASIC programs. It uses a string stored in Ans to make a menu and outputs the ASCII code of the selected option. You can also now use the left and right arrows to switch between menus. If you do end up using this as part of a TI-BASIC program, please acknowledge me and this program. "Scrolling Menu Plus" is a port for the TI-83/84 plus.

;-----------------------------------------------------

Instructions:
The string you put into Ans should be formatted like this:
"MENU1,Option 1,Option 2,Last Option:MENU2,Option 1, ... ending with "."

First word at beginning/after each colon is always the title and will be highlighted at the top.
Separate each option with a comma and always end the string with a decimal point.

;--------------------------------------------------------

Like the built-in menus, options can be selected by either highlighting them and pressing enter or by pressing the number or Alpha key then letter of the option. The ASCII code of the selected option is multiplied by the index of the current menu and stored into Ans. Here's something to help.

Option		ASCII code
1		49
2		50
3		51
4		52
5		53
6		54
7		55
8		56
9		57
0		48
A		65
B		66
C		67
...		And so on...

For example let's say you chose the third option on the second menu, Ans would be...

51 (Third option) * 2 (Second menu) = 102

;-----------------------------------------------------------

Possible Errors: 

Weird symbols:
The calculator stores letters as tokens instead of characters, it's a bit strange with some tokens (i.e. if a space is put into Ans, "(" will display instead), but I can guarantee that all the capital letters will display correctly, experiment a little and you might be get some cool characters.

Syntax:
Make sure each option is seperated by a comma, each menu seperated by a colon, each menu has at least one option, and that string ends with a decimal point.

Dimension:
There is more than 37 options in a menu.

DataType:
Ans is not a string, double check that there's a quotation mark before the start of the string.

OverFlow:
The number of characters can't fit horizontally on the screen.

;-----------------------------------------------------------------

Acknowledgements:

-John Wilton for creating "Scrolling Menu", which I got a couple ideas from (mainly using C register for scrolling and making an address table)

-Sean McLaughlin for putting together "Learn TI-83 Plus Assembly In 28 Days"

;----------------------------------------------------------------------

ChangeLog:

v1.1.1: Removed residual black pixels appearing on left side of screen and did some cheap optimization. I also decided to release source-code since I do want feedback and want to improve my coding. Also made a port to TI-83/84 plus called "Scrolling Menu Plus". (Aug 2020)

v1.1.0: Added multi-menu support and a few equates so porting to TI-83 plus is an option for the future. (Aug 2020)

v1.0.0: Initial release to ticalc.org and cemetech.net. (Aug 2020)