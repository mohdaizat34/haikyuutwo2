
print("Detect sv_hud")
util.AddNetworkString("textPlayerPosition")
util.AddNetworkString("playerPositions")

 
net.Receive ("playerPositions" , function(bits , ply )
	for k,v in pairs(player.GetAll()) do 
		net.Start("textPlayerPosition")
		net.WriteEntity(v)
		net.Send(v)
	end 
end) 
