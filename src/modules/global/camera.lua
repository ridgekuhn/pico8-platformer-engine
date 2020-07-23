---camera functions

---initialize camera
function camera_init()
  cam = {
    x = 0,
    y = 0,
    shake = 0
  }
end

---follow player 1
function camera_follow()
  local newx = mid(0, p[1].x - 56, 64)
  local dx = newx - cam.x

  if(dx > 1) then
    cam.x += 2
  elseif(dx < -1) then
    cam.x -= 2
  else
    cam.x = newx
  end

  cam.y = 0

  camera_shake()

  camera(cam.x, cam.y)
end

---shake camera
function camera_shake()
  if(cam.shake > 0) then
    cam.x += cam.shake - (rnd(cam.shake * 2))
    cam.y += cam.shake - (rnd(cam.shake * 2))

    cam.shake *= .9

    if(cam.shake < .1) then
      cam.shake = 0
    end
  end
end
