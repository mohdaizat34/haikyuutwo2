 util.AddNetworkString("communication")
 util.AddNetworkString("colored_message")

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