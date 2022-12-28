push = require 'push'
Class = require 'class'

GROUND_SCROLL_SPEED = 60

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 512
VIRTUAL_HEIGHT = 288

local background = love.graphics.newImage('res/background.png')
backgroundScroll = 0

local ground = love.graphics.newImage('res/ground.png')
groundScroll = 0

GROUND_SCROLL_SPEED = 60


require 'Bird'
require 'Pipe'
require 'PipePair'
require 'StateMachine'
require 'states/BaseState'
require 'states/TitleScreenState'
require 'states/PlayState'
require 'states/ScoreState'
require 'states/CountdownState'
require 'states/PauseState'

function love.load()
    love.graphics.setDefaultFilter('nearest', 'nearest')
    love.window.setTitle('Flappy Bird')
    math.randomseed(os.time())

    smallFont = love.graphics.newFont('res/font.ttf', 8)
    mediumFont = love.graphics.newFont('res/flappy.ttf', 14)
    flappyFont = love.graphics.newFont('res/flappy.ttf', 28)
    hugeFont = love.graphics.newFont('res/flappy.ttf', 56)
    love.graphics.setFont(flappyFont)

    sounds = {
        ['jump'] = love.audio.newSource('res/jump.wav', 'static'),
        ['explosion'] = love.audio.newSource('res/explosion.wav', 'static'),
        ['hurt'] = love.audio.newSource('res/hurt.wav', 'static'),
        ['score'] = love.audio.newSource('res/score.wav', 'static'),
        ['pause'] = love.audio.newSource('res/pause.wav', 'static'),
        ['music'] = love.audio.newSource('res/marios_way.mp3', 'static')
    }

    sounds['music']:setLooping(true)
    sounds['music']:play()

    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        vsync = true,
        fullscreen = false,
        resizable = true
    })

    gStateMachine = StateMachine {
        ['title'] = function() return TitleScreenState() end,
        ['play'] = function() return PlayState() end,
        ['score'] = function() return ScoreState() end,
        ['countdown'] = function() return CountdownState() end,
        ['pause'] = function() return PauseState() end,
    }
    gStateMachine:change('title')


    love.keyboard.keysPressed = {}
    love.mouse.buttonsPressed = {}

end

function love.resize(w, h)
    push:resize(w, h)
end

function love.keypressed(key)
    love.keyboard.keysPressed[key] = true

    if key == 'escape' then
        love.event.quit()
    end
end

function love.mousepressed(x, y, button)
    love.keyboard.keysPressed[button] = true
    love.mouse.buttonsPressed[button] = true
end

function love.keyboard.wasPressed(key)
    return love.keyboard.keysPressed[key]
end

function love.mouse.wasPressed(button)
    return love.mouse.buttonsPressed[button]
end

function love.update(dt)

    gStateMachine:update(dt)

    love.keyboard.keysPressed = {}
    love.mouse.buttonsPressed = {}

end

function love.draw()
    push:start()

    love.graphics.draw(background, -backgroundScroll, 0)
    gStateMachine:render()
    love.graphics.draw(ground, -groundScroll, VIRTUAL_HEIGHT - 16)

    push:finish()
end
