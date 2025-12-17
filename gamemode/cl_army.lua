

function SurvivorScreen2()
	--hook.Add("Think","check_selected",function() 
		--net.Start("check_system")
		--net.SendToServer() 
	--end)

	local MainFrame2 = vgui.Create("DFrame")
	MainFrame2:SetSize(1366,768)
	MainFrame2:SetTitle("This gamemode is created by Hope")
	MainFrame2:SetVisible(true) 
	MainFrame2:SetBackgroundBlur( true )
	MainFrame2:ShowCloseButton(true)  
	MainFrame2:Center()
	MainFrame2:MakePopup(true)
	MainFrame2.Paint = function( self, w, h ) -- 'function Frame:Paint( w, h )' works too
	draw.RoundedBox( 0, 0, 0, w, h, Color( 255,255,255,255) ) -- Draw a black box instead of the frame
	end

	function MainFrame2:Init()     
		self.startTime = SysTime() 
	end
	function MainFrame2:Paint()
		Derma_DrawBackgroundBlur( self, self.startTime)                
	end

	local TopPanel = vgui.Create( "DPanel", MainFrame2 )       
	TopPanel:Dock(TOP) 
	TopPanel:SetSize(200,200)       
	TopPanel.Paint = function( self, w, h )    
	draw.RoundedBox( 0, 0, 0, w, h, Color( 0,0,0,0) ) -- Draw a black box instead of the frame
	end

	local FillPanel = vgui.Create( "DScrollPanel", MainFrame2 )       
	FillPanel:Dock(FILL)
	FillPanel:SetSize(1366,1366)   
	FillPanel.Paint = function( self, w, h )    
	draw.RoundedBox( 0, 0, 0, w, h, Color( 0,0,0,0) ) -- Draw a black box instead of the frame
	end

	local back = vgui.Create( "DButton", TopPanel )       
	back:Dock(TOP)
	back:SetSize(100,100)   
	back:SetText("BACK")   
	back:SetTextColor(Color(255,255,255))                  
	back:DockMargin( 500, 0 , 0, 0 )     
	back:SetFont("tiny2") 
	--myer_button:SetImage("materials/stalk.gif")        
	back.Paint = function( self, w, h ) -- 'function Frame:Paint( w, h )' works too 
		draw.RoundedBox( 0, 0, 0, w, h, Color( 0,0,0,0) )      
	end 

	function back:DoClick() 
		MainFrame2:Close() 
		SelectScreen()
	end 

	local title = vgui.Create( "DLabel", TopPanel )       
	title:Dock(TOP)
	title:SetSize(100,100)   
	title:SetText("Choose a Position")   
	title:SetTextColor(Color(255,255,255))                  
	title:DockMargin( 500, 0 , 0, 0 )     
	title:SetFont("logo") 
	--myer_button:SetImage("materials/stalk.gif")        
	title.Paint = function( self, w, h ) -- 'function Frame:Paint( w, h )' works too 
		draw.RoundedBox( 0, 0, 0, w, h, Color( 0,0,0,0) )      
	end 


	local survivor_simon = vgui.Create( "DButton", FillPanel )      
	survivor_simon:Dock(TOP)    
	survivor_simon:SetSize(418, 418)      
	survivor_simon:SetText("WING SPIKER")   
	survivor_simon:SetTextColor(Color(255,255,255))   
	survivor_simon:SetFont("Big")         
	survivor_simon:DockMargin( 0, 30 , 0, 0 )              
	survivor_simon:SetImage("materials/ace.jpg")                 
	survivor_simon.Paint = function( self, w, h ) -- 'function Frame:Paint( w, h )' works too 
		draw.RoundedBox( 0, 0, 0, w, h, Color( 252, 182, 3) )     
	end 

	function survivor_simon:DoClick() 
		hook.Remove( "Think", "stalked", function( ) end)
		surface.PlaySound("click.wav")     
		MainFrame2:SetVisible(false)    
		MainFrame2:MakePopup(false) 
		net.Start("ace_stats")
		net.SendToServer()
		AceScreen()    
		--net.Start("simon_stats")  
		--net.SendToServer()   
	end  

	net.Receive("ace_selected_cl",function()   
		survivor_simon:SetText("SELECTED") 
		survivor_simon.Paint = function( self, w, h ) -- 'function Frame:Paint( w, h )' works too 
			draw.RoundedBox( 0, 0, 0, w, h, Color( 255,0,0,50) )       
		end  
		function survivor_simon:DoClick() 
			print("Simon LOCKED")
		end           
	end)

	local position_setter = vgui.Create( "DButton", FillPanel )          
	position_setter:Dock(TOP)  
	position_setter:SetText("SETTER")     
	position_setter:SetSize(360, 360)    
	position_setter:SetTextColor(Color(255,255,255))   
	position_setter:SetFont("Big")         
	position_setter:DockMargin( 0, 30 , 0, 0 )     
	position_setter:SetImage("materials/serve.png")   
	position_setter.Paint = function( self, w, h ) -- 'function Frame:Paint( w, h )' works too 
		draw.RoundedBox( 0, 0, 0, w, h, Color( 37, 245, 92) )     
	end               
	--myer_button:SetImage("materials/stalk.gif")   

	function position_setter:DoClick()  
		hook.Remove( "Think", "stalked", function( ) end)
		surface.PlaySound("click.wav")   
		MainFrame2:SetVisible(false)    
		MainFrame2:MakePopup(false) 
		ArmySetterScreen()   
		--net.Start("meg_stats")             
		--net.SendToServer() 
	end 
	net.Receive("serveking_selected_cl",function()  
		position_setter:SetText("SELECTED")
		position_setter.Paint = function( self, w, h ) -- 'function Frame:Paint( w, h )' works too 
			draw.RoundedBox( 0, 0, 0, w, h, Color( 255,0,0,50) )       
		end  
		function position_setter:DoClick() 
			print("Meg LOCKED")
		end  
	end)
   
	local survivor_army = vgui.Create( "DButton", FillPanel )           
	survivor_army:Dock(TOP)  
	survivor_army:SetText("LIBERO")     
	survivor_army:SetSize(300, 300)  
	survivor_army:SetTextColor(Color(255,255,255))   
	survivor_army:SetFont("Big")                
	survivor_army:DockMargin( 0, 30 , 0, 0 )        
	survivor_army:SetImage("materials/run.png")     
	--myer_button:SetImage("materials/stalk.gif")         
	survivor_army.Paint = function( self, w, h ) -- 'function Frame:Paint( w, h )' works too 
		draw.RoundedBox( 0, 0, 0, w, h, Color( 23, 205, 255) )    
	end

	function survivor_army:DoClick()          
		hook.Remove( "Think", "stalked", function( ) end)
		surface.PlaySound("click.wav")      
		MainFrame2:SetVisible(false)    
		MainFrame2:MakePopup(false) 
		LiberoScreen()   
		net.Start("army_stats")             
		net.SendToServer()    
	end 
	net.Receive("libero_selected_cl",function()  
		survivor_army:SetText("SELECTED")
		survivor_army.Paint = function( self, w, h ) -- 'function Frame:Paint( w, h )' works too 
			draw.RoundedBox( 0, 0, 0, w, h, Color( 255,0,0,50) )       
		end  
		function survivor_army:DoClick() 
			print("FBI LOCKED")
		end  
	end)

		local survivor_simon = vgui.Create( "DButton", FillPanel )      
	survivor_simon:Dock(TOP)    
	survivor_simon:SetSize(418, 418)      
	survivor_simon:SetText("Middle Blocker")   
	survivor_simon:SetTextColor(Color(255,255,255))   
	survivor_simon:SetFont("Big")         
	survivor_simon:DockMargin( 0, 30 , 0, 0 )              
	survivor_simon:SetImage("materials/jump.png")                 
	survivor_simon.Paint = function( self, w, h ) -- 'function Frame:Paint( w, h )' works too 
		draw.RoundedBox( 0, 0, 0, w, h, Color( 252, 182, 3) )     
	end 

	function survivor_simon:DoClick() 
		hook.Remove( "Think", "stalked", function( ) end)
		surface.PlaySound("click.wav")     
		MainFrame2:SetVisible(false)    
		MainFrame2:MakePopup(false) 
		SimonScreen()    
		--net.Start("simon_stats")  
		--net.SendToServer()   
	end  

	net.Receive("simon_selected_cl",function()    
		survivor_simon:SetText("SELECTED") 
		survivor_simon.Paint = function( self, w, h ) -- 'function Frame:Paint( w, h )' works too 
			draw.RoundedBox( 0, 0, 0, w, h, Color( 255,0,0,50) )       
		end  
		function survivor_simon:DoClick() 
			print("Simon LOCKED")
		end           
	end)

	local position_setter = vgui.Create( "DButton", FillPanel )          
	position_setter:Dock(TOP)  
	position_setter:SetText("Setter")     
	position_setter:SetSize(360, 360)    
	position_setter:SetTextColor(Color(255,255,255))   
	position_setter:SetFont("Big")         
	position_setter:DockMargin( 0, 30 , 0, 0 )     
	position_setter:SetImage("materials/eyes.png")   
	position_setter.Paint = function( self, w, h ) -- 'function Frame:Paint( w, h )' works too 
		draw.RoundedBox( 0, 0, 0, w, h, Color( 37, 245, 92) )     
	end               
	--myer_button:SetImage("materials/stalk.gif")   

	function position_setter:DoClick()  
		hook.Remove( "Think", "stalked", function( ) end)
		surface.PlaySound("click.wav")   
		MainFrame2:SetVisible(false)    
		MainFrame2:MakePopup(false) 
		MegScreen()   
		--net.Start("meg_stats")             
		--net.SendToServer() 
	end 
	net.Receive("meg_selected_cl",function()  
		position_setter:SetText("SELECTED")
		position_setter.Paint = function( self, w, h ) -- 'function Frame:Paint( w, h )' works too 
			draw.RoundedBox( 0, 0, 0, w, h, Color( 255,0,0,50) )       
		end  
		function position_setter:DoClick() 
			print("Meg LOCKED")
		end  
	end)
   
	local survivor_army = vgui.Create( "DButton", FillPanel )           
	survivor_army:Dock(TOP)  
	survivor_army:SetText("Opposite Hitter")     
	survivor_army:SetSize(300, 300)  
	survivor_army:SetTextColor(Color(255,255,255))   
	survivor_army:SetFont("Big")                
	survivor_army:DockMargin( 0, 30 , 0, 0 )        
	survivor_army:SetImage("materials/wall.jpg")     
	--myer_button:SetImage("materials/stalk.gif")         
	survivor_army.Paint = function( self, w, h ) -- 'function Frame:Paint( w, h )' works too 
		draw.RoundedBox( 0, 0, 0, w, h, Color( 23, 205, 255) )    
	end

	function survivor_army:DoClick()          
		hook.Remove( "Think", "stalked", function( ) end)
		surface.PlaySound("click.wav")      
		MainFrame2:SetVisible(false)    
		MainFrame2:MakePopup(false) 
		ArmyScreen()   
		net.Start("army_stats")             
		net.SendToServer()    
	end 
	net.Receive("fbi_selected_cl",function()  
		survivor_army:SetText("SELECTED")
		survivor_army.Paint = function( self, w, h ) -- 'function Frame:Paint( w, h )' works too 
			draw.RoundedBox( 0, 0, 0, w, h, Color( 255,0,0,50) )       
		end  
		function survivor_army:DoClick() 
			--print("FBI LOCKED")
		end  
	end) 

