function KenmaDump(setForce)
	ply = LocalPlayer() 
	local pb_left = 0  
	local leftpower = 0 
	local leftbuttonpress = 0 

	local pb_right = 0  
	local rightpower = 0 
	local rightbuttonpress = 0 
	local on_cd = false 

	
	-- hook.Add("PlayerButtonDown","cd_detection",function(ply,button) 
	-- 	if button == KEY_R then 
	-- 		on_cd = true 
	-- 		timer.Simple(2,function() on_cd = false end)
	-- 	elseif button == KEY_T then
	-- 		on_cd = true 
	-- 		timer.Simple(2,function() on_cd = false end)
	-- 	end 
	-- end)

	hook.Add( "Tick", "keydownkenma", function()

		local keySettingR,keySettingT 

		if allow_left_assist == false then
			keySettingR = KEY_R
			keySettingT = KEY_T
		else 
			keySettingR = KEY_LBRACKET
			keySettingT = KEY_SEMICOLON
		end

		if (input.IsButtonDown(keySettingR)) then
			
			leftbuttonpress = 1 
			--MainFrame2:SetVisible(true)
			leftpower = leftpower + 1 
			pb_left = pb_left + 0.04 
			DProgress:SetFraction( pb_left )
		

		else 
			if leftbuttonpress == 0 then 

			elseif leftbuttonpress == 1 then 
				leftbuttonpress = 0 
				--MainFrame2:SetVisible(false)
				if leftpower < setForce then 
					if on_cd == false then
						KenmaSendToServer("back","soft")
						on_cd = true 
						timer.Simple(2,function() on_cd = false end)
						leftpower = 0
						pb_left = 0 
						DProgress:SetFraction( pb_left )  
						print( "reset" )
					end 

				else 
					if on_cd == false then 
						KenmaSendToServer("back","power")
						--chat.AddText("Left Cut")
						on_cd = true 
						timer.Simple(2,function() on_cd = false end)
						leftpower = 0  
						pb_left = 0 
						DProgress:SetFraction( pb_left ) 
						print( "reset" )
					end 
				end  
				leftpower = 0
				pb_left = 0 
				DProgress:SetFraction( pb_left )  
			end 
		end  



		if (input.IsButtonDown(keySettingT)) then
			rightbuttonpress = 1 
			--MainFrame2:SetVisible(true)
			rightpower = rightpower + 1 
			pb_right = pb_right + 0.04 
			DProgress:SetFraction( pb_right )

		else 
			if rightbuttonpress == 0 then 

			elseif rightbuttonpress == 1 then 
				rightbuttonpress = 0 
				--MainFrame2:SetVisible(false)
				if rightpower < setForce then 
					if on_cd == false then
						KenmaSendToServer("front","soft")
						on_cd = true 
						timer.Simple(2,function() on_cd = false end)
						--chat.AddText("Front Dump")
						rightpower = 0
						pb_right = 0 
						DProgress:SetFraction( pb_right )  
						print( "reset" )
					end 		
				else 
					if on_cd == false then
						KenmaSendToServer("front","power")
						--chat.AddText("Front Dumpt")
						on_cd = true 
						timer.Simple(2,function() on_cd = false end)
						rightpower = 0  
						pb_right = 0 
						DProgress:SetFraction( pb_right ) 
						print( "reset" )
					end
				end  
				rightpower = 0
				pb_right = 0 
				DProgress:SetFraction( pb_right )  
			end 
		end  
	end) 
end  

function KenmaSendToServer(direction,power)  
	if ply:GetPos():WithinAABox( pos1, pos2 ) then
		position = "left"
	else 
		position = "right"
	end 
	
	net.Start("kenma_dump")
	net.WriteString(position)
	net.WriteString(direction)
	net.WriteString(power)
	net.SendToServer()
end




