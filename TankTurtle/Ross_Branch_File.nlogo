patches-own
[
  gridNumber
]

to setup
  
clear-all

generate-map

reset-ticks

end

to clear-screen
  cd
  ask patches with [pcolor != white]
  [
    set pcolor white
  ]
  
end

;This method is triggered by the setup button being pressed
;and generates our game level for us. It does the following:
;Calls the clear-screen method to make sure that we're working
;with a blank canvas.
;Sections off the screen into a 3x3 grid, to give us the slots
;where our pseudo-randomly generated tiles will slot into.
;Defines the 9 random tiles that will combine to create the
;game level by calling a method that does this for us.
;Then all the patches are polled by the program. This is where,
;depending on which tile it has been assigned to, the tiles are
;"loaded" in randomly, i.e. the patch colours are changed to
;generate our map.
to generate-map
  
  clear-screen
  
  set-grid-number
  
  let chosenTile1 calc-tile
  let chosenTile2 calc-tile
  let chosenTile3 calc-tile
  let chosenTile4 calc-tile
  let chosenTile5 calc-tile
  let chosenTile6 calc-tile
  let chosenTile7 calc-tile
  let chosenTile8 calc-tile
  let chosenTile9 calc-tile
 
  ask patches
  [
   
   if gridNumber = 1
   [
     load-tile chosenTile1 0 0
   ] 
   
   if gridNumber = 2
   [
     load-tile chosenTile2 12 0
   ]
   
   if gridNumber = 3
   [
     load-tile chosenTile3 24 0
   ]
   
   if gridNumber = 4
   [
     load-tile chosenTile4 0 12
   ]
   if gridNumber = 5
   [
     load-tile chosenTile5 12 12
   ]
   if gridNumber = 6
   [
    load-tile chosenTile6 24 12
   ]
   if gridNumber = 7
   [
    load-tile chosenTile7 0 24
   ]
   if gridNumber = 8
   [
     load-tile chosenTile8 12 24
   ]
   if gridNumber = 9
   [
     load-tile chosenTile9 24 24
   ]
  ]
  
  place-ammo
  place-fuel
  place-player-spawn
  place-enemy-spawns
  
  reset-ticks
  
end

;This method, based upon where the patches exist in coordinate space,
;sets the variable gridNumber to be the slot in the grid which the
;patch belongs to.

to set-grid-number
  ask patches
  [    
   if pxcor < 12 and pycor <= 12 ;bottom left tile
   [
     set gridNumber 1
   ]
   if pxcor >= 12 and pxcor <= 24 and pycor <= 12 ;bottom middle tile
   [
     set gridNumber 2
   ]
   if pxcor > 24 and pycor <= 12 ;bottom right tile
   [
    set gridNumber 3
   ]
   if pxcor < 12 and pycor > 12 and pycor <= 24 ;middle left
   [
    set gridNumber 4 
   ]
   if pxcor >= 12 and pxcor <= 24 and pycor > 12 and pycor <= 24 ;middle tile
   [
     set gridNumber 5
   ]
   if pxcor > 24 and pycor > 12 and pycor <= 24 ;middle right tile
   [
    set gridNumber 6
   ]
   if pxcor < 12 and pycor > 24 ;top left tile
   [
    set gridNumber 7
   ]
   if pxcor >= 12 and pxcor <= 24 and pycor > 24 ;top middle tile
   [
    set gridNumber 8
   ]
   if pxcor > 24 and pycor > 24 ;top right tile
   [
    set gridNumber 9
   ]
  ]
  
end

;This is the random number generator that decides which tile will be
;loaded. Based upon what number this method generates, the tile corresponding
;to it will load. For example, 0 will load tile-1, 1 will load tile-2, etc.
to-report calc-tile
  
  random-seed new-seed
  let chance random 7

  report chance
  
end

;This method loads the tile into its chosen slot, based upon
;the value of the chosenTile variable passed into the method.
;This method will call the defined-tile method corresponding to
;the needed tile, as well as its x and y offset, making sure that
;it will load into the correct place in the scene.
to load-tile [chosenTile xoff yoff]
  
  if (chosenTile = 0)
    [
     defined-tile-1 xoff yoff 
    ]
    if (chosenTile = 1)
    [
     defined-tile-2 xoff yoff 
    ]
    if (chosenTile = 2)
    [
     defined-tile-3 xoff yoff 
    ]
    if (chosenTile = 3)
    [
     defined-tile-4 xoff yoff 
    ]
    if (chosenTile = 4)
    [
     defined-tile-5 xoff yoff 
    ]
    if (chosenTile = 5)
    [
      defined-tile-6 xoff yoff
    ]
    if (chosenTile = 6)
    [
     defined-tile-7 xoff yoff 
    ]
  
end


