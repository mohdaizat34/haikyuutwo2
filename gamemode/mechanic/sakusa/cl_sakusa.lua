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
	local release_ball_spike = false 

	hook.Add( "Tick", "KeyDown_Sakusa_Spike", function()
		if !ply:IsOnGround()  then
			if release_ball_spike == false then 
				if (input.IsButtonDown(KEY_R)) then
					release_ball_spike = false
					//action_status = "SPIKING"
					-- detect ball when hold button
					local ent =  ents.FindByClass( "prop_physics*" )
					for k, v in pairs( ent ) do    
						physObj = ent[k]:GetPhysicsObject()

						
						if LocalPlayer():GetPos():DistToSqr( ent[k]:GetPos() ) < 115*115 then
							ply:ConCommand("pac_event spike") 
							surface.PlaySound("spike.mp3")
							
                            release_ball_spike = true
                            SpikeSakusaSendToServer("strong",spikepower,ent[k],ent[k]:GetPos(),"left",allow_spike_assist) 

                            -- Function to check if the entity's physics object is on the ground
                            function IsEntityOnGround(entity)
                                -- Get the position of the entity
                                local posBall = entity:GetPos()
                                
                                -- Trace a line downward to check for ground collision
                                local traceBall = util.TraceLine({
                                    start = posBall,
                                    endpos = posBall - Vector(0, 0, 23), -- Adjust the length based on your needs
                                    mask = MASK_OPAQUE
                                })
                                
                                -- Return true if the trace hits the ground, false otherwise
                                return traceBall.Hit
                            end



                            -- Function to check if the entity's physics object is on the ground and create a ground marker if so
                            function BallGroundCheck() 
                                -- Usage example
                                if IsEntityOnGround(ent[k]) then
                                    hook.Remove("Think", "BallChecker") -- Remove the hook as it's no longer needed
                                    net.Start("BallHitGround")
                                    net.WriteVector(ent[k]:GetPos())
                                    net.WriteEntity(ent[k])
                                    net.SendToServer()
                                    --CreateGroundMarker(ent[k]:GetPos()) -- Create a ground marker at the position of the entity
                                else
                                    hook.Add("Think", "BallChecker", BallGroundCheck) -- Add the hook to keep checking
                                end
                            end 

                            -- Start checking if the ball is on the ground
                            BallGroundCheck()
							
							timer.Simple(1,function() release_ball_spike = false end)
						end	
					end	
				elseif (input.IsButtonDown(KEY_T)) then 
					//action_status = ""
                    release_ball_spike = false
					//action_status = "SPIKING"
					-- detect ball when hold button
					local ent =  ents.FindByClass( "prop_physics*" )
					for k, v in pairs( ent ) do    
						physObj = ent[k]:GetPhysicsObject()

						
						if LocalPlayer():GetPos():DistToSqr( ent[k]:GetPos() ) < 115*115 then
							ply:ConCommand("pac_event spike") 
							surface.PlaySound("spike.mp3")
                            release_ball_spike = true
                            SpikeSakusaSendToServer("strong",spikepower,ent[k],ent[k]:GetPos(),"right",allow_spike_assist) 

                            -- Function to check if the entity's physics object is on the ground
                            function IsEntityOnGround(entity)
                                -- Get the position of the entity
                                local posBall = entity:GetPos()
                                
                                -- Trace a line downward to check for ground collision
                                local traceBall = util.TraceLine({
                                    start = posBall,
                                    endpos = posBall - Vector(0, 0, 23), -- Adjust the length based on your needs
                                    mask = MASK_OPAQUE
                                })
                                
                                -- Return true if the trace hits the ground, false otherwise
                                return traceBall.Hit
                            end



                            -- Function to check if the entity's physics object is on the ground and create a ground marker if so
                            function BallGroundCheck() 
                                -- Usage example
                                if IsEntityOnGround(ent[k]) then
                                    hook.Remove("Think", "BallChecker") -- Remove the hook as it's no longer needed
                                    net.Start("BallHitGround")
                                    net.WriteVector(ent[k]:GetPos())
                                    net.WriteEntity(ent[k])
                                    net.SendToServer()
                                    --CreateGroundMarker(ent[k]:GetPos()) -- Create a ground marker at the position of the entity
                                else
                                    hook.Add("Think", "BallChecker", BallGroundCheck) -- Add the hook to keep checking
                                end
                            end 

                            -- Start checking if the ball is on the ground
                            BallGroundCheck()
						
							timer.Simple(1,function() release_ball_spike = false end)
						end	
					end	
				end 
			end 
		end
	end) 
end 


function SpikeSakusaSendToServer(powertype,spikepower,entity,entityPos,direction,allow_spike_assist)  
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