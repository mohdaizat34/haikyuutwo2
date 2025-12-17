print("Mechanic")
hook.Remove( "Tick", "KeyDown_Testis", function() end)
hook.Remove( "Tick", "KeyDown_Tests", function() end) 
hook.Remove( "Tick", "KeyDown_Toss", function() end)
hook.Remove("PlayerButtonDown","miya_serve",function(ply,button) end) 
hook.Remove( "Tick", "Kage_toss", function() end) 
hook.Remove( "Tick", "KeyDown_Toss2", function() end)
--hook.Remove( "Tick", "KeyDown_Test", function() end)  
--hook.Remove( "PlayerButtonUp", "ButtonUpWikiExample", function( ply, button ) end) 


local MainFrame2 = vgui.Create("DFrame")  
MainFrame2:SetSize(1366,768)
MainFrame2:SetTitle("This gamemode is created by Hope")
MainFrame2:SetVisible(false) 
MainFrame2:SetBackgroundBlur( false ) 
MainFrame2:ShowCloseButton(false)  
MainFrame2:Center()
--MainFrame2:MakePopup()
MainFrame2.Paint = function( self, w, h ) -- 'function Frame:Paint( w, h )' works too
draw.RoundedBox( 0, 0, 0, w, h, Color( 0,0,0,0) ) -- Draw a black box instead of the frame
end

local TopPanel = vgui.Create( "DPanel", MainFrame2 )       
TopPanel:Dock(TOP) 
TopPanel:SetSize(200,100)       
TopPanel.Paint = function( self, w, h )    
draw.RoundedBox( 0, 0, 0, w, h, Color( 0,0,0,0) ) -- Draw a black box instead of the frame
end

local FillPanel = vgui.Create( "DPanel", MainFrame2 )       
FillPanel:Dock(FILL)
FillPanel:SetSize(1366,1366)   
FillPanel.Paint = function( self, w, h )    
draw.RoundedBox( 0, 0, 0, w, h, Color( 0,0,0,0) ) -- Draw a black box instead of the frame
end

local LeftPanel = vgui.Create( "DScrollPanel", MainFrame2 )       
LeftPanel:Dock(LEFT)
LeftPanel:SetSize(500,0)   
LeftPanel.Paint = function( self, w, h )    
draw.RoundedBox( 0, 0, 0, w, h, Color( 0,0,0,0) ) -- Draw a black box instead of the frame
end

local RightPanel = vgui.Create( "DScrollPanel", MainFrame2 )       
RightPanel:Dock(RIGHT)
RightPanel:SetSize(500,0)   
RightPanel.Paint = function( self, w, h )    
draw.RoundedBox( 0, 0, 0, w, h, Color( 0,0,0,0) ) -- Draw a black box instead of the frame
end

local BottomPanel = vgui.Create( "DPanel", MainFrame2 )       
BottomPanel:Dock(BOTTOM)
BottomPanel:SetSize(1366,100)   
BottomPanel.Paint = function( self, w, h )    
draw.RoundedBox( 0, 0, 0, w, h, Color( 0,0,0,0) ) -- Draw a black box instead of the frame
end

local DProgress = vgui.Create( "DProgress",BottomPanel )
DProgress:Dock(TOP)
DProgress:SetSize( 400, 30 )
DProgress:SetFraction( 0 )
--DProgress:SetVisible(false)

local ball_detect = vgui.Create( "DButton", BottomPanel ) 
ball_detect:Dock(TOP)  
ball_detect:SetText("OUT OF RANGE")
ball_detect:SetTextColor(Color(0,0,0))     
ball_detect:SetSize(64, 64)  
ball_detect:DockMargin( 0, 5 , 0, 0 )         
ball_detect:SetFont("tiny") 
ball_detect.Paint = function( self, w, h ) -- 'function Frame:Paint( w, h )' works too 	
	draw.RoundedBox( 255, 0, 0, w, h, Color( 0,0,0,0) )
end


 pos3 = Vector(1323.512085, -209.445648, -150.328781)
 pos4 = Vector(590.920776, 313.469574, 388.779938)  

