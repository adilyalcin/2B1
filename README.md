2B1
===

A multi-player game for arduino


CREDITS:

Programming & Design: Zahra Ashktorab & Adil Yalcin

Art:
All artwork is under Creative Commons Attribution-NonCommercial-ShareAlike 3.0 Unported license, including original and other's work:
* Wolf image http://www.sweetclipart.com/cute-grey-wolf-1094
* Carrot image http://www.sweetclipart.com/large-single-orange-carrot-182


TODO:
* power up implementation
  => Bunny speed up
  => Freeze all (or near) wolves
  => Slow wolves
  => Be invisible (touching wolves will not reset the map)
  ** Timed powerup (powerups decay in time)
  ** Powerups will randomly appear/disappear inside the game area.
  ** Once a power up is taken, it will be placed into the box
     => Just one object of each powerup type.
	 => Just change position & scale of the object when placed inside powerup box.

different modes of character control
- Current Mode: Absolute speed x and speed y
- Mode 2: one knob direction, the other speed
- Mode 3: relative speed x & y (instead of absolute)