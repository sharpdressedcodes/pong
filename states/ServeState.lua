ServeState = Class{__includes = BaseState}

function ServeState:init(players, ball)
	self.players = players
	self.ball = ball
end

function ServeState:enter(params)
	self.servingPlayer = params.servingPlayer

	self.ball:reset()
end

function ServeState:update(dt)
	self.ball.dy = math.random(-50, 50)

	if self.servingPlayer == 1 then
		self.ball.dx = math.random(140, 200)
	else
		self.ball.dx = -math.random(140, 200)
	end

	for _, player in pairs(self.players) do
		player:handleMovement()
		player:update(dt)
	end
end

function ServeState:render()
	local textY = 10

	displayFPS()

	love.graphics.setFont(fonts.small)
	love.graphics.printf('Player ' .. tostring(self.servingPlayer) .. "'s serve", 0, textY, VIRTUAL_WIDTH, 'center')

	textY = textY + 10
	love.graphics.printf('Press ENTER to serve', 0, textY, VIRTUAL_WIDTH, 'center')

	for _, player in pairs(self.players) do
		player:render()
	end

	self.ball:render()
end

function ServeState:exit()
	--
end
