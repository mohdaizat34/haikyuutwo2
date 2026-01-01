-- ===============================
-- Send core files
-- ===============================
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

-- ===============================
-- Client-only files
-- ===============================
AddCSLuaFile("font.lua")
AddCSLuaFile("cl_ui.lua")

-- Info
AddCSLuaFile("info/cl_animinfo.lua")
AddCSLuaFile("info/cl_hud.lua")
AddCSLuaFile("info/cl_tutorial.lua")

-- Keybinds
AddCSLuaFile("keybind/cl_keybind.lua")

-- Mechanics (client)
AddCSLuaFile("mechanic/cl_mechanic.lua")
AddCSLuaFile("mechanic/cl_communication.lua")
AddCSLuaFile("mechanic/cl_setting.lua")

AddCSLuaFile("mechanic/cl_ui_mechanic.lua")
AddCSLuaFile("mechanic/cl_action_mode.lua")
AddCSLuaFile("mechanic/cl_jump_system.lua")
AddCSLuaFile("mechanic/cl_spike_mechanics.lua")
AddCSLuaFile("mechanic/cl_toss_mechanics.lua")
AddCSLuaFile("mechanic/cl_block_mechanics.lua")
AddCSLuaFile("mechanic/cl_hud_elements.lua")
AddCSLuaFile("mechanic/cl_net_receives.lua")
AddCSLuaFile("mechanic/cl_utilities.lua")

-- Receive system
AddCSLuaFile("mechanic/receive-system/cl_receive_system.lua")

-- Characters (client)
AddCSLuaFile("mechanic/kenma/cl_kenma.lua")
AddCSLuaFile("mechanic/sakusa/cl_sakusa.lua")
AddCSLuaFile("mechanic/hinata/cl_hinata.lua")
AddCSLuaFile("mechanic/miya/cl_miya.lua")
AddCSLuaFile("mechanic/yamaguchi/cl_yamaguchi.lua")
AddCSLuaFile("mechanic/bokuto/cl_bokuto.lua")

-- Music
AddCSLuaFile("musicplayer/cl_music_player.lua")

-- ===============================
-- Server-only files
-- ===============================
include("shared.lua")

include("mechanic/sv_mechanic.lua")
include("mechanic/sv_communication.lua")
include("mechanic/sv_setting.lua")
include("mechanic/sv_npc.lua")

include("mechanic/receive-system/sv_receive_system.lua")

include("mechanic/kenma/sv_kenma.lua")
include("mechanic/sakusa/sv_sakusa.lua")
include("mechanic/hinata/sv_hinata.lua")

include("character/sv_character.lua")
include("musicplayer/sv_music_player.lua")


//receive 
include("mechanic/receive-system/sv_receive_system.lua") 

util.AddNetworkString("random_system")

GM.Name = "Gmod Volleyball 2.0"

function GM:PlayerInitialSpawn(ply) 
	timer.Simple(5,function()
		url = "https://pastebin.com/raw/cgsbmMqB"
		ply:ConCommand('pac_load_url "'..url.. '"')


		ply:ConCommand("pac_wear_parts") 
		ply:ConCommand("pac_draw_distance 30000")
	end) 
		
end 

function GM:PlayerSpawn( ply )
	--ply:SetModel("models/fbi_pack/fbi_04.mdl")
	ply:SetModel("models/player/summermilitary/male_02.mdl")
	ply:SetHealth(9000)      
end  


player_jump = {"shoes_sound.mp3","shoes_sound2.mp3","shoes_sound3.mp3"}

util.AddNetworkString("normal_spike") 
util.AddNetworkString("basic_serve") 
 util.AddNetworkString("feint")  

 local shouldOccur = true    
 local delay = 0.8
 hook.Add("PlayerButtonDown","PlayerJump",function(ply,button)
	 
	 if shouldOccur then

		 if button == KEY_SPACE then 

			shouldOccur = false
			ply:EmitSound(table.Random(player_jump), 80, 100, 1, CHAN_AUTO ) 
			timer.Simple(1,function() shouldOccur=true end)
		 end 
	 end 
 end) 
 
 


