local MainFrame = vgui.Create("DFrame")
MainFrame:SetSize(600,500)
MainFrame:SetTitle("This gamemode is created by Hope")
MainFrame:SetVisible(false) 
MainFrame:SetBackgroundBlur( true )
MainFrame:ShowCloseButton(false)
MainFrame:Center()
MainFrame:MakePopup(true)
MainFrame.Paint = function( self, w, h ) -- 'function Frame:Paint( w, h )' works too
draw.RoundedBox( 0, 0, 0, w, h, Color( 0,0,0,0) ) -- Draw a black box instead of the frame
end


local TopPanel = vgui.Create( "DPanel", MainFrame )  
TopPanel:Dock(TOP)
TopPanel:SetSize(0,150)
TopPanel.Paint = function( self, w, h )  
draw.RoundedBox( 0, 0, 0, w, h, Color( 0,0,0,0) ) -- Draw a black box instead of the frame
end

local BottomPanel = vgui.Create( "DPanel", MainFrame )  
BottomPanel:Dock(BOTTOM)
BottomPanel:SetSize(0,150)
BottomPanel.Paint = function( self, w, h )  
draw.RoundedBox( 0, 0, 0, w, h, Color( 0,0,0,0) ) -- Draw a black box instead of the frame
end

local RightPanel = vgui.Create( "DPanel", MainFrame )  
RightPanel:Dock(RIGHT)
RightPanel:SetSize(150,150)
RightPanel.Paint = function( self, w, h )  
draw.RoundedBox( 0, 0, 0, w, h, Color( 0,0,0,0) ) -- Draw a black box instead of the frame
end

local LeftPanel = vgui.Create( "DPanel", MainFrame )  
LeftPanel:Dock(LEFT)
LeftPanel:SetSize(150,150)
LeftPanel.Paint = function( self, w, h )  
draw.RoundedBox( 0, 0, 0, w, h, Color( 0,0,0,0) ) -- Draw a black box instead of the frame
end


local MarkPlayerPanel = vgui.Create( "DPanel", MainFrame )  
MarkPlayerPanel:Dock(FILL)
MarkPlayerPanel:SetSize(0,100)
MarkPlayerPanel.Paint = function( self, w, h )  
draw.RoundedBox( 0, 0, 0, w, h, Color( 0,0,0,200) ) -- Draw a black box instead of the frame
end

net.Receive ("team_get_players_cl" , function(bits , ply )
	local team_players = net.ReadTable() 
	MarkPlayerPanel:Clear()
	//--Start Mark Player list //-- 
	for k,v in pairs(team_players) do 

	
		local player_list_button = vgui.Create( "DButton", MarkPlayerPanel )       
		player_list_button:Dock(TOP) 
		player_list_button:SetSize(100,20)   
		player_list_button:SetText(team_players[k]:Nick())   
		player_list_button:SetTextColor(Color(255,255,255))                
		player_list_button:DockMargin( 0, 10 , 0, 0 )     
		player_list_button:SetFont("TargetID") 
		player_list_button.Paint = function(self, w, h)   
			draw.RoundedBox(0, 0, 0, w, h, team.GetColor(LocalPlayer():Team())) -- Corrected
		end
		

		function player_list_button:DoClick() 
			net.Start("communication")
			net.WriteString("(Setter) Setting to : "..team_players[k]:Nick())
			net.SendToServer()
		end 
	
	end 
end)
--//End  Mark Player //---


button_outside = vgui.Create( "DButton", LeftPanel )       
button_outside:Dock(TOP) 
button_outside:SetSize(100,50)   
button_outside:SetText("Outside - High")   
button_outside:SetTextColor(Color(255,255,255))                  
button_outside:DockMargin( 0, 0 , 0, 0 )     
button_outside:SetFont("tiny") 
button_outside.Paint = function( self, w, h )   
	draw.RoundedBox( 0, 0, 0, w, h, Color( 255,0,0,180) ) 
end

function button_outside:DoClick() 
	net.Start("communication")
	net.WriteString("Outside - High")
	net.SendToServer()
end 

