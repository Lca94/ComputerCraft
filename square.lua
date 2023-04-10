

-- préprog pour faire un carré de X en zigzag avec turtle

local function f()
	turtle.forward()
end

local function b()
	turtle.back()
end

local function l()
	turtle.turnLeft()
end

local function r()
	turtle.turRight()
end

--
--

--tArg => x
local x=3

--phase forward 1er ligne
for i=1, x do
	f()
end

--phase premier turn
r()
local z=x-1
for i=1, z do
f()
end

-- zigzag x-1 fois
local y=z-1
for j=1, z do
	--phase droite forward
	if (math.mod(j,2) == 0) then
		-- phase gauche car j pair
		g()
		f()
		for i=1, y do
			f()
		end
	else
		-- phase d car j impair
		d()
		f()
		for i=1, y do
			f()
		end
	end
	
	--phase gauche forward