;This method will randomly spawn positions where ammo will
;appear within the game world. This will randomly place 4 
;ammo spawns across the game, only placing them on an available patch
;that isn't taken up by an obstacle. Due to the method being semi-random
;this also keep the game different every time.
to place-ammo
  
  let xcord random-pxcor
  let ycord random-pycor
  
  let no-of-ammo-spawns 4
  let no-of-ammo-spawned 0
  
  while [no-of-ammo-spawned < no-of-ammo-spawns]
  [
    ask patches
    [
     if (pcolor = white)
     [
      ifelse (pxcor = xcord and pycor = ycord)
      [
        set pcolor green
        set no-of-ammo-spawned no-of-ammo-spawned + 1
      ]
      [
       set xcord random-pxcor
       set ycord random-pycor 
      ]
     ] 
    ]
  ] 
    
end

;This method will randomly spawn positions where fuel will
;appear within the game world. This will randomly place 4 
;fuel spawns across the game, only placing them on an available patch
;that isn't taken up by an obstacle. Due to the method being semi-random
;this also keep the game different every time.
to place-fuel
  
  let xcord random-pxcor
  let ycord random-pycor
  
  let no-of-fuel-spawns 4
  let no-of-fuel-spawned 0
  
  while [no-of-fuel-spawned < no-of-fuel-spawns]
  [
    ask patches
    [
     if (pcolor = white)
     [
      ifelse (pxcor = xcord and pycor = ycord)
      [
        set pcolor black
        set no-of-fuel-spawned no-of-fuel-spawned + 1
      ]
      [
       set xcord random-pxcor
       set ycord random-pycor 
      ]
     ] 
    ]
  ] 
  
end


;This method draws an obstacle (definied as a red patch) where 
;the tile requires it to be on-screen. Obstacles are drawn based
;upon the coordinate of the patch being checked, and their offsets.
to draw-obstacle [patchxcor xoff xcord patchycor yoff ycord]
  
  if ((patchxcor - xoff = xcord) and (patchycor - yoff = ycord))
    [
     set pcolor red 
    ]
  
end

;This method generates a random x and y coordinate and, after polling
;the patches, places the spawn for the player in a valid location (i.e
;in a patch that is white). This is randomly generated, so this 
;will change each time the game has run. 
to place-player-spawn
  
  let xcord random-pxcor
  let ycord random-pycor
  
  let no-of-players-spawned 0
  
   ask patches with [pcolor = white]
   [
    if (no-of-players-spawned = 0)
    [
      if (pxcor = xcord and pycor = ycord)
      [
        set pcolor blue
        set no-of-players-spawned 1
      ]
     ] 
    ]
  
end

;This method will randomly spawn positions where enemy spawns will
;appear within the game world. This will randomly place 4 
;enemy spawns across the game, only placing them on an available patch
;that isn't taken up by an obstacle. Due to the method being semi-random
;this also keep the game different every time.
to place-enemy-spawns
  
  let xcord random-pxcor
  let ycord random-pycor
  
  let no-of-enemy-spawns 4
  let no-of-enemies-spawned 0
  
  while [no-of-enemies-spawned < no-of-enemy-spawns]
  [
    ask patches
    [
     if (pcolor = white)
     [
      ifelse (pxcor = xcord and pycor = ycord)
      [
        set pcolor yellow
        set no-of-enemies-spawned no-of-enemies-spawned + 1
      ]
      [
       set xcord random-pxcor
       set ycord random-pycor 
      ]
     ] 
    ]
  ] 
    
end

;Holds the definition of tile-1.
;Whilst this tile will look the same wherever it appears in the
;game, an offset is needed so that all of the patches are drawn
;in their correct locations regardless of where they will appear.
;For clarity, the positions of the obstacles (before any offsets
;have been applied) are as follows:
;(2,2) (5,1) (6,1) (9,2) (2,5) (5,5) (6,5) (9,5) (2,6) (5,6) (6,6)
;(9,6) (2,9) (9,9) (5,10) (6,10)

to defined-tile-1 [xoff yoff]
  
  set pcolor white
  
  draw-obstacle pxcor xoff 2 pycor yoff 2
  draw-obstacle pxcor xoff 5 pycor yoff 1
  draw-obstacle pxcor xoff 6 pycor yoff 1
  draw-obstacle pxcor xoff 9 pycor yoff 2
  draw-obstacle pxcor xoff 2 pycor yoff 5
  draw-obstacle pxcor xoff 5 pycor yoff 5
  draw-obstacle pxcor xoff 6 pycor yoff 5
  draw-obstacle pxcor xoff 9 pycor yoff 5
  draw-obstacle pxcor xoff 2 pycor yoff 6
  draw-obstacle pxcor xoff 5 pycor yoff 6
  draw-obstacle pxcor xoff 6 pycor yoff 6
  draw-obstacle pxcor xoff 9 pycor yoff 6
  draw-obstacle pxcor xoff 2 pycor yoff 9
  draw-obstacle pxcor xoff 9 pycor yoff 9
  draw-obstacle pxcor xoff 5 pycor yoff 10
  draw-obstacle pxcor xoff 6 pycor yoff 10
  