-- left side (see from reset button)
 pos1 = Vector(  1419.853394, 866.308411, -165.108414)  
 pos2 = Vector(  602.493164, 332.357361, 398.086914)  


position = ""


function BlockSendToServer(powertype)  
	if ply:GetPos():WithinAABox( pos1, pos2 ) then
		position = "left"
	else 
		position = "right"
	end 
	net.Start("block_power")
	net.WriteString(position)
	net.WriteString(powertype)
	net.SendToServer()
end


function SpikeSendToServer(powertype,spikepower)  
	if ply:GetPos():WithinAABox( pos1, pos2 ) then
		position = "left"
	else 
		position = "right"
	end 
	net.Start("spike_power_hinata")
	net.WriteString(position)
	net.WriteString(powertype)
	net.WriteInt(spikepower,32)
	net.SendToServer()
end 

function ReceiveSendToServer(powertype)  
	if ply:GetPos():WithinAABox( pos1, pos2 ) then
		position = "left"
	else 
		position = "right"
	end 
	net.Start("receive_power")
	net.WriteString(position)
	net.WriteString(powertype)
	net.SendToServer()
end 

function TossSendToServer(powertype,frontback)  
	if ply:GetPos():WithinAABox( pos1, pos2 ) then
		position = "left"
	else 
		position = "right"
	end 
	net.Start("toss_power")
	net.WriteString(position)
	net.WriteString(powertype)
	net.WriteString(frontback)
	net.SendToServer()
end



local shouldOccur3 = true  
local delay3 = 1 
local meg_cd2=1 

function DiveSendToServer(powertype)  
	if ply:GetPos():WithinAABox( pos1, pos2 ) then
		position = "left"
	else 
		position = "right"
	end 
	if shouldOccur3 then 
		meg_cd = 64 
		net.Start("dive_power")
		net.WriteString(position)
		net.WriteString(powertype)
		net.SendToServer()

		timer.Create("stopmovement",1,1,function() 
			--[[net.Start("dive_power")
			net.WriteString(position)
			net.WriteString(powertype)
			net.WriteString("stop")
			net.SendToServer("")]]

			net.Start("revertspeed")
			net.WriteString("libero")
			net.SendToServer()
		end)

		ply:PrintMessage( HUD_PRINTTALK, "You used your ability" )
		shouldOccur3 = false   
		timer.Create("meg_cd2",1,1,function() meg_cd2=meg_cd2-1  end) 
		timer.Simple( delay3, function() shouldOccur3 = true end )
	else
		ply:PrintMessage( HUD_PRINTTALK, "Cooldown!" )
	end     
end 



function BasicServe()
	 miya_pos1 = Vector(1300.494019, -261.572266, -119.701813) 
	 miya_pos2 = Vector(670.607239, -30.208231, 199.167160) 
	 miya_pos3 = Vector( 676.425293 ,888.083191, -108.272842) 
	 miya_pos4 = Vector(1375.196899, 661.645447, 262.988831)  

	hook.Remove("PlayerButtonDown","basic_serve2",function(ply,button) end) 

	hook.Add("PlayerButtonDown","basic_serve2",function(ply,button)

		if button == MOUSE_RIGHT then 
			if  ply:GetPos():WithinAABox( miya_pos1, miya_pos2 ) or ply:GetPos():WithinAABox( miya_pos3, miya_pos4)  then 
				net.Start("basic_serve")
				net.SendToServer()
				--hook.Remove("PlayerButtonDown","miya_serve2",function() end) 
				BasicServe()
			else 
				hook.Remove("PlayerButtonDown","basic_serve2",function() end)
				chat.AddText("Not in area to use serve.")
				BasicServe()
			end 
		end 
	end) 	
end  



--ABILITY 

function KageSendToServer(powertype,frontback,tosstype)  
	if ply:GetPos():WithinAABox( pos1, pos2 ) then
		position = "left"
	else 
		position = "right"
	end 
	net.Start("kage_toss_ability")
	net.WriteString(position)
	net.WriteString(powertype)
	net.WriteString(frontback)
	net.WriteString(tosstype)
	net.SendToServer()
end 

