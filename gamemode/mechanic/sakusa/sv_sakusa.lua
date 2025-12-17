-- print("sv_sakusa")

-- function SakusaAttack() 
--     hook.Add("PlayerButtonDown","sakusa_attack",function(ply,button)
		

-- 		local keySettingR,keySettingT 

-- 		if allow_left_assist == false then
-- 			keySettingR = KEY_R
-- 			keySettingT = KEY_T
-- 		else 
-- 			keySettingR = KEY_LBRACKET
-- 			keySettingT = KEY_SEMICOLON
-- 		end


-- 		if  ply:GetPos():WithinAABox( miya_pos1, miya_pos2 ) or ply:GetPos():WithinAABox( miya_pos3, miya_pos4)  then 
-- 			if button == keySettingR then

-- 				net.Start("check_miya_position")
-- 				net.SendToServer() 
-- 				--chat.AddText(Color(255,0,0),"Miya Serve is active")

-- 				hook.Remove("PlayerButtonDown","miya_serve",function(ply,button) end) 
-- 				--hook.Remove( "Tick", "KeyDown_Toss", function() end )
-- 				hook.Remove( "Tick", "Kage_toss2", function() end)

-- 				hook.Add("PlayerButtonDown","miya_serve2",function(ply,button)
-- 					if button == keySettingR then
-- 						if  ply:GetPos():WithinAABox( miya_pos1, miya_pos2 ) or ply:GetPos():WithinAABox( miya_pos3, miya_pos4)  then 
							
-- 							net.Start("miya_ability")
-- 							net.WriteString("tossup")
-- 							net.SendToServer()

-- 						else 
-- 							hook.Remove("PlayerButtonDown","miya_serve2",function() end) 
-- 							MiyaServe()
-- 						end 
-- 					end 

-- 					if button == keySettingT then 
-- 						if  ply:GetPos():WithinAABox( miya_pos1, miya_pos2 ) or ply:GetPos():WithinAABox( miya_pos3, miya_pos4)  then 
-- 							if character == "miya" then 
-- 								net.Start("miya_ability")
-- 								net.WriteString("spike")
-- 								net.WriteString("miya")
-- 								net.SendToServer()
-- 							elseif character == "korai" then 
-- 								-- net.Start("miya_ability")
-- 								-- net.WriteString("spike")
-- 								-- net.WriteString("korai")
-- 								-- net.SendToServer()
-- 							end 

-- 							hook.Remove("PlayerButtonDown","miya_serve2",function() end) 
-- 							hook.Remove( "Tick", "KeyDown_Toss", function() end )
-- 							hook.Remove( "Tick", "Kage_toss2", function() end)

-- 							local ent =  ents.FindByClass( "prop_physics*" )
-- 							for k, v in pairs( ent ) do  
-- 								if ply:GetPos():DistToSqr( ent[k]:GetPos() ) < 170*170 then  
-- 									-- END FAKE BALL VELOCITY -------------------------
-- 									-- Function to check if the entity's physics object is on the ground
-- 									function IsEntityOnGround(entity)
-- 										-- Get the position of the entity
-- 										local posBall = entity:GetPos()
										
-- 										-- Trace a line downward to check for ground collision
-- 										local traceBall = util.TraceLine({
-- 											start = posBall,
-- 											endpos = posBall - Vector(0, 0, 25), -- Adjust the length based on your needs
-- 											mask = MASK_OPAQUE
-- 										})
										
-- 										-- Return true if the trace hits the ground, false otherwise
-- 										return traceBall.Hit
-- 									end

-- 										-- Function to check if the entity's physics object is on the ground and create a ground marker if so
-- 									function BallGroundCheck() 
-- 										-- Usage example
-- 										if IsEntityOnGround(ent[k]) then
-- 											hook.Remove("Think", "BallChecker") -- Remove the hook as it's no longer needed
-- 											net.Start("BallHitGround")
-- 											net.WriteVector(ent[k]:GetPos())
-- 											net.WriteEntity(ent[k])
-- 											net.SendToServer()
-- 											--CreateGroundMarker(ent[k]:GetPos()) -- Create a ground marker at the position of the entity
-- 										else
-- 											hook.Add("Think", "BallChecker", BallGroundCheck) -- Add the hook to keep checking
-- 										end
-- 									end 

-- 									-- Start checking if the ball is on the ground
-- 									BallGroundCheck()

-- 								end 
-- 							end 


-- 							MiyaServe()
-- 							timer.Create("re",1,1,function() 
-- 								chat.AddText("Set is now usable")
-- 								TossPower(10)
-- 								if character == "miya" then 
-- 									KageQuickToss(10)
-- 								end 
-- 								timer.Stop("re")
-- 							end) 
						
-- 						else 
-- 							--hook.Remove("PlayerButtonDown","miya_serve2",function() end)
-- 							--TossPower(10)
-- 							--KageQuickToss(10)
-- 							if character == "miya" then 
-- 								net.Start("miya_ability")
-- 								net.WriteString("spike")
-- 								net.WriteString("miya")
-- 								net.SendToServer()
-- 							elseif character == "korai" then 
-- 								-- net.Start("miya_ability")
-- 								-- net.WriteString("spike")
-- 								-- net.WriteString("korai")
-- 								-- net.SendToServer()
-- 							end 

-- 							hook.Remove("PlayerButtonDown","miya_serve2",function() end) 
-- 							hook.Remove( "Tick", "KeyDown_Toss", function() end )
-- 							hook.Remove( "Tick", "Kage_toss2", function() end)
							
-- 							local ent =  ents.FindByClass( "prop_physics*" )
-- 							for k, v in pairs( ent ) do  
-- 								if ply:GetPos():DistToSqr( ent[k]:GetPos() ) < 170*170 then  
-- 									-- END FAKE BALL VELOCITY -------------------------
-- 									-- Function to check if the entity's physics object is on the ground
-- 									function IsEntityOnGround(entity)
-- 										-- Get the position of the entity
-- 										local posBall = entity:GetPos()
										
-- 										-- Trace a line downward to check for ground collision
-- 										local traceBall = util.TraceLine({
-- 											start = posBall,
-- 											endpos = posBall - Vector(0, 0, 25), -- Adjust the length based on your needs
-- 											mask = MASK_OPAQUE
-- 										})
										
-- 										-- Return true if the trace hits the ground, false otherwise
-- 										return traceBall.Hit
-- 									end

-- 									-- Function to check if the entity's physics object is on the ground and create a ground marker if so
-- 									function BallGroundCheck() 
-- 										-- Usage example
-- 										if IsEntityOnGround(ent[k]) then
-- 											hook.Remove("Think", "BallChecker") -- Remove the hook as it's no longer needed
-- 											net.Start("BallHitGround")
-- 											net.WriteVector(ent[k]:GetPos())
-- 											net.WriteEntity(ent[k])
-- 											net.SendToServer()
-- 											--CreateGroundMarker(ent[k]:GetPos()) -- Create a ground marker at the position of the entity
-- 										else
-- 											hook.Add("Think", "BallChecker", BallGroundCheck) -- Add the hook to keep checking
-- 										end
-- 									end 

-- 									-- Start checking if the ball is on the ground
-- 									BallGroundCheck()

-- 								end 
-- 							end 


-- 							MiyaServe()


-- 							hook.Remove("PlayerButtonDown","miya_serve2",function() end)
-- 							MiyaServe()
-- 							TossPower(10)
-- 							if character == "miya" then 
-- 								KageQuickToss(10)
-- 							end 						
-- 						end 
-- 					end 
-- 				end) 
-- 			end 
-- 		end 
-- 	end)
-- end 

