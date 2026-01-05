--ability 
util.AddNetworkString("kage_toss_ability")
util.AddNetworkString("check_miya_position")
util.AddNetworkString("miya_ability")
util.AddNetworkString("yama_ability")
util.AddNetworkString("revertspeed") 
util.AddNetworkString("bokuto_cut") 
util.AddNetworkString("hoshiumi_jump")
--basic  
util.AddNetworkString("spiker_feint")
util.AddNetworkString("basic_serve")
util.AddNetworkString("spike_power_hinata")
util.AddNetworkString("fake_spike")
util.AddNetworkString("receive_power") 
util.AddNetworkString("block_power")
util.AddNetworkString("toss_power") 
util.AddNetworkString("dive_power") 
util.AddNetworkString("ref")
util.AddNetworkString("predictBall")
util.AddNetworkString("graphicprediction")
util.AddNetworkString("stopMomentum")

util.AddNetworkString("create_wall")
util.AddNetworkString("topDownView")
util.AddNetworkString("SyncIsSpiked")
util.AddNetworkString("StartCountdown")
util.AddNetworkString("ReceiveMessage")
util.AddNetworkString("ScoreAnnouncement")

--lag compensate
util.AddNetworkString("illusion_effect")
--ball detector
util.AddNetworkString("BallHitGroundClient")
util.AddNetworkString("BallHitGround")
util.AddNetworkString("CancelScoring")
util.AddNetworkString("UpdateScore")
-- collide
util.AddNetworkString("get_collide_info")
util.AddNetworkString("PrintEveryone")
-- player aim prediction
util.AddNetworkString("PlayerAimPrediction")
-- spike position info
util.AddNetworkString("SpikePositionInfo")

--Jump System
util.AddNetworkString("addVelocity")

hook.Add("PlayerInitialSpawn","test",function(ply)
	ply:SetCollisionGroup( COLLISION_GROUP_WORLD)
end)

hook.Add("PlayerSpawn","test",function(ply)
	ply:SetCollisionGroup( COLLISION_GROUP_WORLD)
end)



net.Receive("get_collide_info",function(bits,ply)
	local ent1 = net.ReadEntity() 
	local ent2 = net.ReadEntity() 

	print("ENTITY COLLIDE NAME ----------------------")
	print(ent1:GetName())
	print(ent2:GetName())

	if ent1:GetClass() == "prop_physics" then 
		ent1:GetPhysicsObject():SetMaterial("dirt")
		print("yeah ent1 is the ball")
		if ent2:GetName() == "kabe" then
			PrintMessage(HUD_PRINTTALK, "BLOCK HIT!")
			PrintMessage(HUD_PRINTCENTER, "BLOCK HIT!")
		end 
	elseif ent2:GetClass() == "prop_physics" then 
		ent2:GetPhysicsObject():SetMaterial("dirt")
		print("yeah ent2 is the ball")
		if ent1:GetName() == "kabe" then
			PrintMessage(HUD_PRINTTALK, "BLOCK HIT!")
			PrintMessage(HUD_PRINTCENTER, "BLOCK HIT!")
		end 
	else 

	end 


	-- if ent2:GetName() == "kabe" then 
	-- 	PrintMessage(HUD_PRINTTALK, "BLOCK HIT!")
	-- 	PrintMessage(HUD_PRINTCENTER, "BLOCK HIT!")
	-- 	net.Start("PrintEveryone")
	-- 	net.WriteString("BLOCK HIT!")
	-- 	net.Broadcast() 
	-- end 

end) 

net.Receive("BallHitGround",function(bits,ply)
	local ballPos = net.ReadVector()
	local ballEnt = net.ReadEntity()

	ballEnt:SetElasticity(0.3) -- 1 means maximum bounciness, 0 means no bounce
	ballEnt:GetPhysicsObject():SetMaterial("dirt")
	-- Removed ball landing sound effect

	-- Set scoring pending for delayed scoring
	scoringPending = true

	-- Start countdown UI for all players
	net.Start("StartCountdown")
	net.WriteFloat(0.7) -- Duration in seconds
	net.Broadcast()

	-- Delay scoring by 0.7 seconds
	timer.Simple(0.7, function()
		if scoringPending and not rallyEnded and allow_competitive_mode then
			-- Determine if ball is in court bounds
			local courtMin = Vector(794.318298, -40.005096, -100)
			local courtMax = Vector(1207.460327, 676.799255, 100)
			local isBallInCourt = ballPos:WithinAABox(courtMin, courtMax)

			-- Determine scoring based on last ball toucher and ball position
			local scoringTeam = 0
			local pointReason = ""

			if lastBallToucher then
				if lastTouchWasBlock then
					-- Special scoring for blocks
					if isBallInCourt then
						-- Check which team's court the ball landed in
						local isBallInBlockerCourt = ballPos:WithinAABox(TEAM1_COURT_MIN, TEAM1_COURT_MAX) and lastBallToucherTeam == 1 or
						                            ballPos:WithinAABox(TEAM2_COURT_MIN, TEAM2_COURT_MAX) and lastBallToucherTeam == 2

						if isBallInBlockerCourt then
							-- Ball landed in blocker's court - attacking team scores (block failed to keep ball away)
							scoringTeam = (lastBallToucherTeam == 1) and 2 or 1
							pointReason = lastBallToucher:Nick() .. " blocked the ball but it landed in own court - attacking team scores!"
						else
							-- Ball landed in attacker's court - blocking team scores (successful block)
							scoringTeam = lastBallToucherTeam
							pointReason = lastBallToucher:Nick() .. " successfully blocked the ball - blocking team scores!"
						end
					else
						-- Blocked ball out of court - attacking team scores (blocking team failed to keep ball in play)
						scoringTeam = (lastBallToucherTeam == 1) and 2 or 1
						pointReason = lastBallToucher:Nick() .. " blocked the ball out of court - attacking team scores!"
					end
				else
					-- Normal scoring for non-block touches
					if isBallInCourt then
						-- Check which team's court the ball landed in
						local isBallInPlayerCourt = ballPos:WithinAABox(TEAM1_COURT_MIN, TEAM1_COURT_MAX) and lastBallToucherTeam == 1 or
						                           ballPos:WithinAABox(TEAM2_COURT_MIN, TEAM2_COURT_MAX) and lastBallToucherTeam == 2

						if isBallInPlayerCourt then
							-- Ball landed in player's own court - opposite team gets point
							scoringTeam = (lastBallToucherTeam == 1) and 2 or 1
							pointReason = lastBallToucher:Nick() .. " hit the ball into own court - point to opposite team!"
						else
							-- Ball landed in opponent's court - player's team gets point
							scoringTeam = lastBallToucherTeam
							pointReason = lastBallToucher:Nick() .. " hit the ball into opponent's court - point to own team!"
						end
					else
						-- Ball out of court - team of last toucher loses point (opposite team scores)
						scoringTeam = (lastBallToucherTeam == 1) and 2 or 1
						pointReason = lastBallToucher:Nick() .. " hit the ball out of court!"
					end
				end

				-- Update score
				if scoringTeam >= 1 and scoringTeam <= 2 then
					teamScores[scoringTeam] = teamScores[scoringTeam] + 1

					-- Broadcast score update to all players
					net.Start("UpdateScore")
					net.WriteInt(scoringTeam, 8)
					net.WriteInt(teamScores[scoringTeam], 16)
					net.WriteString(pointReason)
					net.Broadcast()

					if scoringTeam == 2 then scoringTeam = 'RED' else scoringtTeam = 'BLUE' end 
					-- Announce the point via HUD message
					net.Start("ScoreAnnouncement")
					net.WriteString("POINT! " .. pointReason)
					net.WriteString("POINT! Team " .. scoringTeam .. " scores!")
					net.Broadcast()

					-- Mark rally as ended to prevent double scoring
					rallyEnded = true

					-- Reset ball toucher for next rally
					lastBallToucher = nil
					lastBallToucherTeam = 0
					lastTouchWasBlock = false
				end
			else
				-- No last toucher recorded (serve or other case)
				if not isBallInCourt then
					-- Ball out - determine based on ball position relative to court center
					local courtCenter = Vector(1000.89, 318.4, 0) -- Approximate court center
					if ballPos.y < courtCenter.y then
						scoringTeam = 2 -- Right side out, left team scores
						pointReason = "Ball out on right side!"
					else
						scoringTeam = 1 -- Left side out, right team scores
						pointReason = "Ball out on left side!"
					end

					teamScores[scoringTeam] = teamScores[scoringTeam] + 1

					net.Start("UpdateScore")
					net.WriteInt(scoringTeam, 8)
					net.WriteInt(teamScores[scoringTeam], 16)
					net.WriteString(pointReason)
					net.Broadcast()

					-- Announce the point via HUD message
					net.Start("ScoreAnnouncement")
					net.WriteString("POINT! " .. pointReason)
					net.WriteString("POINT! Team " .. scoringTeam .. " scores!")
					net.Broadcast()
				end
			end
		end
	end)

	net.Start("BallHitGroundClient")
	net.WriteVector(ballPos)
	net.WriteEntity(ballEnt)
	net.WriteBool(ballPos:WithinAABox(Vector(794.318298, -40.005096, -100), Vector(1207.460327, 676.799255, 100)))
	net.Broadcast()
end)


ball_status = ""
one_time_message = ""
isReceived = false
isSpiked = false
spikeMessageCooldown = 0

-- Ball touch tracking and scoring system
lastBallToucher = nil
lastBallToucherTeam = 0
lastTouchWasBlock = false -- Track if the last touch was a block
teamScores = {0, 0} -- Index 1 = Team 1, Index 2 = Team 2
scoringPending = false -- Flag for delayed scoring after ball hits ground
rallyEnded = false -- Flag to prevent multiple scoring per rally

-- Court boundaries for Team 1 and Team 2 (split vertically - top/bottom)
TEAM1_COURT_MIN = Vector(794.318298, 318.4, -100)  -- Top half court (full width)
TEAM1_COURT_MAX = Vector(1207.460327, 676.799255, 100)
TEAM2_COURT_MIN = Vector(794.318298, -40.005096, -100) -- Bottom half court (full width)
TEAM2_COURT_MAX = Vector(1207.460327, 318.4, 100)