function KageQuickToss(setForce)
	powertossbarkage2 = 0  
	powertosskage2 = 0 
	buttonpresstosskage2 = 0

	hook.Add( "Tick", "Kage_toss2", function()
		if (input.IsButtonDown(KEY_T)) then
			buttonpresstosskage2 = 1 
			MainFrame2:SetVisible(true)
			powertosskage2 = powertosskage2 + 1 
			powertossbarkage2 = powertossbarkage2 + 0.04 
			DProgress:SetFraction( powertossbarkage2 )
			print( "Player is charging receive power! Power: ".. powertossbarkage2 )

		else 
			if buttonpresstosskage2 == 0 then 

			elseif buttonpresstosskage2 == 1 then 
				buttonpresstosskage2 = 0 
				MainFrame2:SetVisible(false)
				if powertosskage2 <= setForce then 
				
					KageSendToServer("weak","front","quick")
					chat.AddText("Short Toss!")
					powertosskage2 = 0
					powertossbarkage2 = 0 
					DProgress:SetFraction( powertossbarkage2 )  
					print( "reset" )

				elseif powertosskage2 < 20 then 
					KageSendToServer("medium","front","quick")
					chat.AddText("Medium Toss!")
					powertosskage2 = 0  
					powertossbarkage2 = 0 
					DProgress:SetFraction( powertossbarkage2 ) 
					print( "reset" )

				else 
					KageSendToServer("high","front","quick")
					chat.AddText("Power Toss!")
					powertosskage2 = 0  
					powertossbarkage2 = 0 
					DProgress:SetFraction( powertossbarkage2 ) 
					print( "reset" )
				end  
				powertosskage2 = 0
				powertossbarkage2 = 0 
				DProgress:SetFraction( powertossbarkage2 )  
			end 
		end 
	end)
end 

function KageFrontToss(setForce)
	powertossbarkage = 0  
	powertosskage = 0 
	buttonpresstosskage = 0  

	powertossbarkage2 = 0  
	powertosskage2 = 0 
	buttonpresstosskage2 = 0

	hook.Add( "Tick", "Kage_toss", function()
		if (input.IsButtonDown(KEY_R)) then
			buttonpresstosskage = 1 
			MainFrame2:SetVisible(true)
			powertosskage = powertosskage + 1 
			powertossbarkage = powertossbarkage + 0.04  
			DProgress:SetFraction( powertossbarkage )
			print( "Player is charging receive power! Power: ".. powertosskage )

		else 
			if buttonpresstosskage == 0 then 

			elseif buttonpresstosskage == 1 then 
				buttonpresstosskage = 0 
				MainFrame2:SetVisible(false)
				if powertosskage <= setForce then 
				
					KageSendToServer("weak","front","king")
					chat.AddText("Short Toss!")
					powertosskage = 0
					powertossbarkage = 0 
					DProgress:SetFraction( powertossbarkage )  
					print( "reset" )

				elseif powertosskage < 20 then 
					KageSendToServer("medium","front","king")
					chat.AddText("Medium Toss!")
					powertosskage = 0  
					powertossbarkage = 0 
					DProgress:SetFraction( powertossbarkage ) 
					print( "reset" )

				else 
					KageSendToServer("high","front","king")
					chat.AddText("Power Toss!")
					powertosskage = 0  
					powertossbarkage = 0 
					DProgress:SetFraction( powertossbarkage ) 
					print( "reset" )
				end  
				powertosskage = 0
				powertossbarkage = 0 
				DProgress:SetFraction( powertossbarkage )  
			end 
		end 
	end)

end 

function CutSendToServer(direction,power)  
	if ply:GetPos():WithinAABox( pos1, pos2 ) then
		position = "left"
	else 
		position = "right"
	end 
	net.Start("bokuto_cut")
	net.WriteString(position)
	net.WriteString(direction)
	net.WriteString(power)
	net.SendToServer()
end

