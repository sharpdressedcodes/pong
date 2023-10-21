DoneState = Class{__includes = BaseState}

function DoneState:init(players)
	self.players = players
end

function DoneState:enter(params)
	--
end

function DoneState:update(dt)
	for _, player in pairs(self.players) do
		player:handleMovement()
		player:update(dt)
	end
end

function DoneState:render()
	local textY = 10

	displayScores()
	displayFPS()

	love.graphics.setFont(largeFont)
	love.graphics.printf('Player ' .. tostring(winningPlayer) .. ' wins!', 0, textY, VIRTUAL_WIDTH, 'center')

	textY = textY + 20
	love.graphics.setFont(smallFont)
	love.graphics.printf('Press [enter] to restart', 0, textY, VIRTUAL_WIDTH, 'center')

	for _, player in pairs(self.players) do
		player:render()
	end

	self.ball:render()
end

function DoneState:exit()
	--
end
