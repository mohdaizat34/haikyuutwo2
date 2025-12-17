
--warmup delay system 
util.AddNetworkString("allow_warmup") 

print("setting open")

allow_delay = true 
--allow warmup ? 
net.Receive("allow_warmup",function(bits,ply)
	local allow_warmup = net.ReadBool() 
	if allow_warmup == true then 
		allow_delay = true 
	else 
		allow_delay = false  
	end 
	
	delay_status = tostring(allow_delay)
	for k,v in pairs(player.GetAll()) do 
		v:ChatPrint(v:Nick().." Turn the Delay System to: ".. delay_status)
	end 
end) 