--

	local myvar_Selected
	local myvar_EmptyBuckets=1
	local myvar_CoalSlot=16
	local myvar_CoalRefuel=3
	local myvar_CobbleBuff=15
	local myvar_LavaBucket=14
	local myvar_ChesPlace=13
	local myvar_End=12

-- check Args
    if #tArgs = 0 then
      print("Usage: <blockSquare>")
      return
    end

--Number of blocks to travel in square
    local maxDistance = tArgs[1]

-- comparer la place en dessous avec un Chest
	local DownisaChest()		
		if turtle.compareDown(myvar_ChesPlace) == true then
			-- arrêt de fin OK : vidange possible 
			return true
		else
			print("Error : chest not in down place")
			return false
		end
	end

-- Vidange en fin de parcours
	local Vidange()
		--Faire vidange dans le coffre en dessous s'il est bien présent
		if DownisaChest() == true then
			for i = 1, myvar_End do
			    turtle.select(i)
			    if (turtle.compareTo(myvar_LavaBucket) == true) then
				turtle.dropDown()
			    end
			end
			print("Fin de vidange")
		end
	end

-- reprise des buckets vides
	local takeBuckets()
		print("Waiting 2 seconds for emptying buckets")
		os.sleep(2)

		-- Recharge des seaux vides dans le coffre à gauche
		turtle.select(1)
		l()
		turtle.suck()
		turtle.suck()
		r()
	end

-- place Cobble on up after take lava bucket
	local function PlaceCobbleUp()
		turtle.select(myvar_CobbleBuff)
		return turtle.placeUp()
		turtle.select(myvar_EmptyBuckets)
	end

-- Prendre la lave au dessus
	local function digLavaUp()
		local nbBucket = turtle.getItemCount(myvar_EmptyBuckets)
		turtle.select(myvar_EmptyBuckets)
		
		-- take the Lava Bucket with placeUp commande (special !)
		turtle.placeUp()

		local nbBucketAfter = turtle.getItemCount(myvar_EmptyBuckets)
		if nbBucket == nbBucketAfter then
			--rien pris ?			
			--comparer avec Cobble
			if turtle.compareUp(CobbleStone) == true then
				print("Cobble at up")
			end
			return 0
		else
			PlaceCobbleUp()
			return 1
		end
		print("digLavaUp endif")
		
		-- retourne s'il n'y a plus de bucket
		return turtle.getItemCount(myvar_End) 
	end

-- préprog pour faire un carré de X en zigzag avec turtle
local function f()
	turtle.select(myvar_CobbleBuff)
	
	-- check if for ok
	if print("turtle.forward()") == false then
		--Failed to move, see if we can dig our way forward
		while print("turtle.dig()") do
		--Keep digging till we can't dig any more, in case gravel is falling.
		end
	end
	
	print("digLavaUp()")
end

local function b()
	print("turtle.back()")
	-- normalement ne fera rien mais au cas où
	print("digLavaUp()")
end

local function l()
	print("turtle.turnLeft()")
end

local function r()
	print("turtle.turRight()")
end

--
--

--tArg => x
local x=maxDistance

--phase forw 1er ligne
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
	--phase droite forw
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
end
-- preEnd / carré impair
if (math.mod(z,2) == 0) then
	-- ok déjà dans case X
	print("end pair")
else
	-- retour case X
	l()
	l()
	for j=1, z do
		f()
	end
	print("end impair")
end

-- End : go to chest
print ("Ok : go to chest")
f()
r()
b()

print ("Ok : End - Vidange")

-- the end and prepare next run
Vidange()
takeBuckets()