function MiyaServe()
	 miya_pos1 = Vector(1300.494019, -261.572266, -119.701813) 
	 miya_pos2 = Vector(670.607239, -30.208231, 199.167160) 
	 miya_pos3 = Vector( 676.425293 ,888.083191, -108.272842) 
	 miya_pos4 = Vector(1375.196899, 661.645447, 262.988831) 

	 miya_active = false 

	
	hook.Add("PlayerButtonDown","miya_serve",function(ply,button)
			--[[if button == KEY_R then
			if  ply:GetPos():WithinAABox( miya_pos1, miya_pos2 ) or ply:GetPos():WithinAABox( miya_pos3, miya_pos4)  then 
				--net.Start("check_miya_position")
				--net.SendToServer() 
				chat.AddText(Color(255,0,0),"Wait for 3 seconds to use yamaguchi float serve.")

				hook.Remove("PlayerButtonDown","yama_serve",function(ply,button) end) 
				hook.Remove( "Tick", "KeyDown_Toss", function() end )


				timer.Create("yama_cd",3,1,function() 
					hook.Add("PlayerButtonDown","yama_serve2",function(ply,button)
						if button == KEY_R then
							if  ply:GetPos():WithinAABox( miya_pos1, miya_pos2 ) or ply:GetPos():WithinAABox( miya_pos3, miya_pos4)  then 
								net.Start("yama_ability")
								net.WriteString("tossup")
								net.SendToServer()
							else 
								hook.Remove("PlayerButtonDown","yama_serve2",function() end) 
								YamaguchiServe()
							end 
						end 

						if button == KEY_T then 
							if  ply:GetPos():WithinAABox( miya_pos1, miya_pos2 ) or ply:GetPos():WithinAABox( miya_pos3, miya_pos4)  then 
								net.Start("yama_ability")
								net.WriteString("spike")
								net.SendToServer()
								--hook.Remove("PlayerButtonDown","miya_serve2",function() end) 
								YamaguchiServe()
								--TossPower(10)
							else 
								hook.Remove("PlayerButtonDown","yama_serve2",function() end)
								YamaguchiServe() 
								--MiyaServe()
							end 
						end 
					end) 
				end) 
			end 
	
			--hook.Remove("PlayerButtonDown","miya_serve",function(ply,button) end) 

		else 
			--hook.Remove("PlayerButtonDown","miya_serve2",function(ply,button) end) 
		end 


	end)]]
		if  ply:GetPos():WithinAABox( miya_pos1, miya_pos2 ) or ply:GetPos():WithinAABox( miya_pos3, miya_pos4)  then 
			if button == KEY_R then

				net.Start("check_miya_position")
				net.SendToServer() 
				chat.AddText(Color(255,0,0),"Miya Serve is active")

				hook.Remove("PlayerButtonDown","miya_serve",function(ply,button) end) 
				hook.Remove( "Tick", "KeyDown_Toss", function() end )
				hook.Remove( "Tick", "Kage_toss2", function() end)

				hook.Add("PlayerButtonDown","miya_serve2",function(ply,button)
					if button == KEY_R then
						if  ply:GetPos():WithinAABox( miya_pos1, miya_pos2 ) or ply:GetPos():WithinAABox( miya_pos3, miya_pos4)  then 
							net.Start("miya_ability")
							net.WriteString("tossup")
							net.SendToServer()

						else 
							hook.Remove("PlayerButtonDown","miya_serve2",function() end) 
							MiyaServe()
							--KageQuickToss()
						end 
					end 

					if button == KEY_T then 
						if  ply:GetPos():WithinAABox( miya_pos1, miya_pos2 ) or ply:GetPos():WithinAABox( miya_pos3, miya_pos4)  then 
							net.Start("miya_ability")
							net.WriteString("spike")
							net.SendToServer()
							hook.Remove("PlayerButtonDown","miya_serve2",function() end) 
							hook.Remove( "Tick", "KeyDown_Toss", function() end )
							hook.Remove( "Tick", "Kage_toss2", function() end)
							MiyaServe()
							timer.Create("re",1,1,function() 
								chat.AddText("Set is now usable")
								TossPower(10)
								KageQuickToss(10)
								timer.Stop("re")
							end) 
						
						else 
							--hook.Remove("PlayerButtonDown","miya_serve2",function() end)
							--TossPower(10)
							--KageQuickToss(10)
							hook.Remove("PlayerButtonDown","miya_serve2",function() end)
							MiyaServe()
							TossPower(10)
							KageQuickToss(10)							
						end 
					end 
				end) 
			end 
	
			--hook.Remove("PlayerButtonDown","miya_serve",function(ply,button) end) 

		else 
			--hook.Remove("PlayerButtonDown","miya_serve2",function(ply,button) end) 
		end 


	end)