end

;Holds the definition of tile-2.
;Whilst this tile will look the same wherever it appears in the
;game, an offset is needed so that all of the patches are drawn
;in their correct locations regardless of where they will appear.
;For clarity, the positions of the obstacles (before any offsets
;have been applied) are as follows:
;(5,1) (6,1) (2,2) (3,2) (5,2) (6,2) (8,2) (9,2) (2,3) (9,3) (2,4)
;(9,4) (5,5) (6,5) (5,6) (6,6) (2,7) (9,7) (2,8) (9,8) (2,9) (3,9)
;(5,9) (6,9) (8,9) (9,9) (5,10) (6,10)
to defined-tile-2 [xoff yoff]
  
  draw-obstacle pxcor xoff 5 pycor yoff 1
  draw-obstacle pxcor xoff 6 pycor yoff 1
  draw-obstacle pxcor xoff 2 pycor yoff 2
  draw-obstacle pxcor xoff 3 pycor yoff 2
  draw-obstacle pxcor xoff 5 pycor yoff 2
  draw-obstacle pxcor xoff 6 pycor yoff 2
  draw-obstacle pxcor xoff 8 pycor yoff 2
  draw-obstacle pxcor xoff 9 pycor yoff 2
  draw-obstacle pxcor xoff 2 pycor yoff 3
  draw-obstacle pxcor xoff 9 pycor yoff 3
  draw-obstacle pxcor xoff 2 pycor yoff 4
  draw-obstacle pxcor xoff 9 pycor yoff 4
  draw-obstacle pxcor xoff 5 pycor yoff 5
  draw-obstacle pxcor xoff 6 pycor yoff 5
  draw-obstacle pxcor xoff 5 pycor yoff 6
  draw-obstacle pxcor xoff 6 pycor yoff 6
  draw-obstacle pxcor xoff 2 pycor yoff 7
  draw-obstacle pxcor xoff 9 pycor yoff 7
  draw-obstacle pxcor xoff 2 pycor yoff 8
  draw-obstacle pxcor xoff 9 pycor yoff 8
  draw-obstacle pxcor xoff 2 pycor yoff 9
  draw-obstacle pxcor xoff 3 pycor yoff 9
  draw-obstacle pxcor xoff 5 pycor yoff 9
  draw-obstacle pxcor xoff 6 pycor yoff 9
  draw-obstacle pxcor xoff 8 pycor yoff 9
  draw-obstacle pxcor xoff 9 pycor yoff 9
  draw-obstacle pxcor xoff 5 pycor yoff 10
  draw-obstacle pxcor xoff 6 pycor yoff 10

end

