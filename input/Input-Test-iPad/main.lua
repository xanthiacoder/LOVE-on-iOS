-- for love 12.0
-- on iphone (landscape), screen seems to be 830x368 (hard to touch corners x:30px y20px)
-- iphone landscape, camera island 60px, bottom swipe bar 40px
-- iPad 10 Gen desktop: 1180 x 820, 147 chars wide (1176px) by 51 char height (816px)
-- iPad safe area: 1024 x 768, 128 chars by 48 chars

function love.load()

	-- flags
	mouseDetected = false

	-- variables
	mouse = {}
	mouse.x = 0
	mouse.y = 0
	mouse.button = 0
	mouse.clicks = 0
	keypressed = {}
	keypressedHistory = ""	
	holdToQuit = 0
	
	-- codepage 437, 8x16 px, 80x30 chars (640x480)
	monoFont = love.graphics.newFont("Mx437_IBM_VGA_8x16.ttf", 16)
	FONT_WIDTH = 8
	FONT_HEIGHT = 16
	love.graphics.setFont( monoFont )
	print(monoFont:getWidth("█"))
	print(monoFont:getHeight())

	-- joystick code
	local axisCount = {}
	local buttonCount = {}
	local hatCount = {}
  local joystick = love.joystick.getJoysticks() -- table
	if joystick ~= nil then -- not empty table, joystick(s) detected
		for i = 1,#joystick do
			axisCount[i] = joystick[i]:getAxisCount() -- number
			buttonCount[i] = joystick[i]:getButtonCount() -- number
			hatCount[i] = joystick[i]:getHatCount() -- number
		end
	end

end


function love.textinput(t)
	-- callback on text input
end


function love.keypressed(key, scancode, isrepeat)
	-- trap 'escape' unicode 27 to quit
	-- if key == "escape" then
	--		love.filesystem.write( "textdump.txt", stringValue )		
	--		love.event.quit()
	-- end
	local keyPressedBefore = false
	for _, value in pairs(keypressed) do
		if type(value) == "string" and value == scancode then
			keyPressedBefore = true
		end
	end
	if keyPressedBefore == false then -- scancode not found in table
		-- add scancode to keypressed table
		table.insert(keypressed, scancode)
		table.sort(keypressed)
	end
end

function love.keyreleased(key, scancode)
	-- reset holdToQuit
	holdToQuit = 0
end


function love.joystickpressed(joystick,button) -- joystick is object, button is number
	-- joystick button presses detected
end

-- love.mousepressed( x, y, button, istouch, presses )
-- number presses
-- The number of presses in a short time frame and small area, used to simulate double, triple clicks
function love.mousepressed( x, y, button, istouch, presses )
	-- mouse button presses detected
	mouse.button = button
	mouse.clicks = presses
end
function love.mousemoved( x, y, dx, dy, istouch )
	-- mouse movement detected
	mouseDetected = true
	mouse.x = love.mouse.getX()
	mouse.y = love.mouse.getY()
end
-- love.touchpressed( id, x, y, dx, dy, pressure )
-- number pressure
-- The amount of pressure being applied. Most touch screens aren't pressure sensitive, in which case the pressure will be 1.
function love.mousereleased( x, y, button, istouch, presses )
	-- reset holdToQuit
	holdToQuit = 0
end

function love.touchpressed( id, x, y, dx, dy, pressure )
	-- detect touches
end

function love.draw()
	-- set font before draw text
  love.graphics.setFont(monoFont)
    
  -- draw joysticks data
  love.graphics.print("--[ Joysticks ]--"..love.joystick.getJoystickCount(),FONT_WIDTH*0,FONT_HEIGHT*0)
	if joystick ~= nil then -- not empty table, joystick(s) detected
		for i = 1,#joystick do
			love.graphics.print("Joystick "..i..": "..axisCount[i].." axes,"..buttonCount[i].." buttons, "..hatCount[i].." hats",FONT_WIDTH*0,FONT_HEIGHT*(i))
		end
	else
		love.graphics.print("No joystick detected",FONT_WIDTH*0,FONT_HEIGHT*1)
  end  

	-- draw mouse data
  love.graphics.print("--[ Mouse ]--",FONT_WIDTH*0,FONT_HEIGHT*5)
	if mouseDetected then
		love.graphics.print("Mouse detected, x:"..mouse.x.." y:"..mouse.y,FONT_WIDTH*0,FONT_HEIGHT*6)
		if mouse.button > 0 then
			love.graphics.print("Mouse button "..mouse.button.." pressed, "..mouse.clicks.." clicks",FONT_WIDTH*0,FONT_HEIGHT*7)		
		end
	else
		love.graphics.print("No mouse detected",FONT_WIDTH*0,FONT_HEIGHT*6)
	end

	-- draw touch data
  love.graphics.print("--[ Touches ]--",FONT_WIDTH*0,FONT_HEIGHT*9)
	if love.touch.getTouches() ~= nil then
		love.graphics.print("#getTouches = "..#love.touch.getTouches(),FONT_WIDTH*0,FONT_HEIGHT*10)
		local touches = love.touch.getTouches()
    for i, id in ipairs(touches) do
      local x, y = love.touch.getPosition(id)
      love.graphics.circle("fill", x, y, 20)
			love.graphics.print("Touch "..i.." x:"..math.floor(x).." y:"..math.floor(y),FONT_WIDTH*0,FONT_HEIGHT*(10+i))
    end	
  else
		love.graphics.print("getTouches == nil",FONT_WIDTH*0,FONT_HEIGHT*10)	
	end	

	-- draw keyboard data
  love.graphics.print("--[ Keyboard ]--",FONT_WIDTH*40,FONT_HEIGHT*0)
  love.graphics.print("#keypressed = "..#keypressed,FONT_WIDTH*40,FONT_HEIGHT*1)
	keypressedHistory = ""
	for _, value in pairs(keypressed) do
		keypressedHistory = keypressedHistory .. value .. " "
	end
	love.graphics.printf(keypressedHistory, FONT_WIDTH*40, FONT_HEIGHT*2, FONT_WIDTH*40, "left")

	width_desktop, height_desktop = love.window.getDesktopDimensions(1)
	width_window, height_window = love.graphics.getDimensions()
	love.graphics.print("desktop size : "..width_desktop.."x"..height_desktop,FONT_WIDTH*0,FONT_HEIGHT*26)
	love.graphics.print("window size  : "..width_window.."x"..height_window,FONT_WIDTH*0,FONT_HEIGHT*27)
  love.graphics.print("--[ hold anything to quit ]--",FONT_WIDTH*((80-30)/2),FONT_HEIGHT*46)
	love.graphics.printf(holdToQuit,FONT_WIDTH*0,FONT_HEIGHT*47,FONT_WIDTH*80, "center")

end



function love.update(dt)

-- joystickcount = love.joystick.getJoystickCount( ) -- number
-- direction = Joystick:getHat( hat ) -- constant: c d l ld lu r rd ru u

-- x, y = love.touch.getPosition( id )
-- pressure = love.touch.getPressure( id )

	-- for holdToQuit feature
	if love.mouse.isDown( 1, 2, 3) then
		holdToQuit = holdToQuit + dt
	end

	if holdToQuit >= 3 then
		love.event.quit()
	end

end