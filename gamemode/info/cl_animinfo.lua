function PopUpFrame() 
	
end 

function loadPlayermodel() 
	LoadFrame = vgui.Create("DFrame")
	LoadFrame:SetSize(1366,768)
	LoadFrame:SetTitle("This gamemode is created by Hope")
	LoadFrame:SetVisible(true) 
	LoadFrame:SetBackgroundBlur( true )
	LoadFrame:ShowCloseButton(true)
	LoadFrame:Center()
	LoadFrame:MakePopup(false)
	LoadFrame.Paint = function( self, w, h ) -- 'function Frame:Paint( w, h )' works too
	draw.RoundedBox( 0, 0, 0, w, h, Color( 0,0,0,0) ) -- Draw a black box instead of the frame
	end

	local FillPanel = vgui.Create( "DPanel", LoadFrame )  
	FillPanel:Dock(FILL)
	FillPanel:DockPadding(100,0,100,0)
	FillPanel.Paint = function( self, w, h )  
	draw.RoundedBox( 0, 0, 0, w, h, Color( 0,0,0,0) ) -- Draw a black box instead of the frame
	end

	local linkbutton = vgui.Create( "DButton", FillPanel ) 
	linkbutton:Dock(TOP)  
	linkbutton:SetText("Press this button and copy the URL! (If you want animation)")
	linkbutton:SetTextColor(Color(0,0,0))     
	linkbutton:SetSize(50, 50)  
	linkbutton:DockMargin( 0, 50 , 0, 0 )         

	linkbutton.DoClick = function()
		--sound3:Stop()
	    gui.OpenURL( "https://pastebin.com/bWbQdALs" )
	end

	local loadmodel = vgui.Create( "DButton", FillPanel ) 
	loadmodel:Dock(TOP)  
	loadmodel:SetText("STEPS(Must do it fast!, if not working rejoin and do it fast)\n\n1.pac\n2.load > load from url\n3.paste link\n4.pac > wear\npress x button on top right")
	loadmodel:SetTextColor(Color(255,255,255))     
	loadmodel:SetSize(50, 300)  
	loadmodel:DockMargin( 0, 50 , 0, 0 )         
	loadmodel:SetFont("tiny2") 
		loadmodel.Paint = function( self, w, h ) -- 'function Frame:Paint( w, h )' works too 
		draw.RoundedBox( 0, 0, 0, w, h, Color( 255,0,0) )     
	end 

	function loadmodel:DoClick() 
		LoadFrame:SetVisible(false)
	end 
	
end 