;Holds the definition of tile-3.
;Whilst this tile will look the same wherever it appears in the
;game, an offset is needed so that all of the patches are drawn
;in their correct locations regardless of where they will appear.
;For clarity, the positions of the obstacles (before any offsets
;have been applied) are as follows:
;(3,2) (4,2) (7,2) (8,2) (3,3) (4,3) (7,3) (8,3) (3,4) (4,4) (5,4)
;(6,4) (7,4) (8,4) (3,5) (4,5) (5,5) (6,5) (7,5) (8,5) (3,6) (4,6)
;(5,6) (6,6) (7,6) (8,6) (3,7) (4,7) (5,7) (6,7) (7,7) (8,7) (3,8)
;(4,8) (5,8) (6,8) (7,8) (8,8) (3,9) (4,9) (7,9) (8,9) (3,10) (4,10)
;(7,10) (8,10)
to defined-tile-3 [xoff yoff]
  
  draw-obstacle pxcor xoff 3 pycor yoff 2
  draw-obstacle pxcor xoff 4 pycor yoff 2
  draw-obstacle pxcor xoff 7 pycor yoff 2
  draw-obstacle pxcor xoff 8 pycor yoff 2
  draw-obstacle pxcor xoff 3 pycor yoff 3
  draw-obstacle pxcor xoff 4 pycor yoff 3
  draw-obstacle pxcor xoff 7 pycor yoff 3
  draw-obstacle pxcor xoff 8 pycor yoff 3
  draw-obstacle pxcor xoff 3 pycor yoff 4
  draw-obstacle pxcor xoff 4 pycor yoff 4
  draw-obstacle pxcor xoff 5 pycor yoff 4
  draw-obstacle pxcor xoff 6 pycor yoff 4
  draw-obstacle pxcor xoff 7 pycor yoff 4
  draw-obstacle pxcor xoff 8 pycor yoff 4
  draw-obstacle pxcor xoff 3 pycor yoff 5
  draw-obstacle pxcor xoff 4 pycor yoff 5
  draw-obstacle pxcor xoff 5 pycor yoff 5
  draw-obstacle pxcor xoff 6 pycor yoff 5
  draw-obstacle pxcor xoff 7 pycor yoff 5
  draw-obstacle pxcor xoff 8 pycor yoff 5
  draw-obstacle pxcor xoff 3 pycor yoff 6
  draw-obstacle pxcor xoff 4 pycor yoff 6
  draw-obstacle pxcor xoff 5 pycor yoff 6
  draw-obstacle pxcor xoff 6 pycor yoff 6
  draw-obstacle pxcor xoff 7 pycor yoff 6
  draw-obstacle pxcor xoff 8 pycor yoff 6
  draw-obstacle pxcor xoff 3 pycor yoff 7
  draw-obstacle pxcor xoff 4 pycor yoff 7
  draw-obstacle pxcor xoff 5 pycor yoff 7
  draw-obstacle pxcor xoff 6 pycor yoff 7
  draw-obstacle pxcor xoff 7 pycor yoff 7
  draw-obstacle pxcor xoff 8 pycor yoff 7
  draw-obstacle pxcor xoff 3 pycor yoff 8
  draw-obstacle pxcor xoff 4 pycor yoff 8
  draw-obstacle pxcor xoff 5 pycor yoff 8
  draw-obstacle pxcor xoff 6 pycor yoff 8
  draw-obstacle pxcor xoff 7 pycor yoff 8
  draw-obstacle pxcor xoff 8 pycor yoff 8
  draw-obstacle pxcor xoff 3 pycor yoff 9
  draw-obstacle pxcor xoff 4 pycor yoff 9
  draw-obstacle pxcor xoff 7 pycor yoff 9
  draw-obstacle pxcor xoff 8 pycor yoff 9
  draw-obstacle pxcor xoff 3 pycor yoff 10
  draw-obstacle pxcor xoff 4 pycor yoff 10
  draw-obstacle pxcor xoff 7 pycor yoff 10
  draw-obstacle pxcor xoff 8 pycor yoff 10
  
end

;Holds the definition of tile-4.
;Whilst this tile will look the same wherever it appears in the
;game, an offset is needed so that all of the patches are drawn
;in their correct locations regardless of where they will appear.
;For clarity, the positions of the obstacles (before any offsets
;have been applied) are as follows:
;(2,2) (9,2) (5,3) (6,3) (2,5) (9,5) (2,6) (9,6) (5,7) (6,7) (2,9)
;(9,9)
to defined-tile-4 [xoff yoff]
  
  draw-obstacle pxcor xoff 2 pycor yoff 2
  draw-obstacle pxcor xoff 9 pycor yoff 2
  draw-obstacle pxcor xoff 5 pycor yoff 3
  draw-obstacle pxcor xoff 6 pycor yoff 3
  draw-obstacle pxcor xoff 2 pycor yoff 5
  draw-obstacle pxcor xoff 9 pycor yoff 5
  draw-obstacle pxcor xoff 2 pycor yoff 6
  draw-obstacle pxcor xoff 9 pycor yoff 6
  draw-obstacle pxcor xoff 5 pycor yoff 7
  draw-obstacle pxcor xoff 6 pycor yoff 7
  draw-obstacle pxcor xoff 2 pycor yoff 9
  draw-obstacle pxcor xoff 9 pycor yoff 9

end

;Holds the definition of tile-5.
;Whilst this tile will look the same wherever it appears in the
;game, an offset is needed so that all of the patches are drawn
;in their correct locations regardless of where they will appear.
;For clarity, the positions of the obstacles (before any offsets
;have been applied) are as follows:
;(5,1) (6,1) (2,2) (9,2) (3,5) (8,5) (3,6) (8,6) (2,9) (9,9) (5,10)
;(6,10)
to defined-tile-5 [xoff yoff]
  
  draw-obstacle pxcor xoff 5 pycor yoff 1
  draw-obstacle pxcor xoff 6 pycor yoff 1
  draw-obstacle pxcor xoff 2 pycor yoff 2
  draw-obstacle pxcor xoff 9 pycor yoff 2
  draw-obstacle pxcor xoff 3 pycor yoff 5
  draw-obstacle pxcor xoff 8 pycor yoff 5
  draw-obstacle pxcor xoff 3 pycor yoff 6
  draw-obstacle pxcor xoff 8 pycor yoff 6
  draw-obstacle pxcor xoff 2 pycor yoff 9
  draw-obstacle pxcor xoff 9 pycor yoff 9
  draw-obstacle pxcor xoff 5 pycor yoff 10
  draw-obstacle pxcor xoff 6 pycor yoff 10

