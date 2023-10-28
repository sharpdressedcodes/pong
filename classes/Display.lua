Display = Class{}

local FONT_SIZE_SMALL = 8
local FONT_SIZE_MEDIUM = 16
local FONT_SIZE_LARGE = 32
local WINDOW_WIDTH = 1280
local WINDOW_HEIGHT = 720
local VIRTUAL_WIDTH = 432
local VIRTUAL_HEIGHT = 243
local fontFile = 'fonts/font.ttf'

function Display.init()
	Display.FONT_SIZE_SMALL = FONT_SIZE_SMALL
	Display.FONT_SIZE_MEDIUM = FONT_SIZE_MEDIUM
	Display.FONT_SIZE_LARGE = FONT_SIZE_LARGE
	Display.WINDOW_WIDTH = WINDOW_WIDTH
	Display.WINDOW_HEIGHT = WINDOW_HEIGHT
	Display.VIRTUAL_WIDTH = VIRTUAL_WIDTH
	Display.VIRTUAL_HEIGHT = VIRTUAL_HEIGHT
	Display.windowWidth = VIRTUAL_WIDTH
    Display.windowHeight = VIRTUAL_HEIGHT

    love.graphics.setDefaultFilter('nearest', 'nearest')

    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
		fullscreen = false,
		resizable = true,
		vsync = true
	})

	Display.loadFonts()
end

function Display.loadFonts()
	Display.fonts = {
		small = love.graphics.newFont(fontFile, FONT_SIZE_SMALL),
		medium = love.graphics.newFont(fontFile, FONT_SIZE_MEDIUM),
		large = love.graphics.newFont(fontFile, FONT_SIZE_LARGE),
	}
end

function Display.drawHorizontallyCenteredText(text, y, font, rgba)
	local r = nil
	local g = nil
	local b = nil
	local a = nil

	if rgba ~= nil then
		r, g, b, a = love.graphics.getColor()
		love.graphics.setColor(rgba.r, rgba.g, rgba.b, rgba.a ~= nil and rgba.a or 1)
	end

	love.graphics.setFont(font)
	love.graphics.printf(text, 0, y, Display.windowWidth, 'center')

	if rgba ~= nil then
		love.graphics.setColor(r, g, b, a)
	end
end

function Display.drawFPS()
	local r = nil
	local g = nil
	local b = nil
	local a = nil

	r, g, b, a = love.graphics.getColor()

	love.graphics.setFont(Display.fonts.small)
	love.graphics.setColor(0, 1, 0, 1)
    love.graphics.printf('FPS: ' .. tostring(love.timer.getFPS()), 0, 0, Display.windowWidth, 'right')
    love.graphics.setColor(r, g, b, a)
end

function Display.drawScores(player1Score, player2Score)
	Display.drawHorizontallyCenteredText(tostring(player1Score) .. '  ' .. tostring(player2Score), 0, Display.fonts.large)
end

function Display.drawDivider()
	local size = 4
    local step = 4
    local x = (Display.windowWidth / 2) - (size / 2) - 2
    local y = step

    for i = step, Display.windowHeight do
        love.graphics.rectangle('fill', x, y, size, size)
        y = y + size + step
    end
end

function Display.clear()
	value = Display.b2f(20)

	love.graphics.clear(value, value, value, 1.0)
end

function Display.remapPosition(value, valueMin, valueMax, desiredMin, desiredMax)
	return desiredMin + (value - valueMin) * (desiredMax - desiredMin) / (valueMax - valueMin)
end

function Display.b2f(value)
	return value / 255
end