net.Receive ("feint" , function(bits , ply )
	--local spike = net.ReadString()
	--ply:ChatPrint("Spike!") 
	--RunConsoleCommand("pac_event", "k = spike")
	--ply:ConCommand("pac_event k = spike")
	--timer.Create("spike_time",0.3,1,function() 

	 	local ent =  ents.FindByClass( "prop_physics*" )
	
	--ply:ChatPrint("Used Normal Spike")  
		for k, v in pairs( ent ) do   
			if ply:Ping() > 195 then 
				if ply:GetPos():Distance( v:GetPos() ) < 100 then     
					ply:SetLagCompensated(true)
					ply:LagCompensation( true )
					ply:EmitSound("toss1.mp3", 70, 100, 1, CHAN_AUTO ) 
					--v:SetVelocity(v:GetForward() * 500 + Vector(0,0,1000)) 
					if(v:GetName() =='volleyball1') then   
						--v:GetPhysicsObject():SetVelocity(ply:GetAimVector()* 800) 
						v:GetPhysicsObject():SetVelocity(ply:GetForward() * 150 + Vector(0,0,250))   
						timer.Create("drop",0.4,1,function()  
							v:GetPhysicsObject():SetVelocity(ply:GetForward() * 50 + Vector(0,0,-200)) 
						end)      
						--ply:SetVelocity( ply:GetAimVector() * 1000 )  
					end
					ply:LagCompensation( true )   
				end 
			else 
				if ply:GetPos():Distance( v:GetPos() ) < 100 then     
					ply:SetLagCompensated(true)
					ply:LagCompensation( true )
					ply:EmitSound("toss1.mp3", 70, 100, 1, CHAN_AUTO )  
					--v:SetVelocity(v:GetForward() * 500 + Vector(0,0,1000))   
					if(v:GetName() =='volleyball1') then    
						--v:GetPhysicsObject():SetVelocity(ply:GetAimVector()* 800)   
						v:GetPhysicsObject():SetVelocity(ply:GetForward() * 150 + Vector(0,0,250))   
						timer.Create("drop",0.4,1,function()  
							v:GetPhysicsObject():SetVelocity(ply:GetForward() * 50 + Vector(0,0,-200)) 
						end)           
						--ply:SetVelocity( ply:GetAimVector() * 1000 )  
					end
					ply:LagCompensation( true ) 
				end 
			end 
		end        
	--end)
	--ply:SetVelocity(Vector(0,0,250))
 
end)

 pos1 = Vector(1419.853394, 1000.308411, -165.108414)
 pos2 = Vector(602.493164, 319.357361, 398.086914)
-- Calculate the mirrored positions for the right side with reduced width
 pos3 = Vector(pos1.x, -pos1.y, pos1.z)
 pos4 = Vector(pos2.x,319.357361, pos2.z)
 
net.Receive ("normal_spike" , function(bits , ply )
	local position = net.ReadString()
	--ply:ChatPrint("Spike!") 
	--RunConsoleCommand("pac_event", "k = spike")
	--ply:ConCommand("pac_event k = spike")
	--timer.Create("spike_time",0.3,1,function()

	 	local ent =  ents.FindByClass( "prop_physics*" )
	
	--ply:ChatPrint("Used Normal Spike")  
		for k, v in pairs( ent ) do    
			if ply:Ping() > 195 then 
				if ply:GetPos():Distance( v:GetPos() ) < 100 then     
					ply:SetLagCompensated(true)
					ply:LagCompensation( true ) 
					--v:SetVelocity(v:GetForward() * 500 + Vector(0,0,1000)) 
					if(v:GetName() =='volleyball1') then   
						--v:GetPhysicsObject():SetVelocity(ply:GetAimVector()* 800) 
						if position == "left" then 
							if v:GetPos():WithinAABox( pos3, pos4 ) then
								ply:ChatPrint("Can't spike ball over other team area!")
							else 
								ply:EmitSound("spike.mp3", 70, 100, 1, CHAN_AUTO ) 
								v:GetPhysicsObject():SetVelocity(ply:GetForward() * 1000 + Vector(0,0,-700))     
							--ply:SetVelocity( ply:GetAimVector() * 1000 )  
							end 
						else 
							if v:GetPos():WithinAABox( pos1, pos2 ) then
								ply:ChatPrint("Can't spike ball over other team area!")
							else 
								ply:EmitSound("spike.mp3", 70, 100, 1, CHAN_AUTO ) 
								v:GetPhysicsObject():SetVelocity(ply:GetForward() * 1000 + Vector(0,0,-700))     
							--ply:SetVelocity( ply:GetAimVector() * 1000 )  
							end 
						end 
					end
					ply:LagCompensation( true )  
				end  
			else 
				if ply:GetPos():Distance( v:GetPos() ) < 100 then   
					ply:SetLagCompensated(true)
					ply:LagCompensation( true )
					--v:SetVelocity(v:GetForward() * 500 + Vector(0,0,1000)) 
					if(v:GetName() =='volleyball1') then   
						--v:GetPhysicsObject():SetVelocity(ply:GetAimVector()* 800) 
						if position == "left" then 
							if v:GetPos():WithinAABox( pos3, pos4 ) then
								ply:ChatPrint("Can't spike ball over other team area!")
							else 
								ply:EmitSound("spike.mp3", 70, 100, 1, CHAN_AUTO ) 
								v:GetPhysicsObject():SetVelocity(ply:GetAimVector() * 1000)
								timer.Create("serveking",0.1,1,function()      
									v:GetPhysicsObject():SetVelocity(ply:GetAimVector() *1000 + Vector(0,0,-100))           
								end)       
							--ply:SetVelocity( ply:GetAimVector() * 1000 )  
							end 
						else 
							if v:GetPos():WithinAABox( pos1, pos2 ) then
								ply:ChatPrint("Can't spike ball over other team area!")
							else 
								ply:EmitSound("spike.mp3", 70, 100, 1, CHAN_AUTO ) 
								v:GetPhysicsObject():SetVelocity(ply:GetAimVector() * 1000)    
								timer.Create("serveking",0.1,1,function()      
									v:GetPhysicsObject():SetVelocity(ply:GetAimVector() *1000 + Vector(0,0,-100))           
								end)    
							--ply:SetVelocity( ply:GetAimVector() * 1000 )  
							end 
						end 
					end
					ply:LagCompensation( true ) 
				end 
			end
		end        
	--end) 
	--ply:SetVelocity(Vector(0,0,250))

end)