local cooldown = false
net.Receive("create_wall",function(bits,ply)
	local blocker = ents.Create( "prop_dynamic" )
	local blockerMedium = ents.Create( "prop_dynamic" )
	local blockerTsuki = ents.Create( "prop_dynamic" )
	local blockerTsuki2 = ents.Create( "prop_dynamic" )
	local blockerKuro = ents.Create( "prop_dynamic" )

	local position = net.ReadString()  
	local tsuki_direction = net.ReadString() 
	local character = net.ReadString() 
	local default_block = net.ReadBool() 

	print("char:"..character)
	blocker:SetModel( "models/props/court/blockpanel_s.mdl" )
	blockerMedium:SetModel( "models/props/court/blockpanel_medium.mdl" )
	blockerTsuki:SetModel( "models/props/court/blockpanel_s.mdl" )
	blockerTsuki2:SetModel( "models/props/court/blockpanel_s.mdl" )
	blockerKuro:SetModel( "models/props/court/blockpanel_s.mdl" )

	-- Set blocker colors based on team
	local creatorTeam = ply:Team()
	if creatorTeam == 1 then
		-- Team 1: Light blue
		blocker:SetColor(Color(114, 144, 228))
		blockerMedium:SetColor(Color(114, 144, 228))
		blockerTsuki:SetColor(Color(114, 144, 228))
		blockerTsuki2:SetColor(Color(114, 144, 228))
		blockerKuro:SetColor(Color(114, 144, 228))
	elseif creatorTeam == 2 then
		-- Team 2: Red
		blocker:SetColor(Color(255, 0, 0, 255))
		blockerMedium:SetColor(Color(255, 0, 0, 255))
		blockerTsuki:SetColor(Color(255, 0, 0, 255))
		blockerTsuki2:SetColor(Color(255, 0, 0, 255))
		blockerKuro:SetColor(Color(255, 0, 0, 255))
	end
    -- blocker2:SetModel( "models/props_debris/metal_panel01a.mdl" )
    -- tsukiBlock:SetModel( "models/props_debris/metal_panel01a.mdl" )


	-- -- debug 
	-- local blocker4 = ents.Create( "prop_dynamic" ) 
	-- blocker4:SetModel( "models/props/court/blockpanel_s.mdl" ) 
	-- blocker:SetMaterial( "models/wireframe" )
	-- blocker4:SetCollisionGroup(COLLISION_GROUP_PASSABLE_DOOR)
	-- blocker4:SetPos( Vector(ply:GetPos().x+33,ply:GetPos().y-33,ply:GetPos().z+100) )
	-- blocker4:SetAngles(Angle(-15, 90, 0))
	-- blocker4:SetSolid(SOLID_VPHYSICS)
	-- blocker4:SetName("kabe")
	-- blocker4:Spawn()
	


	
	-- Set collision group for the blockers
	blocker:SetCollisionGroup(COLLISION_GROUP_PASSABLE_DOOR)
	blockerMedium:SetCollisionGroup(COLLISION_GROUP_PASSABLE_DOOR)
	blockerTsuki:SetCollisionGroup(COLLISION_GROUP_PASSABLE_DOOR)
	blockerTsuki2:SetCollisionGroup(COLLISION_GROUP_PASSABLE_DOOR)
	blockerKuro:SetCollisionGroup(COLLISION_GROUP_PASSABLE_DOOR)

	-- Tag blockers for collision detection and store creator
	blocker:SetName("kabe")
	blocker:SetNWInt("BlockCreatorTeam", creatorTeam)
	blocker:SetNWString("BlockCreator", ply:Nick())

	blockerMedium:SetName("kabe")
	blockerMedium:SetNWInt("BlockCreatorTeam", creatorTeam)
	blockerMedium:SetNWString("BlockCreator", ply:Nick())

	blockerTsuki:SetName("kabe")
	blockerTsuki:SetNWInt("BlockCreatorTeam", creatorTeam)
	blockerTsuki:SetNWString("BlockCreator", ply:Nick())

	blockerTsuki2:SetName("kabe")
	blockerTsuki2:SetNWInt("BlockCreatorTeam", creatorTeam)
	blockerTsuki2:SetNWString("BlockCreator", ply:Nick())

	blockerKuro:SetName("kabe")
	blockerKuro:SetNWInt("BlockCreatorTeam", creatorTeam)
	blockerKuro:SetNWString("BlockCreator", ply:Nick())
	
----------DEFAULT (Q) BLOCK ------------------------------------------------------------------------
	local forward = ply:GetForward()
	local blockerPosition = ply:GetPos() + forward * 45 -- Adjust the distance as needed
	blockerPosition.z = 120 -- Adjust the height as needed

	
	
	//KURO BLOCK -------------------------------------------------------------------------------
	local right = ply:GetRight()  -- Get the right vector based on the player's angles

	local distanceForward = 50  -- Adjust the distance forward as needed
	local distanceRight = 55    -- Adjust the distance to the right or left as needed
	local heightOffset = 95     -- Adjust the height as needed
	
	local blockerPositionKuroRight = ply:GetPos() + ply:GetForward() * distanceForward + right * distanceRight
	blockerPositionKuroRight.z = blockerPositionKuroRight.z + 80 -- Adjust the height as needed

	local blockerPositionKuroLeft = ply:GetPos() + ply:GetForward() * distanceForward - right * distanceRight
	blockerPositionKuroLeft.z = blockerPositionKuroLeft.z + 80 -- Adjust the height as needed

	local angleKuro = ply:GetAngles()
    angleKuro.p = angleKuro.p - 15 -- Set pitch (up/down tilt) to 45 degrees
    angleKuro.y = angleKuro.y + 180 
    angleKuro.r = 5-- Set roll (side tilt) to 45 degrees

	//-----------------------------------------------------------

	local angle = forward:Angle()
	angle.p = angle.p - 15 -- Tilt up by 15 degrees
	angle.y = angle.y + 180 -- Rotate by 180 degrees along the Y-axis

	--if default_block == true then 
	if position == "left" then
		if character == "tsukishima" then
			local blockerTsukiLeft = blockerPosition + right * 15
			local blockerTsukiRight = blockerPosition - right * 15

			blockerTsuki:SetMaterial( "models/wireframe" )
			blockerTsuki:SetPos(blockerTsukiLeft)
			blockerTsuki:SetAngles(angle)
			blockerTsuki:SetSolid(SOLID_VPHYSICS)
			blockerTsuki:Spawn()
			blockerTsuki:SetNoDraw(false)

			blockerTsuki2:SetMaterial( "models/wireframe" )
			blockerTsuki2:SetPos(blockerTsukiRight)
			blockerTsuki2:SetAngles(angle)
			blockerTsuki2:SetSolid(SOLID_VPHYSICS)
			blockerTsuki2:Spawn()
			blockerTsuki2:SetNoDraw(false)

			cooldown = true
		elseif character == "kuro" then
			if tsuki_direction == "block_right" then 
				angleKuro.r = -5 -- Set roll (side tilt) to 45 degrees
				blocker:SetMaterial( "models/wireframe" )
				blocker:SetPos(blockerPositionKuroRight)
				blocker:SetAngles(angleKuro) -- Set the angles based on the player's forward vector
				blocker:SetSolid(SOLID_VPHYSICS)
				blocker:Spawn()
				blocker:SetNoDraw(false)
				cooldown = true 
			elseif tsuki_direction == "block_left" then  
				angleKuro.r = 5
				blockerKuro:SetMaterial( "models/wireframe" )
				blockerKuro:SetPos(blockerPositionKuroLeft)
				blockerKuro:SetAngles(angleKuro) -- Set the angles based on the player's forward vector
				blockerKuro:SetSolid(SOLID_VPHYSICS)
				blockerKuro:Spawn()
				blockerKuro:SetNoDraw(false)
				cooldown = true 
			else 
				blocker:SetMaterial( "models/wireframe" )
				blocker:SetPos(blockerPosition)
				blocker:SetAngles(angle) -- Set the angles based on the player's forward vector
				blocker:SetSolid(SOLID_VPHYSICS)
				blocker:Spawn()
				blocker:SetNoDraw(false)
			cooldown = true 
			end 
		else 
			blocker:SetMaterial( "models/wireframe" )
			blocker:SetPos(blockerPosition)
			blocker:SetAngles(angle) -- Set the angles based on the player's forward vector
			blocker:SetSolid(SOLID_VPHYSICS)
			blocker:Spawn()
			blocker:SetNoDraw(false)
			cooldown = true 
		end 
	else
		if character == "tsukishima" then
			local blockerTsukiLeft = blockerPosition + right * 15
			local blockerTsukiRight = blockerPosition - right * 15

			blockerTsuki:SetMaterial( "models/wireframe" )
			blockerTsuki:SetPos(blockerTsukiLeft)
			blockerTsuki:SetAngles(angle)
			blockerTsuki:SetSolid(SOLID_VPHYSICS)
			blockerTsuki:Spawn()
			blockerTsuki:SetNoDraw(false)

			blockerTsuki2:SetMaterial( "models/wireframe" )
			blockerTsuki2:SetPos(blockerTsukiRight)
			blockerTsuki2:SetAngles(angle)
			blockerTsuki2:SetSolid(SOLID_VPHYSICS)
			blockerTsuki2:Spawn()
			blockerTsuki2:SetNoDraw(false)

			cooldown = true
		elseif character == "kuro" then
			if tsuki_direction == "block_right" then 
				angleKuro.r = -5
				blockerKuro:SetMaterial( "models/wireframe" )
				blockerKuro:SetPos(blockerPositionKuroRight)
				blockerKuro:SetAngles(angleKuro) -- Set the angles based on the player's forward vector
				blockerKuro:SetSolid(SOLID_VPHYSICS)
				blockerKuro:Spawn()
				blockerKuro:SetNoDraw(false)
				cooldown = true 
			elseif tsuki_direction == "block_left" then 
				angleKuro.r = 5 
				blockerKuro:SetMaterial( "models/wireframe" )
				blockerKuro:SetPos(blockerPositionKuroLeft)
				blockerKuro:SetAngles(angleKuro) -- Set the angles based on the player's forward vector
				blockerKuro:SetSolid(SOLID_VPHYSICS)
				blockerKuro:Spawn()
				blockerKuro:SetNoDraw(false)
				cooldown = true 
			else 
				blocker:SetMaterial( "models/wireframe" )
				blocker:SetPos(blockerPosition)
				blocker:SetAngles(angle) -- Set the angles based on the player's forward vector
				blocker:SetSolid(SOLID_VPHYSICS)
				blocker:Spawn()
				blocker:SetNoDraw(false)
				cooldown = true 
			end 
		else 
			blocker:SetMaterial( "models/wireframe" )
			blocker:SetPos(blockerPosition)
			blocker:SetAngles(angle) -- Set the angles based on the player's forward vector
			blocker:SetSolid(SOLID_VPHYSICS)
			blocker:Spawn()
			blocker:SetNoDraw(false)
			cooldown = true 
		end 
	end 
	timer.Simple( 0.8, function() cooldown = false  blockerTsuki:Remove() blockerTsuki2:Remove() blockerKuro:Remove()  blocker:Remove() blockerMedium:Remove() end )

end)



net.Receive("topDownView",function(bits,ply)
 	mode = net.ReadString() 

 	if mode == "enable" then 
 		local viewcontrol = ents.FindByName('viewcontrol') 
        for j = 1, #viewcontrol do viewcontrol[j]:Fire('Enable', 1) end
 	else
 		local viewcontrol = ents.FindByName('viewcontrol')  
  		for j = 1, #viewcontrol do viewcontrol[j]:Fire('Disable', 1) end
 	end 
end)




 --------------------SPIKE MECHANICS-------------------------------------
