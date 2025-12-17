--ability 
util.AddNetworkString("kage_toss_ability")
util.AddNetworkString("check_miya_position")
util.AddNetworkString("miya_ability")
util.AddNetworkString("yama_ability")
util.AddNetworkString("revertspeed") 
util.AddNetworkString("bokuto_cut") 
--basic  
util.AddNetworkString("basic_serve")
util.AddNetworkString("spike_power_hinata")
util.AddNetworkString("fake_spike")
util.AddNetworkString("receive_power") 
util.AddNetworkString("block_power")
util.AddNetworkString("toss_power") 
util.AddNetworkString("dive_power") 
util.AddNetworkString("ref")

function SpikePosition(v,ply,position,power,arc)  
	if position == "left" then  
		if v:GetPos():WithinAABox( pos3, pos4 ) then
			ply:ChatPrint("Can't spike ball over other team area!") 
		else  
			ply:EmitSound("spike.mp3", 70, 100, 1, CHAN_AUTO ) 
			v:GetPhysicsObject():SetVelocity(ply:GetAimVector() * power)
			if power > 2799 then 
					ply:EmitSound("ushi/ushijimaspike2.wav", 70, 100, 1, CHAN_AUTO ) 
			elseif power == 1100 then 
				ply:EmitSound("hina/hinataspike2.mp3", 70, 100, 1, CHAN_AUTO ) 
			elseif power == 2200 then 
				ply:EmitSound("boku/spike2.mp3", 70, 100, 1, CHAN_AUTO ) 
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
			ply:EmitSound("spike.mp3", 70, 100, 1, CHAN_AUTO ) 
			v:GetPhysicsObject():SetVelocity(ply:GetAimVector() * power)
			if power > 2799 then 
					ply:EmitSound("ushi/ushijimaspike2.wav", 70, 100, 1, CHAN_AUTO ) 
			elseif power == 1100 then 
				ply:EmitSound("hina/hinataspike2.mp3", 70, 100, 1, CHAN_AUTO )  
			elseif power == 2200 then 
				ply:EmitSound("boku/spike2.mp3", 70, 100, 1, CHAN_AUTO ) 
			end    
			--[[timer.Create("serveking",0.1,1,function()      
				v:GetPhysicsObject():SetVelocity(ply:GetAimVector() *1000 + Vector(0,0,arc))           
			end)  ]]         
--ply:SetVelocity( ply:GetAimVector() * 1000 )  
		end 
	end  
end  

 
 function BlockPosition(v,ply,position,power,arc) 

	if position == "left" then 
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
	--ply:SetVelocity( ply:GetAimVector() * 1000 )  
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


function ReceivePosition(v,ply,position,power,arc,divetype) 

	if position == "left" then 
		if v:GetPos():WithinAABox( pos3, pos4 ) then
			ply:ChatPrint("Can't receive ball over other team area!")
		else  
			v:GetPhysicsObject():SetVelocity(ply:GetForward() * power + Vector(0,0,arc))    -- standard 470 arc   110 power  
			ply:EmitSound("receive.mp3", 70, 100, 1, CHAN_AUTO ) 
			ply:ConCommand("pac_event receive")
	--ply:SetVelocity( ply:GetAimVector() * 1000 )  
		end 
	else
		if v:GetPos():WithinAABox( pos1, pos2 ) then
			ply:ChatPrint("Can't receive ball over other team area!")
		else 
			v:GetPhysicsObject():SetVelocity(ply:GetForward() * power + Vector(0,0,arc))      
			ply:EmitSound("receive.mp3", 70, 100, 1, CHAN_AUTO ) 
			ply:ConCommand("pac_event receive")
	--ply:SetVelocity( ply:GetAimVector() * 1000 )  
		end 
	end
end 


