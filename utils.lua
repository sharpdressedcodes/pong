function b2f(value)
	return value / 255
end

function displayFPS()
	love.graphics.setFont(fonts.small)
	love.graphics.setColor(0, 1, 0, 1)
    love.graphics.printf('FPS: ' .. tostring(love.timer.getFPS()), 0, 0, VIRTUAL_WIDTH, 'right')
    love.graphics.setColor(1, 1, 1, 1)
end

function displayScores()
    love.graphics.setColor(1, 1, 1, 1)
	love.graphics.setFont(fonts.large) 
    love.graphics.printf(tostring(player1Score) .. '  ' .. tostring(player2Score), 0, 0, VIRTUAL_WIDTH, 'center')
end

function drawDivider()
    local size = 4
    local step = 4
    local x = (VIRTUAL_WIDTH / 2) - (size / 2) - 2
    local y = step

    for i = step, VIRTUAL_HEIGHT do
        love.graphics.rectangle('fill', x, y, size, size)
        y = y + size + step
    end
end

function playSound(sound)
    if isSoundEnabled then
        sound:play()
    end
end

function incrementScore(player)
    local won = 0

    playSound(sounds.score)

    if player == 1 then
        player1Score = player1Score + 1

        if MAX_SCORE > 0 then
            if player1Score == MAX_SCORE then
                won = 1
                state:change(states.done)
            else
                state:change(states.serve, {servingPlayer = 2})
            end
        else
            state:change(states.serve, {servingPlayer = 2})
        end
    else
        player2Score = player2Score + 1

        if MAX_SCORE > 0 then
            if player2Score == MAX_SCORE then
                won = 1
                state:change(states.done)
            else
                state:change(states.serve, {servingPlayer = 1})
            end
        else
            state:change(states.serve, {servingPlayer = 1})
        end
    end

    return won
end