end 


function BokutoSpike(setForce)
	ply = LocalPlayer() 
	pb_left = 0  
	leftpower = 0 
	leftbuttonpress = 0 

	pb_right = 0  
	rightpower = 0 
	rightbuttonpress = 0 


	
	hook.Add( "Tick", "keydownboku", function()

		if (input.IsButtonDown(KEY_R)) then
			leftbuttonpress = 1 
			MainFrame2:SetVisible(true)
			leftpower = leftpower + 1 
			pb_left = pb_left + 0.04 
			DProgress:SetFraction( pb_left )
			print( "Player is charging spike power! Power: ".. leftpower )

		else 
			if leftbuttonpress == 0 then 

			elseif leftbuttonpress == 1 then 
				leftbuttonpress = 0 
				MainFrame2:SetVisible(false)
				if leftpower < setForce then 
					CutSendToServer("left","soft")
					chat.AddText("Left Cut")
					leftpower = 0
					pb_left = 0 
					DProgress:SetFraction( pb_left )  
					print( "reset" )

				else 
					CutSendToServer("left","power")
					chat.AddText("Left Cut")
					leftpower = 0  
					pb_left = 0 
					DProgress:SetFraction( pb_left ) 
					print( "reset" )
				end  
				leftpower = 0
				pb_left = 0 
				DProgress:SetFraction( pb_left )  
			end 
		end  



		if (input.IsButtonDown(KEY_T)) then
			rightbuttonpress = 1 
			MainFrame2:SetVisible(true)
			rightpower = rightpower + 1 
			pb_right = pb_right + 0.04 
			DProgress:SetFraction( pb_right )
			print( "Player is charging spike power! Power: ".. rightpower )

		else 
			if rightbuttonpress == 0 then 

			elseif rightbuttonpress == 1 then 
				rightbuttonpress = 0 
				MainFrame2:SetVisible(false)
				if rightpower < setForce then 
					CutSendToServer("right","soft")
					chat.AddText("Right Cut")
					rightpower = 0
					pb_right = 0 
					DProgress:SetFraction( pb_right )  
					print( "reset" )

				else 
					CutSendToServer("right","power")
					chat.AddText("Right Cut")
					rightpower = 0  
					pb_right = 0 
					DProgress:SetFraction( pb_right ) 
					print( "reset" )
				end  
				rightpower = 0
				pb_right = 0 
				DProgress:SetFraction( pb_right )  
			end 
		end  
	end) 
end 

-- yamaguchi 
function YamaguchiServe()
	 miya_pos1 = Vector(1300.494019, -261.572266, -119.701813) 
	 miya_pos2 = Vector(670.607239, -30.208231, 199.167160) 
	 miya_pos3 = Vector( 676.425293 ,888.083191, -108.272842) 
	 miya_pos4 = Vector(1375.196899, 661.645447, 262.988831) 

	 miya_active = false 

	
	hook.Add("PlayerButtonDown","yama_serve",function(ply,button)
		if button == KEY_R then
			if  ply:GetPos():WithinAABox( miya_pos1, miya_pos2 ) or ply:GetPos():WithinAABox( miya_pos3, miya_pos4)  then 
				--net.Start("check_miya_position")
				--net.SendToServer() 
				chat.AddText(Color(255,0,0),"Wait for 3 seconds to use yamaguchi float serve.")

				hook.Remove("PlayerButtonDown","yama_serve",function(ply,button) end) 
				hook.Remove( "Tick", "KeyDown_Toss", function() end )


				timer.Create("yama_cd",3,1,function() 
					hook.Add("PlayerButtonDown","yama_serve2",function(ply,button)
						if button == KEY_R then
							if  ply:GetPos():WithinAABox( miya_pos1, miya_pos2 ) or ply:GetPos():WithinAABox( miya_pos3, miya_pos4)  then 
								net.Start("yama_ability")
								net.WriteString("tossup")
								net.SendToServer()
							else 
								hook.Remove("PlayerButtonDown","yama_serve2",function() end) 
								YamaguchiServe()
							end 
						end 

						if button == KEY_T then 
							if  ply:GetPos():WithinAABox( miya_pos1, miya_pos2 ) or ply:GetPos():WithinAABox( miya_pos3, miya_pos4)  then 
								net.Start("yama_ability")
								net.WriteString("spike")
								net.SendToServer()
								--hook.Remove("PlayerButtonDown","miya_serve2",function() end) 
								YamaguchiServe()
								--TossPower(10)
							else 
								hook.Remove("PlayerButtonDown","yama_serve2",function() end)
								YamaguchiServe() 
								--MiyaServe()
							end 
						end 
					end) 
				end) 
			end 
	
			--hook.Remove("PlayerButtonDown","miya_serve",function(ply,button) end) 

		else 
			--hook.Remove("PlayerButtonDown","miya_serve2",function(ply,button) end) 
		end 


	end)