end 



function AceScreen() 
		local MainFrame = vgui.Create("DFrame")
	MainFrame:SetSize(1366,768)
	MainFrame:SetTitle("This gamemode is created by Hope")
	MainFrame:SetVisible(true) 
	MainFrame:SetBackgroundBlur( true )
	MainFrame:ShowCloseButton(false)  
	MainFrame:Center()
	MainFrame:MakePopup(true)
	MainFrame.Paint = function( self, w, h ) -- 'function Frame:Paint( w, h )' works too
	draw.RoundedBox( 0, 0, 0, w, h, Color( 255,255,255,255) ) -- Draw a black box instead of the frame
	end

	function MainFrame:Init()     
		self.startTime = SysTime()  
	end
	function MainFrame:Paint()
		Derma_DrawBackgroundBlur( self, self.startTime)                
	end

	local TopPanel = vgui.Create( "DPanel", MainFrame )       
	TopPanel:Dock(TOP) 
	TopPanel:SetSize(100,100)        
	TopPanel.Paint = function( self, w, h )    
	draw.RoundedBox( 0, 0, 0, w, h, Color( 0,0,0,0) ) -- Draw a black box instead of the frame
	end

	local FillPanel = vgui.Create( "DScrollPanel", MainFrame )       
	FillPanel:Dock(FILL)
	FillPanel:SetSize(100,100)    
	FillPanel.Paint = function( self, w, h )    
	draw.RoundedBox( 0, 0, 0, w, h, Color( 0,0,0,100) ) -- Draw a black box instead of the frame 
	end

	local LeftPanel = vgui.Create( "DPanel", FillPanel )          
	LeftPanel:Dock(LEFT)
	LeftPanel:SetSize(300,500)                    
	LeftPanel.Paint = function( self, w, h )  
	draw.RoundedBox( 0, 0, 0, w, h, Color( 0,0,0,0) ) -- Draw a black box instead of the frame
	end

	local BottomPanel = vgui.Create( "DPanel", MainFrame )          
	BottomPanel:Dock(BOTTOM)
	BottomPanel:SetSize(100,100)               
	BottomPanel.Paint = function( self, w, h )  
	draw.RoundedBox( 0, 0, 0, w, h, Color( 0,0,0,0) ) -- Draw a black box instead of the frame
	end

	local title = vgui.Create( "DLabel", TopPanel )       
	title:Dock(FILL)
	title:SetSize(100,100)     
	title:SetText("ACE")       
	title:SetTextColor(Color(255,255,255))                
	title:DockMargin( 0, 50 , 0, 0 )    
	title:SetFont("logo")    

	
	local simon_model = vgui.Create( "DModelPanel", LeftPanel )  
	simon_model:Dock(LEFT)
	simon_model:SetSize( 400, 300 )    
	simon_model:SetModel("models/player/summermilitary/male_02.mdl")
	simon_model:DockMargin( 0, 50 , 0, 0 )  

	local simon_desc2 = vgui.Create( "DLabel", FillPanel )          
	simon_desc2:Dock(TOP)  
	simon_desc2:SetSize(50,50)      
	simon_desc2:SetText("ABILITY")     
	simon_desc2:SetTextColor(Color(255,255,255))                
	simon_desc2:DockMargin( 0, 30 , 0, 0 )     
	simon_desc2:SetFont("logo") 

	local simon_desc3 = vgui.Create( "DLabel", FillPanel )          
	simon_desc3:Dock(TOP)  
	simon_desc3:SetSize(100,100)             
	simon_desc3:SetText("JUMP POWER\n1  2  3  (4)  5")     
	simon_desc3:SetTextColor(Color(37, 245, 92))                
	simon_desc3:DockMargin( 0, 30 , 0, 0 )     
	simon_desc3:SetFont("Big2")   

	local simon_desc4 = vgui.Create( "DLabel", FillPanel )            
	simon_desc4:Dock(TOP)   
	simon_desc4:SetSize(100,100)              
	simon_desc4:SetText("SPEED\n1  2  (3)  4  5")     
	simon_desc4:SetTextColor(Color( 23, 205, 255))                
	simon_desc4:DockMargin( 0, 10 , 0, 0 )     
	simon_desc4:SetFont("Big2")

	local simon_desc5 = vgui.Create( "DLabel", FillPanel )            
	simon_desc5:Dock(TOP)   
	simon_desc5:SetSize(100,100)              
	simon_desc5:SetText("SPIKE\n1  2  3  4  (5)")     
	simon_desc5:SetTextColor(Color(252, 182, 3))                
	simon_desc5:DockMargin( 0, 10 , 0, 0 )     
	simon_desc5:SetFont("Big2")

	local simon_desc6 = vgui.Create( "DLabel", FillPanel )            
	simon_desc6:Dock(TOP)   
	simon_desc6:SetSize(100,100)              
	simon_desc6:SetText("- Can spike super fast, Top scorer in team")     
	simon_desc6:SetTextColor(Color(255, 255, 255))                
	simon_desc6:DockMargin( 0, 10 , 0, 0 )     
	simon_desc6:SetFont("tiny2")
   
	local confirm_button = vgui.Create( "DButton", BottomPanel )           
	confirm_button:Dock(TOP)  
	confirm_button:SetText("Confirm") 
	confirm_button:SetFont("small")
	confirm_button:SetTextColor(Color(255,255,255))       
	confirm_button:SetSize(50, 50)            
	--myer_button:SetImage("materials/stalk.gif")         
	confirm_button.Paint = function( self, w, h ) -- 'function Frame:Paint( w, h )' works too 
		draw.RoundedBox( 0, 0, 0, w, h, Color( 18, 132, 161,100) )        
	end 

	function confirm_button:DoClick()
		sound3:Stop()
		MainFrame:Close() 
		local AbilityFrame = vgui.Create("DFrame")
		AbilityFrame:SetSize(1366,768)
		AbilityFrame:SetTitle("This gamemode is created by Hope")
		AbilityFrame:SetVisible(true) 
		AbilityFrame:ShowCloseButton(false)    
		AbilityFrame:Center()  
		AbilityFrame.Paint = function( self, w, h ) -- 'function Frame:Paint( w, h )' works too
		draw.RoundedBox( 0, 0, 0, w, h, Color( 0,0,0,0) ) -- Draw a black box instead of the frame
		end

		local RightPanel = vgui.Create( "DPanel", AbilityFrame )          
		RightPanel:Dock(RIGHT)
		RightPanel:SetSize(300,300)               
		RightPanel.Paint = function( self, w, h )  
		draw.RoundedBox( 0, 0, 0, w, h, Color( 0,0,0,0) ) -- Draw a black box instead of the frame
		end

		local ability_label = vgui.Create( "DLabel", RightPanel )             
		ability_label:Dock(TOP)  
		ability_label:SetSize(300,300)          
		ability_label:SetText(" V - RECEIVE\n B - SUPER SPIKE!")     
		ability_label:SetTextColor(Color(255,255,255))                
		ability_label:DockMargin( 0, 300 , 0, 0 )      
		ability_label:SetFont("tiny2") 

		if keybind_set == "a" then 
			ability_label:SetText(" V - RECEIVE\n B - SUPER SPIKE!\n R.Click - SERVE")
		elseif keybind_set == "b" then  
			ability_label:SetText("R - RECEIVE\n Q - SUPER SPIKE!\n R.Click - SERVE")
		end

		hook.Remove( "KeyPress", "focus_breathing", function( ply, key ) end)
		hook.Remove( "KeyPress", "secret_camera", function( ply, key ) end)
		surface.PlaySound("click.wav")   
		net.Start("ace_stats") 
		net.SendToServer()
		net.Start("ace_selected") 
		net.SendToServer() 

		-- MEG_ABILITY -------------------------
		hook.Add( "PlayerButtonDown", "ability_ace", function(ply,button)
			if ply:Team() == 10 then
				if keybind_set == "a" then   
					if   button ==  KEY_V then
						if ply:GetPos():WithinAABox( pos1, pos2 ) then
								ply:LagCompensation(true)
								print("hellow world")
								net.Start("medium_toss")    
								net.WriteString("left")  	 
								net.SendToServer()	 
								ply:LagCompensation(false)
							elseif ply:GetPos():WithinAABox( pos3, pos4 ) then
								ply:LagCompensation(true)
								print("hellow world")
								net.Start("medium_toss")    
								net.WriteString("right")  	  
								net.SendToServer()	 
								ply:LagCompensation(false)
							end 
					end     
					if   button ==  KEY_B then
						if ply:GetPos():WithinAABox( pos1, pos2 ) then
							ply:LagCompensation(true)
							print("hellow world")
							net.Start("ace_spike")    
							net.WriteString("left")  	 
							net.SendToServer()	 
							ply:LagCompensation(false)
						elseif ply:GetPos():WithinAABox( pos3, pos4 ) then
							ply:LagCompensation(true)
							print("hellow world")
							net.Start("ace_spike")    
							net.WriteString("right")  	 
							net.SendToServer()	 
							ply:LagCompensation(false)
						end 
					end
					if   button ==  MOUSE_RIGHT then
						net.Start("basic_serve")    	
						net.SendToServer()	
					end 



				elseif  keybind_set == "b" then  
					if   button ==  KEY_R then
						if ply:GetPos():WithinAABox( pos1, pos2 ) then
							ply:LagCompensation(true)
							print("hellow world")
							net.Start("medium_toss")    
							net.WriteString("left")  	 
							net.SendToServer()	 
							ply:LagCompensation(false)
						elseif ply:GetPos():WithinAABox( pos3, pos4 ) then
							ply:LagCompensation(true)
							print("hellow world")
							net.Start("medium_toss")    
							net.WriteString("right")  	  
							net.SendToServer()	 
							ply:LagCompensation(false)
						end 
						
					end     
					if   button ==  KEY_Q then
						if ply:GetPos():WithinAABox( pos1, pos2 ) then
							ply:LagCompensation(true)
							print("hellow world")
							net.Start("ace_spike")    
							net.WriteString("left")  	 
							net.SendToServer()	 
							ply:LagCompensation(false)
						elseif ply:GetPos():WithinAABox( pos3, pos4 ) then
							ply:LagCompensation(true)
							print("hellow world")
							net.Start("ace_spike")    
							net.WriteString("right")  	 
							net.SendToServer()	 
							ply:LagCompensation(false) 
						end 
					end 
					if   button ==  MOUSE_RIGHT then
						net.Start("basic_serve")    	
						net.SendToServer()	
					end 


				end
			end  
		end)                 
	end            

	local close_button = vgui.Create( "DButton", BottomPanel )          
	close_button:Dock(TOP)  
	close_button:SetText("Back") 
	close_button:SetFont("small") 
	close_button:SetTextColor(Color(255,255,255))    
	close_button:SetSize(50, 50)            
	--myer_button:SetImage("materials/stalk.gif")         
	close_button.Paint = function( self, w, h ) -- 'function Frame:Paint( w, h )' works too 
		draw.RoundedBox( 0, 0, 0, w, h, Color( 255,0,0,100) )     
	end
	function close_button:DoClick()
		surface.PlaySound("click.wav")  
		MainFrame:Close() 
		SurvivorScreen2() 
	end 
