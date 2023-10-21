StartState = Class{__includes = BaseState}

function StartState:init(players)
	self.players = players
end

function StartState:enter(params)
	--
end

function StartState:update(dt)
	for _, player in pairs(self.players) do
		player:handleMovement()
		player:update(dt)
	end
end

function StartState:render()
	local textY = (VIRTUAL_HEIGHT - FONT_SIZE_SMALL) / 2

	displayScores()
	displayFPS()

	love.graphics.setFont(fonts.small)
	love.graphics.printf('Welcome to ' .. APP_NAME .. '!', 0, textY, VIRTUAL_WIDTH, 'center')

	textY = textY + FONT_SIZE_SMALL
	love.graphics.printf('Press ENTER to start', 0, textY, VIRTUAL_WIDTH, 'center')

	for _, player in pairs(self.players) do
		player:render()
	end
end

function StartState:exit()
	--
end
