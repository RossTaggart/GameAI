__includes [ "setup.nls" "playerProcedures.nls" "botProcedures.nls" "ProceduralGeneration.nls" ]

; global variables used
globals [
  action                ; last button pressed
  score                 ; current score
  lives                 ; remaining lives
  range                 ; tank fire range
  playerHealth          ; player current health
  max-health            ; maximum player health
  playerAmmo            ; current ammo
  max-ammo              ; maximum ammo you can carry
  playerFuelLevel       ; current fuel
  max-fuel              ; maximum fuel you can carry
  playerState           ; the player's state
  dead?                 ; are you dead
  enemyHealth           ; the current health of the enemy
  enemyAmmo             ; the current amount of ammo they have
  enemyFuel             ; enemy fuel level
  current-enemy-state   ; the current state of the enemy tank
  end-game              ; the state of ended game
  debug-state           ; debug state for the enemy tank (temp)
  enemy-can-shoot?      ; if the enemy can shoot or not
  
  destination              ; the currently assigned destination for the bot
  current-bot-move-rate    ; the bot's currently set movement rate
  current-player-move-rate ; the player's currently set movement rate
  
  open                     ; the open list of patches
  closed                   ; the closed list of patches
  optimal-path             ; the optimal path, list of patches from source to destination
  
  heuristic-value
]

patches-own
[
  parent-patch ; patch's predecessor
  f ; g + h
  g ; distance so far (knowledge)
  h ; estimated distance to go (heuristic)
  move-rate ; turtle move-rate on this patch
]
  
;; A breed of turtle (bots)
breed [ bots bot ]
bots-own 
[
  path ; optimal path from source to destination
  current-path ; the remaining part of the path
]

;; A breed of turtle (player)
breed [ players player ]
players-own 
[ 
  state
]

;; A breed of turtle (ammo)
breed [ ammos ammo ]

;; A breed of turtle (fuel)
breed [ fuels fuel ]

;; A breed of turtle (missile)
breed [ missiles missile ]

;; A breed of turtle (bomb)
breed [ bombs bomb ]

to play ;; Forever button
  if playerHealth = 0 or playerFuelLevel = 0
  [ user-message "YOU FAILED. YOU FAILURE"   toggleendgame ]
  
  ;;Displays win message if the enemy is destroyed.
  if enemyHealth = 0
  [ user-message "Congratulations, you win!" toggleendgame ]
  
  if end-game = "true"
  [
    stop 
  ]
  every ( current-player-move-rate )
  [ 
    input-player ;; Player move/fire
    changePlayerState
  ]
  every ( current-bot-move-rate )
  [
    input-bots ;; Bots move/fire
  ]
  every (0.25)
  [
    ;;This is put here to stop the missiles from gaining speed whenever the player is moved.
    ;;If this is put in "input-player" procedure in playerProcedures.nls, the speed of the
    ;;missiles is increased as the player is moved. Putting this here allows the missiles to
    ;;move at a steady speed independent of the player movement.
    shoot-missiles
    Enemy-shoot-missiles
  ]
end

to toggleendgame
  if end-game = "true"
  [set end-game  "false"]
  
   if end-game = "false"
  [set end-game "true"]
end

to verify-map
  
  ask bots
  [
   die 
  ]
  
  ask players
  [
   die 
  ]
  
  setup-bots
  setup-player
  
end
@#$#@#$#@
GRAPHICS-WINDOW
244
22
735
534
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
11
22
121
62
Setup
new
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
124
22
232
62
Play
play
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
93
356
148
389
Up
move-up
NIL
1
T
OBSERVER
NIL
W
NIL
NIL
1

BUTTON
93
391
148
424
Down
move-down
NIL
1
T
OBSERVER
NIL
S
NIL
NIL
1

BUTTON
150
391
205
424
Right
move-right
NIL
1
T
OBSERVER
NIL
D
NIL
NIL
1

BUTTON
36
391
91
424
Left
move-left
NIL
1
T
OBSERVER
NIL
A
NIL
NIL
1

SWITCH
16
67
119
100
debug?
debug?
1
1
-1000

BUTTON
11
105
124
138
Draw Elements
Draw
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