end 


-- BASIC 
function ReceivePower(setForce)
	ply = LocalPlayer() 
	powerreceivebar = 0  
	powerreceive = 0 
	--jumpcount = 0 
	buttonpressrec = 0 


	hook.Add( "Tick", "KeyDown_Testis", function()

		if (input.IsButtonDown(KEY_V)) then
			buttonpressrec = 1 
			MainFrame2:SetVisible(true)
			powerreceive = powerreceive + 1 
			powerreceivebar = powerreceivebar + 0.04  
			DProgress:SetFraction( powerreceivebar )
			print( "Player is charging receive power! Power: ".. powerreceivebar )

		else 
			if buttonpressrec == 0 then 

			elseif buttonpressrec == 1 then 
				buttonpressrec = 0 
				MainFrame2:SetVisible(false)
				if character == "nishinoya" then 
					if powerreceive < setForce then 
					
						ReceiveSendToServer("weak")
						chat.AddText("Short Receive!")
						powerreceive = 0
						powerreceivebar = 0 
						DProgress:SetFraction( powerreceivebar )  
						print( "reset" )

					elseif powerreceive < 20 then  
						ReceiveSendToServer("strong")
						chat.AddText("Long Receive!")
						powerreceive = 0  
						powerreceivebar = 0 
						DProgress:SetFraction( powerreceivebar ) 
						print( "reset" )
					else 
						ReceiveSendToServer("highball")
						chat.AddText("High ball Receive!")
						powerreceive = 0  
						powerreceivebar = 0 
						DProgress:SetFraction( powerreceivebar ) 
						print( "reset" )
					end   
				else 

					if powerreceive < setForce then 
					
						ReceiveSendToServer("weak")
						chat.AddText("Short Receive!")
						powerreceive = 0
						powerreceivebar = 0 
						DProgress:SetFraction( powerreceivebar )  
						print( "reset" )

					else 
						ReceiveSendToServer("strong")
						chat.AddText("Long Receive!")
						powerreceive = 0  
						powerreceivebar = 0 
						DProgress:SetFraction( powerreceivebar ) 
						print( "reset" )
					end  
				end 

				powerreceive = 0
				powerreceivebar = 0 
				DProgress:SetFraction( powerreceivebar )  
			end 
		end  
	end) 
end 


