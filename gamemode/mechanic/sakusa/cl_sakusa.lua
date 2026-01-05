print("cl_sakusa")

function SakusaAttack(spikepower)
    ply = LocalPlayer()
	powerbar = 0
	power = 0
	jumpcount = 0
	buttonpress = 0
	local ent =  ents.FindByClass( "prop_physics*" )

	--spikepower = 0
	--jumpcount = 0
	buttonpressrec = 0
	local ply = LocalPlayer()
	local sakusaClientCooldown = 0

	hook.Add( "Tick", "KeyDown_Sakusa_Spike", function()
		if !ply:IsOnGround() and CurTime() >= sakusaClientCooldown then
			if (input.IsButtonDown(KEY_R)) then
				//action_status = "SPIKING"
				-- detect ball when hold button
				local ent =  ents.FindByClass( "prop_physics*" )
				for k, v in pairs( ent ) do
					physObj = ent[k]:GetPhysicsObject()


					local ballPos = ent[k]:GetPos()
                    local NET_Y = 318.4  -- Match server-side court boundary
                    local GAP_SIZE = 5  -- Size of the unspikeable gap between nets
                    local playerTeam = LocalPlayer():Team()

                    -- Check if ball is in the gap between nets
                    local isBallInGap = ballPos.y >= NET_Y - GAP_SIZE and ballPos.y <= NET_Y + GAP_SIZE

                    -- Strict court boundary check - prevent spiking balls on opponent's side or in gap
                    local isBallOnMySide =
                        (playerTeam == 2 and ballPos.y < NET_Y - GAP_SIZE) or
                        (playerTeam == 1 and ballPos.y > NET_Y + GAP_SIZE)

                    if LocalPlayer():GetPos():DistToSqr(ballPos) < 115*115 and isBallOnMySide then
						ply:ConCommand("pac_event spike")
						surface.PlaySound("spike.mp3")

                        sakusaClientCooldown = CurTime() + 1
                        SpikeSakusaSendToServer("strong",spikepower,ent[k],ent[k]:GetPos(),"left",allow_spike_assist)

                        -- Function to check if the entity's physics object is on the ground
                        function IsEntityOnGround(entity)
                            -- Get the position of the entity
                            local posBall = entity:GetPos()

                            -- Trace a line downward to check for ground collision
                            local traceBall = util.TraceLine({
                                start = posBall,
                                endpos = posBall - Vector(0, 0, 15), -- Slightly reduced from 20 to 15 units
                                mask = MASK_OPAQUE
                            })

                            -- Return true if the trace hits the ground, false otherwise
                            return traceBall.Hit
                        end

                        -- Function to check if the entity's physics object is on the ground and create a ground marker if so
                        function BallGroundCheck()
                            -- Usage example
                            if IsEntityOnGround(ent[k]) then
                                -- Capture the position where the ball hit the ground
                                local hitGroundPos = ent[k]:GetPos()

                                -- Set scoring pending for delayed sending (like server-side)
                                scoringPending = true

                                -- Start immediate countdown UI when ball hits ground
                                countdownActive = true
                                countdownStartTime = CurTime()
                                countdownDuration = 0.7
                                print("BALL HIT GROUND - SHOWING MESSAGE")

                                -- Activate debug UI
                                debugDelayActive = true
                                debugDelayTime = CurTime() + 0.7
                                debugDelayCancelled = false

                                -- Delay sending by 0.7 seconds to match server-side scoring delay
                                timer.Simple(0.7, function()
                                    debugDelayActive = false -- Deactivate active countdown
                                    debugDelayCompleted = true -- Show result
                                    debugDelayResultTime = CurTime() + 3 -- Show result for 3 seconds
                                    countdownActive = false -- Hide countdown when sending

                                    if scoringPending then
                                        hook.Remove("Think", "BallChecker") -- Remove the hook as it's no longer needed
                                        -- Send the position from when the ball hit the ground
                                        net.Start("BallHitGround")
                                        net.WriteVector(hitGroundPos)
                                        net.WriteEntity(ent[k])
                                        net.SendToServer()
                                        CreateGroundMarker(hitGroundPos) -- Create a ground marker at the hit position
                                    end
                                end)
                            else
                                hook.Add("Think", "BallChecker", BallGroundCheck) -- Add the hook to keep checking
                            end
                        end

                        -- Start checking if the ball is on the ground
                        BallGroundCheck()
                    elseif LocalPlayer():GetPos():DistToSqr(ballPos) < 115*115 and isBallInGap then
                        -- Ball is in the gap between nets - show warning and prevent spike
                        ply:ChatPrint("Can't spike ball in the gap between nets!")
                    end
				end
			elseif (input.IsButtonDown(KEY_T)) then
				//action_status = ""
				-- detect ball when hold button
				local ent =  ents.FindByClass( "prop_physics*" )
				for k, v in pairs( ent ) do
					physObj = ent[k]:GetPhysicsObject()


					local ballPos = ent[k]:GetPos()
                    local NET_Y = 318.4  -- Match server-side court boundary
                    local GAP_SIZE = 5  -- Size of the unspikeable gap between nets
                    local playerTeam = LocalPlayer():Team()

                    -- Check if ball is in the gap between nets
                    local isBallInGap = ballPos.y >= NET_Y - GAP_SIZE and ballPos.y <= NET_Y + GAP_SIZE

                    -- Strict court boundary check - prevent spiking balls on opponent's side or in gap
                    local isBallOnMySide =
                        (playerTeam == 2 and ballPos.y < NET_Y - GAP_SIZE) or
                        (playerTeam == 1 and ballPos.y > NET_Y + GAP_SIZE)

                    if LocalPlayer():GetPos():DistToSqr(ballPos) < 115*115 and isBallOnMySide then
						ply:ConCommand("pac_event spike")
						surface.PlaySound("spike.mp3")
                        sakusaClientCooldown = CurTime() + 1
                        SpikeSakusaSendToServer("strong",spikepower,ent[k],ent[k]:GetPos(),"right",allow_spike_assist)

                        -- Function to check if the entity's physics object is on the ground
                        function IsEntityOnGround(entity)
                            -- Get the position of the entity
                            local posBall = entity:GetPos()

                            -- Trace a line downward to check for ground collision
                            local traceBall = util.TraceLine({
                                start = posBall,
                                endpos = posBall - Vector(0, 0, 15), -- Slightly reduced from 20 to 15 units
                                mask = MASK_OPAQUE
                            })

                            -- Return true if the trace hits the ground, false otherwise
                            return traceBall.Hit
                        end

                        -- Function to check if the entity's physics object is on the ground and create a ground marker if so
                        function BallGroundCheck()
                            -- Usage example
                            if IsEntityOnGround(ent[k]) then
                                -- Capture the position where the ball hit the ground
                                local hitGroundPos = ent[k]:GetPos()

                                -- Set scoring pending for delayed sending (like server-side)
                                scoringPending = true

                                -- Start immediate countdown UI when ball hits ground
                                countdownActive = true
                                countdownStartTime = CurTime()
                                countdownDuration = 0.7
                                print("BALL HIT GROUND - SHOWING MESSAGE")

                                -- Activate debug UI
                                debugDelayActive = true
                                debugDelayTime = CurTime() + 0.7
                                debugDelayCancelled = false

                                -- Delay sending by 0.7 seconds to match server-side scoring delay
                                timer.Simple(0.7, function()
                                    debugDelayActive = false -- Deactivate active countdown
                                    debugDelayCompleted = true -- Show result
                                    debugDelayResultTime = CurTime() + 3 -- Show result for 3 seconds
                                    countdownActive = false -- Hide countdown when sending

                                    if scoringPending then
                                        hook.Remove("Think", "BallChecker") -- Remove the hook as it's no longer needed
                                        -- Send the position from when the ball hit the ground
                                        net.Start("BallHitGround")
                                        net.WriteVector(hitGroundPos)
                                        net.WriteEntity(ent[k])
                                        net.SendToServer()
                                        CreateGroundMarker(hitGroundPos) -- Create a ground marker at the hit position
                                    end
                                end)
                            else
                                hook.Add("Think", "BallChecker", BallGroundCheck) -- Add the hook to keep checking
                            end
                        end

                        -- Start checking if the ball is on the ground
                        BallGroundCheck()
                    elseif LocalPlayer():GetPos():DistToSqr(ballPos) < 115*115 and isBallInGap then
                        -- Ball is in the gap between nets - show warning and prevent spike
                        ply:ChatPrint("Can't spike ball in the gap between nets!")
                    end
				end
			end
		end
	end)
end


function SpikeSakusaSendToServer(powertype,spikepower,entity,entityPos,direction,allow_spike_assist)
    local sakusaSpikeCooldown = sakusaSpikeCooldown or 0
    if CurTime() < sakusaSpikeCooldown then return end
    -- Set local client-side cooldown to prevent rapid successive spikes
    sakusaSpikeCooldown = CurTime() + 1

	if ply:GetPos():WithinAABox( pos1, pos2 ) then
		position = "left"
	else
		position = "right"
	end
	net.Start("spike_power_sakusa")
	net.WriteString(position)
	net.WriteString(powertype)
	net.WriteInt(spikepower,32)
	net.WriteString(character)
	net.WriteEntity(entity)
	net.WriteVector(entityPos)
    net.WriteString(direction)
	net.WriteBool(allow_spike_assist)
	net.SendToServer()
end
