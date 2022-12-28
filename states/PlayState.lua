PlayState = Class { __includes = BaseState }

function PlayState:init()
    self.bird = Bird()
    self.pipePairs = {}
    self.timer = 0
    self.score = 0

    self.lastY = math.random(80) + 20
end

function PlayState:update(dt)


    self.timer = self.timer + dt
    if self.timer > 3 then

        local y = math.max(10,
            math.min(self.lastY + math.random(-20, 20), VIRTUAL_HEIGHT - 90))
        self.lastY = y

        table.insert(self.pipePairs, PipePair(y))
        self.timer = 0
    end

    self.bird:update(dt)

    for k, pair in pairs(self.pipePairs) do

        pair:update(dt)

        -- player scores
        if not pair.scored then
            if pair.x + PIPE_WIDTH < self.bird.x then
                self.score = self.score + 1
                pair.scored = true
            end
        end

        -- bird collides pipes?
        if self.bird:collides(pair.pipes.upper) or self.bird:collides(pair.pipes.lower) then
            gStateMachine:change('score', {
                score = self.score
            })
        end

        -- pipe has go off the screen
        if pair.remove then
            table.remove(self.pipePairs, k)
        end
    end

    if self.bird.y > VIRTUAL_HEIGHT - 15 then
        gStateMachine:change('score', {
            score = self.score
        })
    end
end

function PlayState:render()
    for k, pair in pairs(self.pipePairs) do
        pair:render()
    end

    love.graphics.setFont(flappyFont)
    love.graphics.print('Score: ' .. tostring(self.score), 8, 8)

    self.bird:render()
end
