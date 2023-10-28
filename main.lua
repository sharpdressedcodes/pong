push = require 'vendors/push'
Class = require 'vendors/class'
require 'classes/Ball'
require 'classes/Paddle'
require 'classes/Display'
require 'classes/StateMachine'
require 'classes/App'
require 'states/BaseState'
require 'states/DoneState'
require 'states/PlayState'
require 'states/ServeState'
require 'states/StartState'

function love.load()
	App.init()
end

function love.update(dt)
	if not App.isPaused then
		App.state:update(dt)
	end
end

function love.keypressed(key)
	App.onKeyDown(key)
end

function love.draw()
    push:start()
    --Display.clear()
	App.state:render()
    push:finish()
end

function love.resize(w, h)
	push:resize(w, h)
end