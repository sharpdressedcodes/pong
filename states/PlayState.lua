PlayState = Class{__includes = BaseState}

function PlayState:init(players, ball)
	self.players = players
	self.ball = ball
end

function PlayState:enter(params)
	playSound(sounds.serve)
end

function PlayState:update(dt)
	local player1 = self.players[1]
	local player2 = self.players[2]

	for _, player in pairs(self.players) do
		player:handleMovement()
		player:update(dt)
	end

	self.ball:update(dt)

	if self.ball:collides(player1) then
		self.ball.dx = -self.ball.dx * 1.03
		self.ball.x = player1.x + player1.width + 1

		if self.ball.dy < 0 then
			self.ball.dy = -math.random(10, 150)
		else
			self.ball.dy = math.random(10, 150)
		end

		playSound(sounds.paddleHit)
	end

	if self.ball:collides(player2) then
		self.ball.dx = -self.ball.dx * 1.03
		self.ball.x = player2.x - player2.width

		if self.ball.dy < 0 then
			self.ball.dy = -math.random(10, 150)
		else
			self.ball.dy = math.random(10, 150)
		end

		playSound(sounds.paddleHit)
	end

	if self.ball.y < 0 then
		self.ball.y = 0
		self.ball.dy = -self.ball.dy

		playSound(sounds.wallHit)
	end

	if self.ball.y > VIRTUAL_HEIGHT - self.ball.height then
		self.ball.y = VIRTUAL_HEIGHT - self.ball.height
		self.ball.dy = -self.ball.dy

		playSound(sounds.wallHit)
	end

	if self.ball.x < 0 then
		won = incrementScore(2)

		if won > 0 then
			winningPlayer = 2
		end
	elseif self.ball.x > VIRTUAL_WIDTH then
		won = incrementScore(1)

		if won > 0 then
			winningPlayer = 1
		end 
	end
end

function PlayState:render()
	displayScores()
	displayFPS()
	-- drawDivider()

	for _, player in pairs(self.players) do
		player:render()
	end

	self.ball:render()
end

function PlayState:exit()
	--
end
