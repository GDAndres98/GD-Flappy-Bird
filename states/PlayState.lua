PlayState = Class { __includes = BaseState }

function PlayState:init()
    self.playParams = {}
    self.playParams.bird = Bird()
    self.playParams.pipePairs = {}
    self.playParams.timer = 0
    self.playParams.score = 0
    self.playParams.nextPipeTimer = 0.5

    self.playParams.lastY = math.random(80) + 20
end

function PlayState:enter(params)
    if params then
        self.playParams = params
    end
end

function PlayState:update(dt)

    local BACKGROUND_SCROLL_SPEED = GROUND_SCROLL_SPEED / 2
    local BACKGROUND_LOOPING_POINT = 413

    backgroundScroll = (backgroundScroll + BACKGROUND_SCROLL_SPEED * dt) % BACKGROUND_LOOPING_POINT
    groundScroll = (groundScroll + GROUND_SCROLL_SPEED * dt) % VIRTUAL_WIDTH

    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') or love.mouse.wasPressed(2) then
        sounds['pause']:play()
        gStateMachine:change('pause', self.playParams)
    end


    self.playParams.timer = self.playParams.timer + dt
    if self.playParams.timer > self.playParams.nextPipeTimer then

        local y = math.max(10,
            math.min(self.playParams.lastY + math.random(-20, 20), VIRTUAL_HEIGHT - 90))
        self.playParams.lastY = y

        table.insert(self.playParams.pipePairs, PipePair(y))
        self.playParams.timer = 0
        self.playParams.nextPipeTimer = math.random(2, 3)
    end

    self.playParams.bird:update(dt)

    for k, pair in pairs(self.playParams.pipePairs) do

        pair:update(dt)

        -- player scores
        if not pair.scored then
            if pair.x + PIPE_WIDTH < self.playParams.bird.x then
                self.playParams.score = self.playParams.score + 1
                pair.scored = true
                sounds['score']:play()
            end
        end

        -- bird collides pipes?
        if self.playParams.bird:collides(pair.pipes.upper) or self.playParams.bird:collides(pair.pipes.lower) then
            sounds['explosion']:play()
            sounds['hurt']:play()
            gStateMachine:change('score', {
                score = self.playParams.score
            })
        end

        -- pipe has go off the screen
        if pair.remove then
            table.remove(self.playParams.pipePairs, k)
        end
    end

    if self.playParams.bird.y > VIRTUAL_HEIGHT - 15 then
        sounds['hurt']:play()
        gStateMachine:change('score', {
            score = self.playParams.score
        })
    end
end

function PlayState:render()

    for k, pair in pairs(self.playParams.pipePairs) do
        pair:render()
    end

    love.graphics.setFont(flappyFont)
    love.graphics.print('Score: ' .. tostring(self.playParams.score), 8, 8)

    self.playParams.bird:render()
end