end 


function ArmySetterScreen() 
	local MainFrame = vgui.Create("DFrame")
	MainFrame:SetSize(1366,768)
	MainFrame:SetTitle("This gamemode is created by Hope")
	MainFrame:SetVisible(true) 
	MainFrame:SetBackgroundBlur( true )
	MainFrame:ShowCloseButton(false)  
	MainFrame:Center()
	MainFrame:MakePopup(true)
	MainFrame.Paint = function( self, w, h ) -- 'function Frame:Paint( w, h )' works too
	draw.RoundedBox( 0, 0, 0, w, h, Color( 255,255,255,255) ) -- Draw a black box instead of the frame
	end

	function MainFrame:Init()     
		self.startTime = SysTime()  
	end
	function MainFrame:Paint()
		Derma_DrawBackgroundBlur( self, self.startTime)                
	end

	local TopPanel = vgui.Create( "DPanel", MainFrame )       
	TopPanel:Dock(TOP) 
	TopPanel:SetSize(100,100)        
	TopPanel.Paint = function( self, w, h )    
	draw.RoundedBox( 0, 0, 0, w, h, Color( 0,0,0,0) ) -- Draw a black box instead of the frame
	end

	local FillPanel = vgui.Create( "DScrollPanel", MainFrame )       
	FillPanel:Dock(FILL)
	FillPanel:SetSize(100,100)    
	FillPanel.Paint = function( self, w, h )    
	draw.RoundedBox( 0, 0, 0, w, h, Color( 0,0,0,100) ) -- Draw a black box instead of the frame 
	end

	local LeftPanel = vgui.Create( "DPanel", FillPanel )          
	LeftPanel:Dock(LEFT)
	LeftPanel:SetSize(300,500)                    
	LeftPanel.Paint = function( self, w, h )  
	draw.RoundedBox( 0, 0, 0, w, h, Color( 0,0,0,0) ) -- Draw a black box instead of the frame
	end

	local BottomPanel = vgui.Create( "DPanel", MainFrame )          
	BottomPanel:Dock(BOTTOM)
	BottomPanel:SetSize(100,100)               
	BottomPanel.Paint = function( self, w, h )  
	draw.RoundedBox( 0, 0, 0, w, h, Color( 0,0,0,0) ) -- Draw a black box instead of the frame
	end

	local title = vgui.Create( "DLabel", TopPanel )       
	title:Dock(FILL)
	title:SetSize(100,100)     
	title:SetText("SERVE KING")       
	title:SetTextColor(Color(255,255,255))                
	title:DockMargin( 0, 50 , 0, 0 )    
	title:SetFont("logo")    

	
	local simon_model = vgui.Create( "DModelPanel", LeftPanel )  
	simon_model:Dock(LEFT)
	simon_model:SetSize( 400, 300 )    
	simon_model:SetModel("models/player/summermilitary/male_02.mdl")
	simon_model:DockMargin( 0, 50 , 0, 0 )  

	local simon_desc2 = vgui.Create( "DLabel", FillPanel )          
	simon_desc2:Dock(TOP)  
	simon_desc2:SetSize(50,50)      
	simon_desc2:SetText("ABILITY")     
	simon_desc2:SetTextColor(Color(255,255,255))                
	simon_desc2:DockMargin( 0, 30 , 0, 0 )     
	simon_desc2:SetFont("logo") 

	local simon_desc3 = vgui.Create( "DLabel", FillPanel )          
	simon_desc3:Dock(TOP)  
	simon_desc3:SetSize(100,100)             
	simon_desc3:SetText("JUMP POWER\n1  2  (3)  4  5")     
	simon_desc3:SetTextColor(Color(37, 245, 92))                
	simon_desc3:DockMargin( 0, 30 , 0, 0 )     
	simon_desc3:SetFont("Big2")   

	local simon_desc4 = vgui.Create( "DLabel", FillPanel )            
	simon_desc4:Dock(TOP)   
	simon_desc4:SetSize(100,100)              
	simon_desc4:SetText("SPEED\n1  2  (3)  4  5")     
	simon_desc4:SetTextColor(Color( 23, 205, 255))                
	simon_desc4:DockMargin( 0, 10 , 0, 0 )     
	simon_desc4:SetFont("Big2")

	local simon_desc5 = vgui.Create( "DLabel", FillPanel )            
	simon_desc5:Dock(TOP)   
	simon_desc5:SetSize(100,100)              
	simon_desc5:SetText("SPIKE\n1  2  (3)  4  5")     
	simon_desc5:SetTextColor(Color(252, 182, 3))                
	simon_desc5:DockMargin( 0, 10 , 0, 0 )     
	simon_desc5:SetFont("Big2")

	local simon_desc6 = vgui.Create( "DLabel", FillPanel )            
	simon_desc6:Dock(TOP)   
	simon_desc6:SetSize(100,100)              
	simon_desc6:SetText("- When activated, toss ball up, jump and spike while look at direction. Similar to Oikawa fast serve.")     
	simon_desc6:SetTextColor(Color(255, 255, 255))                
	simon_desc6:DockMargin( 0, 10 , 0, 0 )     
	simon_desc6:SetFont("tiny2")
   
	local confirm_button = vgui.Create( "DButton", BottomPanel )           
	confirm_button:Dock(TOP)  
	confirm_button:SetText("Confirm") 
	confirm_button:SetFont("small")
	confirm_button:SetTextColor(Color(255,255,255))       
	confirm_button:SetSize(50, 50)            
	--myer_button:SetImage("materials/stalk.gif")         
	confirm_button.Paint = function( self, w, h ) -- 'function Frame:Paint( w, h )' works too 
		draw.RoundedBox( 0, 0, 0, w, h, Color( 18, 132, 161,100) )        
	end 



	local shouldOccur2 = true  
	local delay2 = 64 
	local meg_cd=64 
	function confirm_button:DoClick()
		sound3:Stop()
		MainFrame:Close() 
		local AbilityFrame = vgui.Create("DFrame")
		AbilityFrame:SetSize(1366,768)
		AbilityFrame:SetTitle("This gamemode is created by Hope")
		AbilityFrame:SetVisible(true) 
		AbilityFrame:ShowCloseButton(false)    
		AbilityFrame:Center()  
		AbilityFrame.Paint = function( self, w, h ) -- 'function Frame:Paint( w, h )' works too
		draw.RoundedBox( 0, 0, 0, w, h, Color( 0,0,0,0) ) -- Draw a black box instead of the frame
		end
		
		local RightPanel = vgui.Create( "DPanel", AbilityFrame )          
		RightPanel:Dock(RIGHT)
		RightPanel:SetSize(300,300)               
		RightPanel.Paint = function( self, w, h )  
		draw.RoundedBox( 0, 0, 0, w, h, Color( 0,0,0,0) ) -- Draw a black box instead of the frame
		end

		local ability_control = vgui.Create( "DLabel", RightPanel )             
		ability_control:Dock(TOP)  
		ability_control:SetSize(200,300)          
		ability_control:SetText("C- LOW TOSS\nV- MEDIUM TOSS\nB- SPIKE\nALT- SERVE KING")     
		ability_control:SetTextColor(Color(255,255,255))                
		ability_control:DockMargin( 0, 300 , 0, 0 )      
		ability_control:SetFont("tiny2")

		if keybind_set == "a" then 
			ability_control:SetText("C- LOW TOSS\nV- MEDIUM TOSS\nG- BACK TOSS\nB- SPIKE\nALT- SERVE KING\nR.Click - BASIC SERVE")
		elseif keybind_set == "b" then  
			ability_control:SetText("C- LOW TOSS\nF- MEDIUM TOSS\nG- BACK TOSS\nQ- SPIKE\nALT- SERVE KING\nR.Click - BASIC SERVE")
		end 

		local ability_label = vgui.Create( "DLabel", AbilityFrame )             
		ability_label:Dock(LEFT)  
		ability_label:SetSize(200,300)          
		ability_label:SetText("SERVE KING:")     
		ability_label:SetTextColor(Color(255,255,255))                
		ability_label:DockMargin( 0, 300 , 0, 0 )      
		ability_label:SetFont("tiny") 


		local ability_label2 = vgui.Create( "DLabel", AbilityFrame )             
		ability_label2:Dock(LEFT)  
		ability_label2:SetSize(200,300)            
		ability_label2:SetText("")      
		ability_label2:SetTextColor(Color(255,255,255))                  
		ability_label2:DockMargin( 0, 300 , 0, 0 )        
		ability_label2:SetFont("tiny")  

		hook.Remove( "KeyPress", "focus_breathing", function( ply, key ) end)
		hook.Remove( "KeyPress", "secret_camera", function( ply, key ) end)
		surface.PlaySound("click.wav")   
		net.Start("serveking_stats") 
		net.SendToServer()  
		net.Start("serveking_selected") 
		net.SendToServer()  
		-- MEG_ABILITY -------------------------
		hook.Add( "Think", "ability_indicator", function()
			if shouldOccur2 == true then 
				ability_label2:SetText("ACTIVE")
				ability_label2:SetTextColor(Color(32, 232, 86))
			else 
				--ability_label2:SetText("COOLDOWN")
				ability_label2:SetTextColor(Color(255, 0, 0))
			end 
		end)

		hook.Add( "KeyPress", "serve_ability", function( ply, key )
			if ply:Team() == 11 then  
				if  (key == IN_WALK) then
					if shouldOccur2 then 
						meg_cd = 64 
						net.Start("serve_ability")    	
						net.SendToServer()	
						ply:PrintMessage( HUD_PRINTTALK, "You used your ability" )
						shouldOccur2 = false   
						timer.Create("meg_cd",1,65,function() meg_cd=meg_cd-1 ability_label2:SetText("COOLDOWN("..meg_cd..")") end) 
						timer.Simple( delay2, function() shouldOccur2 = true end )
					else
						ply:PrintMessage( HUD_PRINTTALK, "Cooldown!" )
					end     
				end   	     
			end	           
		end) 


		hook.Add( "PlayerButtonDown", "ability_wall", function(ply,button)
			if ply:Team() == 11 then 
				if keybind_set == "a" then
					if  button ==  KEY_C then
						if ply:GetPos():WithinAABox( pos1, pos2 ) then
							ply:LagCompensation(true)
							print("hellow world")
							net.Start("low_toss")
							net.WriteString("left")
							net.SendToServer()	 
							ply:LagCompensation(false)	
						elseif ply:GetPos():WithinAABox( pos3, pos4 ) then
							ply:LagCompensation(true)
							print("hellow world")
							net.Start("low_toss") 
							net.WriteString("right")
							net.SendToServer()	 
							ply:LagCompensation(false)	
						end 
					end   
					if   button ==  KEY_V then
						if ply:GetPos():WithinAABox( pos1, pos2 ) then
							ply:LagCompensation(true)
							print("hellow world")
							net.Start("medium_toss2")
							net.WriteString("normal")     
							net.WriteString("left")  	 
							net.SendToServer()	 
							ply:LagCompensation(false)	
						elseif ply:GetPos():WithinAABox( pos3, pos4 ) then
							ply:LagCompensation(true)
							print("hellow world")
							net.Start("medium_toss2")
							net.WriteString("normal")     
							net.WriteString("right")  	 
							net.SendToServer()	 
							ply:LagCompensation(false)	
						end 	
					end 
					if   button ==  KEY_G  then 
						if ply:GetPos():WithinAABox( pos1, pos2 ) then
							ply:LagCompensation(true)
							print("hellow world")
							net.Start("medium_toss2")
							net.WriteString("back")     
							net.WriteString("left")  	 
							net.SendToServer()	 
							ply:LagCompensation(false)	
						elseif ply:GetPos():WithinAABox( pos3, pos4 ) then
							ply:LagCompensation(true)
							print("hellow world")
							net.Start("medium_toss2")
							net.WriteString("back")     
							net.WriteString("right")  	 
							net.SendToServer()	 
							ply:LagCompensation(false)	
						end 
					end        
					if   button ==  KEY_B then
						if ply:GetPos():WithinAABox( pos1, pos2 ) then
							ply:LagCompensation(true)
							print("hellow world")
							net.Start("serveking_spike")    
							net.WriteString("left")  	 
							net.SendToServer()	 
							ply:LagCompensation(false)
						elseif ply:GetPos():WithinAABox( pos3, pos4 ) then
							ply:LagCompensation(true)
							print("hellow world")
							net.Start("serveking_spike")    
							net.WriteString("right")  	 
							net.SendToServer()	 
							ply:LagCompensation(false) 
						end 
					end  
					if   button ==  MOUSE_RIGHT then
						net.Start("basic_serve")    	
						net.SendToServer()	
					end  

				elseif  keybind_set == "b" then

					if  button ==  KEY_C then
						if ply:GetPos():WithinAABox( pos1, pos2 ) then
							ply:LagCompensation(true)
							print("hellow world")
							net.Start("low_toss")
							net.WriteString("left")
							net.SendToServer()	 
							ply:LagCompensation(false)	
						elseif ply:GetPos():WithinAABox( pos3, pos4 ) then
							ply:LagCompensation(true)
							print("hellow world")
							net.Start("low_toss") 
							net.WriteString("right")
							net.SendToServer()	 
							ply:LagCompensation(false)	
						end 
					end   
					if   button ==  KEY_F then
						if ply:GetPos():WithinAABox( pos1, pos2 ) then
							ply:LagCompensation(true)
							print("hellow world")
							net.Start("medium_toss2")
							net.WriteString("normal")     
							net.WriteString("left")  	 
							net.SendToServer()	 
							ply:LagCompensation(false)	
						elseif ply:GetPos():WithinAABox( pos3, pos4 ) then
							ply:LagCompensation(true)
							print("hellow world")
							net.Start("medium_toss2")
							net.WriteString("normal")     
							net.WriteString("right")  	 
							net.SendToServer()	 
							ply:LagCompensation(false)	
						end 
					end 
					if   button ==  KEY_G  then 
						if ply:GetPos():WithinAABox( pos1, pos2 ) then
							ply:LagCompensation(true)
							print("hellow world")
							net.Start("medium_toss2")
							net.WriteString("back")     
							net.WriteString("left")  	 
							net.SendToServer()	 
							ply:LagCompensation(false)	
						elseif ply:GetPos():WithinAABox( pos3, pos4 ) then
							ply:LagCompensation(true)
							print("hellow world")
							net.Start("medium_toss2")
							net.WriteString("back")     
							net.WriteString("right")  	 
							net.SendToServer()	 
							ply:LagCompensation(false)	
						end 
					end         
					if   button ==  KEY_Q then
						if ply:GetPos():WithinAABox( pos1, pos2 ) then
							ply:LagCompensation(true)
							print("hellow world")
							net.Start("serveking_spike")    
							net.WriteString("left")  	 
							net.SendToServer()	 
							ply:LagCompensation(false)
						elseif ply:GetPos():WithinAABox( pos3, pos4 ) then
							ply:LagCompensation(true)
							print("hellow world")
							net.Start("serveking_spike")    
							net.WriteString("right")  	 
							net.SendToServer()	 
							ply:LagCompensation(false) 
						end 
					end  
					if   button ==  MOUSE_RIGHT then
						net.Start("basic_serve")    	
						net.SendToServer()	
					end 

				end 
			end  
		end)                 

	end                        

	local close_button = vgui.Create( "DButton", BottomPanel )          
	close_button:Dock(TOP)  
	close_button:SetText("Back") 
	close_button:SetFont("small") 
	close_button:SetTextColor(Color(255,255,255))    
	close_button:SetSize(50, 50)            
	--myer_button:SetImage("materials/stalk.gif")         
	close_button.Paint = function( self, w, h ) -- 'function Frame:Paint( w, h )' works too 
		draw.RoundedBox( 0, 0, 0, w, h, Color( 255,0,0,100) )     
	end
	function close_button:DoClick()
		surface.PlaySound("click.wav")  
		MainFrame:Close() 
		SurvivorScreen2() 
	end 
