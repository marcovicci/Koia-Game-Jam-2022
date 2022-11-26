--goodbye buffer, let me see my prints
io.stdout:setvbuf("no")

-- load in suit, sfxr, markov and 30log
local suit = require 'suit'
local sfxr = require 'sfxr'
local markov = require 'markov'
local BAD_TEXT = io.open("train_text.txt")
local GOOD_TEXT = io.open("happy.txt")
local example = markov(BAD_TEXT:read("*a"))
local example_happy = markov(GOOD_TEXT:read("*a"))
local class = require '30log'
local Twot = class("Twot", { content_list = {}, width = 350, height = 150, r = 223/255, g = 223/255, b = 223/255, user = "Name", content = "Content", x = 100, y = 100, impulse_x = 1, impulse_y = 1})
alpha = 100
alphaToggle = 0
-- data for a slider, an input box and a checkbox
local slider, slider2 = {value = 0.5, min = -2, max = 2}, {value = -3, min = -5, max = 5}
local vertslider = {value = 0.5, min = -5, max = 5}
local chk, chk2, chk3 = {text = "Check?"}, {text = "Check!"}, {text = "Check..."}

function Twot:init(width, height, r, g, b, user, content, x, y, impulse_x, impulse_y)
    -- copy in any given values to self 
    self.content_list, self.width, self.height, self.r, self.g, self.b, self.user, self.content, self.x, self.y, self.impulse_x, self.impulse_y = content_list, width, height, r, g, b, user, content, x, y, impulse_x, impulse_y
    
    -- let's randomize starting position as long as it won't put the twot off the screen
    max_width = love.graphics.getWidth( ) - self.width
    max_height = love.graphics.getHeight( ) - self.height - 105
    self.x = love.math.random( max_width )
    self.y = love.math.random( 110, max_height )

    -- randomize 'impulse' aka direction of slow movement
    impulse_x = love.math.random( -1, 1 )
    impulse_y = love.math.random( -1, 1 )

    -- try randomizing some content now
    content = {}
    for i = 1, 40 do
      content[i] = example:next() .. " "
    end
    self.user = example:next() .. " (@" .. example_happy:next() .. love.math.random(4444, 999999) .. ")"
    -- Save this text content and display as text
    self.content_list = content
    self.content = table.concat(content)

end

function Twot:move()
    max_width = love.graphics.getWidth( ) - self.width
    max_height = love.graphics.getHeight( ) - self.height - 105
    self.x = self.x + self.impulse_x
    self.y = self.y + self.impulse_y
    if self.x >= max_width or self.x <= 0 then
        self.impulse_x = self.impulse_x * -1
    end
    if self.y >= max_height or self.y <= 105 then
        self.impulse_y = self.impulse_y * -1
    end
end

function Twot:fade()
   -- fade out the twot
   print(alpha)
   print(alphaToggle)
   if alphaToggle == 1 and alpha >= 1 then
      alpha = alpha - 1
   end
   if alphaToggle == 2 and alpha <= 99 then
      alpha = alpha + 1
   end
   if alphaToggle == 1 and alpha <= 0 then
      alphaToggle = 500
      newTweet:regenerate()
   end
   if alphaToggle == 2 and alpha >= 100 then
      alphaToggle = 0
   end
end

function Twot:regenerate()
   -- creates new twot 
    self.r, self.g, self.b = 223/255, 223/255, 223/255
    max_width = love.graphics.getWidth( ) - self.width
    max_height = love.graphics.getHeight( ) - self.height
    self.x = love.math.random( max_width )
    self.y = love.math.random( max_height )

    impulse_x = love.math.random( -1, 1 )
    impulse_y = love.math.random( -1, 1 )

    content = {}
    for i = 1, 40 do
      content[i] = example:next() .. " "
    end
   self.user = example:next() .. " (@" .. example_happy:next() .. love.math.random(4444, 999999) .. ")"
    -- Save this text content and display as text
    self.content_list = content
    self.content = table.concat(content)
    -- change toggle to start fading in twot again
    alphaToggle = 2
end

function Twot:fix()
   -- fix a few words in the twot at random
   local fix_start = love.math.random(35)
   local fix_end = fix_start + 5
   content = self.content_list
   for i = fix_start, fix_end do
      content[i] = example_happy:next() .. " "
   end
   self.content_list = content
   self.content = table.concat(content)

   -- change the color of the twot 
   local dice_roll = love.math.random(3)
   if dice_roll == 1 then
      self.r = love.math.random(255) / 255
   end
   if dice_roll == 2 then
      self.g = love.math.random(255) / 255
   end
   if dice_roll == 3 then
      self.b = love.math.random(255) / 255
   end
end

-- love.load() is our setup function, running once
function love.load()
    newTweet = Twot()
    --image = love.graphics.newImage("cake.jpg")
    love.graphics.setNewFont(12)
    love.graphics.setBackgroundColor(45/255,45/255,45/255)
    print("HELLO WORLD")
 end