CHOOSER
10
144
148
189
DrawElements
DrawElements
"Path" "Obstacle" "Player Spawn" "Tank Spawn" "Slow Ground"
1

BUTTON
126
67
189
100
Clear
__clear-all-and-reset-ticks\nask patches [ set pcolor white ]
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

MONITOR
1094
29
1151
74
Fuel
playerFuelLevel
17
1
11

MONITOR
1032
29
1089
74
Health
playerHealth
17
1
11

MONITOR
14
200
140
245
current enemy state
current-enemy-state
17
1
11

MONITOR
18
250
138
295
enemy state debug
debug-state
17
1
11

BUTTON
158
111
221
144
Fire
shoot
NIL
1
T
OBSERVER
NIL
F
NIL
NIL
1

MONITOR
970
28
1027
73
Ammo
playerAmmo
17
1
11

MONITOR
864
30
965
75
Max Ammo Limit
max-ammo
17
1
11

MONITOR
769
29
858
74
Enemy Health
enemyHealth
17
1
11

PLOT
769
125
1127
302
Heuristic performance
Time
Patches considered
0.0
10.0
0.0
1024.0
true
false
"" ""
PENS
"default" 1.0 0 -16777216 true "" "plot length open + length closed"

MONITOR
770
73
857
118
Enemy Ammo
enemyAmmo
17
1
11

BUTTON
150
171
240
204
Verify Map
verify-map
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

MONITOR
17
299
106
344
Player's State
playerState
17
1
11

TEXTBOX
774
315
924
371
Floor Tiles\nRed = Obstacle\nWhite = Drivable(FullSpeed)\nGrey = Drivable(Slow)\n
11
0.0
1

TEXTBOX
774
387
924
457
Pickups:\n(These are custom shapes, but appear too small to see)\nGreen with yellow = Ammo\nGreen with black = Fuel
11
0.0
1

@#$#@#$#@
## WHAT IS IT?

A top down tank game,
You play a tank with a given fuel level and ammo amount, you must destroy the enemy tank before he destroys you!
You can pick up extra ammo and fuel along the way - but watch, the enemy can also pick it up!

## HOW IT WORKS

The player and enemy will both spawn on random patches - unless you use the level editor to create your own, in which case they will spawn in their respective places.
The enemy will being to search for the player - it will roam around different patches until it gets close to the player then it will start to seek the players exact location, if the player gets close enough it will stop and start firing at you.


## HOW TO USE IT

Press the setup button to create the level - or use the level editor to create a level.
+ select the patches you would like to place and place them
+ you MUST have one and only one player patch and enemy spawn patch
+ delete or do not add fuel or ammo to make the game more challenging

Press the go button - the enemy tank will start to search for you
+ click on the white space to allow you to use the keyboard
+ wasd is the movement control
+ f to fire

+ if you are low on fuel, head to a fuel pickup
+ if you are low on ammo, head to an ammo pickup

+ kill the enemy before it kills you!

## THINGS TO NOTICE

+ White patches are walkable at full speed
+ Red patches are obstacles
+ Grey patches are walkable at a lesser speed
+ Enemy tank can seek randomly, chase precisely and attack player
+ Sound is implemented with multiple different sound effects
+ animations are also implemented when the player or enemy gets hit

## THINGS TO TRY

Enable debug mode to see open/closed lists (note that this will remove some obstacles)

## EXTENDING THE MODEL

+ line of sight recognition and behavioural heuristics

## CREDITS AND REFERENCES

Netlogo dictionary
Netlogo user-manual
http://ccl.northwestern.edu/netlogo/models/community/Astardemo1

Alexander Malcolm
Elliot Pryde
Imran Shafiq
Ross Taggart
@#$#@#$#@
default
true
0
Polygon -7500403 true true 150 5 40 250 150 205 260 250

airplane
true
0
Polygon -7500403 true true 150 0 135 15 120 60 120 105 15 165 15 195 120 180 135 240 105 270 120 285 150 270 180 285 210 270 165 240 180 180 285 195 285 165 180 105 180 60 165 15

