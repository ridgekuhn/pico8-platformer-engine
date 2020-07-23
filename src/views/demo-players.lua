---player 1 views

---draws player 1 to screen
function p:draw()
  for player in all(p) do
    pal(11, player.color)

    if(player.invincible) then
      player:draw_invincible()
    else
      player:draw_sprite()
    end

    pal()

    player:update_cors(player.dcors)
  end
end

---flash sprite
function p:draw_invincible()
  if(self.sclock % 2 == 0 and
     self.state ~= 'hit'
  ) then
    return
  else
    self:draw_sprite()
  end
end

---draw speech bubbles
function p:speak(line)
  add(self.dcors, cocreate(function()
    for i=1, 90, 1 do
      --speech bubble
      circfill(self.x + 13, self.y - 1, .5, 7)
      circfill(self.x + 14, self.y - 2, 1, 7)
      circfill(self.x + 15, self.y - 3, 1.5, 7)
      ovalfill(self.x + 12, self.y - 16, self.x + 20 + (#self.dialogue[line] * 4), self.y, 7)

      --dialogue
      print(self.dialogue[line], self.x + 17, self.y - 10, 1)

      yield()
    end
  end))
end

