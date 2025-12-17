util.AddNetworkString("kenma_dump")

net.Receive ("kenma_dump" , function(bits , ply ) 
	local position = net.ReadString()
	local direction = net.ReadString() 
	local power = net.ReadString() 

	local ent =  ents.FindByClass( "prop_physics*" )

	for k, v in pairs( ent ) do   
		if ply:GetPos():DistToSqr( v:GetPos() ) < 120*120 then     
			ply:EmitSound("toss2.mp3", 70, 100, 1, CHAN_AUTO )

			--if(v:GetName() =='volleyball1' or v:GetName() == 'volleyball2' or v:GetName() == 'volleyball3') then 
			
				
				
				v:SetCollisionGroup( COLLISION_GROUP_NONE)

				timer.Create("collide",2,1,function() 
					v:SetCollisionGroup( COLLISION_GROUP_WORLD)
				end)

				if position == "left" then  
					if v:GetPos():WithinAABox( pos3, pos4 ) then
						ply:ChatPrint("Can't spike ball over other team area!") 
					else  
						if direction == "front" then 
							-- ply:EmitSound("toss2.mp3", 70, 100, 1, CHAN_AUTO )  
							if power == "soft" then 
								ply:ConCommand("pac_event dumpright") 
								v:SetPos(ply:GetPos() + Vector(0, 0, 115)) -- Adjust the Z coordinate as needed
								v:GetPhysicsObject():SetVelocity( Vector(-300,-300,-500))
							end
						else 
							if power == "soft" then 
								ply:ConCommand("pac_event dumpleft") 
								v:SetPos(ply:GetPos() + Vector(0, 0, 115)) -- Adjust the Z coordinate as needed
								v:GetPhysicsObject():SetVelocity( Vector(300,-300,-500))
							end
						end 
						--[[timer.Create("serveking",0.1,1,function()      
							v:GetPhysicsObject():SetVelocity(ply:GetAimVector() *1000 + Vector(0,0,arc))           
						end)]]         
					--ply:SetVelocity( ply:GetAimVector() * 1000 )   
					end 
				else  
					if v:GetPos():WithinAABox( pos1, pos2 ) then
						ply:ChatPrint("Can't spike ball over other team area!")

					else 
						if direction == "front" then 
					
							if power == "soft" then 
								ply:ConCommand("pac_event dumpright") 
								v:SetPos(ply:GetPos() + Vector(0, 0, 115)) -- Adjust the Z coordinate as needed
								v:GetPhysicsObject(): SetVelocity(Vector(300,300,-500))
								--v:GetPhysicsObject():SetVelocity(ply:GetForward()* 100  + Vector(0,300,-140))
							end 
						else 
							
							if power == "soft" then
								ply:ConCommand("pac_event dumpleft") 
								v:SetPos(ply:GetPos() + Vector(0, 0, 115)) -- Adjust the Z coordinate as needed
								v:GetPhysicsObject():SetVelocity( Vector(-300,300,-500))
								--v:GetPhysicsObject():SetVelocity(ply:GetForward() * -100  + Vector(0,300,-140))
						
							end 
						end 
					end 
				end 
			--end
		end
	end  
end) 