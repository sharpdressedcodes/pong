PlayState = Class{__includes = BaseState}

function PlayState:init(players, ball, onEnter, onWallHit, onPaddleHit, onPlayer1Score, onPlayer2Score)
	self.players = players
	self.ball = ball
	self.onEnter = onEnter
	self.onWallHit = onWallHit
	self.onPaddleHit = onPaddleHit
	self.onPlayer1Score = onPlayer1Score
	self.onPlayer2Score = onPlayer2Score
end

function PlayState:enter(params)
	self.onEnter()
end

function PlayState:update(dt)
	local player1 = self.players[1]
	local player2 = self.players[2]

	for _, player in pairs(self.players) do
		player:handleMovement()
		player:update(dt)
	end

	self.ball:update(dt)

	if self.ball:collidesWithEntity(player1) then
		self.ball:bounceOffEntity(player1.x + player1.width + 1)
		self.onPaddleHit()

	elseif self.ball:collidesWithEntity(player2) then
		self.ball:bounceOffEntity(player2.x - player2.width)
		self.onPaddleHit()

	elseif self.ball:collidesWithTopWall() then
		self.ball:bounceOffTopWall()
		self.onWallHit()

	elseif self.ball:collidesWithBottomWall() then
		self.ball:bounceOffBottomWall()
		self.onWallHit()

	elseif self.ball:collidesWithLeftWall() then
		self.onPlayer2Score()

	elseif self.ball:collidesWithRightWall() then
		self.onPlayer1Score()
	end
end

function PlayState:render()
	Display.drawFPS()
    Display.drawScores(self.players[1].score, self.players[2].score)
    -- Display.drawDivider()

	for _, player in pairs(self.players) do
		player:render()
	end

	self.ball:render()
end
