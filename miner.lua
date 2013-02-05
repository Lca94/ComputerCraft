Miner = {
    
    yblocks = 6,
    xblocks = 6,
    currentxblock = 1,
    currentyblock = 1,
    startylevel = 64,
    ylevel = 0,
    turtle = Nil,
    
    init = function (self)
        print("Hi, I'm Miner Turtle. Let's be friends!")
        print("Enter how many blocks in front of me you would like to mine [6]")
        self.yblocks = io.read("*number")
        print("Enter how many blocks to the right of me you would like to mine [6]")
        self.xblocks = io.read("*number")
        print("Enter my current Y Level [64]")
        self.startylevel = io.read("*number")
        self.ylevel = self.startylevel
    end,
    
    not_done_mining = function (self)
        if not ((self.currentxblock == self.xblocks) and (self.currentyblock == self.yblocks)) then
            return 1
        else
            return Nil
        end
    end,

    need_fuel = function (self)
        return Nil
    end,

    mine = function (self)
        print(self.yblocks)
        print(self.xblocks)
        print(self.ylevel)
    end,
    
    goDown = function (self)
        self.ylevel = self.ylevel - 1
    end,
    
    goUp = function (self)
        self.ylevel = self.ylevel + 1
    end
    
}

miner = Miner
miner.init(miner)

while miner.not_done_mining(miner) do
    if not miner.need_fuel(miner) then
        miner.mine(miner)
    else
        print("I need fuel!")
    end 
end