net.Receive ("spike_power_hinata" , function(bits , ply )
	local position = net.ReadString()
	local power = net.ReadString()
	local spikepower = net.ReadInt(32)
	local character = net.ReadString()
	local entityBall = net.ReadEntity()
	local entityPosVect = net.ReadVector()
	local allow_spike_assist = net.ReadBool()
	local playerPos = net.ReadVector()
	local reachCM = net.ReadInt(16)

	local ent =  ents.FindByClass( "prop_physics*" )

	print("ball mass:"..entityBall:GetPhysicsObject():GetMass())
	print("ball damping:"..entityBall:GetPhysicsObject():GetDamping())
	print("ball GetVelocity:"..tostring(entityBall:GetPhysicsObject():GetVelocity()))

	ply:ConCommand("pac_event spike")

	ply:SetCollisionGroup( COLLISION_GROUP_WORLD)


	if power == "weak" then
		ply:EmitSound("spike.mp3", 70, 100, 1, CHAN_AUTO )
		SpikePosition(entityBall,ply,position,700,0,entityPosVect,allow_spike_assist)
	else

		if character == "ushijima" then
			--game.SetTimeScale( 0.1 )
			SpikePosition(entityBall,ply,position,spikepower,0,entityPosVect,allow_spike_assist)
		else
			SpikePosition(entityBall,ply,position,spikepower,0,entityPosVect,allow_spike_assist)
		end
	end

	-- Broadcast spike position info to all clients
	net.Start("SpikePositionInfo")
	net.WriteVector(playerPos)
	net.WriteInt(reachCM, 16)
	net.WriteString(ply:Nick())
	net.Broadcast()

end)

net.Receive ("fake_spike" , function(bits , ply )
	ply:ConCommand("pac_event spike")
end) 


randomSoundBokuto = {"boku/spike2.mp3","boku/bokutospike2.mp3"}
randomSoundHinata = {"hina/hinataspike2.mp3","hina/hinataspike3.mp3"}
randomSoundKorai = {"korai/hoshiumispike1.wav","korai/hoshiumispike2.wav"} 
		
function SpikePosition(v, ply, position, power, arc, entityPosVect, allow_spike_assist)
    -- Cancel pending scoring since ball was touched
    scoringPending = false

    -- Reset rally flag for new rally
    rallyEnded = false

    -- Track who last touched the ball
    lastBallToucher = ply
    lastBallToucherTeam = ply:Team()

    -- Broadcast player aim prediction to all clients
    net.Start("PlayerAimPrediction")
    net.WriteString(ply:Nick())
    net.WriteVector(ply:GetPos())
    net.WriteBool(true) -- isSpike = true
    net.Broadcast()

    v:SetCollisionGroup(COLLISION_GROUP_PASSABLE_DOOR)
    local desiredZ = ply:GetPos().z - 10

    if position == "left" then
        print("The ball is at pos 3 and 4:")
        print(v:GetPos():WithinAABox(pos3, pos4))

        if v:GetPos():WithinAABox(pos3, pos4) then
            if CurTime() > spikeMessageCooldown then
                ply:ChatPrint("Can't spike ball over other team area!")
                spikeMessageCooldown = CurTime() + 1
            end
        else
            ball_status = "spike"
            if power == 400 then
                -- Handle specific logic for power == 400
            else
                -- Handle other powers
            end
            if allow_delay then
                if isSpiked == false then
                    isSpiked = true
                    net.Start("SyncIsSpiked")
                    net.WriteBool(true)
                    net.Broadcast()
                    timer.Simple(1, function()
						isSpiked = false
                        net.Start("SyncIsSpiked")
                        net.WriteBool(false)
                        net.Broadcast()
					end)

                    if ply:Ping() > 0 and allow_spike_assist == true then
                        v:SetPos(entityPosVect) -- Adjust the Z coordinate as needed
                        -- PrintMessage(HUD_PRINTTALK, ply:Nick().." is having high ping, high spike assist activated for this player.")
                    else
                        -- v:SetPos(ply:GetPos() + Vector(0, 0, 90)) -- Adjust the Z coordinate as needed
                        -- PrintMessage(HUD_PRINTTALK, ply:Nick().." is having high ping, spike assist activated for this player.")
                    end

                    v:GetPhysicsObject():SetVelocity(ply:GetAimVector() * power)
                    v:GetPhysicsObject():SetAngles(Angle(0, 0, 0))
                    v:GetPhysicsObject():AddAngleVelocity(Vector(3000, 0, 0))

                    -- Make the ball bouncy
                    print("Material:")
                    print(v:GetPhysicsObject():GetMaterial())

                    v:GetPhysicsObject():SetMaterial("gmod_bouncy") -- Set the material to a bouncy material

                    -- reappear ball for laggers issue
                    net.Start("illusion_effect")
                    net.WriteString(ply:Nick())
                    net.WriteEntity(v)
                    net.WriteVector(entityPosVect)
                    net.WriteEntity(ply)
                    net.Broadcast()

                    -- Define the function to apply a downward force to the ball
                    local function ApplyDownwardForce()
                        local downwardForce = Vector(0, 0, -1600) -- Adjust the force as needed
                        v:GetPhysicsObject():ApplyForceCenter(downwardForce)
                    end

                    -- Set a timer to apply the downward force after 0.5 seconds
                    timer.Simple(0.2, function()
                        ApplyDownwardForce()
                    end)
                end
			else -- if no delay 
				if ply:Ping() > 0 and allow_spike_assist == true then
					ply:SetCollisionGroup(COLLISION_GROUP_WORLD)
					v:SetPos(entityPosVect) -- Adjust the Z coordinate as needed
					-- PrintMessage(HUD_PRINTTALK, ply:Nick().." is having high ping, high spike assist activated for this player.")
				else
					-- v:SetPos(ply:GetPos() + Vector(0, 0, 90)) -- Adjust the Z coordinate as needed
					-- PrintMessage(HUD_PRINTTALK, ply:Nick().." is having high ping, spike assist activated for this player.")
				end

				-- Calculate the forward vector of the player's view
				print("right")
				local aimVector = ply:GetAimVector()

				-- Set the initial velocity of the volleyball object in the direction the player is aiming
				v:GetPhysicsObject():SetVelocity(aimVector * power)
				v:GetPhysicsObject():SetAngles(Angle(0, 0, 0))
				v:GetPhysicsObject():AddAngleVelocity(Vector(3000, 0, 0))

				-- Make the ball bouncy
				v:SetElasticity(0) -- 1 means maximum bounciness, 0 means no bounce
				v:GetPhysicsObject():SetMaterial("gmod_bouncy") -- Set the material to a bouncy material

				-- Define the function to apply a downward force to the ball
				local function ApplyDownwardForce()
					local downwardForce = Vector(0, 0, -1500) -- Adjust the force as needed
					v:GetPhysicsObject():ApplyForceCenter(downwardForce)
				end

				-- Set a timer to apply the downward force after 0.5 seconds
				timer.Simple(0.2, function()
					ApplyDownwardForce()
				end)

				net.Start("illusion_effect")
				net.WriteString(ply:Nick())
				net.WriteEntity(v)
				net.WriteVector(entityPosVect)
				net.WriteEntity(ply)
				net.Broadcast()
			end 
        end
    else
        if v:GetPos():WithinAABox(pos1, pos2) then
            if CurTime() > spikeMessageCooldown then
                ply:ChatPrint("Can't spike ball over other team area!")
                spikeMessageCooldown = CurTime() + 1
            end
        else
            ball_status = "spike"
            if power == 400 then
                -- Handle specific logic for power == 400
            else
                -- Handle other powers
            end

            if allow_delay then
                if isSpiked == false then
                    isSpiked = true
                    net.Start("SyncIsSpiked")
                    net.WriteBool(true)
                    net.Broadcast()
                    timer.Simple(1, function()
						isSpiked = false
                        net.Start("SyncIsSpiked")
                        net.WriteBool(false)
                        net.Broadcast()
					end)

                    if ply:Ping() > 0 and allow_spike_assist == true then
                        ply:SetCollisionGroup(COLLISION_GROUP_WORLD)
                        v:SetPos(entityPosVect) -- Adjust the Z coordinate as needed
                        -- PrintMessage(HUD_PRINTTALK, ply:Nick().." is having high ping, high spike assist activated for this player.")
                    else
                        -- v:SetPos(ply:GetPos() + Vector(0, 0, 90)) -- Adjust the Z coordinate as needed
                        -- PrintMessage(HUD_PRINTTALK, ply:Nick().." is having high ping, spike assist activated for this player.")
                    end

                    -- Calculate the forward vector of the player's view
                    print("right")
                    local aimVector = ply:GetAimVector()

                    -- Set the initial velocity of the volleyball object in the direction the player is aiming
                    v:GetPhysicsObject():SetVelocity(aimVector * power)
                    v:GetPhysicsObject():SetAngles(Angle(0, 0, 0))
                    v:GetPhysicsObject():AddAngleVelocity(Vector(3000, 0, 0))

                    -- Make the ball bouncy
                    v:SetElasticity(0) -- 1 means maximum bounciness, 0 means no bounce
                    v:GetPhysicsObject():SetMaterial("gmod_bouncy") -- Set the material to a bouncy material

                    -- Define the function to apply a downward force to the ball
                    local function ApplyDownwardForce()
                        local downwardForce = Vector(0, 0, -1500) -- Adjust the force as needed
                        v:GetPhysicsObject():ApplyForceCenter(downwardForce)
                    end

                    -- Set a timer to apply the downward force after 0.5 seconds
                    timer.Simple(0.2, function()
                        ApplyDownwardForce()
                    end)

                    net.Start("illusion_effect")
                    net.WriteString(ply:Nick())
                    net.WriteEntity(v)
                    net.WriteVector(entityPosVect)
                    net.WriteEntity(ply)
                    net.Broadcast()
                end
            else -- if no delay 
				if ply:Ping() > 0 and allow_spike_assist == true then
					ply:SetCollisionGroup(COLLISION_GROUP_WORLD)
					v:SetPos(entityPosVect) -- Adjust the Z coordinate as needed
					-- PrintMessage(HUD_PRINTTALK, ply:Nick().." is having high ping, high spike assist activated for this player.")
				else
					-- v:SetPos(ply:GetPos() + Vector(0, 0, 90)) -- Adjust the Z coordinate as needed
					-- PrintMessage(HUD_PRINTTALK, ply:Nick().." is having high ping, spike assist activated for this player.")
				end

				-- Calculate the forward vector of the player's view
				print("right")
				local aimVector = ply:GetAimVector()

				-- Set the initial velocity of the volleyball object in the direction the player is aiming
				v:GetPhysicsObject():SetVelocity(aimVector * power)
				v:GetPhysicsObject():SetAngles(Angle(0, 0, 0))
				v:GetPhysicsObject():AddAngleVelocity(Vector(3000, 0, 0))

				-- Make the ball bouncy
				v:SetElasticity(0) -- 1 means maximum bounciness, 0 means no bounce
				v:GetPhysicsObject():SetMaterial("gmod_bouncy") -- Set the material to a bouncy material

				-- Define the function to apply a downward force to the ball
				local function ApplyDownwardForce()
					local downwardForce = Vector(0, 0, -1500) -- Adjust the force as needed
					v:GetPhysicsObject():ApplyForceCenter(downwardForce)
				end

				-- Set a timer to apply the downward force after 0.5 seconds
				timer.Simple(0.2, function()
					ApplyDownwardForce()
				end)

				net.Start("illusion_effect")
				net.WriteString(ply:Nick())
				net.WriteEntity(v)
				net.WriteVector(entityPosVect)
				net.WriteEntity(ply)
				net.Broadcast()
			end 
        end
    end

    -- Handle sound effects and trails based on power
    if power > 2500 then -- Ushijima
	 SafeRemoveEntity(trail)
        trail = util.SpriteTrail(v, 0, Color(217, 72, 214, 300), false, 15, 1, 0.3, 1 / (15 + 1) * 0.5, "trails/physbeam")
        print(trail)
		if ply:Ping() > 120 then return end
        ply:EmitSound("ushi/ushijimaspike2.wav", 70, 100, 1, CHAN_AUTO)
    elseif power == 1150 then -- Hinata
		hinataSound = table.Random(randomSoundHinata)
        SafeRemoveEntity(trail)
        trail = util.SpriteTrail(v, 0, Color(255, 132, 0, 300), false, 15, 1, 0.3, 1 / (15 + 1) * 0.5, "trails/physbeam")
		if ply:Ping() > 120 then return end
		ply:EmitSound(hinataSound, 70, 100, 1, CHAN_AUTO)
    elseif power == 1350 then -- Bokuto
        SafeRemoveEntity(trail)
        trail = util.SpriteTrail(v, 0, Color(161, 161, 161, 300), false, 15, 1, 0.3, 1 / (15 + 1) * 0.5, "trails/physbeam")
		if ply:Ping() > 120 then return end
		bokutoSound = table.Random(randomSoundBokuto)
		ply:EmitSound(bokutoSound, 70, 100, 1, CHAN_AUTO)
    elseif power == 1300 then -- Korai
        SafeRemoveEntity(trail)
        trail = util.SpriteTrail(v, 0, Color(161, 161, 161, 300), false, 15, 1, 0.3, 1 / (15 + 1) * 0.5, "trails/physbeam")
		if ply:Ping() > 120 then return end
		koraiSound = table.Random(randomSoundKorai)
		ply:EmitSound(koraiSound, 70, 100, 1, CHAN_AUTO)
    elseif power == 1200 then -- Kuro
        SafeRemoveEntity(trail)
        trail = util.SpriteTrail(v, 0, Color(255, 65, 65), false, 15, 1, 0.3, 1 / (15 + 1) * 0.5, "trails/physbeam")
    end
