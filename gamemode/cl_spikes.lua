 --[[pos3 = Vector(-633.271851,-126.812737, -68.862015)
 pos4 = Vector( -164.485733, 314.784088, 246.235870)  

-- left side (see from reset button)
 pos1 = Vector( -134.029663, 764.290222,-71.224037)  
 pos2 = Vector(  -556.752686, 324.668060, 218.018539) ]]

hook.Add("PlayerButtonDown","spike",function(ply,button)
	if button == KEY_N then 
		if ply:GetPos():WithinAABox( pos1, pos2 ) then
			ply:LagCompensation(true)
			print("hellow world")
			net.Start("spike_type_long")    
			net.WriteString("left")  	 
			net.SendToServer()	 
			ply:LagCompensation(false)
		elseif ply:GetPos():WithinAABox( pos3, pos4 ) then
			ply:LagCompensation(true)
			print("hellow world")
			net.Start("spike_type_long")    
			net.WriteString("right")  	  
			net.SendToServer()	 
			ply:LagCompensation(false)
		end 
	end 
end)