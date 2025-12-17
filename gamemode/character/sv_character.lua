util.AddNetworkString("character_select")
util.AddNetworkString("changeteam")
util.AddNetworkString("team_get_players_cl")

local jumpAdd = 60
korai_jump = 350+jumpAdd
korai_boost_jump = 395+jumpAdd

net.Receive ("changeteam" , function(bits , ply )
	local teams = net.ReadString() 
	local character = net.ReadString() 

	for k,v in pairs (player.GetAll()) do 
		v:ChatPrint(ply:Nick().." has changed to Team "..teams)
	end 

		--ply:ConCommand("cl_playermodel  ")
	if teams == "blue" then 
		ply:SetTeam(1)
		player_team = team.GetPlayers(ply:Team())
	else 
		ply:SetTeam(2)
		player_team = team.GetPlayers(ply:Team())
	end 
end) 

function CharStats(ply,runspeed,jump)  
	--ply:ConCommand("pac_wear_parts volleyball")
	--ply:ConCommand("pac_editor")
	ply:SetHealth(5000) 
	ply:SetRunSpeed(runspeed) 
	ply:SetJumpPower(jump) 
	ply:SetWalkSpeed(160)
	--ply:SetModel("models/player/summermilitary/male_02.mdl")  
end 



// CharStats(ply,runspeed,jump)  
net.Receive ("character_select" , function(bits , ply )
	--ply:Kill() 
	ply:ConCommand("sv_playermodel_selector_instantly 1")
	--ply:ConCommand("playermodel_selector")
	-- ply:ConCommand("pac_allow_mdl 0")
	-- ply:ConCommand("pac_modifier_model 0")
	timer.Simple(10,function()
		ply:ConCommand("pac_wear_parts") 
	end) 

	ply:AddEFlags(  EFL_NO_DAMAGE_FORCES )
	ply:SetCustomCollisionCheck( true )
	ply:SetFOV(100)
	--ply:SetViewOffset( Vector( 994.060242, -179.835449, 89.400787) )
	--ply:SetCurrentViewOffset( Vector( 994.060242, -179.835449, 89.400787) )
	--ply:SetViewOffset(Vector(0,0,60) )
	for k,v in pairs(player.GetAll()) do
  	  	ply:SetViewOffsetDucked(Vector(0,0,70) )
	end 

	 local ent =  ents.FindByClass( "prop_physics*" )
	for k, v in pairs( ent ) do   
		v:SetCollisionGroup( COLLISION_GROUP_WORLD)
	end 

	local character = net.ReadString() 
	--ply:SetFOV( 90, 0, self )
	for k,v in pairs (player.GetAll()) do 
		v:ChatPrint(ply:Nick().." has changed to "..character)
	end 

	if character == "hinata" then
		CharStats(ply,400,350+jumpAdd) 
		ply:SetModel("models/haikyuu/male/hinata2.mdl")
		ply:ConCommand("cl_playermodel Hinata Shoyo V2") 
		ply:ConCommand("playermodel_apply") 

	elseif character == "kage" then 
		CharStats(ply,320,308+jumpAdd)
		ply:SetModel("models/haikyuu/male/kageyama2.mdl")  
		ply:ConCommand("cl_playermodel Kageyama Tobio V2")
		ply:ConCommand("playermodel_apply")

	elseif character == "miya" then 
		CharStats(ply,320,308+jumpAdd)
		ply:SetModel("models/player/summermilitary/male_02.mdl")
		ply:ConCommand("cl_playermodel Miya Atsumu") 
		ply:ConCommand("playermodel_apply")

	elseif character == "ushi" then 
		CharStats(ply,280,315+jumpAdd)
		ply:SetModel("models/player/summermilitary/male_02.mdl") 
		ply:ConCommand("cl_playermodel Wakatoshi Ushijima")
		ply:ConCommand("playermodel_apply")

	elseif character == "nishi" then 
		CharStats(ply,340,320) 
		ply:SetWalkSpeed(290)
		ply:ConCommand("cl_playermodel Yu Nishinoya")
		ply:ConCommand("playermodel_apply")
		
	elseif character == "yama" then 
		CharStats(ply,300,315+jumpAdd)
		ply:SetModel("models/player/summermilitary/male_02.mdl") 
		ply:ConCommand("cl_playermodel Tadashi Yamaguchi")
		ply:ConCommand("playermodel_apply") 

	elseif character == "bokuto" then 
		CharStats(ply,280,315+jumpAdd)
		ply:SetModel("models/player/summermilitary/male_02.mdl") 
		ply:ConCommand("cl_playermodel Kotaro Bokuto")
		ply:ConCommand("playermodel_apply")

	elseif character == "kenma" then 
		CharStats(ply,320,290+jumpAdd)
		ply:SetModel("models/player/summermilitary/male_02.mdl") 
		ply:ConCommand("cl_playermodel Kenma Kozume")
		ply:ConCommand("playermodel_apply")

	elseif character == "tsuki" then 
		CharStats(ply,300,300+jumpAdd)
		ply:SetModel("models/player/summermilitary/male_02.mdl") 
		ply:ConCommand("cl_playermodel Kei Tsukishima")
		ply:ConCommand("playermodel_apply")

	elseif character == "korai" then 
		CharStats(ply,280,korai_jump+jumpAdd)
		ply:SetModel("models/player/summermilitary/male_02.mdl") 
		ply:ConCommand("cl_playermodel Hoshiumi Korai")
		ply:ConCommand("playermodel_apply")

	elseif character == "kuro" then 
		CharStats(ply,280,300+jumpAdd)
		ply:SetModel("models/player/summermilitary/male_02.mdl") 
		ply:ConCommand("cl_playermodel Tetsurō Kuroo")
		ply:ConCommand("playermodel_apply")
		print(ply:GetModel())

	elseif character == "sakusa" then 
		CharStats(ply,280,300+jumpAdd)
		ply:SetModel("models/player/summermilitary/male_02.mdl") 
		ply:ConCommand("cl_playermodel Kiyoomi Sakusa")
		ply:ConCommand("playermodel_apply")
		print(ply:GetModel())

	elseif character == "ref" then 
		CharStats(ply,340,380)
		ply:SetWalkSpeed(300)
		ply:SetModel("models/player/eric_summer/male_06.mdl")
		ply:SetModel("models/player/fin/male_02.mdl")
		ply:ConCommand("cl_playermodel Referee Chan")
		ply:ConCommand("playermodel_apply")
		print(ply:GetModel())
	end 

end) 