end

 
 --------------------SPIKE end MECHANICS-------------------------------------
 
 function BlockPosition(v,ply,position,power,arc) 

	if position == "left" then 
	

		--[[v:GetPhysicsObject():SetVelocity(ply:GetForward() * power + Vector(0,0,arc))    -- standard 470 arc   110 power  
		ply:EmitSound("receive.mp3", 70, 100, 1, CHAN_AUTO ) 
		ply:ConCommand("pac_event block")]]
		if v:GetPos():WithinAABox( pos3, pos4 ) then
			ply:ChatPrint("Can't receive ball over other team area!")
		else  
			v:GetPhysicsObject():SetVelocity(ply:GetForward() * power + Vector(0,0,arc))    -- standard 470 arc   110 power  
			ply:EmitSound("receive.mp3", 70, 100, 1, CHAN_AUTO ) 
			ply:ConCommand("pac_event block")
	--ply:SetVelocity( ply:GetAimVector() * 1000 )  
		end 
	else
		if v:GetPos():WithinAABox( pos1, pos2 ) then
			ply:ChatPrint("Can't receive ball over other team area!")
		else 
			v:GetPhysicsObject():SetVelocity(ply:GetForward() * power + Vector(0,0,arc))      
			ply:EmitSound("receive.mp3", 70, 100, 1, CHAN_AUTO ) 
			ply:ConCommand("pac_event block")
		end 

	end
end 

 function DivePosition(v,ply,position,power,arc) 

	if position == "left" then 
		if v:GetPos():WithinAABox( pos3, pos4 ) then
			ply:ChatPrint("Can't receive ball over other team area!")
		else  
			v:GetPhysicsObject():SetVelocity(ply:GetForward() * power + Vector(0,0,arc))    -- standard 470 arc   110 power  
			ply:EmitSound("receive.mp3", 70, 100, 1, CHAN_AUTO ) 
			--ply:ConCommand("pac_event block")
	--ply:SetVelocity( ply:GetAimVector() * 1000 )  
		end 
	else
		if v:GetPos():WithinAABox( pos1, pos2 ) then
			ply:ChatPrint("Can't receive ball over other team area!")
		else 
			v:GetPhysicsObject():SetVelocity(ply:GetForward() * power + Vector(0,0,arc))      
			ply:EmitSound("receive.mp3", 70, 100, 1, CHAN_AUTO ) 
			--ply:ConCommand("pac_event block")
	--ply:SetVelocity( ply:GetAimVector() * 1000 )  
		end 
	end
end 

function ReceivePosition(v, vPos, ply, position, power, arc, allow_receive_assist, allow_old_receive, zoneText)
    -- Cancel pending scoring since ball was touched
    scoringPending = false

    -- Reset rally flag for new rally
    rallyEnded = false

    -- Broadcast to all clients to cancel their pending scoring delays
    net.Start("CancelScoring")
    net.Broadcast()

    -- Cancel any pending Yamaguchi serve drop timer
    if v.YamaguchiDropTimer and timer.Exists(v.YamaguchiDropTimer) then
        timer.Remove(v.YamaguchiDropTimer)
        v.YamaguchiDropTimer = nil
    end

    -- Track who last touched the ball
    lastBallToucher = ply
    lastBallToucherTeam = ply:Team()

    -- Reposition the ball slightly in front of the player
    local offsetInFront = ply:GetForward() * 10
    local newPosition = ply:GetPos() + offsetInFront
    newPosition.z = ply:GetPos().z + 50

	
			
	-- Function to apply velocity with optional zone shank
	local function applyVelocity(velPower, velArc)
		local finalVelocity

		if zoneText == "Bad Receive" then
			-- Send bad receive message to all clients
			net.Start("ReceiveMessage")
			net.WriteString(ply:Nick() .. " made a BAD receive!")
			net.WriteBool(false) -- false = bad receive (red color)
			net.Broadcast()
			-- Strong angle error (left/right)
			local shankAngle = math.random(-40, 40) -- degrees
			local forwardDir = ply:GetForward()
			local shankDir = forwardDir:Angle()
			shankDir:RotateAroundAxis(Vector(0,0,1), shankAngle)

			-- Arc mistake (too flat or too high)
			local arcVariance = math.random(-200, 120)

			finalVelocity =
				shankDir:Forward() * velPower +
				Vector(0, 0, velArc + arcVariance)
		else
			-- Send perfect receive message to all clients
			net.Start("ReceiveMessage")
			net.WriteString(ply:Nick() .. " made a PERFECT receive!")
			net.WriteBool(true) -- true = perfect receive (green color)
			net.Broadcast()
			-- Clean receive
			finalVelocity =
				ply:GetForward() * velPower +
				Vector(0, 0, velArc)
		end

		v:GetPhysicsObject():SetVelocity(finalVelocity)
	end



    -- Helper to handle feint vs normal receive
    local function handleReceive()
        if allow_delay then
            if not isReceived then
                isReceived = true
                timer.Simple(1, function() isReceived = false end)
                ply:EmitSound("receive.mp3", 70, 100, 1, CHAN_AUTO)
                applyVelocity(power, arc)
                if allow_receive_assist then v:SetPos(newPosition) end
                print("Receive applied with delay - power:", power, "arc:", arc)
            end
        else
            ply:EmitSound("receive.mp3", 70, 100, 1, CHAN_AUTO)
            applyVelocity(power, arc)
            if allow_receive_assist then v:SetPos(newPosition) end
            print("Receive applied - power:", power, "arc:", arc)
        end
    end

    -- Area check: prevent receiving balls over other team area
    local inOtherTeamArea = false

    if position == "left" then
        -- Left team can't receive balls in right team area (pos1-pos2)
        inOtherTeamArea = v:GetPos():WithinAABox(pos1, pos2)
        if inOtherTeamArea then ply:ChatPrint("Can't receive ball over other team area! code 2 hahah") end
    else
        -- Right team can't receive balls in left team area (pos3-pos4)
        inOtherTeamArea = v:GetPos():WithinAABox(pos3, pos4)
        if inOtherTeamArea then ply:ChatPrint("Can't receive ball over other team area! code 1") end
    end

    if inOtherTeamArea then return end -- stop if over other team area

    ball_status = "receive"

    if arc < 300 then -- feint
        if not isSpiked then
            ply:EmitSound("toss2.mp3", 70, 100, 1, CHAN_AUTO)
            applyVelocity(power, arc)
            v:SetPos(vPos)
        end
    else
        handleReceive()
    end
end