ammoshape
true
15
Rectangle -10899396 true false 60 75 255 225
Circle -955883 true false 75 120 30
Rectangle -1184463 true false 75 135 105 195
Circle -955883 true false 120 120 30
Circle -955883 true false 165 120 30
Circle -955883 true false 210 120 30
Rectangle -1184463 true false 210 135 240 195
Rectangle -1184463 true false 165 135 195 195
Rectangle -1184463 true false 120 135 150 195

arrow
true
0
Polygon -7500403 true true 150 0 0 150 105 150 105 293 195 293 195 150 300 150

arrow 3
true
0
Polygon -7500403 true true 135 255 105 300 105 225 135 195 135 75 105 90 150 0 195 90 165 75 165 195 195 225 195 300 165 255

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

fuelshape
true
0
Rectangle -10899396 true false 90 45 210 255
Rectangle -13840069 true false 105 60 195 240
Rectangle -10899396 true false 120 75 180 225
Rectangle -16777216 false false 105 60 195 240
Rectangle -16777216 false false 120 75 180 225
Rectangle -16777216 false false 90 45 210 255
Line -16777216 false 135 90 165 90
Line -16777216 false 165 90 165 105
Line -16777216 false 150 90 150 105
Line -16777216 false 165 120 135 120
Line -16777216 false 135 120 135 135
Line -16777216 false 135 135 165 135
Line -16777216 false 165 150 165 165
Line -16777216 false 165 150 135 150
Line -16777216 false 135 150 135 165
Line -16777216 false 150 150 150 165
Line -16777216 false 165 180 135 180
Line -16777216 false 135 180 135 195

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

missile
true
0
Polygon -13840069 true false 135 60 143 46 150 60 150 120 158 135 158 146 150 135 150 150 135 150 135 135 128 146 128 135 135 120 135 60

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

rocket
true
0
Polygon -7500403 true true 120 165 75 285 135 255 165 255 225 285 180 165
Polygon -1 true false 135 285 105 135 105 105 120 45 135 15 150 0 165 15 180 45 195 105 195 135 165 285
Rectangle -7500403 true true 147 176 153 288
Polygon -7500403 true true 120 45 180 45 165 15 150 0 135 15
Line -7500403 true 105 105 135 120
Line -7500403 true 135 120 165 120
Line -7500403 true 165 120 195 105
Line -7500403 true 105 135 135 150
Line -7500403 true 135 150 165 150
Line -7500403 true 165 150 195 135

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
Rectangle -13840069 true false 90 90 195 225
Rectangle -10899396 true false 105 120 180 195
Rectangle -10899396 true false 135 45 150 195
Rectangle -16777216 false false 135 45 150 150

tank_dead
true
0
Rectangle -13840069 true false 135 195 225 255
Rectangle -16777216 false false 135 45 150 150
Polygon -13840069 true false 135 75 75 135 105 180 195 150 135 75
Rectangle -10899396 true false 105 135 165 225
Rectangle -13840069 true false 30 165 120 180
Rectangle -16777216 false false 30 165 120 180

tank_dead_1
true
0
Rectangle -13840069 true false 90 90 195 225
Rectangle -10899396 true false 105 120 180 195
Rectangle -10899396 true false 135 45 150 195
Rectangle -16777216 false false 135 45 150 150
Circle -2674135 true false 88 103 95
Circle -955883 true false 105 135 60
Circle -1184463 true false 114 159 42

tank_dead_2
true
0
Rectangle -13840069 true false 90 90 195 225
Rectangle -10899396 true false 105 120 180 195
Rectangle -10899396 true false 135 45 150 195
Rectangle -16777216 false false 135 45 150 150
Circle -2674135 true false 60 105 150
Circle -955883 true false 75 120 120
Circle -1184463 true false 120 135 60
Circle -2674135 true false 90 150 60
Circle -955883 true false 114 144 42

tank_dead_3
true
0
Rectangle -13840069 true false 90 90 195 225
Rectangle -10899396 true false 105 120 180 195
Rectangle -10899396 true false 135 45 150 195
Rectangle -16777216 false false 135 45 150 150
Circle -2674135 true false 30 60 210
Circle -955883 true false 45 75 150
Circle -1184463 true false 105 120 150
Circle -2674135 true false 86 41 127
Circle -955883 true false 75 90 120

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