function TossPosition(v,ply,position,power,arc,frontback) 
	if frontback == "front" then 
		ply:ConCommand("pac_event jumptoss")
		ply:ConCommand("pac_event toss")
		if position == "left" then 
			if v:GetPos():WithinAABox( pos3, pos4 ) then
				ply:ChatPrint("Can't set ball over other team area!")
			else  
				v:GetPhysicsObject():SetVelocity(ply:GetAimVector() *power + Vector(0,0,arc)) 
				--[[timer.Create("serveking",0.1,1,function()      
					v:GetPhysicsObject():SetVelocity(ply:GetForward() *1000 + Vector(0,0,arc))           
				end)]]
				ply:EmitSound("toss2.mp3", 70, 100, 1, CHAN_AUTO )
				ply:ConCommand("pac_event jumpset")
				ply:ConCommand("pac_event set")
		--ply:SetVelocity( ply:GetAimVector() * 1000 )  
			end 
		else
			if v:GetPos():WithinAABox( pos1, pos2 ) then
				ply:ChatPrint("Can't set ball over other team area!")
			else 
				v:GetPhysicsObject():SetVelocity(ply:GetAimVector() *power + Vector(0,0,arc))    
				--[[timer.Create("serveking",0.1,1,function()      
					v:GetPhysicsObject():SetVelocity(ply:GetForward() * 400 + Vector(0,0,arc))           
				end)   ]]  
				ply:EmitSound("toss2.mp3", 70, 100, 1, CHAN_AUTO )
				ply:ConCommand("pac_event jumpset")
				ply:ConCommand("pac_event set")

		--ply:SetVelocity( ply:GetAimVector() * 1000 )  
			end 
		end
	else 
		if position == "left" then 
			if v:GetPos():WithinAABox( pos3, pos4 ) then
				ply:ChatPrint("Can't set ball over other team area!")
			else  
				v:GetPhysicsObject():SetVelocity(ply:GetForward() *power + Vector(0,0,arc)) 
				--[[timer.Create("serveking",0.1,1,function()      
					v:GetPhysicsObject():SetVelocity(ply:GetForward() *1000 + Vector(0,0,arc))           
				end)]]
				ply:EmitSound("toss2.mp3", 70, 100, 1, CHAN_AUTO )
				ply:ConCommand("pac_event jumpbackset")
				ply:ConCommand("pac_event backset")
		--ply:SetVelocity( ply:GetAimVector() * 1000 )  
			end 
		else
			if v:GetPos():WithinAABox( pos1, pos2 ) then
				ply:ChatPrint("Can't set ball over other team area!")

			else 
				v:GetPhysicsObject():SetVelocity(ply:GetForward() *power + Vector(0,0,arc))    
				--[[timer.Create("serveking",0.1,1,function()      
					v:GetPhysicsObject():SetVelocity(ply:GetForward() * 400 + Vector(0,0,arc))           
				end)   ]]  
				ply:EmitSound("toss2.mp3", 70, 100, 1, CHAN_AUTO )
				ply:ConCommand("pac_event jumpbackset")
				ply:ConCommand("pac_event backset")
		--ply:SetVelocity( ply:GetAimVector() * 1000 )  
			end 
		end
	end 
end 
---------------------------------------------------------------------
 