button_outside2 = vgui.Create( "DButton", LeftPanel )       
button_outside2:Dock(TOP) 
button_outside2:SetSize(100,50)   
button_outside2:SetText("Outside - Med")   
button_outside2:SetTextColor(Color(255,255,255))                  
button_outside2:DockMargin( 0, 10 , 0, 0 )     
button_outside2:SetFont("tiny") 
button_outside2.Paint = function( self, w, h )   
	draw.RoundedBox( 0, 0, 0, w, h, Color( 255,0,0,180) ) 
end

function button_outside2:DoClick() 
	net.Start("communication")
	net.WriteString("Outside - Med")
	net.SendToServer()
end 

button_outside3 = vgui.Create( "DButton", LeftPanel )       
button_outside3:Dock(TOP) 
button_outside3:SetSize(100,50)   
button_outside3:SetText("Outside - Shoot")   
button_outside3:SetTextColor(Color(255,255,255))                  
button_outside3:DockMargin( 0, 10 , 0, 0 )     
button_outside3:SetFont("tiny") 
button_outside3.Paint = function( self, w, h )   
	draw.RoundedBox( 0, 0, 0, w, h, Color( 255,0,0,180) ) 
end

function button_outside3:DoClick() 
	net.Start("communication")
	net.WriteString("Outside - Shoot")
	net.SendToServer()
end 

button_opp = vgui.Create( "DButton", RightPanel )       
button_opp:Dock(TOP) 
button_opp:SetSize(100,50)   
button_opp:SetText("Opposite - High")   
button_opp:SetTextColor(Color(255,255,255))                  
button_opp:DockMargin( 0, 0 , 0, 0 )     
button_opp:SetFont("tiny") 
button_opp.Paint = function( self, w, h )   
	draw.RoundedBox( 0, 0, 0, w, h, Color( 45, 94, 173,180) ) 
end

function button_opp:DoClick() 
	net.Start("communication")
	net.WriteString("Opposite - High")
	net.SendToServer()
end 

button_opp2 = vgui.Create( "DButton", RightPanel )       
button_opp2:Dock(TOP) 
button_opp2:SetSize(100,50)   
button_opp2:SetText("Opposite - Med")   
button_opp2:SetTextColor(Color(255,255,255))                  
button_opp2:DockMargin( 0, 10 , 0, 0 )     
button_opp2:SetFont("tiny") 
button_opp2.Paint = function( self, w, h )   
	draw.RoundedBox( 0, 0, 0, w, h, Color( 45, 94, 173,180) ) 
end

function button_opp2:DoClick() 
	net.Start("communication")
	net.WriteString("Opposite - Med")
	net.SendToServer()
end 

button_opp3 = vgui.Create( "DButton", RightPanel )       
button_opp3:Dock(TOP) 
button_opp3:SetSize(100,50)   
button_opp3:SetText("Opposite - Shoot")   
button_opp3:SetTextColor(Color(255,255,255))                  
button_opp3:DockMargin( 0, 10 , 0, 0 )     
button_opp3:SetFont("tiny") 
button_opp3.Paint = function( self, w, h )   
	draw.RoundedBox( 0, 0, 0, w, h, Color( 45, 94, 173,180) ) 
end

function button_opp3:DoClick() 
	net.Start("communication")
	net.WriteString("Opposite - Shoot")
	net.SendToServer()
end 

button_title = vgui.Create( "DButton", TopPanel )       
button_title:Dock(TOP) 
button_title:SetSize(100,30)   
button_title:SetText("Communication")   
button_title:SetTextColor(Color(255,255,255))                  
button_title:DockMargin( 0, 0 , 0, 0 )     
button_title:SetFont("tiny2") 
button_title.Paint = function( self, w, h )   
	draw.RoundedBox( 0, 0, 0, w, h, Color( 0, 0, 0,100) ) 
end


button_mb = vgui.Create( "DButton", TopPanel )       
button_mb:Dock(TOP) 
button_mb:SetSize(100,30)   
button_mb:SetText("Middle - A Quick (Near Setter)")   
button_mb:SetTextColor(Color(255,255,255))                  
button_mb:DockMargin( 0, 0 , 0, 0 )     
button_mb:SetFont("tiny") 
button_mb.Paint = function( self, w, h )   
	draw.RoundedBox( 0, 0, 0, w, h, Color( 255, 129, 10,180) ) 
