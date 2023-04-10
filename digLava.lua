------------------------------------------------------------------
--              Turtle Automatic Lava Collection                --
--               By Lca - Forghy for StoneBlock High Lava zone  --
--                                                              --
-- Place turtle 1 bloc under the High level Lava zone of        --
-- StoneBlock and the turtle travels 'blocks' forward and sucks --
-- all lava from up, take on left empty Buckets, and down for   --
-- treatment of laval bucket / return empty in the first chest  --
--                                                              --
-- Parameters : nb of bloc forward / and nb of block on right   --
--  and thirs for filler blocks                                 --
-- Default values of parameters : 1 & 1 & 0                     --
--   -> that dig 1x1 with no jump                               --
------------------------------------------------------------------

    local tArgs = { ... }
	local myvar_Selected
	local myvar_EmptyBuckets=1
	local myvar_CoalSlot=16
	local myvar_CoalRefuel=3
	local myvar_CobbleBuff=15
	local myvar_LavaBucket=14
	local myvar_End=13
     
    if #tArgs < 3 then
      print("Usage: <blocks> <large> <filler>")
      return
    end

    myvar_Selected=turtle.getSelectedSlot()
    turtle.select(myvar_CoalSlot)
    turtle.refuel(myvar_CoalRefuel)
	turtle.select(myvar_Selected)

    --local counter for how far the turtle has traveled
    local traveled = 0
	
	turtle.select(myvar_CobbleBuff)
	if turtle.compare(CobbleStone) == true then
	-- ok cobble next line
	else
		print("Need Cobble on slot 15")
	end

    if turtle.getFuelLevel() < 20 then
		turtle.select(myvar_CoalSlot)
		turtle.refuel(myvar_CoalRefuel)
		if turtle.getFuelLevel() < 20 then
			print("The turtle must have at least some fuel to start with.")
			return
		end
    elseif turtle.getFuelLevel() == "unlimited" then
      print("This turtle does not use fuel to move")
      return
    end

    --Number of blocks to travel to get the lava
    local maxDistance = tArgs[1]
    --Number of blocks turn
    local maxTurn = tArgs[2]
    --Number of blocks to fillerBlocks
    local fillerBlocks = tArgs[3]


    --On commence par les seaux vides
	turtle.select(myvar_EmptyBuckets)

	-- PlaceUp a Cobble after digLavaUp()
	local function PlaceCobbleUp()
		turtle.select(myvar_CobbleBuff)
		return turtle.placeUp()
	end
	
	-- PlaceUp pour prendre la lave
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
				print("Cobble at up : OK or forwarding for next")
			end
			return 0
		else
			-- print("I take one Bucket!") 
			-- need use cobble for brigde
			--turtle.select(myvar_CobbleBuff)
			--turtle.placeUp()
			--turtle.select(myvar_EmptyBuckets)
			PlaceCobbleUp()
			return 1
		end
		print("digLavaUp endif")
		
		-- retourne s'il n'y a plus de bucket
		return turtle.getItemCount(myvar_End) 
	end
	
	--A helper function to try and move forward, it will attempt to dig if it is blocked.
	local function moveForward(returning)
		
		-- PlaceCobbleUp before forwarding
		PlaceCobbleUp()
		
		if turtle.forward() == false then
			-- Stay Cobble in slotBuffer
			turtle.select(myvar_CobbleBuff)
			--Failed to move, see if we can dig our way forward
			while turtle.dig() do
			--Keep digging till we can't dig any more, in case gravel is falling.
			end
			if turtle.forward() == false then
				print("I am either blocked or out of fuel.")
				return false
			else
				if returning == false then
					traveled = traveled + 1
				end
			end
			--print("Forward trace")
			--we need take this lava !
			digLavaUp()
		else
			if returning == false then
				traveled = traveled + 1
			end
		end

		-- PlaceCobbleUp after forwarding
		PlaceCobbleUp()
		
		return true  
	end

-- filler
for i = 1, fillerBlocks do
  moveForward(false)
end

--Travel
for i = 1, maxDistance do
  moveForward(false)
end

--Turn around move a block over and get more lava
turtle.turnRight()
for i=2, maxTurn do
	moveForward(true)
end
turtle.turnRight()

--Travel back the same number of blocks we came minus 1
for i = 2, traveled do
  moveForward(true)
end
print(maxTurn)
if maxTurn == 1 then
	-- retour cas n'avons pas tourné du tout
	turtle.forward()
	turtle.turnRight()
	turtle.turnRight()
else
	-- retour cas avons tourné x fois / x>0
	turtle.turnLeft()
	for i=1, maxTurn do
		turtle.back()
	end
	turtle.turnLeft()	
	turtle.back()
end


print("Fuel level:")
print(turtle.getFuelLevel())

-- Vérif fuel et utiliser le slot2 si nécessaire avant de vider
if turtle.getFuelLevel() < 2500 then
	print("Refuelling with Lavel Slot 2")
	print(turtle.getFuelLevel())
	turtle.select(2)
	turtle.refuel()
	turtle.dropDown()
	turtle.select(1)	
end

--Faire vidange dans le coffre en dessous
for i = 1, myvar_End do
    turtle.select(i)
    if (turtle.compareTo(14) == true) then
        turtle.dropDown()
    end
end

print("Waiting 2 seconds for emptying buckets")
os.sleep(2)

-- Recharge des seaux vides dans le coffre à gauche
turtle.select(1)
turtle.turnLeft()
turtle.suck()
turtle.turnRight()

-- prêt à repartir
