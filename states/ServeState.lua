ServeState = Class{__includes = BaseState}

function ServeState:init(players, ball)
	self.players = players
	self.ball = ball
end

function ServeState:enter(params)
	self.servingPlayer = params.servingPlayer
	self.ball:setDirection(params.servingPlayer)
end

function ServeState:update(dt)
	for _, player in pairs(self.players) do
		player:handleMovement()
		player:update(dt)
	end
end

function ServeState:render()
	local textY = 10

	Display.drawFPS()

	Display.drawHorizontallyCenteredText('Player ' .. tostring(self.servingPlayer) .. "'s serve", textY, Display.fonts.small)
	Display.drawHorizontallyCenteredText('Press ENTER to serve', textY + Display.FONT_SIZE_SMALL + 1, Display.fonts.small)

	for _, player in pairs(self.players) do
		player:render()
	end

	self.ball:render()
end