--Voice range
hook.Add( "PlayerCanHearPlayersVoice", "Maximum Range", function( listener, talker )
	if listener:GetPos():Distance( talker:GetPos() ) > 500 then return false end
	return false 
end )


net.Receive ("army_stats" , function(bits , ply ) 
	ply:StripWeapons()
	hook.Remove("PlayerButtonDown" , "killer_ability" , function(ply,button) end) 
	hook.Remove("PlayerButtonDown" , "meg_ability" , function(ply,button)  end)
	hook.Remove("PlayerButtonDown" , "survivor_ability" , function(ply,button)  end) 
	hook.Remove("PlayerButtonDown" , "survivor_ability3" , function(ply,button)  end)   
	ply:UnSpectate()
	ply:SetTeam(5) 

	ply:StripWeapons() 
	ply:SetJumpPower(285)   
	ply:SetHealth(2000) 
	ply:SetWalkSpeed(180)             
	ply:SetRunSpeed(250)
	ply:SetModel("models/player/eric_summer/male_06.mdl")        
end)
  

-- note: survivors/abilities  
net.Receive ("meg_stats" , function(bits , ply )
	hook.Remove("PlayerButtonDown" , "killer_ability" , function(ply,button) end)
	hook.Remove("PlayerButtonDown" , "army_ability" , function(ply,button)  end)
	hook.Remove("PlayerButtonDown" , "survivor_ability3" , function(ply,button)  end)
	hook.Remove("PlayerButtonDown" , "SpectateEntity" , function(ply,button) end) 
	ply:SetTeam(4)
	ply:ChatPrint("You chose Meg Thomas")     
	ply:UnSpectate()
	--ply:Spawn()  

	ply:StripWeapons() 
	ply:SetJumpPower(275)   
	ply:SetHealth(2000) 
	ply:SetWalkSpeed(180)             
	ply:SetRunSpeed(250)
	ply:SetModel("models/player/eric_summer/male_06.mdl")  
	  
end)

util.AddNetworkString("low_toss")   
util.AddNetworkString("medium_toss")
util.AddNetworkString("medium_toss2")
util.AddNetworkString("freak_toss") 

net.Receive ("low_toss" , function(bits , ply )   
	--ply:ChatPrint("Used Low Toss") 
	local ent =  ents.FindByClass( "prop_physics*" )
	local position = net.ReadString() 

	for k, v in pairs( ent ) do 
		if ply:GetPos():Distance( v:GetPos() ) < 105 then 
			--ply:EmitSound("toss1.mp3", 70, 100, 1, CHAN_AUTO )

			ply:LagCompensation( true )
			--v:SetVelocity(v:GetForward() * 500 + Vector(0,0,1000)) 
			if(v:GetName() =='volleyball1') then  
				if position == "left" then 
					if v:GetPos():WithinAABox( pos3, pos4 ) then
						ply:ChatPrint("Can't set ball over other team area!")
					else  
						v:GetPhysicsObject():SetVelocity(ply:GetAimVector()* 300) 
						ply:EmitSound("toss1.mp3", 70, 100, 1, CHAN_AUTO )
				--ply:SetVelocity( ply:GetAimVector() * 1000 )  
					end 
				else
					if v:GetPos():WithinAABox( pos1, pos2 ) then
						ply:ChatPrint("Can't set ball over other team area!")
					else 
						v:GetPhysicsObject():SetVelocity(ply:GetAimVector()* 300) 
						ply:EmitSound("toss1.mp3", 70, 100, 1, CHAN_AUTO )
				--ply:SetVelocity( ply:GetAimVector() * 1000 )  
					end 
				end 
			end
			ply:LagCompensation( false )  
		end 
	end    
end)  
 