-- CHAR ABILITIES 
-- Kageyama
function KageTossPosition(v,ply,position,power,arc,frontback,timestop,tosstype)  
	--ply:ConCommand("pac_event toss") 
	--ply:ConCommand("pac_event jumptoss") 
	if tosstype == "king" then 
		if frontback == "front" then 
			if position == "left" then 
				if v:GetPos():WithinAABox( pos3, pos4 ) then
					ply:ChatPrint("Can't set ball over other team area!")
				else  
					v:GetPhysicsObject():SetVelocity(ply:GetAimVector() *power + Vector(0,0,arc)) 
					timer.Create("serveking",timestop,1,function()      
						v:GetPhysicsObject():SetVelocity(ply:GetForward() *50 + Vector(0,0,arc))           
					end)
					ply:EmitSound("toss2.mp3", 70, 100, 1, CHAN_AUTO )
			--ply:SetVelocity( ply:GetAimVector() * 1000 )  
				end 
			else
				if v:GetPos():WithinAABox( pos1, pos2 ) then
					ply:ChatPrint("Can't set ball over other team area!")
				else  
					v:GetPhysicsObject():SetVelocity(ply:GetAimVector() *power + Vector(0,0,arc)) 
					timer.Create("serveking",timestop,1,function()      
						v:GetPhysicsObject():SetVelocity(ply:GetForward() *100 + Vector(0,0,arc))           
					end)
					ply:EmitSound("toss2.mp3", 70, 100, 1, CHAN_AUTO )
			--ply:SetVelocity( ply:GetAimVector() * 1000 )  
				end 
			end
		else 
			if position == "right" then 
				if v:GetPos():WithinAABox( pos1, pos2 ) then 
					ply:ChatPrint("Can't set ball over other team area!")
				else  
					v:GetPhysicsObject():SetVelocity(ply:GetAimVector() *power + Vector(0,0,arc)) 
					timer.Create("serveking",timestop,1,function()      
						v:GetPhysicsObject():SetVelocity(ply:GetForward() *100 + Vector(0,0,arc))           
					end)
					ply:EmitSound("toss2.mp3", 70, 100, 1, CHAN_AUTO )
			--ply:SetVelocity( ply:GetAimVector() * 1000 )  
				end 
			else
				if v:GetPos():WithinAABox( pos1, pos2 ) then
					ply:ChatPrint("Can't set ball over other team area!")
				else  
					v:GetPhysicsObject():SetVelocity(ply:GetAimVector() *power + Vector(0,0,arc)) 
					timer.Create("serveking",timestop,1,function()      
						v:GetPhysicsObject():SetVelocity(ply:GetForward() *100 + Vector(0,0,arc))           
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
					v:GetPhysicsObject():SetVelocity(ply:GetAimVector() *power + Vector(0,0,arc)) 
					ply:EmitSound("toss2.mp3", 70, 100, 1, CHAN_AUTO )
			--ply:SetVelocity( ply:GetAimVector() * 1000 )  
				end 
			else
				if v:GetPos():WithinAABox( pos1, pos2 ) then
					ply:ChatPrint("Can't set ball over other team area!")
				else  
					v:GetPhysicsObject():SetVelocity(ply:GetAimVector() *power + Vector(0,0,arc)) 
					
					ply:EmitSound("toss2.mp3", 70, 100, 1, CHAN_AUTO )
			--ply:SetVelocity( ply:GetAimVector() * 1000 )  
				end 
			end
		else 
			if position == "right" then 
				if v:GetPos():WithinAABox( pos1, pos2 ) then 
					ply:ChatPrint("Can't set ball over other team area!")
				else  
					v:GetPhysicsObject():SetVelocity(ply:GetAimVector() *power + Vector(0,0,arc)) 
					
					ply:EmitSound("toss2.mp3", 70, 100, 1, CHAN_AUTO )
			--ply:SetVelocity( ply:GetAimVector() * 1000 )  
				end 
			else
				if v:GetPos():WithinAABox( pos1, pos2 ) then
					ply:ChatPrint("Can't set ball over other team area!")
				else  
					v:GetPhysicsObject():SetVelocity(ply:GetAimVector() *power + Vector(0,0,arc)) 
					
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


	 local ent =  ents.FindByClass( "prop_physics*" )

	for k, v in pairs( ent ) do    
		ply:ConCommand("pac_event jumpset")
		if tosstype == "king" then 
			if frontback == "front" then 
				if ply:GetPos():DistToSqr( v:GetPos() ) < 120*120 then     
					ply:SetLagCompensated(true)
					ply:LagCompensation( true ) 
					--v:SetVelocity(v:GetForward() * 500 + Vector(0,0,1000)) 
					if(v:GetName() =='volleyball1' or v:GetName() == 'volleyball2' or v:GetName() == 'volleyball3') then   
						--v:GetPhysicsObject():SetVelocity(ply:GetAimVector()* 800) 
						if power == "weak" then 
							KageTossPosition(v,ply,position,350,0,frontback,0.3,tosstype)
						elseif power == "medium" then 
							KageTossPosition(v,ply,position,480,0,frontback,0.4,tosstype)
						else 
							KageTossPosition(v,ply,position,540,0,frontback,0.6,tosstype)
						end 
					end
					ply:LagCompensation( true )  
				end  
			else 
				if ply:GetPos():DistToSqr( v:GetPos() ) < 120*120 then     
					ply:SetLagCompensated(true)
					ply:LagCompensation( true ) 
					--v:SetVelocity(v:GetForward() * 500 + Vector(0,0,1000)) 
					if(v:GetName() =='volleyball1' or v:GetName() == 'volleyball2' or v:GetName() == 'volleyball3') then   
						--v:GetPhysicsObject():SetVelocity(ply:GetAimVector()* 800) 
						if power == "weak" then 
							KageTossPosition(v,ply,position,-110,0,frontback,tosstype)
						elseif power == "medium" then 
							KageTossPosition(v,ply,position,-110,0,frontback,tosstype) 
						else 
							KageTossPosition(v,ply,position,-220,0,frontback,tosstype)
						end 
					end
					ply:LagCompensation( true )  
				end  
			end  
		else 
			if frontback == "front" then 
				if ply:GetPos():DistToSqr( v:GetPos() ) < 120*120 then     
					ply:SetLagCompensated(true)
					ply:LagCompensation( true ) 
					--v:SetVelocity(v:GetForward() * 500 + Vector(0,0,1000)) 
					if(v:GetName() =='volleyball1' or v:GetName() == 'volleyball2' or v:GetName() == 'volleyball3') then   
						--v:GetPhysicsObject():SetVelocity(ply:GetAimVector()* 800) 
						if power == "weak" then 
							KageTossPosition(v,ply,position,350,0,frontback,0.3,tosstype)
						elseif power == "medium" then 
							KageTossPosition(v,ply,position,480,0,frontback,0.4,tosstype)
						else 
							KageTossPosition(v,ply,position,540,0,frontback,0.6,tosstype)
						end 
					end
					ply:LagCompensation( true )  
				end  
			else 
				if ply:GetPos():DistToSqr( v:GetPos() ) < 120*120 then     
					ply:SetLagCompensated(true)
					ply:LagCompensation( true ) 
					--v:SetVelocity(v:GetForward() * 500 + Vector(0,0,1000)) 
					if(v:GetName() =='volleyball1' or v:GetName() == 'volleyball2' or v:GetName() == 'volleyball3') then   
						--v:GetPhysicsObject():SetVelocity(ply:GetAimVector()* 800) 
						if power == "weak" then 
							KageTossPosition(v,ply,position,-110,0,frontback,tosstype)
						elseif power == "medium" then 
							KageTossPosition(v,ply,position,-110,0,frontback,tosstype) 
						else 
							KageTossPosition(v,ply,position,-220,0,frontback,tosstype)
						end 
					end
					ply:LagCompensation( true )  
				end  
			end  
		end 
	end
end) 






