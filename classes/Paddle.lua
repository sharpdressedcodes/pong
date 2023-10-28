Paddle = Class{}

local PADDLE_SPEED = 100
local PADDLE_SPEED_HIGH = 200

function Paddle.setup()
	Paddle.PADDLE_SPEED = PADDLE_SPEED
	Paddle.PADDLE_SPEED_HIGH = PADDLE_SPEED_HIGH
end

function Paddle:init(x, y, width, height, keys)
	self.x = x
	self.y = y
	self.width = width
	self.height = height
	self.dy = 0
	self.keys = keys
	self.score = 0
end

function Paddle:update(dt)
	if self.dy < 0 then
		self.y = math.max(0, self.y + self.dy * dt)
	else
		self.y = math.min(Display.windowHeight - self.height, self.y + self.dy * dt)
	end
end

function Paddle:render()
	love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
end

function Paddle:handleMovement()
	local speed = love.keyboard.isDown(self.keys.shift) and PADDLE_SPEED_HIGH or PADDLE_SPEED

	if love.keyboard.isDown(self.keys.up) then
		self.dy = -speed
	elseif love.keyboard.isDown(self.keys.down) then
		self.dy = speed
	else
		self.dy = 0
	end
end

function Paddle:onWindowResized(newWidth, newHeight, oldWidth, oldHeight)
	self.x = Display.remapPosition(self.x, 0, oldWidth, 0, newWidth)
    self.y = Display.remapPosition(self.y, 0, oldHeight, 0, newHeight)

    -- Hack for right side, to clamp it to the right side, 
    -- otherwise it's x co-ordinate translation makes it look wonky.
    if self.x then
    	self.x = newWidth - self.width
    end
end