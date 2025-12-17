function RulesRegulation() 
	RulesFrame = vgui.Create("DFrame")
	RulesFrame:SetSize(1366,768)
	RulesFrame:SetTitle("This gamemode is created by Hope")
	RulesFrame:SetVisible(true) 
	RulesFrame:SetBackgroundBlur( true )
	RulesFrame:ShowCloseButton(true)
	RulesFrame:Center()
	RulesFrame:MakePopup(true)
	RulesFrame.Paint = function( self, w, h ) -- 'function Frame:Paint( w, h )' works too
	draw.RoundedBox( 0, 0, 0, w, h, Color( 255,255,255,255) ) -- Draw a black box instead of the frame
	end

	function MainFrame:Init()
		self.startTime = SysTime()  
	end
	function MainFrame:Paint() 
		Derma_DrawBackgroundBlur( self, self.startTime) 
	end

	local LeftPanel = vgui.Create( "DScrollPanel", RulesFrame )  
	LeftPanel:Dock(LEFT)
	LeftPanel:SetSize(0,0)
	LeftPanel.Paint = function( self, w, h )  
	draw.RoundedBox( 0, 0, 0, w, h, Color( 0,0,0,0) ) -- Draw a black box instead of the frame
	end

	local RightPanel = vgui.Create( "DScrollPanel", RulesFrame )  
	RightPanel:Dock(RIGHT)
	RightPanel:SetSize(0,0)
	RightPanel.Paint = function( self, w, h )  
	draw.RoundedBox( 0, 0, 0, w, h, Color( 0,0,0,0) ) -- Draw a black box instead of the frame
	end

	local TopPanel = vgui.Create( "DScrollPanel", RulesFrame )  
	TopPanel:Dock(TOP)
	TopPanel:SetSize(200,100)
	TopPanel.Paint = function( self, w, h )  
	draw.RoundedBox( 0, 0, 0, w, h, Color( 0,0,0,0) ) -- Draw a black box instead of the frame
	end

	local FillPanel = vgui.Create( "DScrollPanel", RulesFrame )  
	FillPanel:Dock(FILL)
	FillPanel.Paint = function( self, w, h )  
	draw.RoundedBox( 0, 0, 0, w, h, Color( 0,0,0,0) ) -- Draw a black box instead of the frame
	end

	local title = vgui.Create( "DButton", TopPanel ) 
	title:Dock(TOP)  
	title:SetText("Gmod Haikyuu Volleyball RULES") 
	title:SetTextColor(Color(255,255,255))     
	title:SetSize(50, 60)        
	title:SetFont("Big") 
	title:DockMargin(10,0,0,0)
	title.Paint = function( self, w, h ) -- 'function Frame:Paint( w, h )' works too 		
	draw.RoundedBox( 255, 0, 0, w, h, Color( 0,0,0,0) )
	end

	local desc = vgui.Create( "DButton", FillPanel ) 
	desc:Dock(TOP)  
	desc:SetText("Volleyball has its own rules. However in Garry's Mod there are some stuff that needs to be changed in order to have a \nsmoother gameplay. Below are rules:") 
	desc:SetTextColor(Color(255,255,255))     
	desc:SetSize(50, 70)        
	desc:SetFont("tiny2") 
	desc.Paint = function( self, w, h ) -- 'function Frame:Paint( w, h )' works too 		
	draw.RoundedBox( 255, 0, 0, w, h, Color( 0,0,0,0) )
	end

	local rule1 = vgui.Create( "DButton", FillPanel ) 
	rule1:Dock(TOP)  
	rule1:SetText("1. The ball can still be received even if it reached the ground WITHIN 0.5 seconds."..
		"\nNote: You can turn on the buzzer to know if it is 0.5 (at the ref stand)"..
		"\n\n2. You cannot block using Spike.\n\n3. If player received with multiple receive sound effects (not obvious Double touch) and the player is having high ping. It is acceptable. Keep the game going.")
	rule1:SetTextColor(Color(255,255,255))     
	rule1:SetSize(50, 500)        
	rule1:SetFont("tiny") 
	rule1.Paint = function( self, w, h ) -- 'function Frame:Paint( w, h )' works too 		
	draw.RoundedBox( 255, 0, 0, w, h, Color( 0,0,0,0) )
	end
end

print("cl_keybind")
// Here is where you define all of those keybinds 
LEFT_CLICK = ""
RIGHT_CLICK = ""
KEY_BLOCK = ""
KEY_RECEIVE = ""