-- miya
net.Receive ("check_miya_position" , function(bits , ply )
	--for k,v in pairs(player.GetAll()) do 
	ply:EmitSound("miya/miya_theme2.mp3", 80, 100, 1, CHAN_AUTO ) 
	--end 
end) 
 
net.Receive ("miya_ability" , function(bits , ply )
	local servetype = net.ReadString() 
	local ent =  ents.FindByClass( "prop_physics*" )

	if servetype == "tossup" then 
		for k, v in pairs( ent ) do   
			if ply:GetPos():DistToSqr( v:GetPos() ) < 150*150 then     
				if(v:GetName() =='volleyball1' or v:GetName() == 'volleyball2' or v:GetName() == 'volleyball3') then 
					v:GetPhysicsObject():SetVelocity(ply:GetForward() * 20 + Vector(0,0,600)) 
					ply:EmitSound("tossup.mp3", 70, 100, 1, CHAN_AUTO )
				end
			end   
		end 
	else 
		ply:ConCommand("pac_event spike") 
		for k, v in pairs( ent ) do   
			if ply:GetPos():DistToSqr( v:GetPos() ) < 150*150 then     
				if(v:GetName() =='volleyball1' or v:GetName() == 'volleyball2' or v:GetName() == 'volleyball3') then 
					v:GetPhysicsObject():SetVelocity(ply:GetForward() * 1100 + Vector(0,0,150)) 
					timer.Create("miya_serve",0.3,1,function()     
						v:GetPhysicsObject():SetVelocity(ply:GetForward()*1600 + Vector(0,0,-650))
						ply:EmitSound("miya/miya_spike3.mp3", 70, 100, 1, CHAN_AUTO )  
						ply:ConCommand("pac_event spike")
					end) 
				end
			end   
		end 
	end 
end) 