end

function button_mb:DoClick() 
	net.Start("communication")
	net.WriteString("Middle - A Quick (Near Setter)")
	net.SendToServer()
end 

button_mb2 = vgui.Create( "DButton", TopPanel )       
button_mb2:Dock(TOP) 
button_mb2:SetSize(100,30)   
button_mb2:SetText("Middle - B Quick (Shoot far from Setter)")   
button_mb2:SetTextColor(Color(255,255,255))                  
button_mb2:DockMargin( 0, 10 , 0, 0 )     
button_mb2:SetFont("tiny") 
button_mb2.Paint = function( self, w, h )   
	draw.RoundedBox( 0, 0, 0, w, h, Color( 255, 129, 10,180) ) 
end

function button_mb2:DoClick() 
	net.Start("communication")
	net.WriteString("Middle - B Quick (Shoot far from Setter)")
	net.SendToServer()
end 

button_mb3 = vgui.Create( "DButton", TopPanel )       
button_mb3:Dock(TOP) 
button_mb3:SetSize(100,30)   
button_mb3:SetText("Middle - C Quick (Behind Setter)")   
button_mb3:SetTextColor(Color(255,255,255))                  
button_mb3:DockMargin( 0, 10 , 0, 0 )     
button_mb3:SetFont("tiny") 
button_mb3.Paint = function( self, w, h )   
	draw.RoundedBox( 0, 0, 0, w, h, Color( 255, 129, 10,180) ) 
end

function button_mb3:DoClick() 
	net.Start("communication")
	net.WriteString("Middle - C Quick (Behind Setter)")
	net.SendToServer()
end 

--[[local button_mb = vgui.Create( "DButton", TopPanel )       
button_mb:Dock(TOP) 
button_mb:SetSize(100,30)   
button_mb:SetText("Middle - 2nd Tempo (Delayed A Quick)")   
button_mb:SetTextColor(Color(255,255,255))                  
button_mb:DockMargin( 0, 10 , 0, 0 )     
button_mb:SetFont("tiny") 
button_mb.Paint = function( self, w, h )   
	draw.RoundedBox( 0, 0, 0, w, h, Color(255, 129, 10,180) ) 
end

function button_mb:DoClick() 
	net.Start("communication")
	net.WriteString("")
	net.SendToServer()
end ]]

button_backrow = vgui.Create( "DButton", BottomPanel )       
button_backrow:Dock(TOP) 
button_backrow:SetSize(100,30)   
button_backrow:SetText("Outside - Backrow")   
button_backrow:SetTextColor(Color(255,255,255))                  
button_backrow:DockMargin( 0, 10 , 0, 0 )     
button_backrow:SetFont("tiny") 
button_backrow.Paint = function( self, w, h )   
	draw.RoundedBox( 0, 0, 0, w, h, Color(116, 10, 255,180) ) 
end

function button_backrow:DoClick() 
	net.Start("communication")
	net.WriteString("Outside - Backrow")
	net.SendToServer()
end 

button_backrow2 = vgui.Create( "DButton", BottomPanel )       
button_backrow2:Dock(TOP) 
button_backrow2:SetSize(100,30)   
button_backrow2:SetText("Middle - Backrow")   
button_backrow2:SetTextColor(Color(255,255,255))                  
button_backrow2:DockMargin( 0, 10 , 0, 0 )     
button_backrow2:SetFont("tiny") 
button_backrow2.Paint = function( self, w, h )   
	draw.RoundedBox( 0, 0, 0, w, h, Color( 116, 10, 255,180) ) 
end

function button_backrow2:DoClick() 
	net.Start("communication")
	net.WriteString("Middle - Backrow")
	net.SendToServer()
end 

