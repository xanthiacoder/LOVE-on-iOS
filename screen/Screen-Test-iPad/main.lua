-- for love 12.0
-- on iphone (landscape), screen seems to be 830x368 (hard to touch corners x:30px y20px)
-- iphone landscape, camera island 60px, bottom swipe bar 40px
-- iPad 10 Gen desktop: 1180 x 820, 147 chars wide (1176px) by 51 char height (816px)
-- iPad safe area: 1024 x 768, 128 chars by 48 chars
-- draw to a 1024 x 768 canvas, then draw the canvas centered on desktop
-- need this for canvas - love.graphics.setBlendMode("alpha", "premultiplied")
-- crtmonitor background is 1376 x 1032, screen edge offsetX = - 176, Y = -132

local utf8 = require("utf8") -- needed for extended ASCII codes

function love.load()

	-- graphics
	canvas = love.graphics.newCanvas(1024, 768) -- make a new canvas

	-- constants
	WIDTH_DESKTOP, HEIGHT_DESKTOP = love.window.getDesktopDimensions(1)
	WIDTH_WINDOW, HEIGHT_WINDOW = love.graphics.getDimensions()
	FONT_WIDTH = 8
	FONT_HEIGHT = 16
	if WIDTH_DESKTOP > 1024 then
		SCREEN_OFFSETX = math.floor((WIDTH_DESKTOP-1024)/2)
	else
		SCREEN_OFFSETX = 0
	end
	if HEIGHT_DESKTOP > 768 then
		SCREEN_OFFSETY = math.floor((HEIGHT_DESKTOP-768)/2)
	else
		SCREEN_OFFSETY = 0
	end
	BGOFFSETX = -176+SCREEN_OFFSETX --{ offset position of CRT Monitor 
	BGOFFSETY = -132+SCREEN_OFFSETY --{ 


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
	monoFont = love.graphics.newFont("Mx437_IBM_VGA_8x16.ttf", FONT_HEIGHT)
	love.graphics.setFont( monoFont )
	print(monoFont:getWidth("█"))
	print(monoFont:getHeight())

--	crtmonitor = love.graphics.newImage("CRT-Monitor.jpg" )


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
	mouse.x = love.mouse.getX() - SCREEN_OFFSETX
	mouse.y = love.mouse.getY() - SCREEN_OFFSETY
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

function love.touchreleased( id, x, y, dx, dy, pressure )
	-- detect touch releases
end

function love.draw()
	-- set font before draw text
  love.graphics.setFont(monoFont)

	love.graphics.setCanvas(canvas) -- select the 1024 x 768 canvas
  love.graphics.clear(0, 0, 0, 0) -- clear the canvas
	love.graphics.setColor(0,0,0,1) -- black color
	love.graphics.rectangle("fill",0,0,1024,768) -- draw black background
	love.graphics.setColor(1,1,1,1) -- white color 
	
		-- draw screen rulers
	love.graphics.print("0....,....1....,....2....,....3....,....4....,....5....,....6....,....7....,....8....,....9....,....0....,....1....,....2....,....",0,0)
	love.graphics.print("0\n.\n.\n.\n.\n-\n.\n.\n.\n.\n1\n.\n.\n.\n.\n-\n.\n.\n.\n.\n2\n.\n.\n.\n.\n-\n.\n.\n.\n.\n3\n.\n.\n.\n.\n-\n.\n.\n.\n.\n4\n.\n.\n.\n.\n-\n.\n.\n.\n.\n",0,0)
	   
  -- draw joysticks data
  love.graphics.print("--[ Joysticks ]--"..love.joystick.getJoystickCount(),FONT_WIDTH*1,FONT_HEIGHT*1)
	if joystick ~= nil then -- not empty table, joystick(s) detected
		for i = 1,#joystick do
			love.graphics.print("Joystick "..i..": "..axisCount[i].." axes,"..buttonCount[i].." buttons, "..hatCount[i].." hats",FONT_WIDTH*1,FONT_HEIGHT*(i+1))
		end
	else
		love.graphics.print("No joystick detected",FONT_WIDTH*1,FONT_HEIGHT*2)
  end  

	-- draw mouse data
  love.graphics.print("--[ Mouse ]--",FONT_WIDTH*1,FONT_HEIGHT*6)
	if mouseDetected then
		love.graphics.print("Mouse detected, x:"..mouse.x.." y:"..mouse.y,FONT_WIDTH*1,FONT_HEIGHT*7)
		if mouse.button > 0 then
			love.graphics.print("Mouse button "..mouse.button.." pressed, "..mouse.clicks.." clicks",FONT_WIDTH*1,FONT_HEIGHT*8)		
		end
	else
		love.graphics.print("No mouse detected",FONT_WIDTH*1,FONT_HEIGHT*7)
	end

	-- draw touch data
  love.graphics.print("--[ Touches ]--",FONT_WIDTH*1,FONT_HEIGHT*10)
	if love.touch.getTouches() ~= nil then
		love.graphics.print("#getTouches = "..#love.touch.getTouches(),FONT_WIDTH*1,FONT_HEIGHT*11)
		if #love.touch.getTouches() == 0 then
			-- reset holdToQuit
			holdToQuit = 0
		end
		local touches = love.touch.getTouches()
    for i, id in ipairs(touches) do
      local x, y = love.touch.getPosition(id)
      x = x - SCREEN_OFFSETX
      y = y - SCREEN_OFFSETY
      love.graphics.circle("fill", x, y, 20)
			love.graphics.print("Touch "..i.." x:"..math.floor(x).." y:"..math.floor(y),FONT_WIDTH*1,FONT_HEIGHT*(11+i))
    end	
  else
		love.graphics.print("getTouches == nil",FONT_WIDTH*1,FONT_HEIGHT*11)	
	end	

	-- draw keyboard data
  love.graphics.print("--[ Keyboard ]--",FONT_WIDTH*64,FONT_HEIGHT*1)
  love.graphics.print("#keypressed = "..#keypressed,FONT_WIDTH*64,FONT_HEIGHT*2)
	keypressedHistory = ""
	for _, value in pairs(keypressed) do
		keypressedHistory = keypressedHistory .. value .. " "
	end
	love.graphics.printf(keypressedHistory, FONT_WIDTH*64, FONT_HEIGHT*3, FONT_WIDTH*64, "left")

	-- draw table of screen printable chars, 1..255
	local ansiChars = ""
	for i = 1, 127 do -- run backwards
		if i ~= 10 then
			ansiChars = ansiChars .. tostring(string.format("%d",i)..":"..string.format("%s",string.char(i))) .. " "
		end
	end
	-- should store all the chars in a table, maybe called altCode[]
	local extendedChars = "Ç:128 ü:129 é:130 â:131 ä:132 à:133 å:134 ç:135 ê:136 ë:137 è:138 ï:139 î:140 ì:141 Ä:142 Å:143 É:144 æ:145 Æ:146 ô:147 ö:148 ò:149 û:150 ù:151 ÿ:152 Ö:153 Ü:154 ¢:155 £:156 ¥:157 ₧:158 ƒ:159 á:160 í:161 ó:162 ú:163 ñ:164 Ñ:165 ª:166 º:167 ¿:168 ⌐:169 ¬:170 ½:171 ¼:172 ¡:173 «:174 »:175 ░:176 ▒:177 ▓:178 │:179 ┤:180 ╡:181 ╢:182 ╖:183 ╕:184 ╣:185 ║:186 ╗:187 ╝:188 ╜:189 ╛:190 ┐:191 └:192 ┴:193 ┬:194 ├:195 ─:196 ┼:197 ╞:198 ╟:199 ╚:200 ╔:201 ╩:202 ╦:203 ╠:204 ═:205 ╬:206 ╧:207 ╨:208 ╤:209 ╥:210 ╙:211 ╘:212 ╒:213 ╓:214 ╫:215 ╪:216 ┘:217 ┌:218 █:219 ▄:220 ▌:221 ▐:222 ▀:223 α:224 ß:225 Γ:226 π:227 Σ:228 σ:229 µ:230 τ:231 Φ:232 Θ:233 Ω:234 δ:235 ∞:236 φ:237 ε:238 ∩:239 ≡:240 ±:241 ≥:242 ≤:243 ⌠:244 ⌡:245 ÷:246 ≈:247 °:248 ∙:249 ·:250 √:251 ⁿ:252 ²:253 ■:254  :255"
	ansiChars = ansiChars..extendedChars
	love.graphics.printf(ansiChars,FONT_WIDTH*64,FONT_HEIGHT*22,FONT_WIDTH*64,"left")



	love.graphics.print("desktop size : "..WIDTH_DESKTOP.."x"..HEIGHT_DESKTOP,FONT_WIDTH*1,FONT_HEIGHT*27)
	love.graphics.print("window size  : "..WIDTH_WINDOW.."x"..HEIGHT_WINDOW,FONT_WIDTH*1,FONT_HEIGHT*28)
  love.graphics.print("--[ hold anything to quit ]--",FONT_WIDTH*((128-30)/2),FONT_HEIGHT*46)
	love.graphics.printf(holdToQuit,FONT_WIDTH*0,FONT_HEIGHT*47,FONT_WIDTH*128, "center")

  -- settings for canvas
  love.graphics.setCanvas() -- switch back to default screen canvas
  love.graphics.setColor(0.929,0.878,0.78,1) -- dark blue
  love.graphics.rectangle("fill",0,0,WIDTH_DESKTOP,HEIGHT_DESKTOP)
  love.graphics.setColor(1,1,1,1)
--  love.graphics.draw(crtmonitor, BGOFFSETX, BGOFFSETY)
--  love.graphics.setBlendMode("alpha", "premultiplied") -- needed for canvas
  
  -- draw ANSI borders around 1024x768 canvas
  -- draw extended black border first
	love.graphics.setColor(0, 0, 0, 1)
  love.graphics.rectangle("fill",SCREEN_OFFSETX+(FONT_WIDTH*-1),SCREEN_OFFSETY+(FONT_HEIGHT*-1),1024+(FONT_WIDTH*2),768+(FONT_HEIGHT*2))

  for i = -2,129 do
  	love.graphics.setColor(0.568, 0.529, 0.454, 1)
		love.graphics.print("▀",SCREEN_OFFSETX+(FONT_WIDTH*i),SCREEN_OFFSETY+(FONT_HEIGHT*-1))
  	love.graphics.setColor(0.868, 0.829, 0.754, 1)
		love.graphics.print("▄",SCREEN_OFFSETX+(FONT_WIDTH*i),SCREEN_OFFSETY+(FONT_HEIGHT*48))	
  end
	for i =  -1,48 do
  love.graphics.setColor(0.568, 0.529, 0.454, 1)
	love.graphics.print("▒ ",SCREEN_OFFSETX+(FONT_WIDTH*-2),SCREEN_OFFSETY+(FONT_HEIGHT*i))	
	love.graphics.print(" ▒",SCREEN_OFFSETX+(FONT_WIDTH*128),SCREEN_OFFSETY+(FONT_HEIGHT*i))	
	end

  -- draw the 1024x768 canvas in the middle
  love.graphics.setColor(1, 1, 1, 1)
--	love.graphics.print("░",SCREEN_OFFSETX+(FONT_WIDTH*-1),SCREEN_OFFSETY+(FONT_HEIGHT*-1))	

  love.graphics.draw(canvas, SCREEN_OFFSETX, SCREEN_OFFSETY)

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
	if love.touch.getTouches() ~= nil then
		if #love.touch.getTouches() >=1 then
			holdToQuit = holdToQuit + dt
		end
	end

	if holdToQuit >= 3 then
		love.event.quit()
	end

end