end

;Holds the definition of tile-6.
;Whilst this tile will look the same wherever it appears in the
;game, an offset is needed so that all of the patches are drawn
;in their correct locations regardless of where they will appear.
;For clarity, the positions of the obstacles (before any offsets
;have been applied) are as follows:
;(1,1) (10,1) (3,3) (8,3) (5,5) (6,5) (5,6) (6,6) (3,8) (8,8) (1,10)
;(10,10)
to defined-tile-6 [xoff yoff]
  
  draw-obstacle pxcor xoff 1 pycor yoff 1
  draw-obstacle pxcor xoff 10 pycor yoff 1
  draw-obstacle pxcor xoff 3 pycor yoff 3
  draw-obstacle pxcor xoff 8 pycor yoff 3
  draw-obstacle pxcor xoff 5 pycor yoff 5
  draw-obstacle pxcor xoff 6 pycor yoff 5
  draw-obstacle pxcor xoff 5 pycor yoff 6
  draw-obstacle pxcor xoff 6 pycor yoff 6
  draw-obstacle pxcor xoff 3 pycor yoff 8
  draw-obstacle pxcor xoff 8 pycor yoff 8
  draw-obstacle pxcor xoff 1 pycor yoff 10
  draw-obstacle pxcor xoff 10 pycor yoff 10
  
end

;Holds the definition of tile-7.
;Whilst this tile will look the same wherever it appears in the
;game, an offset is needed so that all of the patches are drawn
;in their correct locations regardless of where they will appear.
;For clarity, the positions of the obstacles (before any offsets
;have been applied) are as follows:
;(0,0) (1,0) (2,0) (3,0) (0,1) (1,1) (2,1) (3,1) (9,0) (10,0) (11,0)
;(9,1) (10,1) (11,1) (4,5) (5,5) (6,5) (4,6) (5,6) (6,6) (4,7) (5,7)
;(6,7) (4,8) (5,8) (6,8) (4,9) (5,9) (6,9) (4,10) (5,10) (6,10)
; (4,11) (5,11) (6,11)

to defined-tile-7 [xoff yoff]
  
  
  draw-obstacle pxcor xoff 0 pycor yoff 0
  draw-obstacle pxcor xoff 1 pycor yoff 0
  draw-obstacle pxcor xoff 2 pycor yoff 0
  draw-obstacle pxcor xoff 3 pycor yoff 0
  draw-obstacle pxcor xoff 0 pycor yoff 1
  draw-obstacle pxcor xoff 1 pycor yoff 1
  draw-obstacle pxcor xoff 2 pycor yoff 1
  draw-obstacle pxcor xoff 3 pycor yoff 1
  draw-obstacle pxcor xoff 9 pycor yoff 0
  draw-obstacle pxcor xoff 10 pycor yoff 0
  draw-obstacle pxcor xoff 11 pycor yoff 0
  draw-obstacle pxcor xoff 9 pycor yoff 1
  draw-obstacle pxcor xoff 10 pycor yoff 1
  draw-obstacle pxcor xoff 11 pycor yoff 1
  draw-obstacle pxcor xoff 4 pycor yoff 5
  draw-obstacle pxcor xoff 5 pycor yoff 5
  draw-obstacle pxcor xoff 6 pycor yoff 5
  draw-obstacle pxcor xoff 4 pycor yoff 6
  draw-obstacle pxcor xoff 5 pycor yoff 6
  draw-obstacle pxcor xoff 6 pycor yoff 6
  draw-obstacle pxcor xoff 4 pycor yoff 7
  draw-obstacle pxcor xoff 5 pycor yoff 7
  draw-obstacle pxcor xoff 6 pycor yoff 7
  draw-obstacle pxcor xoff 4 pycor yoff 8
  draw-obstacle pxcor xoff 5 pycor yoff 8
  draw-obstacle pxcor xoff 6 pycor yoff 8
  draw-obstacle pxcor xoff 4 pycor yoff 9
  draw-obstacle pxcor xoff 5 pycor yoff 9
  draw-obstacle pxcor xoff 6 pycor yoff 9
  draw-obstacle pxcor xoff 4 pycor yoff 10
  draw-obstacle pxcor xoff 5 pycor yoff 10
  draw-obstacle pxcor xoff 6 pycor yoff 10
  draw-obstacle pxcor xoff 4 pycor yoff 11
  draw-obstacle pxcor xoff 5 pycor yoff 11
  draw-obstacle pxcor xoff 6 pycor yoff 11
  
end
@#$#@#$#@
GRAPHICS-WINDOW
319
14
810
526
-1
-1
13.0
1
10
1
1
1
0
0
0
1
0
36
0
36
0
0
1
ticks
30.0

BUTTON
49
43
139
76
Setup Map
setup
NIL
1
T
OBSERVER
NIL
M
NIL
NIL
1

