push = require 'vendors/push'
Class = require 'vendors/class'
require 'classes/Ball'
require 'classes/Paddle'
require 'classes/StateMachine'
require 'states/BaseState'
require 'states/DoneState'
require 'states/PlayState'
require 'states/ServeState'
require 'states/StartState'
require 'utils'

function love.load()
	local fontFile = 'fonts/font.ttf'

	love.graphics.setDefaultFilter('nearest', 'nearest')

	math.randomseed(os.time())

	push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
		fullscreen = false,
		resizable = true,
		vsync = true
	})

	fonts = {
		small = love.graphics.newFont(fontFile, FONT_SIZE_SMALL),
		medium = love.graphics.newFont(fontFile, FONT_SIZE_MEDIUM),
		large = love.graphics.newFont(fontFile, FONT_SIZE_LARGE),
	}

	sounds = {
		paddleHit = love.audio.newSource('sounds/paddle_hit.wav', 'static'),
		score = love.audio.newSource('sounds/pacman_dies.mp3', 'static'),
		serve = love.audio.newSource('sounds/dark.wav', 'static'),
		wallHit = love.audio.newSource('sounds/wall_hit.wav', 'static')
	}

	player1 = Paddle(sideGap, player1Y, paddleWidth, paddleHeight, keys.player1)
	player2 = Paddle(VIRTUAL_WIDTH - sideGap - paddleWidth, player2Y, paddleWidth, paddleHeight, keys.player2)
	
	ball = Ball(ballX, ballY, ballWidth, ballHeight)

	local players = {player1, player2}

	state = StateMachine {
		done = function() return DoneState(players) end,
		play = function() return PlayState(players, ball) end,
		serve = function() return ServeState(players, ball) end,
		start = function() return StartState(players) end,
	}

	state:change(states.start)
end

-- dt is the elapsed time in seconds since last frame.
-- We can use this to scale any changes in our game for
-- even behaviour across frame rates
function love.update(dt)
	if not isPaused then
		state:update(dt)
	end
end

function love.keypressed(key)
	if key == 'escape' then
		love.event.quit()

	elseif key == 'enter' or key == 'return' then
		if state:is(states.start) then
			state:change(states.serve, {servingPlayer = servingPlayer})

		elseif state:is(states.serve) then
			state:change(states.play)

		elseif state:is(states.done) then
			player1Score = 0
			player2Score = 0
			servingPlayer = winningPlayer == 1 and 2 or 1

			state:change(states.serve, {servingPlayer = servingPlayer})
		end

	elseif key == 'p' then
		isPaused = not isPaused

	elseif key == 'space' then
		isSoundEnabled = not isSoundEnabled

	elseif key == 'f12' then
		isFullScreen = not isFullScreen
		love.window.setFullscreen(isFullScreen)

		local width, height = love.graphics.getDimensions()

		love.resize(width, height)
	end
end

function love.draw()
    push:start()
    love.graphics.clear(b2f(20), b2f(20), b2f(20), 1.0)
	state:render()
    push:finish()
end

function love.resize(w, h)
	push:resize(w, h)
end