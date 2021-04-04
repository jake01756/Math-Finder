**Math Finder v0.75**
Math Finder is a program for the TI 84 Plus CE that can find the volumes and surface areas of geometric shapes. It is still under heavy development but I thought I would share my progress with the Cemetech community. It is written entirely in TI-Basic to ensure that it would work on all OS versions. Originally I was going to write it using ICE Compiler but after some consideration, I wrote it in TI-Basic. This decision would pay off after TI decided on a whim to remove ASM support.

Now for some eye candy:

![](https://i.imgur.com/IWB4n1Z.png) ![](https://i.imgur.com/k1ypOto.png) ![](https://i.imgur.com/GDTZtM6.png)


Please note that screenshots will not be updated as frequently as the program.

It is important to note that it is still a work in progress, as you may have noticed in the gif where the quit option on the main menu throws an error. There were many errors in that one recording, most of which have been fixed. **If there are any issues or bugs that you find, please reply below with an explanation.** I do plan to continue development, make improvements, and fix bugs.

This is my first project post on Cemetech, so I hope I did everything right.

**Not Started:** :!: 
:arrow: Revamp the extras menu.
:arrow: Revamp the second page menu.
:arrow: Add surface area functionality to existing formulas.
:arrow: Add more formulas
:arrow: Add more screenshots.
:arrow: Complete rewriting & refactoring of all old code segments.

**In Progress...**
:arrow: [color=orange]Fix errors  **:!: Important :!: (85%)**[/color]
:arrow: [color=orange]Replace uppercase text with lowercase text. (80%)[/color]

**Completed:**
:arrow: [color=green]Revamp Main Menu with new look - ✅ Done[/color]
:arrow: [color=green]Add slope formula. - ✅ Done[/color]
:arrow: [color=green]Update pyramid section. - ✅ Done[/color]
:arrow: [color=green]Add least common multiple. - ✅ Done[/color]
:arrow: [color=green]Add greatest common denominator function. - ✅ Done[/color]
:arrow: [color=green]Import newly created icon. - ✅ Done[/color]

**Features**
:arrow: Finds the volumes of Cylinders, Rectangular Prisms, Cubes, Pyramids, and with more to come.
:arrow: Finds the surface areas of Rectangular Prisms, Pyramids, Cubes, Cylinders, and with more to come.
:arrow: Includes Distance, Midpoint, and Slope formulas.
:arrow: Compatible with your favorite shells! The program even has a Cesium icon. :D
:arrow: Compatible with all OS versions 5.3 or newer. (Math Finder might be compatible with OS 5.2.2 but using that old OS version could significantly degrade your experience with Math Finder. Math Finder has not been tested on anything older than OS 5.3.)

:calc:
**Calculator Compatibility:**
**Fully compatible:**
:arrow: TI-84 Plus CE
:arrow: TI-84 Plus CE-T
:arrow: TI-83 Premium CE
:arrow: TI-83 Premium CE Edition Python
:arrow: TI-84 Plus CE-T Python Edition

**Not tested, but might be compatible:**
:?:  TI-84 Plus Color Sliver Edition 

**[color=red]WARNING:[/color]** this calculator has a much slower processor than the TI-84 Plus CE series. Please do not expect everything to run smoothly. This program was designed and tested on a TI-84 Plus CE. It may also be hard to fit such a big program into the limited onboard memory included with the CSE. Don't say you haven't been warned.

**Not supported:**
:!: Have a monochrome calculator? Well alas, Math Finder is not compatible with your TI non-color edition calculator. It is possible to download and run the program, but the text will go off the edges of the screen and the main menu will be impossible to navigate.
:!: Any non-TI calculator.

**Feature :idea:**
All great features come from ideas. This is just the beginning.
:arrow: Add some unit circle magic.
:arrow: Add popular math mnemonics.

**Just a reminder before you download, this program is still in beta.**
While most of the features are complete and are currently working perfectly, there may be a few bugs and graphical glitches. These will be worked out before the final release. I always try and have no program breaking bugs that can plague a release and require a supplemental update.

**[color=red]The current version of Math Finder is v0.75 and contains numerous improvements over v0.74.[/color]** 
Staying up to date is important with beta software.

**Download:**
 :arrow: [url]http://ceme.tech/DL2028[/url]
:arrow: [url]https://github.com/jake01756/Math-Finder[/url]

[color=red]**The GitHub Link may be more up to date then the Cemetech Archives.**
[/color]

Here is a small snippet of code:

```
Lbl 3
Menu("Cube","Volume",56,"Surface Area",57,"Back",85
Lbl 56
Disp "Cube - v=a*a*a OR"
Disp "V=A^3"
Input "Edge?",A
A^3->V
Disp "Volume is",V
Pause 
Menu("Do another?","Yes",56,"No",3)
Lbl 57
Disp "Cube - sa=6A^2"
Input "Edge?",A
6*A^2->V
Disp "Surface Area is",V
Pause 
Menu("Do another?","Yes",57,"No",3)
```


**Possible TI-Nspire Port:**
A TI-Nspire CX II/TI-Nspire CX II CAS port might be possible and might happen someday. But that might be far off because of the lack of good programming on it. Even with great tools such as ndless, I would really like to *ensure* that the port would work on *all* recent versions of the OS (OS 4.5.3 and up). With the TI-Nspire port, the program would most likely be split up into different functions. A CAS-only version might be possible and could really expand what I can do with the program. With the Nspire series, it is surprisingly easy for programs to detect what type of calculator they are running on (CAS or non-CAS).

**Have any feature suggestions? Feel free to leave a comment below, and they might get added.**

I hope you enjoy using Math Finder as much as I did making it. There is a big update coming soon. :D 
Post last updated on 4/3/21.