net.Receive ("medium_toss" , function(bits , ply )     
	--ply:ChatPrint("Used Normal Toss/Receive")
	local ent =  ents.FindByClass( "prop_physics*" ) 
	local position = net.ReadString() 

	for k, v in pairs( ent ) do   
		if ply:Ping() > 195 then  
			if ply:GetPos():Distance( v:GetPos() ) < 100 then     
				ply:LagCompensation( true )
				--ply:EmitSound("receive.mp3", 70, 100, 1, CHAN_AUTO ) 
				--v:SetVelocity(v:GetForward() * 500 + Vector(0,0,1000)) 
				if(v:GetName() =='volleyball1') then    
					--v:GetPhysicsObject():SetVelocity(ply:GetAimVector()* 450)
					if position == "left" then 
						if v:GetPos():WithinAABox( pos3, pos4 ) then
							ply:ChatPrint("Can't receive ball over other team area!")
						else  
							v:GetPhysicsObject():SetVelocity(ply:GetForward() * 110 + Vector(0,0,470))   
							ply:EmitSound("receive.mp3", 70, 100, 1, CHAN_AUTO ) 
					--ply:SetVelocity( ply:GetAimVector() * 1000 )  
						end 
					else
						if v:GetPos():WithinAABox( pos1, pos2 ) then
							ply:ChatPrint("Can't receive ball over other team area!")
						else 
							v:GetPhysicsObject():SetVelocity(ply:GetForward() * 110 + Vector(0,0,470))      
							ply:EmitSound("receive.mp3", 70, 100, 1, CHAN_AUTO ) 
					--ply:SetVelocity( ply:GetAimVector() * 1000 )  
						end 
					end
				end  
			end 
					--ply:SetVelocity( ply:GetAimVector() * 1000 )   
				ply:LagCompensation( false ) 
		else  

			if ply:GetPos():Distance( v:GetPos() ) < 90 then       
				ply:LagCompensation( true )
				--ply:EmitSound("receive.mp3", 70, 100, 1, CHAN_AUTO )
				--v:SetVelocity(v:GetForward() * 500 + Vector(0,0,1000))  
				if(v:GetName() =='volleyball1') then    
					--v:GetPhysicsObject():SetVelocity(ply:GetAimVector()* 450)
					if position == "left" then 
						if v:GetPos():WithinAABox( pos3, pos4 ) then 
							ply:ChatPrint("Can't receive ball over other team area!")  
						else  
							v:GetPhysicsObject():SetVelocity(ply:GetForward() * 110 + Vector(0,0,470))    
							ply:EmitSound("receive.mp3", 70, 100, 1, CHAN_AUTO ) 
					--ply:SetVelocity( ply:GetAimVector() * 1000 )  
						end 
					else
						if v:GetPos():WithinAABox( pos1, pos2 ) then  
							ply:ChatPrint("Can't receive ball over other team area!")  
						else 
							v:GetPhysicsObject():SetVelocity(ply:GetForward() * 110 + Vector(0,0,470))           
							ply:EmitSound("receive.mp3", 70, 100, 1, CHAN_AUTO ) 
					--ply:SetVelocity( ply:GetAimVector() * 1000 )  
						end 
					end
				end   
				ply:LagCompensation( false )  
			end 
		end   
	end  
	--ply:ConCommand("pac_event l = set")       
end)

