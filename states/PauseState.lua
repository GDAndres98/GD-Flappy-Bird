PauseState = Class { __includes = BaseState }

function PauseState:enter(params)
    self.playParams = params
end

function PauseState:update(dt)
    if love.keyboard.wasPressed('enter') or
        love.keyboard.wasPressed('return') or
        love.mouse.wasPressed(1) or
        love.mouse.wasPressed(2) then
        gStateMachine:change('play', self.playParams)
    end
end

function PauseState:render()
    for k, pair in pairs(self.playParams.pipePairs) do
        pair:render()
    end
    self.playParams.bird:render()
    love.graphics.setFont(flappyFont)
    love.graphics.printf('PAUSE', 0, 64, VIRTUAL_WIDTH, 'center')
    love.graphics.setFont(mediumFont)
    love.graphics.printf('Press Enter to continue', 0, 100, VIRTUAL_WIDTH, 'center')
end
