App = Class{}

function App.init()
	math.randomseed(os.time())
	
	Display.init()
	Ball.setup()
	Paddle.setup()

	App.APP_NAME = 'Pong'
    App.APP_ICON = 'images/icon16.png'
    App.MAX_SCORE = 0

    App.isPaused = false
    App.isSoundEnabled = true
    App.isFullScreen = false
    App.isRunning = false

    App.servingPlayer = 0
    App.winningPlayer = 0
    App.sounds = {}
    App.state = nil
    App.states = {
        done = 'done',
        play = 'play',
        serve = 'serve',
        start = 'start',
    }
    App.playerKeys = {
        player1 = {
			up = 'w',
			down = 's',
        	shift = 'lshift',
        },
        player2 = {
            up = 'up',
			down = 'down',
        	shift = 'rshift',
        },
    }
    App.sideGap = 0
    App.paddleWidth = 5
    App.paddleHeight = 20
    App.ballWidth = 4
    App.ballHeight = 4
    App.player1Y = 0
    App.player2Y = Display.windowHeight - App.paddleHeight
    App.ballX = (Display.windowWidth / 2) - (App.ballWidth / 2)
    App.ballY = (Display.windowHeight / 2) - (App.ballHeight / 2)
    App.player1 = nil
    App.player2 = nil
    App.ball = nil
    App.players = {}

    App.loadSounds()

    love.window.setTitle(App.APP_NAME)
    love.window.setIcon(love.image.newImageData(App.APP_ICON))

    App.player1 = Paddle(App.sideGap, App.player1Y, App.paddleWidth, App.paddleHeight, App.playerKeys.player1)
    App.player2 = Paddle(Display.windowWidth - App.sideGap - App.paddleWidth, App.player2Y, App.paddleWidth, App.paddleHeight, App.playerKeys.player2)

    App.ball = Ball(App.ballX, App.ballY, App.ballWidth, App.ballHeight)

    App.players = { App.player1, App.player2 }
    StartState.appName = App.APP_NAME

    App.state = StateMachine {
		done = function() return DoneState(App.players, App.winningPlayer) end,
		play = function() return PlayState(
			App.players,
			App.ball,
			App.onPlayStateEnter,
            App.onWallHit,
            App.onPaddleHit,
            App.onPlayer1Score,
            App.onPlayer2Score
		) end,
		serve = function() return ServeState(App.players, App.ball) end,
		start = function() return StartState(App.players) end,
	}

	App.state:change(App.states.start)
end

function App.onPlayStateEnter()
	App.playSound(App.sounds.serve)
end

function App.onWallHit()
	App.playSound(App.sounds.wallHit)
end

function App.onPaddleHit()
	App.playSound(App.sounds.paddleHit)
end

function App.onPlayer1Score()
	App.playSound(App.sounds.score)
	App.players[1].score = App.players[1].score + 1

	if App.MAX_SCORE > 0 and App.players[1].score == App.MAX_SCORE then
		App.winningPlayer = 1
		App.state:change(App.states.done)
	else
		App.state:change(App.states.serve, { servingPlayer = 2 })
	end
end

function App.onPlayer2Score()
	App.playSound(App.sounds.score)
	App.players[2].score = App.players[2].score + 1

	if App.MAX_SCORE > 0 and App.players[2].score == App.MAX_SCORE then
		App.winningPlayer = 2
		App.state:change(App.states.done)
	else
		App.state:change(App.states.serve, { servingPlayer = 1 })
	end
end

function App.loadSounds()
	App.sounds = {
		paddleHit = love.audio.newSource('sounds/paddle_hit.wav', 'static'),
		score = love.audio.newSource('sounds/pacman_dies.mp3', 'static'),
		serve = love.audio.newSource('sounds/dark.wav', 'static'),
		wallHit = love.audio.newSource('sounds/wall_hit.wav', 'static')
	}
end

function App.playSound(sound)
	if App.isSoundEnabled then
		sound:play()
	end
end

function App.chooseRandomServingPlayer()
	App.servingPlayer = math.random(1, 2)
end

function App.setServingPlayer()
	App.servingPlayer = App.winningPlayer == 1 and 2 or 1
end

function App.resetScores()
	for _, player in ipairs(App.players) do
		player.score = 0
	end
end

function App.onKeyDown(key)
	if key == 'escape' then
		App.isRunning = false
		love.event.quit()

	elseif key == 'enter' or key == 'return' then
		if App.state:is(App.states.start) then
			App.chooseRandomServingPlayer()
			App.state:change(App.states.serve, { servingPlayer = App.servingPlayer })

		elseif App.state:is(App.states.serve) then
			App.state:change(App.states.play)

		elseif App.state:is(App.states.done) then
			App.resetScores()
            App.setServingPlayer()
			App.state:change(App.states.serve, {servingPlayer = App.servingPlayer})
		end

	elseif key == 'p' then
		App.isPaused = not App.isPaused

	elseif key == 'space' then
		App.isSoundEnabled = not App.isSoundEnabled

	elseif key == 'f12' then
		App.isFullScreen = not App.isFullScreen
		love.window.setFullscreen(App.isFullScreen)

		local width, height = love.graphics.getDimensions()

		love.resize(width, height)
	end
end

function App.onWindowResized(newWidth, newHeight)
	oldWidth = Display.VIRTUAL_WIDTH
    oldHeight = Display.VIRTUAL_HEIGHT
    Display.windowWidth = newWidth
    Display.windowHeight = newHeight
    Display.VIRTUAL_WIDTH = newWidth
    Display.VIRTUAL_HEIGHT = newHeight

    for _, player in ipairs(App.players) do
		player:onWindowResized(newWidth, newHeight, oldWidth, oldHeight)
	end

	App.ball:onWindowResized(newWidth, newHeight, oldWidth, oldHeight)
end