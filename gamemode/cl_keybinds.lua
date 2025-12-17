
function ControlScreen() 
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
	draw.RoundedBox( 0, 0, 0, w, h, Color( 0,0,0,0) ) -- Draw a black box instead of the frame 
	end

	--[[local BottomPanel = vgui.Create( "DPanel", MainFrame )          
	BottomPanel:Dock(BOTTOM)
	BottomPanel:SetSize(100,100)               
	BottomPanel.Paint = function( self, w, h )  
	draw.RoundedBox( 0, 0, 0, w, h, Color( 0,0,0,0) ) -- Draw a black box instead of the frame
	end]]

	local title = vgui.Create( "DButton", FillPanel )          
	title:Dock(TOP)  
	title:SetSize(110,110)      
	title:SetText("CHOOSE A KEYBIND SET")     
	title:SetTextColor(Color(255,255,255))                
	title:DockMargin( 0, 30 , 0, 0 )      
	title:SetFont("Big2") 
	title.Paint = function( self, w, h )  
	draw.RoundedBox( 0, 0, 0, w, h, Color( 0,0,0,0) ) -- Draw a black box instead of the frame
	end
 
	set_a = vgui.Create( "DButton", FillPanel )           
	set_a:Dock(TOP)  
	set_a:SetSize(110,250)        
	set_a:SetText("SET A\n\nV - RECEIVE or MEDIUM TOSS (for setter)\nB - SPIKE or FREAK TOSS (for Freak tosser)\nC - LOW TOSS (Setter)\nG- BACK TOSS (Setter)\nALT - ABILITY (Only certain character) ")     
	set_a:SetTextColor(Color(255,0,0))                
	set_a:DockMargin( 0, 30 , 0, 0 )     
	set_a:SetFont("tiny2") 

	function set_a:DoClick() 
		keybind_set = "a"
		surface.PlaySound("click.wav")
		set_a:SetText("SELECTED")
		set_a:SetTextColor(Color(255,255,255)) 
		set_a:SetFont("Big2")
		set_a.Paint = function( self, w, h )  
			draw.RoundedBox( 0, 0, 0, w, h, Color( 44, 212, 89,150) ) -- Draw a black box instead of the frame
		end

		set_b:SetVisible(false)
		timer.Create("close",1.5,1,function()
			MainFrame:Close()
			MenuFrame()  
		end)
	end 
 
	set_b = vgui.Create( "DButton", FillPanel )          
	set_b:Dock(TOP)  
	set_b:SetSize(110,250)        
	set_b:SetText("SET B\n\nE - RECEIVE\nQ - SPIKE or FREAK TOSS (for Freak tosser)\nC - LOW TOSS (Setter)\nF - MED TOSS (Setter)\nG- BACK TOSS (Setter)\nLT - ABILITY (Only certain character) ")     
	set_b:SetTextColor(Color(255,0,0))                
	set_b:DockMargin( 0, 30 , 0, 0 )     
	set_b:SetFont("tiny2") 

	function set_b:DoClick() 
		keybind_set = "b"
		surface.PlaySound("click.wav")
		set_b:SetText("SELECTED")
		set_b:SetTextColor(Color(255,255,255)) 
		set_b:SetFont("Big2")
		set_b.Paint = function( self, w, h )  
			draw.RoundedBox( 0, 0, 0, w, h, Color( 44, 212, 89,150) ) -- Draw a black box instead of the frame
		end

		set_a:SetVisible(false) 
		timer.Create("close",1.5,1,function()
			MainFrame:Close()
			MenuFrame()
		end)
	end    

	--[[local simon_desc3 = vgui.Create( "DLabel", FillPanel )          
	simon_desc3:Dock(TOP)  
	simon_desc3:SetSize(100,100)             
	simon_desc3:SetText("2.Setter (Freak Tosser)\nC - Low Toss\nV - Medium Toss\nB - Freak Toss!")     
	simon_desc3:SetTextColor(Color(255, 255, 255))                
	simon_desc3:DockMargin( 0, 30 , 0, 0 )     
	simon_desc3:SetFont("tiny2")

	local simon_desc3 = vgui.Create( "DLabel", FillPanel )          
	simon_desc3:Dock(TOP)  
	simon_desc3:SetSize(100,100)             
	simon_desc3:SetText("3.Opposite Hitter (Wall)\nC - Slam Down\nV - Receive\nB - Spike")     
	simon_desc3:SetTextColor(Color(255, 255, 255))                
	simon_desc3:DockMargin( 0, 30 , 0, 0 )     
	simon_desc3:SetFont("tiny2")      

	local title2 = vgui.Create( "DLabel", FillPanel )       
	title2:Dock(TOP)
	title2:SetSize(100,100)     
	title2:SetText("ARMY ATHLETES")       
	title2:SetTextColor(Color(255,0,255))                
	title2:DockMargin( 0, 50 , 0, 0 )    
	title2:SetFont("logo")  

	local simon_desc2 = vgui.Create( "DLabel", FillPanel )          
	simon_desc2:Dock(TOP)  
	simon_desc2:SetSize(110,110)      
	simon_desc2:SetText("1.Wing Spiker (Ace)\nC - None\nV - Receive\nL.Click - SPIKE")     
	simon_desc2:SetTextColor(Color(255,255,255))                
	simon_desc2:DockMargin( 0, 30 , 0, 0 )     
	simon_desc2:SetFont("tiny2") 

	local simon_desc3 = vgui.Create( "DLabel", FillPanel )          
	simon_desc3:Dock(TOP)  
	simon_desc3:SetSize(150,150)             
	simon_desc3:SetText("2.Setter (Serve King)\nC - Low Toss\nV - Medium Toss\nL.Click - SPIKE\nALT - Serve King")     
	simon_desc3:SetTextColor(Color(255, 255, 255))                
	simon_desc3:DockMargin( 0, 30 , 0, 0 )     
	simon_desc3:SetFont("tiny2")

	local simon_desc3 = vgui.Create( "DLabel", FillPanel )          
	simon_desc3:Dock(TOP)  
	simon_desc3:SetSize(150,150)             
	simon_desc3:SetText("3.Libero (Fast Retard)\nC - Low Toss\nV - Receive\nB - Save Ball\nALT - Dash")     
	simon_desc3:SetTextColor(Color(255, 255, 255))                
	simon_desc3:DockMargin( 0, 30 , 0, 0 )     
	simon_desc3:SetFont("tiny2")      

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
		MenuFrame() 
	end ]] 
end 