@#$#@#$#@
## WHAT IS IT?

This Logo shows an approach to procedurally generate content during the Setup process of a game. Each time this Logo is ran, the map which it generates is different every time due to the way it utilises random number generators and a tileset.

## HOW IT WORKS

The model creates a pseudo-randomly generated map by utilising a number of different created methods, as well as functions that Netlogo provides.

When the Setup Map button is pressed by the user, the program firstly sections the map into a 3x3 grid: this is how we determine where the tiles will eventually appear on-screen. 

Then, the program generates 9 randomly generated numbers (derived from the 3x3 grid) that will be a numerical representation of the tile that will occupy the screen in a particular section of the grid (To illustrate this better, the bottom-left section of the grid will be tile number 1, and the top right section will be tile number 9).

Next, the program then asks all the patches in the game what their grid position is and, based upon what the value is, loads in the corresponding tile to that grid space. The program has [INSERT NUMBER OF TILES TOTAL] to choose from in its pseudo-random generation, giving a large number of possibilities for the final map.

Finally, the program places the ammo and fuel spawns, as well as the player and enemy spawns into the game. These are all placed using their own methods which randomly place each spawn onto a random white patch, and then place four ammo and four fuel spawns onto white patches.

## HOW TO USE IT

This model is easy to use, simply click on the Setup Map button to see the results of the random generation!

## THINGS TO NOTICE

Notice how pressing the Setup Map button again after pressing it before generates a different map, player spawns et al. This is because all of the code that generated the map the first time is ran again, giving an entirely new layout of the map!

## EXTENDING THE MODEL

The player could add in their own tile definitions using how this model defines them as an example. Plotting the tiles on graph paper between 0-11 on the x and y axes before creating them in code would be the best way to achieve this. Then, simply increasing the value of chance in the calc-tile method and then adding in functionality in the load-tile method to load the new tile will allow the new tile to be added into the tileset and thus be able to appear in the map.

## NETLOGO FEATURES

(interesting or unusual features of NetLogo that the model uses, particularly in the Code tab; or where workarounds were needed for missing features)

This model relies heavily on the random number generator built into Netlogo that, based upon the seed and the highest number it can generate, allows you to create pseudo-random numbers that can be utilised however you see fit. 

The model also uses the random-pxcor and random-pycor methods built into Netlogo to choose a random patch in the game in order to spawn both spawns and pickups. This was useful as this meant that a method didn't need to be created purely to do this as the functionality already exists.

## RELATED MODELS

(models in the NetLogo Models Library and elsewhere which are of related interest)

## CREDITS AND REFERENCES