function TossPosition(v,ply,position,power,arc,frontback,allow_set_assist)
    -- Cancel pending scoring since ball was touched
    scoringPending = false

    -- Reset rally flag for new rally
    rallyEnded = false

    -- Track who last touched the ball
    lastBallToucher = ply
    lastBallToucherTeam = ply:Team()

	SafeRemoveEntity( trail )
	trail = util.SpriteTrail( v, 0, Color(102, 102, 102,800 ), false, 15, 1, 0.3, 1 / ( 15 + 1 ) * 0.5, "trails/plasma" )


	if frontback == "front" then 
		-- ply:ConCommand("pac_event jumptoss")
		-- ply:ConCommand("pac_event toss")


		if position == "left" then 
			if v:GetPos():WithinAABox( pos3, pos4 ) then
				ply:ChatPrint("Can't set ball over other team area!")
			else  
				ball_status = "set" 
				if allow_set_assist == true then 
					v:SetPos(ply:GetPos() + Vector(0, 0, 100))
				end 
				v:GetPhysicsObject():SetVelocity(ply:GetAimVector() *power + Vector(0,0,arc)) 
				v:GetPhysicsObject():SetAngles(Angle(0, 0, 0))
				--[[timer.Create("serveking",0.1,1,function()      
					v:GetPhysicsObject():SetVelocity(ply:GetForward() *1000 + Vector(0,0,arc))           
				end)]]
				ply:EmitSound("toss2.mp3", 70, 100, 1, CHAN_AUTO )
				-- ply:ConCommand("pac_event jumpset")
				-- ply:ConCommand("pac_event set")
		--ply:SetVelocity( ply:GetAimVector() * 1000 )  
			end 
		else
			if v:GetPos():WithinAABox( pos1, pos2 ) then
				ply:ChatPrint("Can't set ball over other team area!")
			else 
				ball_status = "set"
				if allow_set_assist == true then 
					v:SetPos(ply:GetPos() + Vector(0, 0, 100))
				end 
				v:GetPhysicsObject():SetVelocity(ply:GetAimVector() *power + Vector(0,0,arc))
				v:GetPhysicsObject():SetAngles(Angle(0, 0, 0))    
				--[[timer.Create("serveking",0.1,1,function()      
					v:GetPhysicsObject():SetVelocity(ply:GetForward() * 400 + Vector(0,0,arc))           
				end)   ]]  
				ply:EmitSound("toss2.mp3", 70, 100, 1, CHAN_AUTO )
				-- ply:ConCommand("pac_event jumpset")
				-- ply:ConCommand("pac_event set")

		--ply:SetVelocity( ply:GetAimVector() * 1000 )  
			end 
		end
	else //backtoss

		if position == "left" then 
			if v:GetPos():WithinAABox( pos3, pos4 ) then
				ply:ChatPrint("Can't set ball over other team area!")
			else  
				ball_status = "set"
				if allow_set_assist == true then 
					v:SetPos(ply:GetPos() + Vector(0, 0, 100))
				end 
				v:GetPhysicsObject():SetVelocity(ply:GetForward() *power + Vector(0,0,arc)) 
				v:GetPhysicsObject():SetAngles(Angle(0, 0, 0))
				--[[timer.Create("serveking",0.1,1,function()      
					v:GetPhysicsObject():SetVelocity(ply:GetForward() *1000 + Vector(0,0,arc))           
				end)]]
				ply:EmitSound("toss2.mp3", 70, 100, 1, CHAN_AUTO )
			
				//ply:ConCommand("pac_event backset")
		--ply:SetVelocity( ply:GetAimVector() * 1000 )  
			end 
		else
			if v:GetPos():WithinAABox( pos1, pos2 ) then
				ply:ChatPrint("Can't set ball over other team area!")

			else 
				ball_status = "set"
				if allow_set_assist == true then 
					v:SetPos(ply:GetPos() + Vector(0, 0, 100))
				end 
				v:GetPhysicsObject():SetVelocity(ply:GetForward() *power + Vector(0,0,arc))  
				v:GetPhysicsObject():SetAngles(Angle(0, 0, 0))  
				--[[timer.Create("serveking",0.1,1,function()      
					v:GetPhysicsObject():SetVelocity(ply:GetForward() * 400 + Vector(0,0,arc))           
				end)   ]]  
				ply:EmitSound("toss2.mp3", 70, 100, 1, CHAN_AUTO )
				
				//ply:ConCommand("pac_event backset")
		--ply:SetVelocity( ply:GetAimVector() * 1000 )  
			end 
		end
	end 
end 
---------------------------------------------------------------------
 
-- CHAR ABILITIES 
-- Kageyama
function KageTossPosition(v,ply,position,power,arc,frontback,timestop,tosstype,allow_set_assist)  
	ply:ConCommand("pac_event toss") 
	ply:ConCommand("pac_event jumptoss") 
	print(allow_set_assist)
	SafeRemoveEntity( trail )	
	trail = util.SpriteTrail( v, 0, Color(255, 0, 0,1000 ), false, 15, 1, 0.3, 1 / ( 15 + 1 ) * 0.5, "trails/plasma" )


	if tosstype == "king" then 
		if frontback == "front" then 
			SafeRemoveEntity( trail )	
			trail = util.SpriteTrail( v, 0, Color(255, 0, 0,1000 ), false, 15, 1, 0.3, 1 / ( 15 + 1 ) * 0.5, "trails/plasma" )
			if position == "left" then 
				if v:GetPos():WithinAABox( pos3, pos4 ) then
					ply:ChatPrint("Can't set ball over other team area!")
				else  
					ball_status = "set"
					if allow_set_assist == true then 
						v:SetPos(ply:GetPos() + Vector(0, 0, 100))
					end 
					v:GetPhysicsObject():SetVelocity(ply:GetAimVector() *power + Vector(0,0,arc)) 
					v:GetPhysicsObject():SetAngles(Angle(0, 0, 0))
					v:GetPhysicsObject():AddAngleVelocity(Vector(0,2000,0)) 
					timer.Create("serveking",timestop,1,function() 
						if isSpiked == true then
							//if player spike before it king toss stop then cancel the stop motion.
						else
							v:GetPhysicsObject():SetVelocity(ply:GetForward() *50 + Vector(0,0,arc))  
						end      
					end)
					ply:EmitSound("toss2.mp3", 70, 100, 1, CHAN_AUTO )
			--ply:SetVelocity( ply:GetAimVector() * 1000 )  
				end 
			else
				if v:GetPos():WithinAABox( pos1, pos2 ) then
					ply:ChatPrint("Can't set ball over other team area!")
				else  
					ball_status = "set"
					if allow_set_assist == true then 
						v:SetPos(ply:GetPos() + Vector(0, 0, 100))
					end
					v:GetPhysicsObject():SetVelocity(ply:GetAimVector() *power + Vector(0,0,arc)) 
					v:GetPhysicsObject():SetAngles(Angle(0, 0, 0))
					v:GetPhysicsObject():AddAngleVelocity(Vector(0,2000,0)) 
					timer.Create("serveking",timestop,1,function() 
						if isSpiked == true then
							//if player spike before it king toss stop then cancel the stop motion.
						else
							v:GetPhysicsObject():SetVelocity(ply:GetForward() *50 + Vector(0,0,arc))  
						end         
					end)
					ply:EmitSound("toss2.mp3", 70, 100, 1, CHAN_AUTO )
			--ply:SetVelocity( ply:GetAimVector() * 1000 )  
				end 
			end
		else 
			SafeRemoveEntity( trail )	
			trail = util.SpriteTrail( v, 0, Color(255, 0, 0,1000 ), false, 15, 1, 0.3, 1 / ( 15 + 1 ) * 0.5, "trails/plasma" )

			if position == "right" then 
				if v:GetPos():WithinAABox( pos1, pos2 ) then 
					ply:ChatPrint("Can't set ball over other team area!")
				else 
					ball_status = "set" 
					if allow_set_assist == true then 
						v:SetPos(ply:GetPos() + Vector(0, 0, 100))
					end
					v:GetPhysicsObject():SetVelocity(ply:GetAimVector() *power + Vector(0,0,arc)) 
					v:GetPhysicsObject():SetAngles(Angle(0, 0, 0))
					v:GetPhysicsObject():AddAngleVelocity(Vector(0,2000,0)) 
					timer.Create("serveking",timestop,1,function() 
						--v:SetPos(ply:GetPos() + Vector(0, 0, 100))     
						v:GetPhysicsObject():SetVelocity(ply:GetForward() *50 + Vector(0,0,arc))        
					end)
					ply:EmitSound("toss2.mp3", 70, 100, 1, CHAN_AUTO )
			--ply:SetVelocity( ply:GetAimVector() * 1000 )  
				end 
			else
				if v:GetPos():WithinAABox( pos1, pos2 ) then
					ply:ChatPrint("Can't set ball over other team area!")
				else  
					ball_status = "set"
					if allow_set_assist == true then 
						v:SetPos(ply:GetPos() + Vector(0, 0, 100))
					end
					v:GetPhysicsObject():SetVelocity(ply:GetAimVector() *power + Vector(0,0,arc)) 
					v:GetPhysicsObject():SetAngles(Angle(0, 0, 0))
					v:GetPhysicsObject():AddAngleVelocity(Vector(0,2000,0)) 
					timer.Create("serveking",timestop,1,function() 
						--v:SetPos(ply:GetPos() + Vector(0, 0, 100))     
						v:GetPhysicsObject():SetVelocity(ply:GetForward() *50 + Vector(0,0,arc))         
					end)
					ply:EmitSound("toss2.mp3", 70, 100, 1, CHAN_AUTO )
			--ply:SetVelocity( ply:GetAimVector() * 1000 )  
				end 
			end
		end 
	else 
		if frontback == "front" then 
			if position == "left" then 
				if v:GetPos():WithinAABox( pos3, pos4 ) then
					ply:ChatPrint("Can't set ball over other team area!")
					print(tosstype)
				else  
					ball_status = "set"
					if allow_set_assist == true then 
						v:SetPos(ply:GetPos() + Vector(0, 0, 100))
					end
					
					v:GetPhysicsObject():SetVelocity(ply:GetAimVector() *power + Vector(0,0,arc)) 
					v:GetPhysicsObject():SetAngles(Angle(0, 0, 0))
					ply:EmitSound("toss2.mp3", 70, 100, 1, CHAN_AUTO )
			--ply:SetVelocity( ply:GetAimVector() * 1000 )  
				end 
			else
				if v:GetPos():WithinAABox( pos1, pos2 ) then
					ply:ChatPrint("Can't set ball over other team area!")
				else  
					ball_status = "set"
					if allow_set_assist == true then 
						v:SetPos(ply:GetPos() + Vector(0, 0, 100))
					end
					v:GetPhysicsObject():SetVelocity(ply:GetAimVector() *power + Vector(0,0,arc)) 
					
					ply:EmitSound("toss2.mp3", 70, 100, 1, CHAN_AUTO )
			--ply:SetVelocity( ply:GetAimVector() * 1000 )  
				end 
			end
		else 
			if position == "right" then 
				if v:GetPos():WithinAABox( pos1, pos2 ) then 
					ply:ChatPrint("Can't set ball over other team area! haha")
				else  
					ball_status = "set"
					if allow_set_assist == true then 
						v:SetPos(ply:GetPos() + Vector(0, 0, 100))
					end
					v:GetPhysicsObject():SetVelocity(ply:GetAimVector() *power + Vector(0,0,arc)) 
					v:GetPhysicsObject():SetAngles(Angle(0, 0, 0))
					
					ply:EmitSound("toss2.mp3", 70, 100, 1, CHAN_AUTO )
			--ply:SetVelocity( ply:GetAimVector() * 1000 )  
				end 
			else
				if v:GetPos():WithinAABox( pos3, pos4 ) then
					ply:ChatPrint("Can't set ball over other team area! huhu")
				else  
					ball_status = "set"
					if allow_set_assist == true then 
						v:SetPos(ply:GetPos() + Vector(0, 0, 100))
					end
					v:GetPhysicsObject():SetVelocity(ply:GetAimVector() *power + Vector(0,0,arc)) 
					v:GetPhysicsObject():SetAngles(Angle(0, 0, 0))
					
					ply:EmitSound("toss2.mp3", 70, 100, 1, CHAN_AUTO )
			--ply:SetVelocity( ply:GetAimVector() * 1000 )  
				end 
			end
		end 
	end 
end 

