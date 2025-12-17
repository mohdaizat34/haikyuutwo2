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

local FillPanel = vgui.Create( "DPanel", MainFrame )  
FillPanel:Dock(FILL)
FillPanel.Paint = function( self, w, h )  
draw.RoundedBox( 0, 0, 0, w, h, Color( 0,0,0,0) ) -- Draw a black box instead of the frame
end

local button_outside = vgui.Create( "DButton", LeftPanel )       
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

local button_outside2 = vgui.Create( "DButton", LeftPanel )       
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

local button_outside3 = vgui.Create( "DButton", LeftPanel )       
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

local button_opp = vgui.Create( "DButton", RightPanel )       
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

local button_opp = vgui.Create( "DButton", RightPanel )       
button_opp:Dock(TOP) 
button_opp:SetSize(100,50)   
button_opp:SetText("Opposite - Med")   
button_opp:SetTextColor(Color(255,255,255))                  
button_opp:DockMargin( 0, 10 , 0, 0 )     
button_opp:SetFont("tiny") 
button_opp.Paint = function( self, w, h )   
	draw.RoundedBox( 0, 0, 0, w, h, Color( 45, 94, 173,180) ) 
end

function button_opp:DoClick() 
	net.Start("communication")
	net.WriteString("Opposite - Med")
	net.SendToServer()
end 

local button_opp = vgui.Create( "DButton", RightPanel )       
button_opp:Dock(TOP) 
button_opp:SetSize(100,50)   
button_opp:SetText("Opposite - Shoot")   
button_opp:SetTextColor(Color(255,255,255))                  
button_opp:DockMargin( 0, 10 , 0, 0 )     
button_opp:SetFont("tiny") 
button_opp.Paint = function( self, w, h )   
	draw.RoundedBox( 0, 0, 0, w, h, Color( 45, 94, 173,180) ) 
end

function button_opp:DoClick() 
	net.Start("communication")
	net.WriteString("Opposite - Shoot")
	net.SendToServer()
end 

local button_title = vgui.Create( "DButton", TopPanel )       
button_title:Dock(TOP) 
button_title:SetSize(100,30)   
button_title:SetText("Communication")   
button_title:SetTextColor(Color(255,255,255))                  
button_title:DockMargin( 0, 0 , 0, 0 )     
button_title:SetFont("tiny2") 
button_title.Paint = function( self, w, h )   
	draw.RoundedBox( 0, 0, 0, w, h, Color( 0, 0, 0,100) ) 
end


local button_mb = vgui.Create( "DButton", TopPanel )       
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

local button_mb = vgui.Create( "DButton", TopPanel )       
button_mb:Dock(TOP) 
button_mb:SetSize(100,30)   
button_mb:SetText("Middle - B Quick (Shoot far from Setter)")   
button_mb:SetTextColor(Color(255,255,255))                  
button_mb:DockMargin( 0, 10 , 0, 0 )     
button_mb:SetFont("tiny") 
button_mb.Paint = function( self, w, h )   
	draw.RoundedBox( 0, 0, 0, w, h, Color( 255, 129, 10,180) ) 
end

function button_mb:DoClick() 
	net.Start("communication")
	net.WriteString("Middle - B Quick (Shoot far from Setter)")
	net.SendToServer()
end 

local button_mb = vgui.Create( "DButton", TopPanel )       
button_mb:Dock(TOP) 
button_mb:SetSize(100,30)   
button_mb:SetText("Middle - C Quick (Behind Setter)")   
button_mb:SetTextColor(Color(255,255,255))                  
button_mb:DockMargin( 0, 10 , 0, 0 )     
button_mb:SetFont("tiny") 
button_mb.Paint = function( self, w, h )   
	draw.RoundedBox( 0, 0, 0, w, h, Color( 255, 129, 10,180) ) 
end

function button_mb:DoClick() 
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

local button_backrow = vgui.Create( "DButton", BottomPanel )       
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

local button_backrow = vgui.Create( "DButton", BottomPanel )       
button_backrow:Dock(TOP) 
button_backrow:SetSize(100,30)   
button_backrow:SetText("Middle - Backrow")   
button_backrow:SetTextColor(Color(255,255,255))                  
button_backrow:DockMargin( 0, 10 , 0, 0 )     
button_backrow:SetFont("tiny") 
button_backrow.Paint = function( self, w, h )   
	draw.RoundedBox( 0, 0, 0, w, h, Color( 116, 10, 255,180) ) 
end

function button_backrow:DoClick() 
	net.Start("communication")
	net.WriteString("Middle - Backrow")
	net.SendToServer()
end 

local button_backrow3 = vgui.Create( "DButton", BottomPanel )       
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

local button_backrow3 = vgui.Create( "DButton", BottomPanel )       
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


function SetterSignal() 
	local buttonpress = 0 
	hook.Add( "Tick", "SetterSignal", function()
		if (input.IsButtonDown(KEY_LALT)) then
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

net.Receive("colored_message",function() 
	local message = net.ReadString() 

	chat.AddText(Color(222, 16, 174),message)
end)