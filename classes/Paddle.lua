Paddle = Class{}

local PADDLE_SPEED = 100
local PADDLE_SPEED_HIGH = 200

function Paddle:init(x, y, width, height, keys)
	self.x = x
	self.y = y
	self.width = width
	self.height = height
	self.dy = 0
	self.keys = keys
end

function Paddle:update(dt)
	if self.dy < 0 then
		self.y = math.max(0, self.y + self.dy * dt)
	else
		self.y = math.min(VIRTUAL_HEIGHT - self.height, self.y + self.dy * dt)
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