--bokuto 
net.Receive ("bokuto_cut" , function(bits , ply )
	local position = net.ReadString()
	local direction = net.ReadString() 
	local power = net.ReadString() 

	local ent =  ents.FindByClass( "prop_physics*" )

	for k, v in pairs( ent ) do   
		if ply:GetPos():DistToSqr( v:GetPos() ) < 118*118 then     
			ply:EmitSound("spike.mp3", 70, 100, 1, CHAN_AUTO ) 
			if(v:GetName() =='volleyball1' or v:GetName() == 'volleyball2' or v:GetName() == 'volleyball3') then 
				if position == "left" then  
					if v:GetPos():WithinAABox( pos3, pos4 ) then
						ply:ChatPrint("Can't spike ball over other team area!") 
					else  
						if direction == "right" then 
							 
							if power == "soft" then 
							
								v:GetPhysicsObject():SetVelocity(ply:GetAimVector() * 700  + Vector(-900,0,0))
							else 
								ply:EmitSound("boku/spike2.mp3", 70, 100, 1, CHAN_AUTO )
								v:GetPhysicsObject():SetVelocity(ply:GetAimVector() * 1000  + Vector(-1500,0,-200)) 
							end 
						else 
							
							if power == "soft" then 
				
								
								v:GetPhysicsObject():SetVelocity(ply:GetAimVector() * 700  + Vector(900,0,0))
							else 
								ply:EmitSound("boku/spike2.mp3", 70, 100, 1, CHAN_AUTO )  
								v:GetPhysicsObject():SetVelocity(ply:GetAimVector() * 1500  + Vector(1500,0,-200))
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
						if direction == "left" then 
					
							if power == "soft" then 
								
								v:GetPhysicsObject():SetVelocity(ply:GetAimVector() * 700  + Vector(-900,0,0))
							else 
						
								ply:EmitSound("boku/spike2.mp3", 70, 100, 1, CHAN_AUTO ) 
								v:GetPhysicsObject():SetVelocity(ply:GetAimVector() * 1500  + Vector(-1500,0,-200))
							end 
						else 
							
							if power == "soft" then
						
						
								v:GetPhysicsObject():SetVelocity(ply:GetAimVector() * 700  + Vector(900,0,0))
							else 
								ply:EmitSound("boku/spike2.mp3", 70, 100, 1, CHAN_AUTO )  
								v:GetPhysicsObject():SetVelocity(ply:GetAimVector() * 1500  + Vector(1500,0,-200))
							end 
						end 
					end 
				end 
			end
		end
	end  
end) 