net.Receive ("kage_toss_ability" , function(bits , ply )
	local position = net.ReadString()
	local power = net.ReadString()
	local frontback = net.ReadString() 
	local tosstype = net.ReadString() 
	local allow_set_assist = net.ReadBool() 
	 local ent =  ents.FindByClass( "prop_physics*" )

	

	for k, v in pairs( ent ) do    
		

		if tosstype == "king" then 
			if frontback == "front" then 
				ply:ConCommand("pac_event jumpset")
				if ply:GetPos():DistToSqr( v:GetPos() ) < 120*120 then     
					ply:SetLagCompensated(true)
					ply:LagCompensation( true ) 
					--v:SetVelocity(v:GetForward() * 500 + Vector(0,0,1000)) 
					--if(v:GetName() =='volleyball1' or v:GetName() == 'volleyball2' or v:GetName() == 'volleyball3') then  
					SafeRemoveEntity( trail )	
					trail = util.SpriteTrail( v, 0, Color(255, 84, 84,800 ), false, 15, 1, 0.3, 1 / ( 15 + 1 ) * 0.5, "trails/plasma" ) 
					v:SetCollisionGroup( COLLISION_GROUP_PASSABLE_DOOR)
					--v:GetPhysicsObject():SetVelocity(ply:GetAimVector()* 800) 
					if isSpiked != true then 
						if power == "weak" then 
							KageTossPosition(v,ply,position,350,0,frontback,0.3,tosstype, allow_set_assist)
						elseif power == "medium" then 
							KageTossPosition(v,ply,position,480,0,frontback,0.4,tosstype, allow_set_assist)
						else 
							KageTossPosition(v,ply,position,540,0,frontback,0.6,tosstype, allow_set_assist)
						end 
					end
				end  
			else 
				if ply:GetPos():DistToSqr( v:GetPos() ) < 120*120 then     
					ply:SetLagCompensated(true)
					ply:LagCompensation( true ) 
					--v:SetVelocity(v:GetForward() * 500 + Vector(0,0,1000)) 
					--if(v:GetName() =='volleyball1' or v:GetName() == 'volleyball2' or v:GetName() == 'volleyball3') then 
						SafeRemoveEntity( trail )	
						trail = util.SpriteTrail( v, 0, Color(255, 84, 84,800 ), false, 15, 1, 0.3, 1 / ( 15 + 1 ) * 0.5, "trails/plasma" )  
						v:SetCollisionGroup( COLLISION_GROUP_PASSABLE_DOOR)
					if isSpiked != true then 
						if power == "weak" then 
							KageTossPosition(v,ply,position,-110,0,frontback,tosstype,allow_set_assist)
						elseif power == "medium" then 
							KageTossPosition(v,ply,position,-110,0,frontback,tosstype,allow_set_assist) 
						else 
							KageTossPosition(v,ply,position,-220,0,frontback,tosstype,allow_set_assist)
						end 
					end
				end  
			end  
		else 
			if frontback == "front" then 
				ply:ConCommand("pac_event jumpset")
				if ply:GetPos():DistToSqr( v:GetPos() ) < 120*120 then     
					ply:SetLagCompensated(true)
					ply:LagCompensation( true ) 
					--v:SetVelocity(v:GetForward() * 500 + Vector(0,0,1000)) 
					--if(v:GetName() =='volleyball1' or v:GetName() == 'volleyball2' or v:GetName() == 'volleyball3') then 
					SafeRemoveEntity( trail )	
					trail = util.SpriteTrail( v, 0, Color(255, 84, 84,800 ), false, 15, 1, 0.3, 1 / ( 15 + 1 ) * 0.5, "trails/plasma" )  
					if isSpiked != true then 
						if power == "weak" then 
							KageTossPosition(v,ply,position,350,0,frontback,0.3,tosstype,allow_set_assist)
						elseif power == "medium" then 
							KageTossPosition(v,ply,position,480,0,frontback,0.4,tosstype,allow_set_assist)
						else 
							KageTossPosition(v,ply,position,600,0,frontback,0.6,tosstype,allow_set_assist)
						end 
					end  
				end  
			else 
				print("Back shoot toss")
				//back shoot toss 
				ply:ConCommand("pac_event backset")
                ply:ConCommand("pac_event jumpbackset")
				if ply:GetPos():DistToSqr( v:GetPos() ) < 120*120 then     
					ply:SetLagCompensated(true)
					ply:LagCompensation( true ) 
					SafeRemoveEntity( trail )	
					trail = util.SpriteTrail( v, 0, Color(255, 84, 84,800 ), false, 15, 1, 0.3, 1 / ( 15 + 1 ) * 0.5, "trails/plasma" ) 
					if isSpiked != true then 
						if power == "shoot" then 
							KageTossPosition(v,ply,position,-600,180,frontback,0.3,tosstype,allow_set_assist)
						end 
					end
				end  
			end  
		end 
	end
end) 






-- MIYA---------------------------------------------------------------------------------------------------
net.Receive ("check_miya_position" , function(bits , ply )
	for k,v in pairs(player.GetAll()) do 
	--ply:EmitSound("miya/miya_theme2.mp3", 80, 100, 1, CHAN_AUTO ) 
		--v:ChatPrint("Get Ready! Miya is serving..")
	end 
end) 
 

net.Receive ("miya_ability" , function(bits , ply )
	local servetype = net.ReadString() 
	local character = net.ReadString() 
	local ent =  ents.FindByClass( "prop_physics*" )
	
	if servetype == "tossup" then 
		for k, v in pairs( ent ) do   
			if ply:GetPos():DistToSqr( v:GetPos() ) < 150*150 then     
				--if(v:GetName() =='volleyball1' or v:GetName() == 'volleyball2' or v:GetName() == 'volleyball3') then 
					v:GetPhysicsObject():SetVelocity(ply:GetForward() * 20 + Vector(0,0,700))
					v:GetPhysicsObject():SetAngles(Angle(0, 0, 0))
					v:GetPhysicsObject():AddAngleVelocity(Vector(2000,0,0))
					ply:EmitSound("tossup.mp3", 70, 100, 1, CHAN_AUTO )
				--end
			end   
		end 
	else 
		ply:ConCommand("pac_event spike") 
		for k, v in pairs( ent ) do   
			if ply:GetPos():DistToSqr( v:GetPos() ) < 150*150 then 

				v:GetPhysicsObject():SetMaterial("gmod_bouncy") -- Set the material to a bouncy material
				v:GetPhysicsObject():SetAngles(Angle(0, 0, 0))
				v:GetPhysicsObject():AddAngleVelocity(Vector(5000,0,0))
				timer.Simple(1,function() 
					v:GetPhysicsObject():SetMaterial("dirt") -- Set the material to a bouncy material
				end)
				--if(v:GetName() =='volleyball1' or v:GetName() == 'volleyball2' or v:GetName() == 'volleyball3') then 
				if character == "miya" then
					v:SetPos(ply:GetPos() + Vector(0, 0, 100))
					-- Realistic jump serve spike trajectory with moderate top spin
					local forwardVel = ply:GetForward() * 1400  -- Faster forward momentum
					local upwardVel = Vector(0, 0, 50)         -- Minimal upward arc
					local sideVel = Vector(math.random(-500, 500), 0, 0)  -- Random side curve
					v:GetPhysicsObject():SetVelocity(forwardVel + upwardVel + sideVel)

					-- Add moderate top spin for realistic trajectory
					local topSpinSpeed = 3000  -- Moderate top spin
					v:GetPhysicsObject():AddAngleVelocity(Vector(0, -topSpinSpeed, 0))  -- Top spin when moving forward

					-- Apply stronger gravity effect over time for faster drop to same point
					local function ApplyGravityArc()
						local gravityForce = Vector(0, 0, -3500)  -- Stronger downward pull for faster drop
						v:GetPhysicsObject():ApplyForceCenter(gravityForce)
					end

					-- Apply gravity in stages for smooth, realistic arc
					timer.Simple(0.1, ApplyGravityArc)
					timer.Simple(0.2, ApplyGravityArc)
					timer.Simple(0.3, function()
						ApplyGravityArc()
						ply:EmitSound("miya/miya_spike3.mp3", 70, 100, 1, CHAN_AUTO )
						ply:ConCommand("pac_event spike")
					end)

				elseif character == "korai" then 
					v:GetPhysicsObject():SetVelocity(ply:GetForward() * 1200 + Vector(0,0,50)) 

					-- Define the function to apply a downward force to the ball
					local function ApplyDownwardForce()
						local downwardForce = Vector(0, 0, -7500)  -- Adjust the force as needed
						v:GetPhysicsObject():ApplyForceCenter(downwardForce)
					end

					-- Set a timer to apply the downward force after 0.5 seconds
					timer.Simple(0.3, function()
						ApplyDownwardForce()
						ply:EmitSound("korai/hoshiumispike2.wav", 70, 100, 1, CHAN_AUTO )  
						ply:ConCommand("pac_event spike")
					end)
				end 
				--end
			end   
		end 
	end 
end) 

--bokuto 
net.Receive ("bokuto_cut" , function(bits , ply )
	local position = net.ReadString()
	local direction = net.ReadString() 
	local power = net.ReadString() 
	local v = net.ReadEntity() 
	local entityPosVect = net.ReadVector() 

	local ent =  ents.FindByClass( "prop_physics*" )


		v:GetPhysicsObject():SetMaterial("gmod_bouncy") -- Set the material to a bouncy material
		ply:EmitSound("spike.mp3", 70, 100, 1, CHAN_AUTO ) 
		--if(v:GetName() =='volleyball1' or v:GetName() == 'volleyball2' or v:GetName() == 'volleyball3') then 

		v:SetCollisionGroup( COLLISION_GROUP_PASSABLE_DOOR)

		timer.Create("collide",2,1,function() 
			v:SetCollisionGroup( COLLISION_GROUP_PASSABLE_DOOR)
		end)

		v:SetPos(Vector(entityPosVect))
		
		if position == "left" then
			if v:GetPos():WithinAABox( pos3, pos4 ) then
				if CurTime() > spikeMessageCooldown then
					ply:ChatPrint("Can't spike ball over other team area!")
					spikeMessageCooldown = CurTime() + 1
				end
			else
				ball_status = "spike"
				if direction == "right" then
					ply:EmitSound("boku/bokutospike2.mp3", 70, 100, 1, CHAN_AUTO )
					v:SetPos(entityPosVect)
					v:GetPhysicsObject():SetVelocity(ply:GetAimVector() * 800  + Vector(900,0,-150))
				else
					ply:EmitSound("boku/bokutospike2.mp3", 70, 100, 1, CHAN_AUTO )
					v:GetPhysicsObject():SetVelocity(ply:GetAimVector() * 800  + Vector(-900,0,-150))
				end
			end
		else
			if v:GetPos():WithinAABox( pos1, pos2 ) then
				if CurTime() > spikeMessageCooldown then
					ply:ChatPrint("Can't spike ball over other team area!")
					spikeMessageCooldown = CurTime() + 1
				end
			else
				if direction == "left" then
					ply:EmitSound("boku/bokutospike2.mp3", 70, 100, 1, CHAN_AUTO )
					v:GetPhysicsObject():SetVelocity(ply:GetAimVector() * 800  + Vector(900,0,-150))
				else
					ply:EmitSound("boku/bokutospike2.mp3", 70, 100, 1, CHAN_AUTO )
					v:GetPhysicsObject():SetVelocity(ply:GetAimVector() * 800  + Vector(-900,0,-150))
				end
			end
		end

end) 