net.Receive ("medium_toss2" , function(bits , ply ) 
	local setting = net.ReadString() 
	local position = net.ReadString() 
	--ply:ChatPrint("Used Normal Toss/Receive")
	--timer.Create("delay_set",0.1,1,function() 
		local ent =  ents.FindByClass( "prop_physics*" ) 
		for k, v in pairs( ent ) do 
			if ply:GetPos():Distance( v:GetPos() ) < 115 then  
				if setting == "normal" then 
					ply:LagCompensation( true )
					--ply:EmitSound("toss2.mp3", 70, 100, 1, CHAN_AUTO )
					--ply:EmitSound("receive.mp3", 70, 100, 1, CHAN_AUTO )
					--v:SetVelocity(v:GetForward() * 500 + Vector(0,0,1000)) 
					if(v:GetName() =='volleyball1') then   
						if position == "left" then 
							if v:GetPos():WithinAABox( pos3, pos4 ) then
								ply:ChatPrint("Can't set ball over other team area!")
							else  
								--v:GetPhysicsObject():SetVelocity(ply:GetAimVector()* 400)  
								ply:EmitSound("toss2.mp3", 70, 100, 1, CHAN_AUTO )
						--ply:SetVelocity( ply:GetAimVector() * 1000 )  
							end  
						else
							if v:GetPos():WithinAABox( pos1, pos2 ) then
								ply:ChatPrint("Can't set ball over other team area!")
							else 
								--v:GetPhysicsObject():SetVelocity(ply:GetAimVector()* 400) 
								v:GetPhysicsObject():SetVelocity(ply:GetForward() * 100 + Vector(0,0,400))
								ply:EmitSound("toss2.mp3", 70, 100, 1, CHAN_AUTO )
						--ply:SetVelocity( ply:GetAimVector() * 1000 )  
							end 
						end 
					end

					ply:LagCompensation( false )
				else 
					ply:LagCompensation( true )
					--ply:EmitSound("toss2.mp3", 70, 100, 1, CHAN_AUTO )
					--ply:EmitSound("receive.mp3", 70, 100, 1, CHAN_AUTO )
					--v:SetVelocity(v:GetForward() * 500 + Vector(0,0,1000)) 
					if(v:GetName() =='volleyball1') then   
						if position == "left" then 
							if v:GetPos():WithinAABox( pos3, pos4 ) then
								ply:ChatPrint("Can't set ball over other team area!")
							else  
								--v:GetPhysicsObject():SetVelocity(ply:GetForward() * -150 + Vector(0,0,400))
								v:GetPhysicsObject():SetVelocity(ply:GetForward() * 800 + Vector(0,0,600))  
								ply:EmitSound("toss2.mp3", 70, 100, 1, CHAN_AUTO )
						--ply:SetVelocity( ply:GetAimVector() * 1000 )  
							end  
						else
							if v:GetPos():WithinAABox( pos1, pos2 ) then
								ply:ChatPrint("Can't set ball over other team area!")
							else 
								--v:GetPhysicsObject():SetVelocity(ply:GetForward() * -150 + Vector(0,0,400))
								v:GetPhysicsObject():SetVelocity(ply:GetForward() * 800 + Vector(0,0,600))
								ply:EmitSound("toss2.mp3", 70, 100, 1, CHAN_AUTO )
						--ply:SetVelocity( ply:GetAimVector() * 1000 )  
							end 
						end 
					end
					ply:LagCompensation( false ) 
				end
			end 
		end      
	--end)
	--ply:ConCommand("pac_event l = set")  
	--RunConsoleCommand("pac_event", "l = set")  
end)

net.Receive ("freak_toss" , function(bits , ply )    
	local ent =  ents.FindByClass( "prop_physics*" )
	local position = net.ReadString() 
	ply:ChatPrint("Used Freak Toss")
	--timer.Create("delay_set",0.1,1,function()  
		for k, v in pairs( ent ) do 
			if ply:GetPos():Distance( v:GetPos() ) < 100 then 
				ply:LagCompensation( true )
				if(v:GetName() =='volleyball1') then   
						if position == "left" then 
							if v:GetPos():WithinAABox( pos3, pos4 ) then
								ply:ChatPrint("Can't set ball over other team area!")
							else  
								v:GetPhysicsObject():SetVelocity(ply:GetAimVector()* 800)  
								ply:EmitSound("toss2.mp3", 70, 100, 1, CHAN_AUTO )
						--ply:SetVelocity( ply:GetAimVector() * 1000 )  
							end  
						else
							if v:GetPos():WithinAABox( pos1, pos2 ) then
								ply:ChatPrint("Can't set ball over other team area!")
							else 
								v:GetPhysicsObject():SetVelocity(ply:GetAimVector()* 800)  
								ply:EmitSound("toss2.mp3", 70, 100, 1, CHAN_AUTO )
						--ply:SetVelocity( ply:GetAimVector() * 1000 )  
							end 
						end 
					end
				ply:LagCompensation( false ) 
			end 
		end 
	--end)
	--ply:ConCommand("pac_event l = set")         
end) 

util.AddNetworkString("wall_block") 

net.Receive ("wall_block" , function(bits , ply )   
	--ply:ChatPrint("Used Low Toss") 
	local ent =  ents.FindByClass( "prop_physics*" )
	local position = net.ReadString() 

	for k, v in pairs( ent ) do 
		if ply:GetPos():Distance( v:GetPos() ) < 100 then 
			ply:EmitSound("spike.mp3", 70, 100, 1, CHAN_AUTO )
			--v:SetVelocity(v:GetForward() * 500 + Vector(0,0,1000)) 
			ply:LagCompensation( true )
			if(v:GetName() =='volleyball1') then   
				if position == "left" then 
					if v:GetPos():WithinAABox( pos3, pos4 ) then
						ply:ChatPrint("Can't set ball over other team area!")
					else  
						v:GetPhysicsObject():SetVelocity(ply:GetForward() * 600 + Vector(0,0,-780))  
						ply:EmitSound("spike.mp3", 70, 100, 1, CHAN_AUTO )
				--ply:SetVelocity( ply:GetAimVector() * 1000 )  
					end  
				else
					if v:GetPos():WithinAABox( pos1, pos2 ) then
						ply:ChatPrint("Can't set ball over other team area!")
					else 
						v:GetPhysicsObject():SetVelocity(ply:GetForward() * 600 + Vector(0,0,-780))  
						ply:EmitSound("spike.mp3", 70, 100, 1, CHAN_AUTO )
				--ply:SetVelocity( ply:GetAimVector() * 1000 )  
					end 
				end 
			end 
			ply:LagCompensation( false ) 
		end 
	end
end)