-- yamaguchi 
net.Receive ("yama_ability" , function(bits , ply )
	local servetype = net.ReadString() 
	local ent =  ents.FindByClass( "prop_physics*" )
	local randomdrop = {0.3,0.4,0.5,0.6} 
	local leftright = {200,-200} 
	local random = table.Random(randomdrop)
	local randompower = {200,200}
	local randomstop = {1300,-30}

	if servetype == "tossup" then 
		for k, v in pairs( ent ) do   
			if ply:GetPos():DistToSqr( v:GetPos() ) < 120*120 then     
				if(v:GetName() =='volleyball1' or v:GetName() == 'volleyball2' or v:GetName() == 'volleyball3') then 
					v:GetPhysicsObject():SetVelocity(ply:GetForward() * 20 + Vector(0,0,600)) 
					ply:EmitSound("tossup.mp3", 70, 100, 1, CHAN_AUTO )
				end
			end    
		end 
	else 
		for k, v in pairs( ent ) do   
			if ply:GetPos():DistToSqr( v:GetPos() ) < 120*120 then     
				if(v:GetName() =='volleyball1' or v:GetName() == 'volleyball2' or v:GetName() == 'volleyball3') then 
					ply:EmitSound("yama/yamaserve.mp3", 70, 100, 1, CHAN_AUTO )
					v:GetPhysicsObject():SetVelocity(ply:GetAimVector() * 300 + Vector(0,0,0))  
					timer.Create("slowdown",0.2,1,function() v:GetPhysicsObject():SetVelocity(ply:GetAimVector() * 600 + Vector(0,0,150))  end) 

							timer.Create("slowdown",0.2,1,function() v:GetPhysicsObject():SetVelocity(ply:GetAimVector() * 400 + Vector(60,0,50))  
								timer.Create("slowdown",0.2,1,function() v:GetPhysicsObject():SetVelocity(ply:GetAimVector() * 400 + Vector(-60,0,-50)) 
									timer.Create("slowdown",0.2,1,function() v:GetPhysicsObject():SetVelocity(ply:GetAimVector() * 400 + Vector(60,0,100))
										timer.Create("slowdown",0.2,1,function() v:GetPhysicsObject():SetVelocity(ply:GetAimVector() * 400 + Vector(-60,0,50))  
											timer.Create("slowdown",0.3,1,function() v:GetPhysicsObject():SetVelocity(ply:GetAimVector() * table.Random(randomstop) + Vector(table.Random(leftright),0,-700))  end)
										end)
									end)
								 end)
							end)
							
							--timer.Create("slowdown",0.4,1,function() v:GetPhysicsObject():SetVelocity(ply:GetAimVector() * 400 + Vector(100,0,150))  end)
						--end  
					--[[timer.Create("slowdown",0.2,1,function() v:GetPhysicsObject():SetVelocity(ply:GetAimVector() * 400 + Vector(0,0,150))  end) 
					
						--v:GetPhysicsObject():SetVelocity(ply:GetForward()*250 + Vector(-50,0,0))
						timer.Create("yama_serve",random,1,function()      
							v:GetPhysicsObject():SetVelocity(ply:GetAimVector()* table.Random(randompower) + Vector(table.Random(leftright),0,table.Random(randomstop)) )
							--[[timer.Create("yama_serve",0.3,1,function()     
								v:GetPhysicsObject():SetVelocity(ply:GetForward()*150 + Vector(50,-100,0)) 
								timer.Create("yama_serve",0.3,1,function()     
									v:GetPhysicsObject():SetVelocity(ply:GetForward()*200 + Vector(random,-50,0,0))
								end)
							end) 
						end) 
							--[[timer.Create("yama_serve",0.5,1,function()     
						v:GetPhysicsObject():SetVelocity(ply:GetForward()*600 + Vector(0,-150,0))
						--ply:EmitSound("miya/miya_spike3.mp3", 70, 100, 1, CHAN_AUTO )  
					end)
					timer.Create("yama_serve",0.7,1,function()     
						v:GetPhysicsObject():SetVelocity(ply:GetForward()*600 + Vector(0,150,0))
						--ply:EmitSound("miya/miya_spike3.mp3", 70, 100, 1, CHAN_AUTO )  
					end)
				end]]
				end 
			end   
		end 
	end 
end) 
---------------------------------------------------------------------

--BASIC REC,SET,SPIKE 

 
net.Receive ("basic_serve" , function(bits , ply )
	local ent =  ents.FindByClass( "prop_physics*" ) 

	for k, v in pairs( ent ) do   
		ply:ConCommand("pac_event serve")
		ply:ConCommand("pac_event spike")
		if ply:GetPos():DistToSqr( v:GetPos() ) < 120*120 then     
			if(v:GetName() =='volleyball1' or v:GetName() == 'volleyball2' or v:GetName() == 'volleyball3') then 
				ply:EmitSound("spike.mp3", 70, 100, 1, CHAN_AUTO )
				v:GetPhysicsObject():SetVelocity(ply:GetForward() * 400 + Vector(0,0,400)) 
			end
		end   
	end 
end) 


net.Receive ("block_power" , function(bits , ply )
	local position = net.ReadString()
	local power = net.ReadString()

	 local ent =  ents.FindByClass( "prop_physics*" )

	for k, v in pairs( ent ) do    
		ply:ConCommand("pac_event block") 

		local vert = ply:GetPos() + v:GetPos() * Vector(0,0,1)
		print(vert)
		if ply:GetPos():DistToSqr( v:GetPos() ) < 105*105 then     
			ply:SetLagCompensated(true)
			ply:LagCompensation( true ) 
			--v:SetVelocity(v:GetForward() * 500 + Vector(0,0,1000)) 
			if(v:GetName() =='volleyball1' or v:GetName() == 'volleyball2' or v:GetName() == 'volleyball3') then    
				--v:GetPhysicsObject():SetVelocity(ply:GetAimVector()* 800) 
				if power == "soft" then 
					BlockPosition(v,ply,position,200,-50)
				elseif power == "kill" then 
					BlockPosition(v,ply,position,140,-700)
				end 
			end
			ply:LagCompensation( true )  
		end  
	end
end)


net.Receive ("receive_power" , function(bits , ply )
	local position = net.ReadString()
	local power = net.ReadString()

	 local ent =  ents.FindByClass( "prop_physics*" )

	for k, v in pairs( ent ) do    

		if ply:GetPos():DistToSqr( v:GetPos() ) < 115*115 then     
			ply:SetLagCompensated(true)
			ply:LagCompensation( true ) 
			--v:SetVelocity(v:GetForward() * 500 + Vector(0,0,1000)) 
			if(v:GetName() =='volleyball1' or v:GetName() == 'volleyball2' or v:GetName() == 'volleyball3') then    
				--v:GetPhysicsObject():SetVelocity(ply:GetAimVector()* 800) 
				if power == "weak" then 
					ReceivePosition(v,ply,position,110,400)
				elseif power == "strong" then 
					ReceivePosition(v,ply,position,140,550)
				else 
					ReceivePosition(v,ply,position,120,750)
				end 
			end
			ply:LagCompensation( true )  
		end  
	end

end)




net.Receive ("spike_power_hinata" , function(bits , ply )
	local position = net.ReadString()
	local power = net.ReadString()
	local spikepower = net.ReadInt(32)

	local ent =  ents.FindByClass( "prop_physics*" )

	for k, v in pairs( ent ) do     
		--ply:ConCommand("pac_event spike") 
		if ply:GetPos():DistToSqr( v:GetPos() ) < 118*118 then   
			ply:ConCommand("pac_event spike")   
			ply:SetLagCompensated(true)
			ply:LagCompensation( true ) 
			--v:SetVelocity(v:GetForward() * 500 + Vector(0,0,1000)) 
			if(v:GetName() =='volleyball1' or v:GetName() == 'volleyball2' or v:GetName() == 'volleyball3') then   
				--v:GetPhysicsObject():SetVelocity(ply:GetAimVector()* 800) 
				if power == "weak" then 
					SpikePosition(v,ply,position,700,0)  
				else 
					SpikePosition(v,ply,position,spikepower,0)
				end 
			end
			ply:LagCompensation( true )  
		end   
	end

end)

net.Receive ("fake_spike" , function(bits , ply )
	ply:ConCommand("pac_event spike")
end) 


net.Receive ("toss_power" , function(bits , ply )
	local position = net.ReadString()
	local power = net.ReadString()
	local frontback = net.ReadString() 

	 local ent =  ents.FindByClass( "prop_physics*" )

	for k, v in pairs( ent ) do    

		if frontback == "front" then
			ply:ConCommand("pac_event set")  
			if ply:GetPos():DistToSqr( v:GetPos() ) < 120*120 then  
				ply:ConCommand("pac_event set") 
				ply:ConCommand("pac_event jumpset")  
				ply:SetLagCompensated(true)
				ply:LagCompensation( true ) 
				--v:SetVelocity(v:GetForward() * 500 + Vector(0,0,1000)) 
				if(v:GetName() =='volleyball1' or v:GetName() == 'volleyball2' or v:GetName() == 'volleyball3') then   
					--v:GetPhysicsObject():SetVelocity(ply:GetAimVector()* 800) 
					if power == "weak" then 
						TossPosition(v,ply,position,100,250,frontback)
					elseif power == "medium" then 
						TossPosition(v,ply,position,100,400,frontback)
					else 
						TossPosition(v,ply,position,220,450,frontback)
					end 
				end
				ply:LagCompensation( true )   
			end  
		else 
			if ply:GetPos():DistToSqr( v:GetPos() ) < 120*120 then  
				ply:ConCommand("pac_event backset")
				ply:ConCommand("pac_event jumpbackset")
				ply:SetLagCompensated(true)
				ply:LagCompensation( true ) 
				--v:SetVelocity(v:GetForward() * 500 + Vector(0,0,1000)) 
				if(v:GetName() =='volleyball1' or v:GetName() == 'volleyball2' or v:GetName() == 'volleyball3') then   
					--v:GetPhysicsObject():SetVelocity(ply:GetAimVector()* 800) 
					if power == "weak" then 
						TossPosition(v,ply,position,-110,330,frontback)
					elseif power == "medium" then 
						TossPosition(v,ply,position,-110,450,frontback)
					else 
						TossPosition(v,ply,position,-220,600,frontback)
					end 
				end
				ply:LagCompensation( true )  
			end  
		end 
	end

end)


net.Receive ("dive_power" , function(bits , ply )
	local position = net.ReadString()
	local power = net.ReadString()

	 local ent =  ents.FindByClass( "prop_physics*" )

	for k, v in pairs( ent ) do    
		ply:SetWalkSpeed(1)
		ply:SetRunSpeed(1)

		if power == "short" then 

			if ply:GetPos():DistToSqr( v:GetPos() ) < 180*180 then     
			ply:SetLagCompensated(true)
			ply:LagCompensation( true ) 
				if(v:GetName() =='volleyball1' or v:GetName() == 'volleyball2' or v:GetName() == 'volleyball3') then    
					--v:GetPhysicsObject():SetVelocity(ply:GetAimVector()* 800) 
					DivePosition(v,ply,position,-100,450,"short")
				end
			end
	
			ply:SetVelocity(ply:GetForward() * 600 ) 
			ply:ConCommand("pac_event diveshort") 
		elseif power == "long" then 

			if ply:GetPos():DistToSqr( v:GetPos() ) < 220*220 then     
			ply:SetLagCompensated(true)
			ply:LagCompensation( true ) 
				if(v:GetName() =='volleyball1' or v:GetName() == 'volleyball2' or v:GetName() == 'volleyball3') then    
					DivePosition(v,ply,position,-100,650,"long")
					--v:GetPhysicsObject():SetVelocity(ply:GetAimVector()* 800) 
				end
			end

			ply:SetVelocity(ply:GetForward() * 1200 ) 
			ply:ConCommand("pac_event divelong")
		end 

		--[[if ply:GetPos():Distance( v:GetPos() ) < 135 then     
			ply:SetLagCompensated(true)
			ply:LagCompensation( true ) 
			--v:SetVelocity(v:GetForward() * 500 + Vector(0,0,1000)) 
			if(v:GetName() =='volleyball1' or v:GetName() == 'volleyball2' or v:GetName() == 'volleyball3') then    
				v:GetPhysicsObject():SetVelocity(ply:GetAimVector()* 800) 
	
			end
			ply:LagCompensation( true )  
		end  ]]
	end
end)

net.Receive("revertspeed",function(bits,ply) 
	local class = net.ReadString() 

	if class == "libero" then 
		ply:SetWalkSpeed(300)
		ply:SetRunSpeed(340)
	end 
end) 

net.Receive ("ref" , function(bits , ply )
	local ref = net.ReadString() 

	if ref == "whistle" then 
		ply:EmitSound("whistle.mp3", 70, 100, 1, CHAN_AUTO )

	elseif ref == "agree" then 
		ply:ConCommand("act agree") 
	else 
		ply:ConCommand("act disagree")
	end 
end)