--draw is where graphics calls are made
 function love.draw()

   -- Drawing the twot 
    love.graphics.setColor(newTweet.r,newTweet.g,newTweet.b, alpha/100)
    love.graphics.rectangle("fill", newTweet.x, newTweet.y, newTweet.width, newTweet.height)
    love.graphics.setColor(45/255,45/255,45/255, alpha/100)
    love.graphics.print(newTweet.user, newTweet.x + 10, newTweet.y + 10)
    love.graphics.printf(newTweet.content, newTweet.x + 10, newTweet.y + 30, newTweet.width - 20, left)
    love.graphics.print("Twotted at 12:13 pm", newTweet.x + newTweet.width - 140, newTweet.y + newTweet.height - 24)

   -- Drawing the miraculum console
   love.graphics.setColor(223/255,223/255,223/255)
   love.graphics.rectangle("line", love.graphics.getWidth( ) / 8, 5, love.graphics.getWidth( ) - love.graphics.getWidth( ) / 4, 100)
   love.graphics.print("These Twots suck.\nLuckily, you control the Miraculum, a device that can mutate opinions on the internet!\nMuck around with the controls at the bottom of the screen, and surely you can fix everything.\nWhen you're satisfied, you can send that Twot back off into the void and try with another one.\n(Sorry if you see some horrible words. These Twots are made from REAL internet content.)\nMade by Zelle Marcovicci for the Koia Game Jam 2022, for some reason.", love.graphics.getWidth( ) / 8 + 5, 10) 
   love.graphics.rectangle("line", love.graphics.getWidth( ) / 2 - love.graphics.getWidth( ) / 4, love.graphics.getHeight( ) - 105, love.graphics.getWidth( ) / 2, 100)

   suit.draw()
 end

 function fuckingAround()
   local sound = sfxr.newSound()
   sound:randomize()
   local sounddata = sound:generateSoundData()
   local source = love.audio.newSource(sounddata)
   source:play()
   newTweet:fix()
 end

 --update function for per-frame

 function love.update(dt)
   if alphaToggle == 0 then
      if suit.Button("It's perfect", newTweet.x + 5,newTweet.y + newTweet.height - 25, 100,20).hit then
         alphaToggle = 1
      end

      if suit.Button("I hate it", newTweet.x + 110,newTweet.y + newTweet.height - 25, 90,20).hit then
         alphaToggle = 1
      end
   end
   if suit.Checkbox(chk, love.graphics.getWidth( ) / 2 - love.graphics.getWidth( ) / 4 + 2, love.graphics.getHeight( ) - 103, 30, 30).hit then
      fuckingAround()
   end
   if suit.Slider(slider, love.graphics.getWidth( ) / 2 - love.graphics.getWidth( ) / 4 + 40, love.graphics.getHeight( ) - 103, love.graphics.getWidth( ) / 2 - 50, 30).hit then
      fuckingAround()
   end
   if suit.Slider(vertslider, {vertical = true}, love.graphics.getWidth( ) / 2 - love.graphics.getWidth( ) / 4 + 2, love.graphics.getHeight( ) - 70, 30, 60).hit then
      fuckingAround()
   end
   if suit.Checkbox(chk2, love.graphics.getWidth( ) / 2 - love.graphics.getWidth( ) / 4 + 36, love.graphics.getHeight( ) - 72, 30, 30).hit then
      fuckingAround()
   end
   if suit.Checkbox(chk3, love.graphics.getWidth( ) / 2 - love.graphics.getWidth( ) / 4 + 69, love.graphics.getHeight( ) - 72, 30, 30).hit then
      fuckingAround()
   end
   if suit.Button("1", love.graphics.getWidth( ) / 2 - love.graphics.getWidth( ) / 4 + 105, love.graphics.getHeight( ) - 70, 26, 26).hit then
      fuckingAround()
   end
   if suit.Button("2", love.graphics.getWidth( ) / 2 - love.graphics.getWidth( ) / 4 + 140, love.graphics.getHeight( ) - 70, 26, 26).hit then
      fuckingAround()
   end
   if suit.Button("7", love.graphics.getWidth( ) / 2 - love.graphics.getWidth( ) / 4 + 175, love.graphics.getHeight( ) - 70, 26, 26).hit then
      fuckingAround()
   end
   if suit.Button("G", love.graphics.getWidth( ) / 2 - love.graphics.getWidth( ) / 4 + 210, love.graphics.getHeight( ) - 70, 26, 26).hit then
      fuckingAround()
   end
   if suit.Button("9", love.graphics.getWidth( ) / 2 - love.graphics.getWidth( ) / 4 + 245, love.graphics.getHeight( ) - 70, 26, 26).hit then
      fuckingAround()
   end
   if suit.Button("M", love.graphics.getWidth( ) / 2 - love.graphics.getWidth( ) / 4 + 280, love.graphics.getHeight( ) - 70, 26, 26).hit then
      fuckingAround()
   end
   if suit.Button("4", love.graphics.getWidth( ) / 2 - love.graphics.getWidth( ) / 4 + 315, love.graphics.getHeight( ) - 70, 26, 26).hit then
      fuckingAround()
   end
   if suit.Button("?", love.graphics.getWidth( ) / 2 - love.graphics.getWidth( ) / 4 + 350, love.graphics.getHeight( ) - 70, 26, 26).hit then
      fuckingAround()
   end
   if suit.Slider(slider2, love.graphics.getWidth( ) / 2 - love.graphics.getWidth( ) / 4 + 40, love.graphics.getHeight( ) - 40, love.graphics.getWidth( ) / 2 - 50, 30).hit then
      fuckingAround()
   end
    newTweet:move()
    if alphaToggle == 1 or alphaToggle == 2 then
      -- start changing alpha
      newTweet:fade()
    end
 end


 --mouse event listeners

 function love.mousepressed(x, y, button, istouch)
    if button == 1 then
       print(x, y)
    end
 end

 function love.mousereleased(x, y, button, istouch)
    if button == 1 then
       --fireSlingshot(x,y) -- this totally awesome custom function is defined elsewhere
    end
 end

 --key event listeners

 function love.keypressed(key)
    if key == 'b' then
       --text = "The B key was pressed."
    elseif key == 'a' then
       --a_down = true
    end
 end

 function love.keyreleased(key)
    if key == 'b' then
       --text = "The B key was released."
    elseif key == 'a' then
       --a_down = false
    end
 end