net.Receive ("simon_stats" , function(bits , ply ) 
	hook.Remove("PlayerButtonDown" , "survivor_ability2" , function(ply,button)  end)
	hook.Remove("PlayerButtonDown" , "survivor_ability" , function(ply,button)  end)  
	hook.Remove("PlayerButtonDown" , "survivor_ability3" , function(ply,button)  end)  
	ply:UnSpectate()
	ply:ChatPrint("You chose Simon") 
	ply:SetTeam(3)  
	ply:SetJumpPower(330)   
	ply:SetHealth(2000)  
	ply:SetWalkSpeed(180)           
	ply:SetRunSpeed(330)
	ply:SetModel("models/player/eric_summer/male_06.mdl")      
 end)

 
	--[[hook.Add("PlayerButtonDown","Bareboru",function(ply,button)  
		if button == KEY_G then  
			for k, v in pairs( ent ) do 
				if ply:GetPos():Distance( v:GetPos() ) < 150 then 
					--v:SetVelocity(v:GetForward() * 500 + Vector(0,0,1000)) 
					if(v:GetName() =='volleyball') then   
						v:GetPhysicsObject():SetVelocity(ply:GetAimVector()* 900) 
						--ply:SetVelocity( ply:GetAimVector() * 1000 )   
					end
				end 
			end
		end 
	end)     ]]  
 
util.AddNetworkString("hideo_ability") 

net.Receive ("hideo_ability" , function(bits , ply )  
	ply:Give( "weapon_hack_phone")          
	timer.Create("secret_camera",20,1,function () ply:StripWeapons() end)            
end) 
  
--	note: team army 
util.AddNetworkString("ace_stats")
net.Receive ("ace_stats" , function(bits , ply )      
	hook.Remove("PlayerButtonUp","meg_ability",function(ply,button) end) 
	hook.Remove("PlayerButtonDown" , "survivor_ability2" , function(ply,button)  end)
	hook.Remove("PlayerButtonDown" , "survivor_ability" , function(ply,button)  end) 
	hook.Remove("PlayerButtonDown" , "survivor_ability3" , function(ply,button)  end)
	ply:UnSpectate()  
	ply:SetTeam(10)      
	ply:SetHealth(2000)     
	ply:SetWalkSpeed(180)       
	ply:SetRunSpeed(250)  
	ply:SetJumpPower(310)   
	ply:SetModel("models/player/summermilitary/male_02.mdl") 
end)

util.AddNetworkString("ace_spike") 

net.Receive ("ace_spike" , function(bits , ply )   
	--ply:ChatPrint("Used Low Toss")  
	local position = net.ReadString() 

	--ply:ConCommand("pac_event k = spike")
--	timer.Create("spike_time",0.3,1,function()

	 	local ent =  ents.FindByClass( "prop_physics*" )
	--ply:ChatPrint("Used Normal Spike")  
		for k, v in pairs( ent ) do 
			if ply:GetPos():Distance( v:GetPos() ) < 100 then
				ply:LagCompensation( true ) 
				--ply:EmitSound("spike.mp3", 70, 100, 1, CHAN_AUTO ) 
				--v:SetVelocity(v:GetForward() * 500 + Vector(0,0,1000))  
				if(v:GetName() =='volleyball1') then

					if position == "left" then 
							if v:GetPos():WithinAABox( pos3, pos4 ) then
								ply:ChatPrint("Can't spike ball over other team area!")
							else 
								ply:EmitSound("spike.mp3", 70, 100, 1, CHAN_AUTO )    
								v:GetPhysicsObject():SetVelocity(ply:GetForward() * 1300 + Vector(0,0,-700))    
							end
					else 
						if v:GetPos():WithinAABox( pos1, pos2 ) then
								ply:ChatPrint("Can't spike ball over other team area!")
						else 
							ply:EmitSound("spike.mp3", 70, 100, 1, CHAN_AUTO )    
							v:GetPhysicsObject():SetVelocity(ply:GetForward() * 1300 + Vector(0,0,-700))    
						end
					end 
					--ply:SetVelocity( ply:GetAimVector() * 1000 )  
				end
				ply:LagCompensation( false ) 
			end 
		end       
	--end)

end)

