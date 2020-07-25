pico-8 cartridge // http://www.pico-8.com
version 29
__lua__
--pico-8 platformer engine
--by ridgek
--https://ridgek.itch.io
--
--released under a
--gpl v3 license

-->8
---engine models
#include ./models/actors.lua
#include ./models/players.lua

-->8
---engine controllers
#include ./controllers/global.lua
#include ./controllers/actors.lua
#include ./controllers/players.lua

-->8
---engine views

-->8
---app
#include ./app/app.lua
#include ./app/game.lua

-->8
---demo modules
#include ./modules/global/camera.lua
#include ./modules/global/print-helpers.lua

#include ./modules/app/title-credits.lua
#include ./modules/app/title-menu.lua
#include ./modules/app/config-menu.lua

#include ./modules/actors/2d-jump.lua
#include ./modules/actors/collision-per-px.lua
#include ./modules/actors/state-frames-deserialize.lua

#include ./modules/actors/draw-sprite.lua

-->8
---demo models
#include ./models/demo-players.lua

-->8
---demo controllers
#include ./controllers/demo-players.lua

-->8
---demo views
#include ./views/demo-actors.lua
#include ./views/demo-players.lua
#include ./views/demo-hud.lua

-->8
---demo debug
#include ./views/actors-debug.lua
#include ./modules/actors/draw-sprite-debug.lua
#include ./modules/actors/collision-aabb-debug.lua
#include ./modules/actors/collision-per-px-debug.lua