-- yamaguchi
net.Receive ("yama_ability" , function(bits , ply )
	local servetype = net.ReadString()
	local ent =  ents.FindByClass( "prop_physics*" )

	if servetype == "tossup" then
		for k, v in pairs( ent ) do
			if ply:GetPos():DistToSqr( v:GetPos() ) < 120*120 then
				--if(v:GetName() =='volleyball1' or v:GetName() == 'volleyball2' or v:GetName() == 'volleyball3') then
					v:GetPhysicsObject():SetAngles(Angle(0, 0, 0))
					v:GetPhysicsObject():SetAngleVelocity(Vector(0, 0, 0))
					v:GetPhysicsObject():SetVelocity(ply:GetForward() * 20 + Vector(0,0,600))
					ply:EmitSound("tossup.mp3", 70, 100, 1, CHAN_AUTO )
				--end
			end
		end
	else
		for k, v in pairs( ent ) do
			if ply:GetPos():DistToSqr( v:GetPos() ) < 120*120 then
				ply:EmitSound("yama/yamaserve.mp3", 70, 100, 1, CHAN_AUTO )

				-- Float serve: no spin, floating trajectory with unpredictable left/right wiggle
				local aimVector = ply:GetAimVector()
				local baseVelocity = aimVector * 600  -- Moderate forward speed
				local floatUp = Vector(0, 0, 150)     -- Initial upward float
				local randomSide = Vector(math.random(-150, 150), 0, 0)  -- Increased random side wiggle

				v:GetPhysicsObject():SetVelocity(baseVelocity + floatUp + randomSide)
				v:GetPhysicsObject():SetAngles(Angle(0, 0, 0))
				v:GetPhysicsObject():SetAngleVelocity(Vector(0, 0, 0))  -- Ensure no spin

				-- Float phase: maintain height with gentle forces
				local floatDuration = math.random(0.8, 1.2)  -- Random float time
				local dropTimer = timer.Simple(floatDuration, function()
					if IsValid(v) then
						-- Sudden drop with unpredictable direction
						local dropVelocity = aimVector * 200 + Vector(math.random(-100, 100), 0, -400)
						v:GetPhysicsObject():SetVelocity(dropVelocity)
						v:GetPhysicsObject():AddAngleVelocity(Vector(math.random(-200, 200), math.random(-200, 200), math.random(-200, 200)))  -- Random spin on drop
					end
				end)
				-- Store timer reference on the ball entity for cancellation
				v.YamaguchiDropTimer = dropTimer
			end
		end
	end
end)
---------------------------------------------------------------------
-- Assuming you're working with a player entity (e.g., a character or player controller)

-- Override the player's jump function
function GM:PlayerCanJump(player)
    -- You can add custom logic here to determine whether the player can jump
    -- For your specific requirement, we'll allow jumping without any extra height
    local canJump = true

    -- Debug: Print whether the player can jump
   // print("Player Can Jump:", canJump)

    return canJump
end





--BASIC REC,SET,SPIKE 

 net.Receive("basic_serve", function(bits, ply)
    local entities = ents.FindByClass("prop_physics*")
    
    for _, v in ipairs(entities) do
        if ply:GetPos():DistToSqr(v:GetPos()) < 120*120 then
            ply:EmitSound("tossup.mp3", 70, 100, 1, CHAN_AUTO)
			-- Tell server jump is starting

   			local phys = v:GetPhysicsObject()
			v:GetPhysicsObject():SetAngles(Angle(0, 0, 0))
			v:GetPhysicsObject():AddAngleVelocity(Vector(0,5000,0))

			if IsValid(phys) then
				-- Move ball just above player
				local newPos = ply:GetPos() + Vector(0, 0, 60) -- slightly higher for jump serve
				v:SetPos(newPos)

				-- Jump serve: high and slightly forward
				local tossForward = 120   -- small forward push
				local tossUp = 600        -- high toss
				phys:SetVelocity(ply:GetForward() * tossForward + Vector(0, 0, tossUp))
			end

        end
    end
end)

-- net.Receive ("basic_serve" , function(bits , ply )
-- 	local ent =  ents.FindByClass( "prop_physics*" ) 

-- 	for k, v in pairs( ent ) do   
-- 		ply:ConCommand("pac_event serve")
-- 		ply:ConCommand("pac_event spike")
-- 		if ply:GetPos():DistToSqr( v:GetPos() ) < 120*120 then     
-- 			--if(v:GetName() =='volleyball1' or v:GetName() == 'volleyball2' or v:GetName() == 'volleyball3') then 
-- 				ply:EmitSound("spike.mp3", 70, 100, 1, CHAN_AUTO )
-- 				v:GetPhysicsObject():SetVelocity(ply:GetForward() * 400 + Vector(0,0,400)) 
-- 			--end
-- 		end   
-- 	end 
-- end) 



net.Receive ("receive_power" , function(bits , ply )
   local position = net.ReadString()
    local power = net.ReadString()
    local entityBall = net.ReadEntity()
    local allow_receive_assist = net.ReadBool()
    local entBallPos = net.ReadVector()
    local allow_old_receive = net.ReadBool()
    local character = net.ReadString()
    local zoneText = net.ReadString()

    print("Position:", position)
    print("Power:", power)
    print("Entity:", entityBall)
    print("Allow assist:", allow_receive_assist)
    print("Ball Pos:", entBallPos)
    print("Allow old:", allow_old_receive)
    print("Character:", character)
    print("Zone:", zoneText)

	print(entityBall:GetName())
	if character ~= "kuro" and character ~= "kenma" then
		character = ""
	end
	
	//print("char "..character)

	entityBall:SetCollisionGroup( COLLISION_GROUP_PASSABLE_DOOR) 

	if power == "weak" then 
		ReceivePosition(entityBall,entBallPos,ply,position,110,400,allow_receive_assist,allow_old_receive,zoneText)
	elseif power == "strong" then 
		ReceivePosition(entityBall,entBallPos,ply,position,140,600,allow_receive_assist,allow_old_receive,zoneText)
	elseif power == "ultra" and character == "kuro" then 
		ReceivePosition(entityBall,entBallPos,ply,position,100,750,allow_receive_assist,allow_old_receive,zoneText)
	elseif power == "ultra" and character == "kenma" then 
		ReceivePosition(entityBall,entBallPos,ply,position,100,750,allow_receive_assist,allow_old_receive,zoneText)
	elseif power == "feint" then 
		ReceivePosition(entityBall,entBallPos,ply,position,200,110,allow_receive_assist,allow_old_receive,zoneText)
	end 
end)


 
net.Receive("toss_power", function(bits, ply)
    local position = net.ReadString()
    local power = net.ReadString()
    local frontback = net.ReadString()
	local allow_set_assist = net.ReadBool()
	
    local ent = ents.FindByClass("prop_physics*")

    for k, v in pairs(ent) do
        if frontback == "front" then
            ply:ConCommand("pac_event set")
            if ply:GetPos():DistToSqr(v:GetPos()) < 120 * 120 then
				if (!ply:IsOnGround()) then  ply:ConCommand("pac_event jumpset") else  ply:ConCommand("pac_event toss") end 

                --v:SetVelocity(v:GetForward() * 500 + Vector(0,0,1000)) 
                --if(v:GetName() =='volleyball1' or v:GetName() == 'volleyball2' or v:GetName() == 'volleyball3') then   
                --v:GetPhysicsObject():SetVelocity(ply:GetAimVector()* 800) 
				if isSpiked != true then 
					if isReceived == false then 
						isReceived = true 
						timer.Simple(1,function() isReceived=false end)
						if power == "weak" then
							TossPosition(v, ply, position, 100, 250, frontback,allow_set_assist)
						elseif power == "medium" then
							TossPosition(v, ply, position, 100, 400, frontback,allow_set_assist)
						else
							TossPosition(v, ply, position, 300, 400, frontback,allow_set_assist)
						end
					end 
				end 
            end
        else
            if ply:GetPos():DistToSqr(v:GetPos()) < 120 * 120 then
                -- ply:ConCommand("pac_event backset")
 
			if (!ply:IsOnGround()) then  ply:ConCommand("pac_event jumpbackset") else  ply:ConCommand("pac_event backset") end 

				if isSpiked != true then 
					if isReceived == false then 
						isReceived = true
						timer.Simple(1,function() isReceived=false end) 
						if power == "weak" then
							TossPosition(v, ply, position, -110, 330, frontback,allow_set_assist)
						elseif power == "medium" then
							TossPosition(v, ply, position, -110, 450, frontback,allow_set_assist)
						else 
							TossPosition(v, ply, position, -120, 500, frontback,allow_set_assist)
						end
					end
				end 
            end
        end
    end
end)


//LIBERO ALPHA FEATURE 
-- net.Receive ("dive_power" , function(bits , ply )
-- 	local position = net.ReadString()
-- 	local power = net.ReadString()

-- 	local ent =  ents.FindByClass( "prop_physics*" )

-- 	for k, v in pairs( ent ) do    
-- 		ply:SetWalkSpeed(1)
-- 		ply:SetRunSpeed(1)

-- 		if power == "short" then 

-- 			if ply:GetPos():DistToSqr( v:GetPos() ) < 180*180 then     
-- 				DivePosition(v,ply,position,-100,450,"short")
-- 			end
	
-- 			ply:SetVelocity(ply:GetForward() * 600 ) 
-- 			ply:ConCommand("pac_event diveshort") 
-- 		elseif power == "long" then 

-- 			if ply:GetPos():DistToSqr( v:GetPos() ) < 220*220 then     
-- 				DivePosition(v,ply,position,-100,650,"long")
-- 			end

-- 			ply:SetVelocity(ply:GetForward() * 1200 ) 
-- 			ply:ConCommand("pac_event divelong")
-- 		end 
-- 	end
-- end)

-- -- Receive the "revertspeed" event and update the player's speed based on their class
-- net.Receive("revertspeed", function(bits, ply)
--     local class = net.ReadString()

--     if class == "libero" then
--         ply:SetWalkSpeed(300)
--         ply:SetRunSpeed(340)
--     end
-- end)	

-- Receive the "ref" event and play a sound or execute a command based on the reference
net.Receive("ref", function(bits, ply)
    local ref = net.ReadString()

    if ref == "whistle" then
        ply:EmitSound("whistle.mp3", 70, 100, 1, CHAN_AUTO)
    elseif ref == "agree" then
        ply:ConCommand("act agree")
    else
        ply:ConCommand("act disagree")
    end
end)

