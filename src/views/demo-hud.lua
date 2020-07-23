---demo hud views

---draw hud
function hud_draw()
	for player in all(p) do
		--print health
		print_shadow('p'..tostr(player.index), cam.x + 94, player.index * 7, 7)
		hud_health(player.index, cam.x + 102, player.index * 7)
	end
end

---draw health
function hud_health(player, x, y)
  for i=0, 4 do
    rect(x + (i * 5) + 2, y + 1, x + (i * 5) + 5, y + 5, 1)
    rect(x + (i * 5) + 1, y, x + (i * 5) + 4, y + 4, 7)
  end

  local bars = ceil(p[player].health / 20)

  for i=0, bars - 1 do
    rectfill(x + (i * 5) + 2, y + 1, x + (i * 5) + 3, y + 3, 8)
  end
end
