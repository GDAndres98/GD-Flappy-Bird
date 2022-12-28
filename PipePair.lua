PipePair = Class {}

local GAP_HEIGHT = 90

function PipePair:init(y)
    self.x = VIRTUAL_WIDTH
    self.y = y

    self.pipes = {}
    self.pipes.upper = Pipe('top', self.y - PIPE_HEIGHT)
    self.pipes.lower = Pipe('bottom', self.y + GAP_HEIGHT)
    
    self.remove = false
end

function PipePair:render()
    self.pipes.upper:render()
    self.pipes.lower:render()
end

function PipePair:update(dt)
    

    if self.x + PIPE_WIDTH < 0 then
        self.remove = true
    else
        self.x = self.x - GROUND_SCROLL_SPEED * dt
        self.pipes.upper.x = self.x
        self.pipes.lower.x = self.x
    end
end
