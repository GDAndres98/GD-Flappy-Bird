ScoreState = Class { __includes = BaseState }

local MEDAL_IMAGE = love.graphics.newImage('res/medal.png')

function ScoreState:enter(params)
    self.score = params.score
end

function ScoreState:update(dt)
    if love.keyboard.wasPressed('enter') or
        love.keyboard.wasPressed('return') or
        love.mouse.wasPressed(2) then
            gStateMachine:change('countdown')
    end
end

function ScoreState:render()

    love.graphics.setFont(flappyFont)
    if self.score >= 10 then
        love.graphics.printf('Good game!', 0, 64, VIRTUAL_WIDTH, 'center')
        love.graphics.setFont(mediumFont)
        love.graphics.printf('Score: ' .. tostring(self.score), 0, 100, VIRTUAL_WIDTH + 50, 'center')
        love.graphics.draw(MEDAL_IMAGE, VIRTUAL_WIDTH / 2 - 60, VIRTUAL_HEIGHT / 2 - 50, 0, 0.1, 0.1)
    else
        love.graphics.printf('Oof! You lost!', 0, 64, VIRTUAL_WIDTH, 'center')
        love.graphics.setFont(mediumFont)
        love.graphics.printf('Score: ' .. tostring(self.score), 0, 100, VIRTUAL_WIDTH, 'center')
    end

    love.graphics.printf('Press Enter to Play Again!', 0, 160, VIRTUAL_WIDTH, 'center')
end
