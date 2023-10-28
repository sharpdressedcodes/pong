StartState = Class{__includes = BaseState}

function StartState:init(players)
	self.players = players
end

function StartState:update(dt)
	for _, player in pairs(self.players) do
		player:handleMovement()
		player:update(dt)
	end
end

function StartState:render()
	local textY = (Display.windowHeight - Display.FONT_SIZE_SMALL) / 2

	Display.drawScores(self.players[1].score, self.players[2].score)
	Display.drawFPS()

	Display.drawHorizontallyCenteredText('Welcome to ' .. StartState.appName .. '!', textY, Display.fonts.small)
	Display.drawHorizontallyCenteredText('Press ENTER to start', textY + Display.FONT_SIZE_SMALL + 1, Display.fonts.small)

	for _, player in pairs(self.players) do
		player:render()
	end
end
