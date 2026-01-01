print("Mechanic UI")

-- Main UI Frame and Panels
MainFrame2 = vgui.Create("DFrame")
MainFrame2:SetSize(1366,768)
MainFrame2:SetTitle("This gamemode is created by Hope")
MainFrame2:SetVisible(false)
MainFrame2:SetBackgroundBlur( false )
MainFrame2:ShowCloseButton(false)
MainFrame2:Center()
MainFrame2.Paint = function( self, w, h )
    draw.RoundedBox( 0, 0, 0, w, h, Color( 0,0,0,0) )
end

TopPanel = vgui.Create( "DPanel", MainFrame2 )
TopPanel:Dock(TOP)
TopPanel:SetSize(200,100)
TopPanel.Paint = function( self, w, h )
    draw.RoundedBox( 0, 0, 0, w, h, Color( 0,0,0,0) )
end

FillPanel = vgui.Create( "DPanel", MainFrame2 )
FillPanel:Dock(FILL)
FillPanel:SetSize(1366,1366)
FillPanel.Paint = function( self, w, h )
    draw.RoundedBox( 0, 0, 0, w, h, Color( 0,0,0,0) )
end

LeftPanel = vgui.Create( "DScrollPanel", MainFrame2 )
LeftPanel:Dock(LEFT)
LeftPanel:SetSize(500,0)
LeftPanel.Paint = function( self, w, h )
    draw.RoundedBox( 0, 0, 0, w, h, Color( 0,0,0,0) )
end

RightPanel = vgui.Create( "DScrollPanel", MainFrame2 )
RightPanel:Dock(RIGHT)
RightPanel:SetSize(500,0)
RightPanel.Paint = function( self, w, h )
    draw.RoundedBox( 0, 0, 0, w, h, Color( 0,0,0,0) )
end

BottomPanel = vgui.Create( "DPanel", MainFrame2 )
BottomPanel:Dock(BOTTOM)
BottomPanel:SetSize(1366,100)
BottomPanel.Paint = function( self, w, h )
    draw.RoundedBox( 0, 0, 0, w, h, Color( 0,0,0,0) )
end

-- Progress Bar
DProgress = vgui.Create( "DProgress",BottomPanel )
DProgress:Dock(TOP)
DProgress:SetSize( 400, 30 )
DProgress:SetFraction( 0 )

-- Ball Detection Button
ball_detect = vgui.Create( "DButton", BottomPanel )
ball_detect:Dock(TOP)
ball_detect:SetText("")
ball_detect:SetTextColor(Color(0,0,0))
ball_detect:SetSize(64, 64)
ball_detect:DockMargin( 0, 5 , 0, 0 )
ball_detect:SetFont("tiny")
ball_detect.Paint = function( self, w, h )
    draw.RoundedBox( 255, 0, 0, w, h, Color( 0,0,0,0) )
end
