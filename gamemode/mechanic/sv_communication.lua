 util.AddNetworkString("communication")
 util.AddNetworkString("colored_message")
 util.AddNetworkString("get_team_players")

 net.Receive ("get_team_players" , function(bits , ply )
	local playerTeam = net.ReadString() 
	player_team = team.GetPlayers(ply:Team())

	PrintTable(player_team)
	if playerTeam == "blue" then 
		net.Start("team_get_players_cl")
		net.WriteTable(player_team)
		net.Send(ply)
	else 
		net.Start("team_get_players_cl")
		net.WriteTable(player_team)
		net.Send(ply)
	end 
 end) 

 net.Receive ("communication" , function(bits , ply )
 	local message = net.ReadString() 

 	if ply:Team() == 1 then  
 		for k,v in pairs(team.GetPlayers(1)) do 
 			net.Start("colored_message")
 			net.WriteString(message)
 			net.Send(v)
 		end 
 	elseif ply:Team() == 2 then 
 		for k,v in pairs(team.GetPlayers(2)) do 
 			net.Start("colored_message")
 			net.WriteString(message)
 			net.Send(v)
 		end 
 	else 

 		--[[for k,v in pairs(player.GetAll()) do 
 			net.Start("colored_message")
 			net.WriteString(message)
 			net.Send(v)
 		end ]]
 	end  
 end) 