button_backrow3 = vgui.Create( "DButton", BottomPanel )       
button_backrow3:Dock(TOP) 
button_backrow3:SetSize(100,30)   
button_backrow3:SetText("Opposite - Backrow")   
button_backrow3:SetTextColor(Color(255,255,255))                  
button_backrow3:DockMargin( 0, 10 , 0, 0 )     
button_backrow3:SetFont("tiny") 
button_backrow3.Paint = function( self, w, h )   
	draw.RoundedBox( 0, 0, 0, w, h, Color( 116, 10, 255,180) ) 
end

function button_backrow3:DoClick() 
	net.Start("communication")
	net.WriteString("Opposite - Backrow")
	net.SendToServer()
end 


function SpikerSignal()
	MarkPlayerPanel:SetVisible(false)
	outsideHigh = LocalPlayer():Nick()..": I want Outside - High!"
	outsideMed = LocalPlayer():Nick()..": I want Outside - Med!"
	outsideShoot = LocalPlayer():Nick()..": I want Outside - Shoot!"
	oppositeHigh = LocalPlayer():Nick()..": I want Opposite - High!"
	oppositeMed = LocalPlayer():Nick()..": I want Opposite - Med!"
	oppositeShoot = LocalPlayer():Nick()..": I want Opposite - Shoot!"
	middleAQuick = LocalPlayer():Nick()..": I want Middle - A Quick (Near Setter)!"
	middleBQuick = LocalPlayer():Nick()..": I want Middle - B Quick (Shoot far from Setter)!"
	middleCQuick = LocalPlayer():Nick()..": I want Middle - C Quick (Behind Setter)!"
	outsideBackrow = LocalPlayer():Nick()..": I want Outside - Backrow!"
	middleBackrow = LocalPlayer():Nick()..": I want Middle - Backrow!"
	oppositeBackrow = LocalPlayer():Nick()..": I want Opposite - Backrow"

	--[[ Declare button_outside DoClick function ]]
	function button_outside:DoClick() 
        net.Start("communication")
        net.WriteString(outsideHigh)
        net.SendToServer()
    end 

    --[[ Declare button_outside2 DoClick function ]]
    function button_outside2:DoClick() 
        net.Start("communication")
        net.WriteString(outsideMed)
        net.SendToServer()
    end 

    --[[ Declare button_outside3 DoClick function ]]
    function button_outside3:DoClick() 
        net.Start("communication")
        net.WriteString(outsideShoot)
        net.SendToServer()
    end 

    --[[ Declare button_opp DoClick function ]]
    function button_opp:DoClick() 
        net.Start("communication")
        net.WriteString(oppositeHigh)
        net.SendToServer()
    end 

    --[[ Declare button_opp2 DoClick function ]]
    function button_opp2:DoClick() 
        net.Start("communication")
        net.WriteString(oppositeMed)
        net.SendToServer()
    end 

    --[[ Declare button_opp3 DoClick function ]]
    function button_opp3:DoClick() 
        net.Start("communication")
        net.WriteString(oppositeShoot)
        net.SendToServer()
    end 

    --[[ Declare button_mb DoClick function ]]
    function button_mb:DoClick() 
        net.Start("communication")
        net.WriteString(middleAQuick)
        net.SendToServer()
    end 

    --[[ Declare button_mb2 DoClick function ]]
    function button_mb2:DoClick() 
        net.Start("communication")
        net.WriteString(middleBQuick)
        net.SendToServer()
    end 

    --[[ Declare button_mb3 DoClick function ]]
    function button_mb3:DoClick() 
        net.Start("communication")
        net.WriteString(middleCQuick)
        net.SendToServer()
    end 

    --[[ Declare button_backrow DoClick function ]]
    function button_backrow:DoClick() 
        net.Start("communication")
        net.WriteString(outsideBackrow)
        net.SendToServer()
    end 

    --[[ Declare button_backrow2 DoClick function ]]
    function button_backrow2:DoClick() 
        net.Start("communication")
        net.WriteString(middleBackrow)
        net.SendToServer()
    end 

	local buttonpress = 0 
	hook.Add( "Tick", "SpikerSignal", function()
		if (input.IsButtonDown(KEY_B)) then
			buttonpress = 1 
			MainFrame:SetVisible(true)

		else 
			if buttonpress == 0 then 

			elseif buttonpress == 1 then 
				buttonpress = 0 
				MainFrame:SetVisible(false)
			end 
		end 
	end) 