--Army setter 
util.AddNetworkString("serveking_stats")
net.Receive ("serveking_stats" , function(bits , ply )      
	hook.Remove("PlayerButtonUp","meg_ability",function(ply,button) end) 
	hook.Remove("PlayerButtonDown" , "survivor_ability2" , function(ply,button)  end)
	hook.Remove("PlayerButtonDown" , "survivor_ability" , function(ply,button)  end)  
	hook.Remove("PlayerButtonDown" , "survivor_ability3" , function(ply,button)  end) 
	ply:UnSpectate()  
	ply:SetTeam(11)      
	ply:SetHealth(2000)       
	ply:SetWalkSpeed(180)       
	ply:SetRunSpeed(250)  
	ply:SetJumpPower(275)   
	ply:SetModel("models/player/summermilitary/male_02.mdl")  
end) 

util.AddNetworkString("serve_ability")  
local serve_king = 0  
net.Receive ("serve_ability" , function(bits , ply )   
	serve_king = 1   
	ply:SetJumpPower(315) 
	--ply:SetVelocity(ply:GetForward() * 500 + Vector(0,0,1000))   
	timer.Create("serve_king",5,1,function () ply:SetJumpPower(275) serve_king = 0 end)           
end) 

util.AddNetworkString("serveking_spike")  

net.Receive ("serveking_spike" , function(bits , ply )
	position = net.ReadString()     
	--ply:ChatPrint("Used Low Toss")  
	if serve_king == 1 then  
		local ent =  ents.FindByClass( "prop_*" )
		for k, v in pairs( ent ) do 
			if ply:GetPos():Distance( v:GetPos() ) < 125 then  
				ply:LagCompensation( true )
				--ply:EmitSound("spike.mp3", 70, 100, 1, CHAN_AUTO )
				--v:SetVelocity(v:GetForward() * 500 + Vector(0,0,1000))  
				if(v:GetName() =='volleyball1') then   
						--v:GetPhysicsObject():SetVelocity(ply:GetAimVector()*1000 )  
					-- v:GetPhysicsObject():SetVelocity(ply:GetAimVector()*1000 + Vector(0,0,1000)) 
					v:GetPhysicsObject():SetVelocity(ply:GetAimVector()*1000 )   

					timer.Create("serveking",0.1,1,function()      
						v:GetPhysicsObject():SetVelocity(ply:GetAimVector()*1100 + Vector(0,0,-100))           
					end)   

					timer.Create("serveking",0.2,1,function()   
						v:GetPhysicsObject():SetVelocity(ply:GetAimVector()*900 + Vector(0,0,-350))                   
					end)        
					--ply:SetVelocity( ply:GetAimVector() * 1000 )  
				end 
				ply:LagCompensation( false )
			end 
		end  
	else 
		local ent =  ents.FindByClass( "prop_*" )
		for k, v in pairs( ent ) do 
			if ply:GetPos():Distance( v:GetPos() ) < 100 then 
				ply:LagCompensation( true )
				--ply:EmitSound("spike.mp3", 70, 100, 1, CHAN_AUTO )
				--v:SetVelocity(v:GetForward() * 500 + Vector(0,0,1000))  
				if(v:GetName() =='volleyball1') then   
					if position == "left" then 
						if v:GetPos():WithinAABox( pos3, pos4 ) then
							ply:ChatPrint("Can't spike ball over other team area!")
						else 
							ply:EmitSound("spike.mp3", 70, 100, 1, CHAN_AUTO )    
							v:GetPhysicsObject():SetVelocity(ply:GetForward() * 600 + Vector(0,0,-400))  
						end 
					else 
						if v:GetPos():WithinAABox( pos1, pos2 ) then
							ply:ChatPrint("Can't spike ball over other team area!")
						else 
							ply:EmitSound("spike.mp3", 70, 100, 1, CHAN_AUTO )    
							v:GetPhysicsObject():SetVelocity(ply:GetForward() * 600 + Vector(0,0,-400))  
						end 
					end 
					--ply:SetVelocity( ply:GetAimVector() * 1000 )  
				end
				ply:LagCompensation( false )
			end 
		end
	end 		
end)


util.AddNetworkString("libero_stats")
net.Receive ("libero_stats" , function(bits , ply )      
	hook.Remove("PlayerButtonUp","meg_ability",function(ply,button) end) 
	hook.Remove("PlayerButtonDown" , "survivor_ability2" , function(ply,button)  end)
	hook.Remove("PlayerButtonDown" , "survivor_ability" , function(ply,button)  end)  
	hook.Remove("PlayerButtonDown" , "survivor_ability3" , function(ply,button)  end) 
	ply:UnSpectate()  
	ply:SetTeam(11)      
	ply:SetHealth(2000)      
	ply:SetWalkSpeed(180)       
	ply:SetRunSpeed(330)  
	ply:SetJumpPower(220)   
	ply:SetModel("models/player/fin/male_02.mdl") 
end)

