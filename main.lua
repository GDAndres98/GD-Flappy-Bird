push = require 'push'
Class = require 'class'

GROUND_SCROLL_SPEED = 60

WINDOW_WIDTH = 1920
WINDOW_HEIGHT = 1080

VIRTUAL_WIDTH = 512
VIRTUAL_HEIGHT = 288

local background = love.graphics.newImage('res/background.png')
local backgroundScroll = 0

local ground = love.graphics.newImage('res/ground.png')
local groundScroll = 0

GROUND_SCROLL_SPEED = 60
local BACKGROUND_SCROLL_SPEED = GROUND_SCROLL_SPEED / 2

local BACKGROUND_LOOPING_POINT = 413


require 'Bird'
require 'Pipe'
require 'PipePair'

local bird = Bird()
local pipePairs = {}

local spawnTimer = 0

local lastY = math.random(80) + 20

function love.load()
    love.graphics.setDefaultFilter('nearest', 'nearest')
    love.window.setTitle('Flappy Bird')
    math.randomseed(os.time())

    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        vsync = true,
        fullscreen = false,
        resizable = true
    })

    love.keyboard.keysPressed = {}

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

function love.keyboard.wasPressed(key)
    return love.keyboard.keysPressed[key]
end

function love.update(dt)
    backgroundScroll = (backgroundScroll + BACKGROUND_SCROLL_SPEED * dt) % BACKGROUND_LOOPING_POINT
    groundScroll = (groundScroll + GROUND_SCROLL_SPEED * dt) % VIRTUAL_WIDTH

    spawnTimer = spawnTimer + dt
    if spawnTimer > 3 then

        local y = math.max(10,
            math.min(lastY + math.random(-20, 20), VIRTUAL_HEIGHT - 90))
        lastY = y

        table.insert(pipePairs, PipePair(y))
        spawnTimer = 0
    end

    bird:update(dt)

    for k, pair in pairs(pipePairs) do
        pair:update(dt)
        if pair.remove then
            table.remove(pipePairs, k)
        end
    end


    love.keyboard.keysPressed = {}
end

function love.draw()
    push:start()
    love.graphics.draw(background, -backgroundScroll, 0)
    
    for k, pair in pairs(pipePairs) do
        pair:render()
    end
    love.graphics.draw(ground, -groundScroll, VIRTUAL_HEIGHT - 16)
    bird:render()
    push:finish()
end