end

function SetterSignal()
	MarkPlayerPanel:SetVisible(true)
	outsideHigh = "Setter: Outside (Leftside) - High"
	outsideMed = "Setter: Outside (Leftside) - Med"
	outsideShoot = "Setter: Outside (Leftside) - Shoot"
	oppositeHigh = "Setter: Opposite (Rightside) - High"
	oppositeMed = "Setter: Opposite (Rightside) - Med"
	oppositeShoot = "Setter: Opposite (Rightside) - Shoot"
	middleAQuick = "Setter: Middle - A Quick (1 Tempo | Near Setter)"
	middleBQuick = "Setter: Middle - B Quick (1 Tempo | Shoot far from Setter)"
	middleCQuick = "Setter: Middle - C Quick (1 Tempo | Behind Setter)"
	outsideBackrow = "Setter: Outside (Leftside) - Backrow"
	middleBackrow = "Setter: Middle - Backrow"
	oppositeBackrow = "Setter: Opposite (Rightside) - Backrow"

	--[[ Declare button_outside DoClick function ]]
	function button_outside:DoClick() 
        net.Start("communication")
        net.WriteString(outsideHigh)
        net.SendToServer()
    end 

    --[[ Declare button_outside2 DoClick function ]]
    function button_outside2:DoClick() 
        net.Start("communication")
        net.WriteString(outsideMed)
        net.SendToServer()
    end 

    --[[ Declare button_outside3 DoClick function ]]
    function button_outside3:DoClick() 
        net.Start("communication")
        net.WriteString(outsideShoot)
        net.SendToServer()
    end 

    --[[ Declare button_opp DoClick function ]]
    function button_opp:DoClick() 
        net.Start("communication")
        net.WriteString(oppositeHigh)
        net.SendToServer()
    end 

    --[[ Declare button_opp2 DoClick function ]]
    function button_opp2:DoClick() 
        net.Start("communication")
        net.WriteString(oppositeMed)
        net.SendToServer()
    end 

    --[[ Declare button_opp3 DoClick function ]]
    function button_opp3:DoClick() 
        net.Start("communication")
        net.WriteString(oppositeShoot)
        net.SendToServer()
    end 

    --[[ Declare button_mb DoClick function ]]
    function button_mb:DoClick() 
        net.Start("communication")
        net.WriteString(middleAQuick)
        net.SendToServer()
    end 

    --[[ Declare button_mb2 DoClick function ]]
    function button_mb2:DoClick() 
        net.Start("communication")
        net.WriteString(middleBQuick)
        net.SendToServer()
    end 

    --[[ Declare button_mb3 DoClick function ]]
    function button_mb3:DoClick() 
        net.Start("communication")
        net.WriteString(middleCQuick)
        net.SendToServer()
    end 

    --[[ Declare button_backrow DoClick function ]]
    function button_backrow:DoClick() 
        net.Start("communication")
        net.WriteString(outsideBackrow)
        net.SendToServer()
    end 

    --[[ Declare button_backrow2 DoClick function ]]
    function button_backrow2:DoClick() 
        net.Start("communication")
        net.WriteString(middleBackrow)
        net.SendToServer()
    end 

	local buttonpress = 0 
	local isRunning = false 

	hook.Add( "Tick", "SetterSignal", function()
		if (input.IsButtonDown(KEY_B)) then
			buttonpress = 1 
			MainFrame:SetVisible(true)
			if isRunning == false then 
				isRunning = true 
				net.Start("get_team_players")
				net.WriteString(team.GetName(LocalPlayer():Team()))
				net.SendToServer() 
				timer.Simple(1,function() isRunning = false end)
			end
		else 
			if buttonpress == 0 then 

			elseif buttonpress == 1 then 
				buttonpress = 0 
				MainFrame:SetVisible(false)
			end 
		end 
	end) 
end


net.Receive("colored_message",function() 
	local message = net.ReadString() 

	chat.AddText(Color(222, 16, 174),message)
end)