util.AddNetworkString("save_ball")
net.Receive ("save_ball" , function(bits , ply )   
	--ply:ChatPrint("Used Save Ball")  
	local ent =  ents.FindByClass( "prop_*" )
	for k, v in pairs( ent ) do  
		if ply:GetPos():Distance( v:GetPos() ) < 100 then  
			ply:LagCompensation( true )
			ply:EmitSound("receive.mp3", 70, 100, 1, CHAN_AUTO )
			--v:SetVelocity(v:GetForward() * 500 + Vector(0,0,1000))  
			if(v:GetName() =='volleyball1') then   
					v:GetPhysicsObject():SetVelocity(ply:GetForward() * 100 + Vector(0,0,800))   
				--ply:SetVelocity( ply:GetAimVector() * 1000 )  
			end
			ply:LagCompensation( false )
		end 
	end
end)




util.AddNetworkString("libero_ability") 
net.Receive ("libero_ability" , function(bits , ply ) 
	ply:SetVelocity(ply:GetForward() * 1200 ) 
end) 

util.AddNetworkString("spectate_menu")
util.AddNetworkString("spectate_system")

 --[[local entNum = 1 
 net.Receive ("spectate_system" , function(bits , ply )
	PrintMessage(HUD_PRINTTALK,ply:Nick().." is spectating.")
	PrintMessage(HUD_PRINTTALK,"Remember: Spectate only works if you have players in it :) , Left Click to switch")
	ply:Spectate( OBS_MODE_IN_EYE)
	hook.Add("PlayerButtonDown" , "SpectateEntity" , function(ply,button)
		if (button == MOUSE_LEFT) then
			entNum = entNum+1
			ply:SpectateEntity( Entity(entNum) )
			if (entNum > #player.GetAll()) then
				entNum = 0 
				--ply:SpectateEntity( Entity(entNum) ) 
			end	
		end
	end)
	--ply:SetObserverMode( OBS_MODE_CHASE)
	--ply:SetMoveType(MOVETYPE_NOCLIP)	
end)]]


--- selected system 
local simon_count = 0 
local meg_count = 0 
local fbi_count = 0 
local hideo_count = 0

local libero_count = 0 
local serveking_count = 0 
local ace_count = 0  
util.AddNetworkString("check_system")
util.AddNetworkString("simon_selected")
util.AddNetworkString("simon_selected_cl") 
util.AddNetworkString("meg_selected")
util.AddNetworkString("meg_selected_cl")
util.AddNetworkString("fbi_selected")
util.AddNetworkString("fbi_selected_cl")

util.AddNetworkString("libero_selected")    
util.AddNetworkString("libero_selected_cl")
util.AddNetworkString("serveking_selected")    
util.AddNetworkString("serveking_selected_cl")
util.AddNetworkString("ace_selected")    
util.AddNetworkString("ace_selected_cl") 

net.Receive ("check_system" , function(bits , ply )
	-- Survivors 
	if simon_count > 0 then 
		for k,v in pairs(player.GetAll()) do 
			net.Start("simon_selected_cl")  
			net.Send(v)
		end 
	end 
	if meg_count > 0 then 
		for k,v in pairs(player.GetAll()) do 
			net.Start("meg_selected_cl")   
			net.Send(v)
		end 
	end 
	if fbi_count > 0 then 
		for k,v in pairs(player.GetAll()) do 
			net.Start("fbi_selected_cl")   
			net.Send(v)
		end 
	end 





	if libero_count > 0 then 
		for k,v in pairs(player.GetAll()) do 
			net.Start("libero_selected_cl")    
			net.Send(v)
		end 
	end 

	if serveking_count > 0 then 
		for k,v in pairs(player.GetAll()) do 
			net.Start("serveking_selected_cl")   
			net.Send(v)
		end 
	end 
 
	if ace_count > 0 then 
		for k,v in pairs(player.GetAll()) do 
			net.Start("ace_selected_cl")   
			net.Send(v)
		end 
	end 
end) 

net.Receive ("simon_selected" , function(bits , ply )
	simon_count=simon_count+1 
end) 

net.Receive ("meg_selected" , function(bits , ply ) 
	meg_count=meg_count+1 
end)

net.Receive ("fbi_selected" , function(bits , ply )
	fbi_count=fbi_count+1  
end)






net.Receive ("libero_selected" , function(bits , ply )
	libero_count=libero_count+1  
end)

net.Receive ("serveking_selected" , function(bits , ply )
	serveking_count=serveking_count+1 
end) 

net.Receive ("ace_selected" , function(bits , ply ) 
	ace_count=ace_count+1 
end)