(a reference to the model's URL on the web if it has one, as well as any other necessary credits, citations, and links)
@#$#@#$#@
default
true
0
Polygon -7500403 true true 150 5 40 250 150 205 260 250

airplane
true
0
Polygon -7500403 true true 150 0 135 15 120 60 120 105 15 165 15 195 120 180 135 240 105 270 120 285 150 270 180 285 210 270 165 240 180 180 285 195 285 165 180 105 180 60 165 15

arrow
true
0
Polygon -7500403 true true 150 0 0 150 105 150 105 293 195 293 195 150 300 150

box
false
0
Polygon -7500403 true true 150 285 285 225 285 75 150 135
Polygon -7500403 true true 150 135 15 75 150 15 285 75
Polygon -7500403 true true 15 75 15 225 150 285 150 135
Line -16777216 false 150 285 150 135
Line -16777216 false 150 135 15 75
Line -16777216 false 150 135 285 75

bug
true
0
Circle -7500403 true true 96 182 108
Circle -7500403 true true 110 127 80
Circle -7500403 true true 110 75 80
Line -7500403 true 150 100 80 30
Line -7500403 true 150 100 220 30

butterfly
true
0
Polygon -7500403 true true 150 165 209 199 225 225 225 255 195 270 165 255 150 240
Polygon -7500403 true true 150 165 89 198 75 225 75 255 105 270 135 255 150 240
Polygon -7500403 true true 139 148 100 105 55 90 25 90 10 105 10 135 25 180 40 195 85 194 139 163
Polygon -7500403 true true 162 150 200 105 245 90 275 90 290 105 290 135 275 180 260 195 215 195 162 165
Polygon -16777216 true false 150 255 135 225 120 150 135 120 150 105 165 120 180 150 165 225
Circle -16777216 true false 135 90 30
Line -16777216 false 150 105 195 60
Line -16777216 false 150 105 105 60

car
false
0
Polygon -7500403 true true 300 180 279 164 261 144 240 135 226 132 213 106 203 84 185 63 159 50 135 50 75 60 0 150 0 165 0 225 300 225 300 180
Circle -16777216 true false 180 180 90
Circle -16777216 true false 30 180 90
Polygon -16777216 true false 162 80 132 78 134 135 209 135 194 105 189 96 180 89
Circle -7500403 true true 47 195 58
Circle -7500403 true true 195 195 58

circle
false
0
Circle -7500403 true true 0 0 300

circle 2
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240

cow
false
0
Polygon -7500403 true true 200 193 197 249 179 249 177 196 166 187 140 189 93 191 78 179 72 211 49 209 48 181 37 149 25 120 25 89 45 72 103 84 179 75 198 76 252 64 272 81 293 103 285 121 255 121 242 118 224 167
Polygon -7500403 true true 73 210 86 251 62 249 48 208
Polygon -7500403 true true 25 114 16 195 9 204 23 213 25 200 39 123

cylinder
false
0
Circle -7500403 true true 0 0 300

dot
false
0
Circle -7500403 true true 90 90 120

face happy
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 255 90 239 62 213 47 191 67 179 90 203 109 218 150 225 192 218 210 203 227 181 251 194 236 217 212 240

face neutral
false
0
Circle -7500403 true true 8 7 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Rectangle -16777216 true false 60 195 240 225

face sad
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 168 90 184 62 210 47 232 67 244 90 220 109 205 150 198 192 205 210 220 227 242 251 229 236 206 212 183

fish
false
0
Polygon -1 true false 44 131 21 87 15 86 0 120 15 150 0 180 13 214 20 212 45 166
Polygon -1 true false 135 195 119 235 95 218 76 210 46 204 60 165
Polygon -1 true false 75 45 83 77 71 103 86 114 166 78 135 60
Polygon -7500403 true true 30 136 151 77 226 81 280 119 292 146 292 160 287 170 270 195 195 210 151 212 30 166
Circle -16777216 true false 215 106 30

flag
false
0
Rectangle -7500403 true true 60 15 75 300
Polygon -7500403 true true 90 150 270 90 90 30
Line -7500403 true 75 135 90 135
Line -7500403 true 75 45 90 45

flower
false
0
Polygon -10899396 true false 135 120 165 165 180 210 180 240 150 300 165 300 195 240 195 195 165 135
Circle -7500403 true true 85 132 38
Circle -7500403 true true 130 147 38
Circle -7500403 true true 192 85 38
Circle -7500403 true true 85 40 38
Circle -7500403 true true 177 40 38
Circle -7500403 true true 177 132 38
Circle -7500403 true true 70 85 38
Circle -7500403 true true 130 25 38
Circle -7500403 true true 96 51 108
Circle -16777216 true false 113 68 74
Polygon -10899396 true false 189 233 219 188 249 173 279 188 234 218
Polygon -10899396 true false 180 255 150 210 105 210 75 240 135 240

house
false
0
Rectangle -7500403 true true 45 120 255 285
Rectangle -16777216 true false 120 210 180 285
Polygon -7500403 true true 15 120 150 15 285 120
Line -16777216 false 30 120 270 120

leaf
false
0
Polygon -7500403 true true 150 210 135 195 120 210 60 210 30 195 60 180 60 165 15 135 30 120 15 105 40 104 45 90 60 90 90 105 105 120 120 120 105 60 120 60 135 30 150 15 165 30 180 60 195 60 180 120 195 120 210 105 240 90 255 90 263 104 285 105 270 120 285 135 240 165 240 180 270 195 240 210 180 210 165 195
Polygon -7500403 true true 135 195 135 240 120 255 105 255 105 285 135 285 165 240 165 195

line
true
0
Line -7500403 true 150 0 150 300

line half
true
0
Line -7500403 true 150 0 150 150

pentagon
false
0
Polygon -7500403 true true 150 15 15 120 60 285 240 285 285 120

person
false
0
Circle -7500403 true true 110 5 80
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Rectangle -7500403 true true 127 79 172 94
Polygon -7500403 true true 195 90 240 150 225 180 165 105
Polygon -7500403 true true 105 90 60 150 75 180 135 105

plant
false
0
Rectangle -7500403 true true 135 90 165 300
Polygon -7500403 true true 135 255 90 210 45 195 75 255 135 285
Polygon -7500403 true true 165 255 210 210 255 195 225 255 165 285
Polygon -7500403 true true 135 180 90 135 45 120 75 180 135 210
Polygon -7500403 true true 165 180 165 210 225 180 255 120 210 135
Polygon -7500403 true true 135 105 90 60 45 45 75 105 135 135
Polygon -7500403 true true 165 105 165 135 225 105 255 45 210 60
Polygon -7500403 true true 135 90 120 45 150 15 180 45 165 90

sheep
false
15
Circle -1 true true 203 65 88
Circle -1 true true 70 65 162
Circle -1 true true 150 105 120
Polygon -7500403 true false 218 120 240 165 255 165 278 120
Circle -7500403 true false 214 72 67
Rectangle -1 true true 164 223 179 298
Polygon -1 true true 45 285 30 285 30 240 15 195 45 210
Circle -1 true true 3 83 150
Rectangle -1 true true 65 221 80 296
Polygon -1 true true 195 285 210 285 210 240 240 210 195 210
Polygon -7500403 true false 276 85 285 105 302 99 294 83
Polygon -7500403 true false 219 85 210 105 193 99 201 83

square
false
0
Rectangle -7500403 true true 30 30 270 270

square 2
false
0
Rectangle -7500403 true true 30 30 270 270
Rectangle -16777216 true false 60 60 240 240

star
false
0
Polygon -7500403 true true 151 1 185 108 298 108 207 175 242 282 151 216 59 282 94 175 3 108 116 108

tank
true
0
Rectangle -2674135 true false 135 105 150 120
Rectangle -2674135 true false 135 120 150 135
Rectangle -2674135 true false 135 90 150 105
Rectangle -2674135 true false 105 135 180 225
Rectangle -16777216 false false 135 90 150 165

target
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240
Circle -7500403 true true 60 60 180
Circle -16777216 true false 90 90 120
Circle -7500403 true true 120 120 60

tree
false
0
Circle -7500403 true true 118 3 94
Rectangle -6459832 true false 120 195 180 300
Circle -7500403 true true 65 21 108
Circle -7500403 true true 116 41 127
Circle -7500403 true true 45 90 120
Circle -7500403 true true 104 74 152

triangle
false
0
Polygon -7500403 true true 150 30 15 255 285 255

triangle 2
false
0
Polygon -7500403 true true 150 30 15 255 285 255
Polygon -16777216 true false 151 99 225 223 75 224

truck
false
0
Rectangle -7500403 true true 4 45 195 187
Polygon -7500403 true true 296 193 296 150 259 134 244 104 208 104 207 194
Rectangle -1 true false 195 60 195 105
Polygon -16777216 true false 238 112 252 141 219 141 218 112
Circle -16777216 true false 234 174 42
Rectangle -7500403 true true 181 185 214 194
Circle -16777216 true false 144 174 42
Circle -16777216 true false 24 174 42
Circle -7500403 false true 24 174 42
Circle -7500403 false true 144 174 42
Circle -7500403 false true 234 174 42

turtle
true
0
Polygon -10899396 true false 215 204 240 233 246 254 228 266 215 252 193 210
Polygon -10899396 true false 195 90 225 75 245 75 260 89 269 108 261 124 240 105 225 105 210 105
Polygon -10899396 true false 105 90 75 75 55 75 40 89 31 108 39 124 60 105 75 105 90 105
Polygon -10899396 true false 132 85 134 64 107 51 108 17 150 2 192 18 192 52 169 65 172 87
Polygon -10899396 true false 85 204 60 233 54 254 72 266 85 252 107 210
Polygon -7500403 true true 119 75 179 75 209 101 224 135 220 225 175 261 128 261 81 224 74 135 88 99

wheel
false
0
Circle -7500403 true true 3 3 294
Circle -16777216 true false 30 30 240
Line -7500403 true 150 285 150 15
Line -7500403 true 15 150 285 150
Circle -7500403 true true 120 120 60
Line -7500403 true 216 40 79 269
Line -7500403 true 40 84 269 221
Line -7500403 true 40 216 269 79
Line -7500403 true 84 40 221 269

wolf
false
0
Polygon -16777216 true false 253 133 245 131 245 133
Polygon -7500403 true true 2 194 13 197 30 191 38 193 38 205 20 226 20 257 27 265 38 266 40 260 31 253 31 230 60 206 68 198 75 209 66 228 65 243 82 261 84 268 100 267 103 261 77 239 79 231 100 207 98 196 119 201 143 202 160 195 166 210 172 213 173 238 167 251 160 248 154 265 169 264 178 247 186 240 198 260 200 271 217 271 219 262 207 258 195 230 192 198 210 184 227 164 242 144 259 145 284 151 277 141 293 140 299 134 297 127 273 119 270 105
Polygon -7500403 true true -1 195 14 180 36 166 40 153 53 140 82 131 134 133 159 126 188 115 227 108 236 102 238 98 268 86 269 92 281 87 269 103 269 113

x
false
0
Polygon -7500403 true true 270 75 225 30 30 225 75 270
Polygon -7500403 true true 30 75 75 30 270 225 225 270

@#$#@#$#@
NetLogo 5.1.0
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
default
0.0
-0.2 0 0.0 1.0
0.0 1 1.0 0.0
0.2 0 0.0 1.0
link direction
true
0
Line -7500403 true 150 150 90 180
Line -7500403 true 150 150 210 180

@#$#@#$#@
0
@#$#@#$#@