function TossPower(setForce)
	ply = LocalPlayer() 
	powertossbar = 0  
	powertoss = 0 
	--jumpcount = 0 
	buttonpresstoss = 0 


	
	hook.Add( "Tick", "KeyDown_Toss", function()

		if (input.IsButtonDown(KEY_C)) then
			buttonpresstoss = 1 
			MainFrame2:SetVisible(true)
			powertoss = powertoss + 1 
			powertossbar = powertossbar + 0.04  
			DProgress:SetFraction( powertossbar )
			print( "Player is charging receive power! Power: ".. powertossbar )

		else 
			if buttonpresstoss == 0 then 

			elseif buttonpresstoss == 1 then 
				buttonpresstoss = 0 
				MainFrame2:SetVisible(false)
				if powertoss <= setForce then 
				
					TossSendToServer("weak","front")
					chat.AddText("Short Toss!")
					powertoss = 0
					powertossbar = 0 
					DProgress:SetFraction( powertossbar )  
					print( "reset" )

				elseif powertoss < 20 then 
					TossSendToServer("medium","front")
					chat.AddText("Medium Toss!")
					powertoss = 0  
					powertossbar = 0 
					DProgress:SetFraction( powertossbar ) 
					print( "reset" )

				else 
					TossSendToServer("high","front")
					chat.AddText("High Toss!")
					powertoss = 0  
					powertossbar = 0 
					DProgress:SetFraction( powertossbar ) 
					print( "reset" )
				end  
				powertoss = 0
				powertossbar = 0 
				DProgress:SetFraction( powertossbar )  
			end 
		end 
	end) 
end 



function BackTossPower(setForce)
	powertossbar2 = 0  
	powertoss2 = 0 
	--jumpcount = 0 
	buttonpresstoss2 = 0  

	hook.Add( "Tick", "KeyDown_Toss2", function()
		if (input.IsButtonDown(KEY_F)) then
			buttonpresstoss2 = 1 
			MainFrame2:SetVisible(true)
			powertoss2 = powertoss2 + 1 
			powertossbar2 = powertossbar2 + 0.04  
			DProgress:SetFraction( powertossbar2 )
			print( "Player is charging receive power! Power: ".. powertossbar2 )

		else 
			if buttonpresstoss2 == 0 then 

			elseif buttonpresstoss2 == 1 then 
				buttonpresstoss2 = 0 
				MainFrame2:SetVisible(false)
				if powertoss2 <= setForce then 
				
					TossSendToServer("weak","back")
					chat.AddText("Short Toss!")
					powertoss2 = 0
					powertossbar2 = 0 
					DProgress:SetFraction( powertossbar2 )  
					print( "reset" )

				elseif powertoss2 < 20 then 
					TossSendToServer("medium","back")
					chat.AddText("Medium Toss!")
					powertoss2 = 0  
					powertossbar2 = 0 
					DProgress:SetFraction( powertossbar2 ) 
					print( "reset" )

				else 
					TossSendToServer("high","back")
					chat.AddText("High Toss!")
					powertoss2 = 0  
					powertossbar2 = 0 
					DProgress:SetFraction( powertossbar2 ) 
					print( "reset" )
				end  
				powertoss2 = 0
				powertossbar2 = 0 
				DProgress:SetFraction( powertossbar2 )  
			end 
		end 
	end)
end 



function BlockPower(setForce)
	ply = LocalPlayer() 
	pb_block = 0  
	blockpower = 0 
	blockbuttonpress = 0 


	
	hook.Add( "Tick", "keydownblock", function()

		if (input.IsButtonDown(KEY_Q)) then
			blockbuttonpress = 1 
			MainFrame2:SetVisible(true)
			blockpower = blockpower + 1 
			pb_block = pb_block + 0.04 
			DProgress:SetFraction( pb_block )
			print( "Player is charging spike power! Power: ".. blockpower )

		else 
			if blockbuttonpress == 0 then 

			elseif blockbuttonpress == 1 then 
				blockbuttonpress = 0 
				MainFrame2:SetVisible(false)
				if blockpower < setForce then 
					BlockSendToServer("soft")
					chat.AddText("Soft Block")
					blockpower = 0
					pb_block = 0 
					DProgress:SetFraction( pb_block )  
					print( "reset" )

				else 
					if character == "tsukishima" then 
						--BlockSendToServer("kill")
						--chat.AddText("Kill Block")
					else 
						BlockSendToServer("soft")
						chat.AddText("Soft Block")
					end 

					blockpower = 0  
					pb_block = 0 
					DProgress:SetFraction( pb_block ) 
					print( "reset" )
				end  
				blockpower = 0
				pb_block = 0 
				DProgress:SetFraction( pb_block )  
			end 
		end  
	end)

	if character == "tsukishima" then 
		hook.Add("PlayerButtonDown","KillBlock",function(ply,button)
			if button == KEY_R then 
				BlockSendToServer("kill")	
				chat.AddText("Kill Block")
			end 
		end) 
	end 
