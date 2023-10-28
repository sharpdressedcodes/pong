Ball = Class{}

local MIN_X_SPEED = 100
local MAX_X_SPEED = 200
local MIN_Y_SPEED = -100
local MAX_Y_SPEED = 100
local SPEED_INCREASE_FACTOR = 1.03

function Ball.setup()
	Ball.MIN_X_SPEED = MIN_X_SPEED
	Ball.MAX_X_SPEED = MAX_X_SPEED
	Ball.MIN_Y_SPEED = MIN_Y_SPEED
	Ball.MAX_Y_SPEED = MAX_Y_SPEED
	Ball.SPEED_INCREASE_FACTOR = SPEED_INCREASE_FACTOR
end

function Ball:init(x, y, width, height)
	self.x = x
	self.y = y
	self.width = width
	self.height = height

	self.halfWidth = width / 2
	self.halfHeight = height / 2

	self:setDirection()
end

function Ball:update(dt)
	self.x = self.x + self.dx * dt
	self.y = self.y + self.dy * dt
end

function Ball:render()
	love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
end

function Ball:setDirection(servingPlayer)
	dx = math.random(Ball.MIN_X_SPEED, Ball.MAX_X_SPEED)

    self.x = Display.windowWidth / 2 - self.halfWidth
    self.y = Display.windowHeight / 2 - self.halfHeight

    self.dx = servingPlayer == 1 and dx or -dx
    self.dy = math.random(Ball.MIN_Y_SPEED, Ball.MAX_Y_SPEED)
end

function Ball:collidesWithEntity(entity)
	if self.x > entity.x + entity.width or entity.x > self.x + self.width then
		return false
	end

	if self.y > entity.y + entity.height or entity.y > self.y + self.height then
		return false
	end

	return true
end

function Ball:collidesWithTopWall()
	return self.y < 0
end

function Ball:collidesWithBottomWall()
	return self.y > Display.windowHeight - self.height
end

function Ball:collidesWithLeftWall()
	return self.x < 0
end

function Ball:collidesWithRightWall()
	return self.x > Display.windowWidth
end

function Ball:bounceOffTopWall()
	self.y = 0
    self.dy = -self.dy
end

function Ball:bounceOffBottomWall()
	self.y = Display.windowHeight - self.height
    self.dy = -self.dy
end

function Ball:bounceOffEntity(entityX)
	dy = math.random(math.min(Ball.MIN_Y_SPEED, 10), Ball.MAX_Y_SPEED)

    self.dx = -self.dx * Ball.SPEED_INCREASE_FACTOR
    self.dy = self.dy < 0 and -dy or dy
    self.x = entityX
end

function Ball:onWindowResized(newWidth, newHeight, oldWidth, oldHeight)
	self.x = Display.remapPosition(self.x, 0, oldWidth, 0, newWidth)
    self.y = Display.remapPosition(self.y, 0, oldHeight, 0, newHeight)
end