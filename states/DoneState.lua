DoneState = Class{__includes = BaseState}

function DoneState:init(players, winningPlayer)
	self.players = players
	self.winningPlayer = winningPlayer
end

function DoneState:update(dt)
	for _, player in pairs(self.players) do
		player:handleMovement()
		player:update(dt)
	end
end

function DoneState:render()
	local textY = 10

	Display.drawFPS()
    Display.drawScores(self.players[1].score, self.players[2].score)

    Display.drawHorizontallyCenteredText('Player ' .. tostring(self.winningPlayer) .. ' wins!', textY, Display.fonts.large)
    Display.drawHorizontallyCenteredText('Press ENTER to restart', textY + Display.FONT_SIZE_LARGE + 1, Display.fonts.small)

	for _, player in pairs(self.players) do
		player:render()
	end

	self.ball:render()
end