end 


function SpikePower(setForce,spikepower)
	ply = LocalPlayer() 
	powerbar = 0  
	power = 0 
	jumpcount = 0 
	buttonpress = 0 


	
	hook.Add( "Tick", "KeyDown_Tests", function()

		if (input.IsButtonDown(KEY_B)) then
			buttonpress = 1 
			MainFrame2:SetVisible(true)
			power = power + 1 
			powerbar = powerbar + 0.04 
			DProgress:SetFraction( powerbar )
			print( "Player is charging spike power! Power: ".. power )

		else 
			if buttonpress == 0 then 

			elseif buttonpress == 1 then 
				buttonpress = 0 
				MainFrame2:SetVisible(false)
				if power < setForce then 
				
					SpikeSendToServer("weak",spikepower) 
					power = 0
					powerbar = 0 
					DProgress:SetFraction( powerbar )  
					print( "reset" )

				else 
					SpikeSendToServer("strong",spikepower)
					chat.AddText("Strong Spike!")
					power = 0  
					powerbar = 0 
					DProgress:SetFraction( powerbar ) 
					print( "reset" )
				end  
				power = 0
				powerbar = 0 
				DProgress:SetFraction( powerbar )  
			end 
		end  
	end) 

	hook.Add("PlayerButtonDown","FakeSpike",function(ply,button) 
		if button == KEY_N then 
			net.Start("fake_spike")
			net.SendToServer() 
		end 
	end)
end 






function DivePower(setForce)
	ply = LocalPlayer() 
	pb_dive = 0  
	divepower = 0 
	divebuttonpress = 0 


	
	hook.Add( "Tick", "keydowndive", function()

		if (input.IsButtonDown(KEY_Q)) then
			divebuttonpress = 1 
			MainFrame2:SetVisible(true)
			divepower = divepower + 1 
			pb_dive = pb_dive + 0.04 
			DProgress:SetFraction( pb_dive )
			print( "Player is charging spike power! Power: ".. pb_dive )

		else 
			if divebuttonpress == 0 then 

			elseif divebuttonpress == 1 then 
				divebuttonpress = 0 
				MainFrame2:SetVisible(false)
				if divepower < setForce then 
					DiveSendToServer("short")
					chat.AddText("Short Dive")
					divepower = 0
					pb_dive = 0 
					DProgress:SetFraction( pb_dive )  
					print( "reset" )

				else 
					DiveSendToServer("long")
					chat.AddText("Long Dive")
					divepower = 0  
					pb_dive = 0 
					DProgress:SetFraction( pb_dive ) 
					print( "reset" )
				end  
				divepower = 0
				pb_dive = 0 
				DProgress:SetFraction( pb_dive )  
			end 
		end  
	end) 
end 









--[[hook.Add("Think", "pov", function()	 
		function ThirdPerson(ply, pos, angles, fov) local view = {} 
			view.origin = pos-(angles:Forward()*60) +  
	                            (angles:Right()*19) +    
	                                    (angles:Up()*0) 
	        view.angles = angles
	        view.fov = fov
	 
			return view 
		end
		
		hook.Add("CalcView", "ThirdPerson", ThirdPerson)
		hook.Add("ShouldDrawLocalPlayer", "ShouldDrawLocalPlayer", function(ply) return true end) 
		
	if (input.IsButtonDown(KEY_Q)) then	
		function ThirdPerson(ply, pos, angles, fov) local view = {}
		view.origin = pos-(angles:Forward()*57) +
                            (angles:Right()*-17) +  
                                    (angles:Up()*0) 
        view.angles = angles
        view.fov = fov
 
		return view
		end
		
		hook.Add("CalcView", "ThirdPerson", ThirdPerson)
		hook.Add("ShouldDrawLocalPlayer", "ShouldDrawLocalPlayer", function(ply) return true end)
	end	 
end)]]