util.AddNetworkString("spike_power_sakusa")
net.Receive ("spike_power_sakusa" , function(bits , ply )
	local position = net.ReadString()
	local power = net.ReadString()
	local spikepower = net.ReadInt(32)
	local character = net.ReadString() 
	local entityBall = net.ReadEntity()
	local entityPosVect = net.ReadVector() 
    local direction = net.ReadString() 
	local allow_spike_assist = net.ReadBool()
	    
	local ent =  ents.FindByClass( "prop_physics*" )

	
	ply:ConCommand("pac_event spike")   
	
	ply:SetCollisionGroup( COLLISION_GROUP_WORLD)

	SpikeSakusaPosition(entityBall,ply,position,spikepower,0,entityPosVect,direction,allow_spike_assist)
	
	
end)

function SpikeSakusaPosition(v,ply,position,power,arc,entityPosVect,direction,allow_spike_assist)  
	
	local rightVector = ply:GetRight()

	v:SetCollisionGroup( COLLISION_GROUP_PASSABLE_DOOR) 
	local desiredZ = ply:GetPos().z - 10
	
	if position == "left" then 

		if v:GetPos():WithinAABox( pos3, pos4 ) then
			ply:ChatPrint("Can't spike ball over other team area!") 
		else 
			ball_status = "spike" 
			if power == 400 then 

			else 

			end 
 
			if isSpiked == false then 
				isSpiked = true 
				timer.Simple(1,function() isSpiked=false end)

			    v:GetPhysicsObject():SetVelocity(ply:GetAimVector() * 1000 + Vector(0,0,50))
                v:SetPos(entityPosVect) -- Adjust the Z coordinate as needed
                v:GetPhysicsObject():SetMaterial("gmod_bouncy") -- Set the material to a bouncy material

                if direction == "left" then 
                    v:GetPhysicsObject():SetAngles(Angle(0, 0, 0))
                    v:GetPhysicsObject():AddAngleVelocity(Vector(5000,0,5000)) 
                    timer.Simple(0.15,function() 
						local leftwardForce = rightVector * -6000  -- Force applied to the left

						v:GetPhysicsObject():ApplyForceCenter(leftwardForce)
                        
                        timer.Simple(0.15,function() 
							local leftwardForce = rightVector * -6000  -- Force applied to the left
                           	local downwardForce2 = Vector(0, 0, -50)  -- Adjust the force as needed
                            v:GetPhysicsObject():ApplyForceCenter(leftwardForce + downwardForce2)
                        end) 
                    end)
                else 
					v:GetPhysicsObject():SetAngles(Angle(0, 0, 0))
                    v:GetPhysicsObject():AddAngleVelocity(Vector(5000,0,5000)) 
                    timer.Simple(0.15,function() 
						local leftwardForce = rightVector * 6000  -- Force applied to the left

						v:GetPhysicsObject():ApplyForceCenter(leftwardForce)
                        
                        timer.Simple(0.15,function() 
							local leftwardForce = rightVector * 6000  -- Force applied to the left
                           	local downwardForce2 = Vector(0, 0, -50)  -- Adjust the force as needed
                            v:GetPhysicsObject():ApplyForceCenter(leftwardForce + downwardForce2)
                        end) 
                    end)
                end 

				if power > 2500 then //ushijima
					ply:EmitSound("ushi/ushijimaspike2.wav", 70, 100, 1, CHAN_AUTO ) 
						SafeRemoveEntity( trail )	
						trail = util.SpriteTrail( v, 0, Color( 217, 72, 214,300 ), false, 15, 1, 0.3, 1 / ( 15 + 1 ) * 0.5, "trails/physbeam" )
					print( trail )
				elseif power == 1150 then //hinata
					local hinataSound = table.Random(randomSoundHinata)
					ply:EmitSound(hinataSound, 70, 100, 1, CHAN_AUTO ) 
					SafeRemoveEntity( trail )	
					trail = util.SpriteTrail( v, 0, Color( 255, 132, 0,300 ), false, 15, 1, 0.3, 1 / ( 15 + 1 ) * 0.5, "trails/physbeam" )
				elseif power == 1800 then //bokuto
					local bokutoSound = table.Random(randomSoundBokuto)
					ply:EmitSound(bokutoSound, 70, 100, 1, CHAN_AUTO ) 
					SafeRemoveEntity( trail )	
					trail = util.SpriteTrail( v, 0, Color(161, 161, 161,300 ), false, 15, 1, 0.3, 1 / ( 15 + 1 ) * 0.5, "trails/physbeam" )
				elseif power == 1300 then //korai
					local koraiSound = table.Random(randomSoundKorai)
					ply:EmitSound(koraiSound, 70, 100, 1, CHAN_AUTO ) 
					SafeRemoveEntity( trail )	
					trail = util.SpriteTrail( v, 0, Color(161, 161, 161,300 ), false, 15, 1, 0.3, 1 / ( 15 + 1 ) * 0.5, "trails/physbeam" )
				elseif power == 1200 then //kuro 
					-- local koraiSound = table.Random(randomSoundKorai)
					-- ply:EmitSound(koraiSound, 70, 100, 1, CHAN_AUTO ) 
					SafeRemoveEntity( trail )	
					trail = util.SpriteTrail( v, 0, Color(255, 65, 65), false, 15, 1, 0.3, 1 / ( 15 + 1 ) * 0.5, "trails/physbeam" )
				end
			end
		end 
	else  
		if v:GetPos():WithinAABox( pos1, pos2 ) then
			ply:ChatPrint("Can't spike ball over other team area!")

		else 
			ball_status = "spike" 
			if power == 400 then 

			else 
				--ply:EmitSound("spike.mp3", 70, 100, 1, CHAN_AUTO ) 
			end
			if isSpiked == false then 
				isSpiked = true 
				timer.Simple(1,function() isSpiked=false end)
				if ply:Ping() > 0 and allow_spike_assist == true then 
					ply:SetCollisionGroup( COLLISION_GROUP_WORLD)
					v:SetPos(entityPosVect) -- Adjust the Z coordinate as needed
					--PrintMessage(HUD_PRINTTALK, ply:Nick().." is having high ping, high spike assist activated for this player.")
				else
					--v:SetPos(ply:GetPos() + Vector(0, 0, 90)) -- Adjust the Z coordinate as needed
					--PrintMessage(HUD_PRINTTALK, ply:Nick().." is having high ping, spike assist activated for this player.")
				end 
				-- Calculate the forward vector of the player's view

				print("right")

				local aimVector = ply:GetAimVector()

				-- Determine the power of the hit (you might need to adjust this value)

                v:GetPhysicsObject():SetVelocity(ply:GetAimVector() * 1000 + Vector(0,0,50))
                v:SetPos(entityPosVect) -- Adjust the Z coordinate as needed
                v:GetPhysicsObject():SetMaterial("gmod_bouncy") -- Set the material to a bouncy material

                if direction == "right" then 
                    v:GetPhysicsObject():SetAngles(Angle(0, 0, 0))
                    v:GetPhysicsObject():AddAngleVelocity(Vector(5000,0,5000)) 
                    timer.Simple(0.15,function() 
						local leftwardForce = rightVector * 6000  -- Force applied to the left

						v:GetPhysicsObject():ApplyForceCenter(leftwardForce)
                        
                        timer.Simple(0.15,function() 
							local leftwardForce = rightVector * 6000  -- Force applied to the left
                           	local downwardForce2 = Vector(0, 0, -50)  -- Adjust the force as needed
                            v:GetPhysicsObject():ApplyForceCenter(leftwardForce + downwardForce2)
                        end) 
                    end)
                else 
					v:GetPhysicsObject():SetAngles(Angle(0, 0, 0))
                    v:GetPhysicsObject():AddAngleVelocity(Vector(5000,0,5000)) 
                    timer.Simple(0.15,function() 
						local leftwardForce = rightVector * -6000  -- Force applied to the left

						v:GetPhysicsObject():ApplyForceCenter(leftwardForce)
                        
                        timer.Simple(0.15,function() 
							local leftwardForce = rightVector * -6000  -- Force applied to the left
                           	local downwardForce2 = Vector(0, 0, -50)  -- Adjust the force as needed
                            v:GetPhysicsObject():ApplyForceCenter(leftwardForce + downwardForce2)
                        end) 
                    end)
                end 

				if power > 2500 then //ushijima
					ply:EmitSound("ushi/ushijimaspike2.wav", 70, 100, 1, CHAN_AUTO ) 
						SafeRemoveEntity( trail )	
						trail = util.SpriteTrail( v, 0, Color( 217, 72, 214,300 ), false, 15, 1, 0.3, 1 / ( 15 + 1 ) * 0.5, "trails/physbeam" )
					print( trail )
				elseif power == 1150 then //hinata
					local hinataSound = table.Random(randomSoundHinata)
					ply:EmitSound(hinataSound, 70, 100, 1, CHAN_AUTO ) 
					SafeRemoveEntity( trail )	
					trail = util.SpriteTrail( v, 0, Color( 255, 132, 0,300 ), false, 15, 1, 0.3, 1 / ( 15 + 1 ) * 0.5, "trails/physbeam" )
				elseif power == 1800 then //bokuto
					local bokutoSound = table.Random(randomSoundBokuto)
					ply:EmitSound(bokutoSound, 70, 100, 1, CHAN_AUTO ) 
					SafeRemoveEntity( trail )	
					trail = util.SpriteTrail( v, 0, Color(161, 161, 161,300 ), false, 15, 1, 0.3, 1 / ( 15 + 1 ) * 0.5, "trails/physbeam" )
				elseif power == 1300 then //korai
					local koraiSound = table.Random(randomSoundKorai)
					ply:EmitSound(koraiSound, 70, 100, 1, CHAN_AUTO ) 
					SafeRemoveEntity( trail )	
					trail = util.SpriteTrail( v, 0, Color(161, 161, 161,300 ), false, 15, 1, 0.3, 1 / ( 15 + 1 ) * 0.5, "trails/physbeam" )
				elseif power == 1200 then //kuro 
					-- local koraiSound = table.Random(randomSoundKorai)
					-- ply:EmitSound(koraiSound, 70, 100, 1, CHAN_AUTO ) 
					SafeRemoveEntity( trail )	
					trail = util.SpriteTrail( v, 0, Color(255, 65, 65), false, 15, 1, 0.3, 1 / ( 15 + 1 ) * 0.5, "trails/physbeam" )
				end
			end
		end 
	end  
end  