net.Receive("hoshiumi_jump", function(bits, ply)
	local status = net.ReadString() 
	local whoami = net.ReadString()

	if status == "boost" then 
		ply:SetJumpPower(korai_boost_jump)
	else 
		ply:SetJumpPower(korai_jump)
	end 
end) 


-- Limit the player's forward momentum when they jump in a direction
hook.Add("SetupMove", "LimitForwardMomentum", function(ply, mv, cmd)
    -- Check if the player is pressing the jump key and moving forward
    if bit.band(cmd:GetButtons(), IN_JUMP) ~= 0 and bit.band(cmd:GetButtons(), IN_FORWARD) ~= 0 then
        local vel = mv:GetVelocity()
        local maxForwardVelocity = 150 -- Adjust as needed

        if vel:Length2D() > maxForwardVelocity then
            local scale = maxForwardVelocity / vel:Length2D()
            vel = vel * scale
            mv:SetVelocity(vel)
        end
    -- Check if the player is pressing the jump key and moving left
    elseif bit.band(cmd:GetButtons(), IN_JUMP) ~= 0 and bit.band(cmd:GetButtons(), IN_MOVELEFT) ~= 0 then
        local vel = mv:GetVelocity()
        local maxLeftVelocity = 270 -- Adjust as needed

        if vel:Length2D() > maxLeftVelocity then
            local scale = maxLeftVelocity / vel:Length2D()
            vel = vel * scale
            mv:SetVelocity(vel)
        end
    -- Check if the player is pressing the jump key and moving right
    elseif bit.band(cmd:GetButtons(), IN_JUMP) ~= 0 and bit.band(cmd:GetButtons(), IN_MOVERIGHT) ~= 0 then
        local vel = mv:GetVelocity()
        local maxRightVelocity = 270 -- Adjust as needed

        if vel:Length2D() > maxRightVelocity then
            local scale = maxRightVelocity / vel:Length2D()
            vel = vel * scale
            mv:SetVelocity(vel)
        end
    -- Check if the player is pressing the jump key and moving backward
    elseif bit.band(cmd:GetButtons(), IN_JUMP) ~= 0 and bit.band(cmd:GetButtons(), IN_BACK) ~= 0 then
        local vel = mv:GetVelocity()
        local maxForwardVelocity = 270 -- Adjust as needed

        if vel:Length2D() > maxForwardVelocity then
            local scale = maxForwardVelocity / vel:Length2D()
            vel = vel * scale
            mv:SetVelocity(vel)
        end
    end
end)



timer.Simple(2, function() 
    local entsList = ents.FindByClass("prop_physics*") -- correct
    for k, v in pairs(entsList) do
        if v:GetName() ~= "volleyball10" then
            v:Remove()
        end
    end
end)

//jump system 
net.Receive("addVelocity", function(len, ply)
	local char = net.ReadString()
    local jumpPower = net.ReadInt(32)
   // if not IsValid(ply) then return end
    if not ply:OnGround() then return end -- prevent air jump
	ply:SetVelocity(Vector(0, 0, jumpPower))
	
	if char == "korai" then 
		ply:EmitSound("korai/highjump1.wav") 
	end 
    
end)

util.AddNetworkString("JumpApproachStart")
util.AddNetworkString("JumpApproachEnd")

net.Receive("JumpApproachStart", function(len, ply)
    if not IsValid(ply) then return end
    ply.isJumping = true
end)

net.Receive("JumpApproachEnd", function(len, ply)
    if not IsValid(ply) then return end
    ply.isJumping = false
end)

-- Set slow speed when charging jump
hook.Add("SetupMove", "DelayedJump_SlowMovement", function(ply, mv, cmd)
    if not IsValid(ply) then return end
    if not ply.isJumping then return end -- use server-side isJumping flag

    -- Reduce speed while jump is charging
    mv:SetMaxSpeed(100)
    mv:SetMaxClientSpeed(100)
end)

-- Automatic block detection system
local lastBlockTime = 0

-- Function to add collision detection to a volleyball
local function AddBlockCollisionToVolleyball(ent)
    if not IsValid(ent) then return end
    if ent:GetClass() ~= "prop_physics" then return end

    -- Check if this is a volleyball (any volleyball entity)
    if string.find(ent:GetName(), "volleyball") then
        -- Remove any existing collision callback first
        if ent.BlockCollisionCallback then
            ent:RemoveCallback("PhysicsCollide", ent.BlockCollisionCallback)
        end

        -- Add collision callback to the volleyball
        ent.BlockCollisionCallback = ent:AddCallback("PhysicsCollide", function(ent, data)
            local hitEnt = data.HitEntity
            if IsValid(hitEnt) and hitEnt:GetName() == "kabe" then
                -- Prevent spam by checking time since last block
                if CurTime() - lastBlockTime > 1.0 then
                    local blockerTeam = hitEnt:GetNWInt("BlockCreatorTeam", 0)
                    local blockerName = hitEnt:GetNWString("BlockCreator", "Unknown")

                    -- Debug prints
                    print("BLOCK COLLISION DETECTED!")
                    print("Blocker Team:", blockerTeam, "Blocker Name:", blockerName)

                    PrintMessage(HUD_PRINTTALK, "BLOCK TOUCH by " .. blockerName .. " (Team " .. blockerTeam .. ")!")

                    -- Track who last touched the ball (blocker) - PRIORITY: Block collisions override player actions
                    -- For dummy blocks, create a pseudo-player object since there's no real player
                    if blockerName == "Team2Blocker" or blockerName == "OppositeTeamBlocker" then
                        -- Create a pseudo-player object for dummy blocks
                        lastBallToucher = {
                            Nick = function() return blockerName end,
                            Team = function() return blockerTeam end,
                            IsValid = function() return true end
                        }
                        lastBallToucherTeam = blockerTeam
                        lastTouchWasBlock = true -- Mark this as a block touch
                        print("BLOCK COLLISION: Last ball toucher updated to dummy blocker:", blockerName, "Team:", blockerTeam)
                    else
                        -- Find the real player who created this block
                        for _, ply in ipairs(player.GetAll()) do
                            if ply:Nick() == blockerName and ply:Team() == blockerTeam then
                                lastBallToucher = ply
                                lastBallToucherTeam = blockerTeam
                                lastTouchWasBlock = true -- Mark this as a block touch
                                print("BLOCK COLLISION: Last ball toucher updated to real blocker:", blockerName, "Team:", blockerTeam)
                                break
                            end
                        end
                    end

                    lastBlockTime = CurTime()
                end
            end
        end)
    end
end

-- Add collision detection to volleyball when it's created
hook.Add("OnEntityCreated", "SetupVolleyballCollision", function(ent)
    timer.Simple(0.1, function()
        AddBlockCollisionToVolleyball(ent)
    end)
end)

-- Also add collision detection to existing volleyballs when blocks are created
local function SetupExistingVolleyballsForBlocks()
    for _, ent in ipairs(ents.FindByClass("prop_physics")) do
        AddBlockCollisionToVolleyball(ent)
    end
end

-- Test command to create a dummy block wall for testing collision
concommand.Add("test_block_wall", function(ply)
    if not IsValid(ply) then return end

    -- Create a test block panel in front of the player
    local blocker = ents.Create("prop_dynamic")
    blocker:SetModel("models/props/court/blockpanel_s.mdl")
    blocker:SetPos(ply:GetPos() + ply:GetForward() * 100 + Vector(0, 0, 150))
    blocker:SetAngles(ply:GetAngles())
    blocker:SetName("kabe") -- Tag it for collision detection
    blocker:SetMaterial("models/wireframe") -- Make it visible
    blocker:SetSolid(SOLID_VPHYSICS)

    -- Set creator information BEFORE spawning - use player's own team
    local creatorTeam = ply:Team()
    blocker:SetNWInt("BlockCreatorTeam", creatorTeam)
    blocker:SetNWString("BlockCreator", ply:Nick())

    blocker:Spawn()

    -- Verify the values after spawning
    timer.Simple(0.1, function()
        if IsValid(blocker) then
            print("Block wall spawned - Team:", blocker:GetNWInt("BlockCreatorTeam", -1), "Name:", blocker:GetNWString("BlockCreator", "NOT_SET"))
        end
    end)

    -- Remove after 30 seconds
    timer.Simple(30, function()
        if IsValid(blocker) then
            blocker:Remove()
        end
    end)

    ply:ChatPrint("Test block wall created (your team)! Check console for debug info.")
end)

-- Test command to create a dummy block wall from TEAM 2 for testing
concommand.Add("test_opposite_block", function(ply)
    if not IsValid(ply) then return end

    -- Create a test block panel in front of the player
    local blocker = ents.Create("prop_dynamic")
    blocker:SetModel("models/props/court/blockpanel_s.mdl")
    blocker:SetPos(ply:GetPos() + ply:GetForward() * 100 + Vector(0, 0, 150))
    blocker:SetAngles(ply:GetAngles())
    blocker:SetName("kabe") -- Tag it for collision detection
    blocker:SetMaterial("models/wireframe") -- Make it visible (but red to indicate team 2)
    blocker:SetColor(Color(255, 0, 0, 255)) -- Red color to indicate team 2
    blocker:SetSolid(SOLID_VPHYSICS)

    -- Set creator information BEFORE spawning - always use TEAM 2
    local fakeBlockerName = "Team2Blocker"

    blocker:SetNWInt("BlockCreatorTeam", 2) -- Always team 2
    blocker:SetNWString("BlockCreator", fakeBlockerName)

    blocker:Spawn()

    -- Setup collision detection for existing volleyballs
    SetupExistingVolleyballsForBlocks()

    -- Verify the values after spawning
    timer.Simple(0.1, function()
        if IsValid(blocker) then
            print("Team 2 block wall spawned - Team:", blocker:GetNWInt("BlockCreatorTeam", -1), "Name:", blocker:GetNWString("BlockCreator", "NOT_SET"))
        end
    end)

    -- Remove after 30 seconds
    timer.Simple(30, function()
        if IsValid(blocker) then
            blocker:Remove()
        end
    end)

    ply:ChatPrint("Team 2 test block wall created (RED)! Hit the ball into this to test block scoring.")
end)
--[[
net.Receive("predictBall",function(bits,ply) 
	local hitpos = net.ReadVector() 
	local mode = net.ReadString() 

	--print(hitpos)

 	for k,v in pairs(player.GetAll()) do 
 		if mode == "add" then 
 			--if v:Nick() == ply:Nick() then 

 			--else 
		 		net.Start("graphicprediction")
		 		net.WriteVector(hitpos)
		 		net.WriteEntity(ply)
		 		net.WriteString(mode)
		 		net.Send(v)
		 end 
	 	--[[else 
	 		net.Start("graphicprediction")
	 		--net.WriteVector(hitpos)
	 		net.WriteString(mode)
	 		net.Send(v)
	 	end  
 	end 
end) ]]