end 





function LiberoScreen() 
	local MainFrame = vgui.Create("DFrame")
	MainFrame:SetSize(1366,768)
	MainFrame:SetTitle("This gamemode is created by Hope")
	MainFrame:SetVisible(true) 
	MainFrame:SetBackgroundBlur( true )
	MainFrame:ShowCloseButton(false)  
	MainFrame:Center()
	MainFrame:MakePopup(true)
	MainFrame.Paint = function( self, w, h ) -- 'function Frame:Paint( w, h )' works too
	draw.RoundedBox( 0, 0, 0, w, h, Color( 255,255,255,255) ) -- Draw a black box instead of the frame
	end

	function MainFrame:Init()     
		self.startTime = SysTime()  
	end
	function MainFrame:Paint()
		Derma_DrawBackgroundBlur( self, self.startTime)                
	end

	local TopPanel = vgui.Create( "DPanel", MainFrame )       
	TopPanel:Dock(TOP) 
	TopPanel:SetSize(100,100)        
	TopPanel.Paint = function( self, w, h )    
	draw.RoundedBox( 0, 0, 0, w, h, Color( 0,0,0,0) ) -- Draw a black box instead of the frame
	end

	local FillPanel = vgui.Create( "DScrollPanel", MainFrame )       
	FillPanel:Dock(FILL)
	FillPanel:SetSize(100,100)    
	FillPanel.Paint = function( self, w, h )    
	draw.RoundedBox( 0, 0, 0, w, h, Color( 0,0,0,100) ) -- Draw a black box instead of the frame 
	end

	local LeftPanel = vgui.Create( "DPanel", FillPanel )          
	LeftPanel:Dock(LEFT)
	LeftPanel:SetSize(300,500)                    
	LeftPanel.Paint = function( self, w, h )  
	draw.RoundedBox( 0, 0, 0, w, h, Color( 0,0,0,0) ) -- Draw a black box instead of the frame
	end

	local BottomPanel = vgui.Create( "DPanel", MainFrame )          
	BottomPanel:Dock(BOTTOM)
	BottomPanel:SetSize(100,100)               
	BottomPanel.Paint = function( self, w, h )  
	draw.RoundedBox( 0, 0, 0, w, h, Color( 0,0,0,0) ) -- Draw a black box instead of the frame
	end

	local title = vgui.Create( "DLabel", TopPanel )       
	title:Dock(FILL)
	title:SetSize(100,100)     
	title:SetText("FAST RETARD")       
	title:SetTextColor(Color(255,255,255))                
	title:DockMargin( 0, 50 , 0, 0 )    
	title:SetFont("logo")    

	
	local simon_model = vgui.Create( "DModelPanel", LeftPanel )  
	simon_model:Dock(LEFT)
	simon_model:SetSize( 400, 300 )    
	simon_model:SetModel("models/player/fin/male_02.mdl")
	simon_model:DockMargin( 0, 50 , 0, 0 )  

	local simon_desc2 = vgui.Create( "DLabel", FillPanel )          
	simon_desc2:Dock(TOP)  
	simon_desc2:SetSize(50,50)      
	simon_desc2:SetText("ABILITY")     
	simon_desc2:SetTextColor(Color(255,255,255))                
	simon_desc2:DockMargin( 0, 30 , 0, 0 )     
	simon_desc2:SetFont("logo") 

	local simon_desc3 = vgui.Create( "DLabel", FillPanel )          
	simon_desc3:Dock(TOP)  
	simon_desc3:SetSize(100,100)             
	simon_desc3:SetText("JUMP POWER\n1  (2)  3  4  5")     
	simon_desc3:SetTextColor(Color(37, 245, 92))                
	simon_desc3:DockMargin( 0, 30 , 0, 0 )     
	simon_desc3:SetFont("Big2")   

	local simon_desc4 = vgui.Create( "DLabel", FillPanel )            
	simon_desc4:Dock(TOP)   
	simon_desc4:SetSize(100,100)              
	simon_desc4:SetText("SPEED\n1  2  3  4  (5)")     
	simon_desc4:SetTextColor(Color( 23, 205, 255))                
	simon_desc4:DockMargin( 0, 10 , 0, 0 )     
	simon_desc4:SetFont("Big2")

	local simon_desc5 = vgui.Create( "DLabel", FillPanel )            
	simon_desc5:Dock(TOP)   
	simon_desc5:SetSize(100,100)              
	simon_desc5:SetText("SPIKE\n(1)  2  3  4  5")     
	simon_desc5:SetTextColor(Color(252, 182, 3))                
	simon_desc5:DockMargin( 0, 10 , 0, 0 )     
	simon_desc5:SetFont("Big2")

	local simon_desc6 = vgui.Create( "DLabel", FillPanel )            
	simon_desc6:Dock(TOP)   
	simon_desc6:SetSize(100,100)              
	simon_desc6:SetText("- When activated, Fast Retard will dash forward. \n useful to save ball")     
	simon_desc6:SetTextColor(Color(255, 255, 255))                
	simon_desc6:DockMargin( 0, 10 , 0, 0 )     
	simon_desc6:SetFont("tiny2")
   
	local confirm_button = vgui.Create( "DButton", BottomPanel )           
	confirm_button:Dock(TOP)  
	confirm_button:SetText("Confirm") 
	confirm_button:SetFont("small")
	confirm_button:SetTextColor(Color(255,255,255))       
	confirm_button:SetSize(50, 50)            
	--myer_button:SetImage("materials/stalk.gif")         
	confirm_button.Paint = function( self, w, h ) -- 'function Frame:Paint( w, h )' works too 
		draw.RoundedBox( 0, 0, 0, w, h, Color( 18, 132, 161,100) )        
	end 




	local shouldOccur3 = true  
	local delay3 = 1 
	local meg_cd2=1 
	function confirm_button:DoClick()
		sound3:Stop()
		MainFrame:Close() 
		local AbilityFrame = vgui.Create("DFrame")
		AbilityFrame:SetSize(1366,768)
		AbilityFrame:SetTitle("This gamemode is created by Hope")
		AbilityFrame:SetVisible(true) 
		AbilityFrame:ShowCloseButton(false)    
		AbilityFrame:Center()  
		AbilityFrame.Paint = function( self, w, h ) -- 'function Frame:Paint( w, h )' works too
		draw.RoundedBox( 0, 0, 0, w, h, Color( 0,0,0,0) ) -- Draw a black box instead of the frame
		end
		
		local RightPanel = vgui.Create( "DPanel", AbilityFrame )          
		RightPanel:Dock(RIGHT)
		RightPanel:SetSize(300,300)               
		RightPanel.Paint = function( self, w, h )  
		draw.RoundedBox( 0, 0, 0, w, h, Color( 0,0,0,0) ) -- Draw a black box instead of the frame
		end

		local ability_control = vgui.Create( "DLabel", RightPanel )             
		ability_control:Dock(TOP)  
		ability_control:SetSize(200,300)          
		ability_control:SetText("C- LOW TOSS\nV- RECEIVE\nB- SAVE BALL\nALT- DASH")     
		ability_control:SetTextColor(Color(255,255,255))                
		ability_control:DockMargin( 0, 300 , 0, 0 )      
		ability_control:SetFont("tiny2")

		if keybind_set == "a" then 
			ability_control:SetText("C- LOW TOSS\nV- RECEIVE\nB- SAVE BALL\nALT- DASH")
		elseif keybind_set == "b" then  
			ability_control:SetText("C- LOW TOSS\nR- RECEIVE\nB- SAVE BALL\nALT- DASH")
		end


		hook.Remove( "KeyPress", "focus_breathing", function( ply, key ) end)
		hook.Remove( "KeyPress", "secret_camera", function( ply, key ) end)
		surface.PlaySound("click.wav")   
		net.Start("libero_stats") 
		net.SendToServer()  
		net.Start("libero_selected") 
		net.SendToServer()  

		hook.Add( "KeyPress", "serve_ability", function( ply, key )
			if ply:Team() == 11 then  
				if  (key == IN_WALK) then
					if shouldOccur3 then 
						meg_cd = 64 
						net.Start("libero_ability")    	
						net.SendToServer()	
						ply:PrintMessage( HUD_PRINTTALK, "You used your ability" )
						shouldOccur3 = false   
						timer.Create("meg_cd2",1,1,function() meg_cd2=meg_cd2-1  end) 
						timer.Simple( delay3, function() shouldOccur3 = true end )
					else
						ply:PrintMessage( HUD_PRINTTALK, "Cooldown!" )
					end     
				end   	     
			end	           
		end) 


		hook.Add( "PlayerButtonDown", "ability_lib", function(ply,button)
			if ply:Team() == 11 then 
				if keybind_set == "a" then
					if  button ==  KEY_C then
						if ply:GetPos():WithinAABox( pos1, pos2 ) then
							ply:LagCompensation(true)
							print("hellow world")
							net.Start("low_toss")
							net.WriteString("left")
							net.SendToServer()	 
							ply:LagCompensation(false)	
						elseif ply:GetPos():WithinAABox( pos3, pos4 ) then
							ply:LagCompensation(true)
							print("hellow world")
							net.Start("low_toss") 
							net.WriteString("right")
							net.SendToServer()	 
							ply:LagCompensation(false)	
						end 	
					end   
					if   button ==  KEY_V then
						if ply:GetPos():WithinAABox( pos1, pos2 ) then
							ply:LagCompensation(true)
							print("hellow world")
							net.Start("medium_toss")    
							net.WriteString("left")  	 
							net.SendToServer()	 
							ply:LagCompensation(false)
						elseif ply:GetPos():WithinAABox( pos3, pos4 ) then
							ply:LagCompensation(true)
							print("hellow world")
							net.Start("medium_toss")    
							net.WriteString("right")  	  
							net.SendToServer()	 
							ply:LagCompensation(false)
						end 
					end     
					if   button ==  KEY_B then
						net.Start("save_ball")    	
						net.SendToServer()	
					end 

				elseif keybind_set == "b" then 
					if  button ==  KEY_C then
						if ply:GetPos():WithinAABox( pos1, pos2 ) then
							ply:LagCompensation(true)
							print("hellow world")
							net.Start("low_toss")
							net.WriteString("left")
							net.SendToServer()	 
							ply:LagCompensation(false)	
						elseif ply:GetPos():WithinAABox( pos3, pos4 ) then
							ply:LagCompensation(true)
							print("hellow world")
							net.Start("low_toss") 
							net.WriteString("right")
							net.SendToServer()	 
							ply:LagCompensation(false)	
						end 
					end   
					if   button ==  KEY_R then
						if ply:GetPos():WithinAABox( pos1, pos2 ) then
							ply:LagCompensation(true)
							print("hellow world")
							net.Start("medium_toss")    
							net.WriteString("left")  	 
							net.SendToServer()	 
							ply:LagCompensation(false)
						elseif ply:GetPos():WithinAABox( pos3, pos4 ) then
							ply:LagCompensation(true)
							print("hellow world")
							net.Start("medium_toss")    
							net.WriteString("right")  	  
							net.SendToServer()	 
							ply:LagCompensation(false)
						end 	
					end     
					if   button ==  KEY_B then
						net.Start("save_ball")    	
						net.SendToServer()	
					end
				end 
			end  
		end)                 

	end                        

	local close_button = vgui.Create( "DButton", BottomPanel )          
	close_button:Dock(TOP)  
	close_button:SetText("Back") 
	close_button:SetFont("small") 
	close_button:SetTextColor(Color(255,255,255))    
	close_button:SetSize(50, 50)            
	--myer_button:SetImage("materials/stalk.gif")         
	close_button.Paint = function( self, w, h ) -- 'function Frame:Paint( w, h )' works too 
		draw.RoundedBox( 0, 0, 0, w, h, Color( 255,0,0,100) )     
	end
	function close_button:DoClick()
		surface.PlaySound("click.wav")  
		MainFrame:Close() 
		SurvivorScreen2() 
	end 
end 

function Third_Person()  
	-- POV -------------------------
	hook.Add("Think", "pov", function()	 
		function ThirdPerson(ply, pos, angles, fov) local view = {} 
		view.origin = pos-(angles:Forward()*60) +  
	                        (angles:Right()*35) +     
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
	end)
end
