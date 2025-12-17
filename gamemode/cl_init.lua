include("mechanic/receive-system/cl_receive_system.lua") 
include("mechanic/cl_mechanic.lua") 
include("mechanic/kenma/cl_kenma.lua")
include("mechanic/sakusa/cl_sakusa.lua")
include("mechanic/hinata/cl_hinata.lua")
include("mechanic/cl_communication.lua") 
include("mechanic/cl_setting.lua")
include("keybind/cl_keybind.lua") 
include("info/cl_animinfo.lua") 
include("info/cl_hud.lua")
include("font.lua")
include("info/cl_tutorial.lua")
include("cl_ui.lua")

include("musicplayer/cl_music_player.lua")


position = "" 


hook.Add("PlayerButtonDown","anim",function(ply,button)
	local jump = 0 

	if button == KEY_K then 
		--ply:ConCommand("resetanim")
		ply:ConCommand("act cheer")
	elseif button == KEY_L then 
		ply:ConCommand("act laugh")
	--[[elseif button == KEY_F3 then 
		net.Start("topDownView")
		net.WriteString("enable")
		net.SendToServer()
	elseif button == KEY_F4 then 
		net.Start("topDownView")
		net.WriteString("disable")
		net.SendToServer()
	end]]
	end 

	if button == KEY_SPACE then 
		jump = jump + 1 
		if jump == 1 then 
			net.Start("stopMomentum")
			net.WriteString("stop")
			net.SendToServer() 
			jump = 0 

			timer.Create("revertjump",1,1,function() 
				net.Start("stopMomentum")
				net.WriteString("revert")
				net.WriteString(character)
				net.SendToServer() 
			end)
		end 
	end  
end)


-- --print("this is cl is working fine ")
-- local FirstFrame = vgui.Create("DFrame") 
-- FirstFrame:SetSize(1366,768)
-- FirstFrame:SetTitle("This gamemode is created by Hope")    
-- FirstFrame:SetVisible(true) 
-- FirstFrame:SetBackgroundBlur( true )
-- FirstFrame:ShowCloseButton(true) 
-- FirstFrame:Center()  
-- FirstFrame:MakePopup(true)
-- FirstFrame.Paint = function( self, w, h ) -- 'function Frame:Paint( w, h )' works too
-- draw.RoundedBox( 0, 0, 0, w, h, Color( 255,255,255,255) ) -- Draw a black box instead of the frame
-- end

-- function FirstFrame:Init() 
-- 	self.startTime = SysTime() 
-- end    
-- function FirstFrame:Paint() 
-- 	Derma_DrawBackgroundBlur( self, self.startTime ) 
-- end
 
-- local StartButton = vgui.Create( "DButton", FirstFrame ) 
-- StartButton:Dock(FILL)
-- StartButton:SetText("Press Anywhere")  
-- StartButton:SetTextColor(Color(255,255,255))  
-- StartButton:DockMargin( 0, 50 , 0, 0 )
-- StartButton:SetFont("Big2") 
-- StartButton.Paint = function( self, w, h ) -- 'function Frame:Paint( w, h )' works too
-- draw.RoundedBox( 0, 0, 0, w, h, Color( 0,0,0,0) )    
-- end

-- local pinkblackText = vgui.Create( "DButton", FirstFrame ) 
-- pinkblackText:Dock(BOTTOM)
-- pinkblackText:SetText("If you experience purple & black texture click here and rejoin")  
-- pinkblackText:SetTextColor(Color(255,255,255))  
-- pinkblackText:DockMargin( 0, 50 , 0, 0 )
-- pinkblackText:SetFont("Trebuchet24") 
-- pinkblackText.Paint = function( self, w, h ) -- 'function Frame:Paint( w, h )' works too
-- draw.RoundedBox( 0, 0, 0, w, h, Color( 232,33,33,88) )    
-- end
-- pinkblackText.DoClick = function()
-- 	--sound3:Stop()
-- 	gui.OpenURL( "https://steamcommunity.com/workshop/filedetails/?id=1933957019" )
-- end

-- local hide = {
-- 	["CHudHealth"] = true,
-- 	["CHudBattery"] = true
-- }

-- hook.Add( "HUDShouldDraw", "HideHUD", function( name )
-- 	if ( hide[ name ] ) then return false end

-- 	-- Don't return anything here, it may break other addons that rely on this hook.
-- end ) 

-- function StartButton:DoClick()
-- 	--hook.Add("Think","check_selected",function()
-- 	--timer.Start("check_status",1,0,function() 
-- 	--end) 
-- 	FirstFrame:Close()

-- 	//MenuFrame() 
-- end 

function MenuFrame() 
	//load pastebin animation 
	sound3  = CreateSound(game.GetWorld(), "lobby.mp3") 
		if sound3 then
			sound3:SetSoundLevel( 0 )
		end
	sound3:Play()  
	local MainFrame = vgui.Create("DFrame")
	MainFrame:SetSize(ScrW(),ScrH())
	MainFrame:SetTitle("This gamemode is created by Hope")
	MainFrame:SetVisible(true) 
	MainFrame:SetBackgroundBlur( true )
	MainFrame:ShowCloseButton(true)
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

	local FillPanel = vgui.Create( "DPanel", MainFrame )  
	FillPanel:Dock(FILL)
	FillPanel:DockPadding(100,0,100,0)
	FillPanel.Paint = function( self, w, h )  
	draw.RoundedBox( 0, 0, 0, w, h, Color( 0,0,0,0) ) -- Draw a black box instead of the frame
	end

	local LeftPanel = vgui.Create( "DPanel", MainFrame )   
	LeftPanel:Dock(LEFT)
	LeftPanel:DockPadding(0,0,0,0)
	LeftPanel:SetSize(200,200) 
	LeftPanel.Paint = function( self, w, h )  
	draw.RoundedBox( 0, 0, 0, w, h, Color( 255,0,0,0) ) -- Draw a black box instead of the frame
	end

	local RightPanel = vgui.Create( "DPanel", MainFrame )   
	RightPanel:Dock(RIGHT)
	RightPanel:DockPadding(0,0,0,0)
	RightPanel:SetSize(200,200) 
	RightPanel.Paint = function( self, w, h )  
	draw.RoundedBox( 0, 0, 0, w, h, Color( 255,0,0,0) ) -- Draw a black box instead of the frame
	end

	-- -- image 
	-- local background_image = vgui.Create("DImage", MainFrame) 
	-- background_image:SetSize(ScrW(),ScrH())
	-- background_image:SetImage("materials/manga.png") 
	-- background_image:SetImageColor(Color(255, 255, 255,20))

	--[[local logo_label = vgui.Create( "DImage", FillPanel )  
	logo_label:Dock(TOP)  
	logo_label:SetSize(500,300)]]
	--logo_label:SetImage("materials/logo.png") 
	--[[timer.Create("change_image",5,0,function()
		background_image:SetImage(image_set[ math.random( #image_set ) ])
	end)]]
	hover_start = true 
	hover_memories = true
	hover_support = true

	local logo_label = vgui.Create( "DButton", FillPanel )   
	logo_label:Dock(TOP)  
	logo_label:SetText("Gmod Volleyball 2.0")  
	logo_label:SetTextColor(Color(255,255,255)) 
	logo_label:SetImage("materials/gmodvballnew.png")         
	logo_label:SetSize(250, 100)         
	logo_label:DockMargin( 0, 150 , 0, 0 )          
	logo_label:SetFont("Big")    
	logo_label.Paint = function( self, w, h ) -- 'function Frame:Paint( w, h )' works too 
		draw.RoundedBox( 0, 0, 0, w, h, Color( 0,0,0,0) )     
	end 

	local start_button = vgui.Create( "DButton", FillPanel ) 
	start_button:Dock(TOP)  
	start_button:SetText("Start Game") 
	start_button:SetTextColor(Color(255,255,255))     
	start_button:SetSize(50, 50)  
	start_button:DockMargin( 0, 30 , 0, 0 )         
	start_button:SetFont("tiny2") 
	start_button.Paint = function( self, w, h ) -- 'function Frame:Paint( w, h )' works too 
		surface.SetDrawColor( 255, 0, 0, 255 )
		surface.DrawOutlinedRect( 0, 0, w, h, 2 ) -- Draw a black box instead of the frame	
		if start_button:IsHovered() then 
			if hover_start == true then  
				surface.PlaySound("hover.mp3")
				hover_start = false 
			end 
			 start_button:DrawOutlinedRect() 
			 draw.RoundedBox( 0, 0, 0, w, h, Color( 255, 0, 0,30) )
		else 
			hover_start = true 
			draw.RoundedBox( 255, 0, 0, w, h, Color( 0,0,0,0) )
		end 
	end

	function start_button:DoClick() 
		timer.Stop("change_image")
		surface.PlaySound("begin_free_time.mp3")
		--surface.PlaySound("confirm.wav")
		MainFrame:Close() 
		--sound3:Stop()  
		sound3:Play()
		MainFrame2:SetVisible(true)
		PopUpFrame()
		RulesRegulation()
	end 

	local credit_button = vgui.Create( "DButton", FillPanel ) 
	credit_button:Dock(TOP)  
	credit_button:SetText("Join Discord!")
	credit_button:SetTextColor(Color(255,255,255))     
	credit_button:SetSize(50, 50)  
	credit_button:DockMargin( 0, 10 , 0, 0 )   
	credit_button:SetImage("materials/discord.png")     
	credit_button:SetFont("tiny2") 
	credit_button.Paint = function( self, w, h ) -- 'function Frame:Paint( w, h )' works too 
		--draw.RoundedBox( 255, 0, 0, w, h, Color( 0,0,0,150) )
		surface.SetDrawColor( 255, 255, 255, 255 )
		surface.DrawOutlinedRect( 0, 0, w, h, 2 ) -- Draw a black box instead of the frame	
		if credit_button:IsHovered() then 
			if hover_memories == true then  
				surface.PlaySound("hover.mp3")
				hover_memories = false 
			end 
			draw.RoundedBox( 0, 0, 0, w, h, Color( 255, 0, 0,30) )
			credit_button:DrawOutlinedRect()
		else 
			hover_memories = true
			draw.RoundedBox( 255, 0, 0, w, h, Color( 255,0,0,0) )
		end 
	end  

	credit_button.DoClick = function()
		--sound3:Stop()
	    gui.OpenURL( "https://discord.gg/7tNcnNW" )
	end

	local tutorial_button2 = vgui.Create( "DButton", FillPanel ) 
	tutorial_button2:Dock(TOP)  
	tutorial_button2:SetText("Tutorial Videos")
	tutorial_button2:SetTextColor(Color(255,255,255))     
	tutorial_button2:SetSize(50, 50)  
	tutorial_button2:SetImage("materials/youtube.png")   
	tutorial_button2:DockMargin( 0, 10 , 0, 0 )        
	tutorial_button2:SetFont("tiny2") 
	tutorial_button2.Paint = function( self, w, h ) -- 'function Frame:Paint( w, h )' works too 
		surface.SetDrawColor( 255, 255, 255, 255 )
		surface.DrawOutlinedRect( 0, 0, w, h, 2 ) -- Draw a black box instead of the frame	
		if tutorial_button2:IsHovered() then 
			if hover_support == true then  
				--surface.PlaySound("hover.mp3")
				hover_support = false 
			end 

			tutorial_button2:DrawOutlinedRect()
			draw.RoundedBox( 0, 0, 0, w, h, Color( 255, 0, 0,30) )
		else 
			hover_support = true 
			draw.RoundedBox( 255, 0, 0, w, h, Color( 233, 240, 31,0) )
		end 
	end 

	tutorial_button2.DoClick = function()
		sound3:Stop()
	    gui.OpenURL( "https://www.youtube.com/watch?v=6QGgGYcjhhg" )
	end


	local tutorial_button = vgui.Create( "DButton", FillPanel ) 
	tutorial_button:Dock(TOP)  
	tutorial_button:SetText("Support Goofy Ahh Devs")
	tutorial_button:SetTextColor(Color(255,255,255))     
	tutorial_button:SetSize(50, 50)  
	tutorial_button:SetImage("materials/donation.png")
	tutorial_button:DockMargin( 0, 10 , 0, 0 )        
	tutorial_button:SetFont("tiny2") 
	tutorial_button.Paint = function( self, w, h ) -- 'function Frame:Paint( w, h )' works too 
		surface.SetDrawColor( 255, 255, 255, 255 )
		surface.DrawOutlinedRect( 0, 0, w, h, 2 ) -- Draw a black box instead of the frame	
		if tutorial_button:IsHovered() then 
			if hover_support == true then  
				surface.PlaySound("hover.mp3")
				hover_support = false 
			end 

			tutorial_button:DrawOutlinedRect()
			draw.RoundedBox( 0, 0, 0, w, h, Color( 255, 0, 0,30) )
		else 
			hover_support = true 
			draw.RoundedBox( 255, 0, 0, w, h, Color( 0,0,0,0) )
		end 
	end 

	tutorial_button.DoClick = function()
		sound3:Stop()
	    gui.OpenURL( "https://paypal.me/hopedanganronpa?locale.x=en_US" )

	end
end 

--[[hook.Add( "PostDrawTranslucentRenderables", "test", function()

	--[[
		when you draw a sphere, you have to specify what material the sphere is
		going to have before rendering it, render.SetColorMaterial()
		just sets it to a white material so we can recolor it easily.
	
	render.SetColorMaterial()
	local radius = 50
	local wideSteps = 5
	local tallSteps = 5

	-- The position to render the sphere at, in this case, the looking position of the local player
	local pos = LocalPlayer():GetEyeTrace().HitPos

	-- Draw the sphere!
	render.DrawSphere( pos, 10, 100, 30, Color( 255, 0, 0, 100 ) )
	--render.DrawLine( ply:GetPos()*Vecter(, pos, Color( 255, 255, 255, 255 ),true )

end )]]


MainFrame2 = vgui.Create("DFrame")  
MainFrame2:SetSize(1366,768)
MainFrame2:SetTitle("This gamemode is created by Hope")
MainFrame2:SetVisible(false) 
MainFrame2:SetBackgroundBlur( true )
MainFrame2:ShowCloseButton(false)  
MainFrame2:Center()
MainFrame2:MakePopup(true)
MainFrame2.Paint = function( self, w, h ) -- 'function Frame:Paint( w, h )' works too
draw.RoundedBox( 0, 0, 0, w, h, Color( 255,255,255) ) -- Draw a black box instead of the frame
end

function MainFrame2:Init()     
	self.startTime = SysTime() 
end
function MainFrame2:Paint()
	Derma_DrawBackgroundBlur( self, self.startTime)                
end

local TopPanel = vgui.Create( "DPanel", MainFrame2 )       
TopPanel:Dock(TOP) 
TopPanel:SetSize(200,100)       
TopPanel.Paint = function( self, w, h )    
draw.RoundedBox( 0, 0, 0, w, h, Color( 0,0,0,0) ) -- Draw a black box instead of the frame
end

local BottomPanel = vgui.Create( "DPanel", MainFrame2 )       
BottomPanel:Dock(BOTTOM) 
BottomPanel:SetSize(200,100)  
BottomPanel:SetVisible(false)     
BottomPanel.Paint = function( self, w, h )    
draw.RoundedBox( 0, 0, 0, w, h, Color( 0,0,0,0) ) -- Draw a black box instead of the frame
end

local FillPanel = vgui.Create( "DPanel", MainFrame2 )       
FillPanel:Dock(FILL)
FillPanel:SetSize(1366,1366)   
FillPanel.Paint = function( self, w, h )    
surface.SetDrawColor( 255, 255, 255 )
surface.DrawOutlinedRect( 0, 0, w, h, 5 ) -- Draw a black box instead of the frame
draw.RoundedBox( 0, 0, 0, w, h, Color( 0,0,0,80) ) -- Draw a black box instead of the frame
end

local background_image = vgui.Create("DImage", FillPanel) 
background_image:SetSize(838,838) 
background_image:SetImage("materials/allstar3.jpg")
background_image:SetImageColor(Color(255, 255, 255,70))

local LeftPanel = vgui.Create( "DScrollPanel", MainFrame2 )       
LeftPanel:Dock(LEFT)
LeftPanel:SetSize(150,0)   
LeftPanel.Paint = function( self, w, h )    
draw.RoundedBox( 0, 0, 0, w, h, Color( 0,0,0,0) ) -- Draw a black box instead of the frame
end

local RightPanel = vgui.Create( "DScrollPanel", MainFrame2 )       
RightPanel:Dock(RIGHT)
RightPanel:SetSize(348,0)   
RightPanel:DockMargin( 30, 0 , 0, 0 )   
RightPanel.Paint = function( self, w, h )    
draw.RoundedBox( 0, 0, 0, w, h, Color( 255,255,255,0) ) -- Draw a black box instead of the frame
end

local background_image = vgui.Create("DImage", RightPanel) 
background_image:SetSize(838,838) 
background_image:SetImage("materials/manga.png")
background_image:SetImageColor(Color(255, 255, 255,50))

local back = vgui.Create( "DButton", TopPanel )       
back:Dock(TOP) 
back:SetSize(100,50)   
back:SetText("BACK")   
back:SetTextColor(Color(255,255,255))                  
back:DockMargin( 0, 0 , 0, 0 )     
back:SetFont("tiny2") 
--myer_button:SetImage("materials/stalk.gif")        
back.Paint = function( self, w, h ) -- 'function Frame:Paint( w, h )' works too 
draw.RoundedBox( 0, 0, 0, w, h, Color( 0,0,0,30) )      
end 

function back:DoClick() 
	sound3:Stop()
	surface.PlaySound("back_button.mp3")
	MainFrame2:SetVisible(false) 
	MenuFrame()
end 


local sbar = LeftPanel:GetVBar()
function sbar:Paint(w, h)
	draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 100))
end
function sbar.btnUp:Paint(w, h)
	draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0,0))
end
function sbar.btnDown:Paint(w, h)
	sbar.btnDown:SetSize(10,30)
	draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0,0))
end
function sbar.btnGrip:Paint(w, h)
	draw.RoundedBox(0, 0, 0, w, h, Color(33, 218, 255))
end

local character_name = vgui.Create( "DButton", RightPanel )       
character_name:Dock(TOP) 
character_name:SetSize(100,50)   
character_name:SetText("")   
character_name:SetTextColor(Color(255,255,255))                  
character_name:DockMargin( 0, 0 , 0, 0 )     
character_name:SetFont("Big") 
--myer_button:SetImage("materials/stalk.gif")        
character_name.Paint = function( self, w, h ) -- 'function Frame:Paint( w, h )' works too 
draw.RoundedBox( 0, 0, 0, w, h, Color( 255,255,255,0) )      
end 

local spider_panel = vgui.Create( "DPanel", RightPanel )       
spider_panel:Dock(TOP) 
spider_panel:SetSize(348,348)                   
spider_panel:DockMargin( 0, 30 , 0, 0 )  
spider_panel:SetVisible(false)
spider_panel.Paint = function( self, w, h ) -- 'function Frame:Paint( w, h )' works too 
surface.SetDrawColor( 0, 0, 0 )
surface.DrawOutlinedRect( 0, 0, w, h, 5 ) -- Draw a black box instead of the frame
draw.RoundedBox( 0, 0, 0, w, h, Color( 255,255,255,192) )      
end    

local character_skill = vgui.Create( "DImage", spider_panel )       
character_skill:Dock(FILL) 
character_skill:SetSize(348,348)                
character_skill:DockMargin( 0, 0 , 0, 0 )          
//character_skill:SetImage("materials/stalk.gif")        
 
--[[
local character_skill = vgui.Create( "DButton", RightPanel )       
character_skill:Dock(TOP) 
character_skill:SetSize(100,300)   
character_skill:SetText("")   
character_skill:SetTextColor(Color(255,255,255))                  
character_skill:DockMargin( 20, 30 , 0, 0 )     
character_skill:SetFont("tiny") 
--myer_button:SetImage("materials/stalk.gif")        
character_skill.Paint = function( self, w, h ) -- 'function Frame:Paint( w, h )' works too 
draw.RoundedBox( 0, 0, 0, w, h, Color( 0,0,0,0) )      
end ]]

local skill_desc = vgui.Create( "DLabel", RightPanel )       
skill_desc:Dock(TOP) 
skill_desc:SetSize(100,150)   
skill_desc:SetText("")   
skill_desc:SetTextColor(Color(255,255,255))
skill_desc:SetWrap(true)                  
skill_desc:DockMargin( 0, 0 , 0, 0 )     
skill_desc:SetFont("tiny") 
--myer_button:SetImage("materials/stalk.gif")        
skill_desc.Paint = function( self, w, h ) -- 'function Frame:Paint( w, h )' works too 
draw.RoundedBox( 0, 0, 0, w, h, Color( 255,255,255,0) )      
end

local skill_difficulty = vgui.Create( "DLabel", RightPanel )       
skill_difficulty:Dock(TOP) 
skill_difficulty:SetSize(100,50)   
skill_difficulty:SetText("")   
skill_difficulty:SetTextColor(Color(0,0,0))
skill_difficulty:SetWrap(true)                  
skill_difficulty:DockMargin( 0, 0 , 0, 0 )     
skill_difficulty:SetFont("tiny") 
--myer_button:SetImage("materials/stalk.gif")        
skill_difficulty.Paint = function( self, w, h ) -- 'function Frame:Paint( w, h )' works too 
draw.RoundedBox( 0, 0, 0, w, h, Color( 103,97,97,0) )      
end



--------gambar tengah ------------------------
models = vgui.Create( "DModelPanel", FillPanel )  
models:Dock(TOP)  
models:SetVisible(true)
models:DockMargin(10,0,0,0)
models:SetSize( 300, 500 )
--[[models.Paint = function( self, w, h ) 
	surface.SetDrawColor( 0, 0, 0, 0 )
	surface.DrawOutlinedRect( 0, 0, w, h, 5 ) -- Draw a black box instead of the frame
end]]

--bottompanel 
local teamtext = vgui.Create( "DButton", BottomPanel )       
teamtext:Dock(TOP) 
teamtext:SetSize(100,40)   
teamtext:SetText("Change Team")   
teamtext:SetTextColor(Color(255,255,255))                  
teamtext:DockMargin( 0, 0 , 0, 0 )     
teamtext:SetFont("small")  
--hinata:SetImage("materials/skill/hajime.png")  
teamtext.Paint = function( self, w, h )      
	draw.RoundedBox( 0, 0, 0, w, h, Color( 0,0,0,0) ) 
	teamtext:SetTextColor(Color(255,255,255))    
end

local team_blue = vgui.Create( "DButton", BottomPanel )       
team_blue:Dock(TOP) 
team_blue:SetSize(100,30)   
team_blue:SetText("Team Blue")   
team_blue:SetTextColor(Color(255,255,255))                  
team_blue:DockMargin( 0, 0 , 0, 0 )     
team_blue:SetFont("tiny")  
--hinata:SetImage("materials/skill/hajime.png")  
team_blue.Paint = function( self, w, h )      
	if team_blue:IsHovered() then 
		draw.RoundedBox( 0, 0, 0, w, h, Color( 255, 0, 0,100) )      

		team_blue:SetTextColor(Color(255,255,255))  
	else 
		draw.RoundedBox( 0, 0, 0, w, h, Color( 23, 73, 255,100) ) 
		team_blue:SetTextColor(Color(255,255,255)) 
	end    
end

function team_blue:DoClick() 
	MainFrame2:SetVisible(false)
	net.Start("changeteam")
	net.WriteString("blue")
	net.WriteString(character)
	net.SendToServer() 
end 

local team_orange = vgui.Create( "DButton", BottomPanel )       
team_orange:Dock(TOP) 
team_orange:SetSize(100,30)   
team_orange:SetText("Team Green")   
team_orange:SetTextColor(Color(255,255,255))                  
team_orange:DockMargin( 0, 0 , 0, 0 )     
team_orange:SetFont("tiny")  
--hinata:SetImage("materials/skill/hajime.png")  
team_orange.Paint = function( self, w, h )      
	if team_orange:IsHovered() then 
		draw.RoundedBox( 0, 0, 0, w, h, Color( 255, 0, 0,100) )      

		team_orange:SetTextColor(Color(255,255,255))  
	else 
		draw.RoundedBox( 0, 0, 0, w, h, Color( 55, 196, 90,100) ) 
		team_orange:SetTextColor(Color(255,255,255)) 
	end    
end

function team_orange:DoClick() 
	MainFrame2:SetVisible(false)
	net.Start("changeteam")
	net.WriteString("green")
	net.SendToServer() 
end 







--------------------------CHARACTER-------------------------------------------------------------
/*local hinata = vgui.Create( "DButton", LeftPanel )       
hinata:Dock(TOP) 
hinata:SetSize(100,50)   
hinata:SetText("Press F1 to see char control\nin game.")   
hinata:SetTextColor(Color(255,255,255))                  
hinata:DockMargin( 0, 0 , 0, 0 )     
hinata:SetFont("tiny2") 
hinata.Paint = function( self, w, h )   
	draw.RoundedBox( 0, 0, 0, w, h, Color( 255,0,0,50) ) 
end */

local hinata = vgui.Create( "DImageButton", LeftPanel )       
hinata:Dock(TOP) 
hinata:SetSize(150,150)    
hinata:SetTextColor(Color(255,255,255))                  
hinata:DockMargin( 0, 0 , 0, 0 )     
hinata:SetFont("tiny2")  
hinata:SetImage("materials/character/hinata2.png")  
hinata.Paint = function( self, w, h )      
	surface.SetDrawColor( 255, 255, 255, 255 )
	surface.DrawOutlinedRect( 0, 0, w, h, 5 ) -- Draw a black box instead of the frame
	if hinata:IsHovered() then 
		spider_panel:SetVisible(true)
		models:SetModel("models/haikyuu/male/hinata2.mdl")
		local headpos = models.Entity:GetBonePosition(models.Entity:LookupBone("ValveBiped.Bip01_Head1"))
		models:SetLookAt(headpos)
		models:SetCamPos(headpos-Vector(-50, 0, 0))	-- Move cam in front of face
		function models:LayoutEntity(ent) return end
		character_name:SetText("Hinata Shoyo")
		character_skill:SetImage("materials/chart/hinata.png")  
		skill_desc:SetText("Able to jump high with high movement speed.\n\nDifficulty:")
		skill_difficulty:SetText("EASY")   
		skill_difficulty:SetTextColor(Color(88, 235, 2))
		draw.RoundedBox( 0, 0, 0, w, h, Color( 255,0,0,100) )      

		hinata:SetTextColor(Color(0,0,0))  
	else 
		draw.RoundedBox( 0, 0, 0, w, h, Color( 0,0,0,0) ) 
		hinata:SetTextColor(Color(255,255,255)) 
	end    
end

function hinata:DoClick() 
	SpikerSignal() 
	chat.AddText(Color(255,0,0),"Press M to change char\nF2 for Thirdperson\nF1 for Character Tips") 
	character = "hinata"
	ClearHooks()
	MainFrame2:SetVisible(false) 
	SpikePower(10,1150) 
	ReceivePower(10)
	BasicServe() 
	SpikerSignal()
	--HinataJump()
	--BlockPower(10)  
	--TossPower(10)
	--BackTossPower(10)
	net.Start("character_select")
	net.WriteString("hinata")
	net.SendToServer() 
	sound3:Stop()
	--loadPlayermodel() 
end 

character = ""


local korai = vgui.Create( "DImageButton", LeftPanel )       
korai:Dock(TOP) 
korai:SetSize(150,150)    
korai:SetTextColor(Color(255,255,255))                  
korai:DockMargin( 0, 10 , 0, 0 )     
korai:SetFont("tiny2")  
korai:SetImage("materials/character/hoshiumi2.jpg") 
korai.Paint = function( self, w, h )      
	if korai:IsHovered() then 
		spider_panel:SetVisible(true)
		models:SetModel("models/haikyuu/male/korai.mdl")
		local headpos = models.Entity:GetBonePosition(models.Entity:LookupBone("ValveBiped.Bip01_Head1"))
		models:SetLookAt(headpos)
		models:SetCamPos(headpos-Vector(-50, 0, 0))	-- Move cam in front of face
		function models:LayoutEntity(ent) return end
		character_skill:SetImage("materials/chart/hoshiumi.png") 
		character_name:SetText("Hoshiumi Korai")
		--character_skill:SetText("Stats\n\nJump: 4.6/5\nSpeed: 4/5\nSpike: 4.8/5\n\nAbility: Able to make a\ncut spike.")
		skill_desc:SetText("A versatile player that can do almost everything.")
		skill_difficulty:SetText("MEDIUM") 
		skill_difficulty:SetTextColor(Color(214, 169, 8))
		draw.RoundedBox( 0, 0, 0, w, h, Color( 255,0,0,100) )      

		korai:SetTextColor(Color(0,0,0))
	else 
		draw.RoundedBox( 0, 0, 0, w, h, Color( 0,0,0,0) ) 
		korai:SetTextColor(Color(255,255,255)) 
	end    
end

function korai:DoClick()
	hook.Remove("PlayerButtonDown","Ref",function(ply,button) end)
	chat.AddText(Color(255,0,0),"Press M to change char\nF2 for Thirdperson\nF1 for Character Tips")  
	character = "korai"
	ClearHooks()
	SpikePower(10,1300)  
	ReceivePower(10)
	SpikerSignal() 
	BasicServe()
	-- ability 
	KoraiJumpBoost() 
	--MiyaServe()
	TossPower(10)

	MainFrame2:SetVisible(false) 

	net.Start("character_select")
	net.WriteString("korai")
	net.SendToServer() 
	sound3:Stop()
	--loadPlayermodel()
end

local kage = vgui.Create( "DImageButton", LeftPanel )       
kage:Dock(TOP) 
kage:SetSize(150,150)    
kage:SetTextColor(Color(255,255,255))                  
kage:DockMargin( 0, 10 , 0, 0 )  
kage:SetFont("tiny2")  
kage:SetImage("materials/character/kageyama.jpg")  
--kage:SetImage("materials/skill/hajime.png")  
kage.Paint = function( self, w, h )      
	if kage:IsHovered() then 
		spider_panel:SetVisible(true)
		models:SetModel("models/haikyuu/male/kageyama2.mdl")
		local headpos = models.Entity:GetBonePosition(models.Entity:LookupBone("ValveBiped.Bip01_Head1"))
		models:SetLookAt(headpos)
		models:SetCamPos(headpos-Vector(-50, 0, 0))	-- Move cam in front of face
		function models:LayoutEntity(ent) return end
		character_skill:SetImage("materials/chart/kageyama.png") 
		character_name:SetText("Kageyama Tobio (S)")
		
		skill_desc:SetText("Able to perform a set that falls around the spiker's point of impact by adding a backspin\n\nDifficulty:")
		skill_difficulty:SetText("MEDIUM")   
		skill_difficulty:SetTextColor(Color(240, 136, 0))
		draw.RoundedBox( 0, 0, 0, w, h, Color( 255,0,0,100) )      

		kage:SetTextColor(Color(0,0,0))  
	else 
		draw.RoundedBox( 0, 0, 0, w, h, Color( 0,0,0,0) ) 
		kage:SetTextColor(Color(255,255,255)) 
	end    
end

function kage:DoClick() 
	--CharPosition() 
	chat.AddText(Color(255,0,0),"Press M to change char\nF2 for Thirdperson\nF1 for Character Tips") 
	chat.AddText(Color(188, 66, 245),"You have wider view because you are a setter!")
	ClearHooks()
	MainFrame2:SetVisible(false) 
	character = "kageyama"
	SpikePower(20,800) 
	ReceivePower(10)
	TossPower(10)
	BackTossPower(10)
	KageFrontToss(10)
	KageQuickToss(10)
	BasicServe()
	--BlockPower(10)
	SetterSignal()
	net.Start("character_select")
	net.WriteString("kage")
	net.SendToServer() 
	sound3:Stop()
	--loadPlayermodel()
end 

local kenma = vgui.Create( "DImageButton", LeftPanel )       
kenma:Dock(TOP) 
kenma:SetSize(150,150)    
kenma:SetTextColor(Color(255,255,255))                  
kenma:DockMargin( 0, 10 , 0, 0 )  
kenma:SetFont("tiny2")  
kenma:SetImage("materials/character/kenma.jpg")  
--kage:SetImage("materials/skill/hajime.png")  
kenma.Paint = function( self, w, h )      
	if kenma:IsHovered() then 
		spider_panel:SetVisible(true)
		models:SetModel("models/haikyuu/male/Kenma.mdl")
		local headpos = models.Entity:GetBonePosition(models.Entity:LookupBone("ValveBiped.Bip01_Head1"))
		models:SetLookAt(headpos)
		models:SetCamPos(headpos-Vector(-50, 0, 0))	-- Move cam in front of face
		function models:LayoutEntity(ent) return end
		character_skill:SetImage("materials/chart/kenma.png") 
		character_name:SetText("Kenma Kozume (S)")
		character_skill:SetText("Stats\n\nJump: 2/5\nSpeed: 3/5\nSpike: 1/5\n\nAbility: Kenma's Dump\nKenma can perform a \ndump that go \nto direction he wants.\nKenma's Receive charge faster\neven the bar is not going faster")
		skill_desc:SetText("Kenma can perform a dump that go to direction he wants. Kenma's Receive charge faster \n\nDifficulty:")
		skill_difficulty:SetText("HARD")   
		skill_difficulty:SetTextColor(Color(255, 0, 0))
		draw.RoundedBox( 0, 0, 0, w, h, Color( 255,0,0,100) )      

		kenma:SetTextColor(Color(0,0,0))  
	else 
		draw.RoundedBox( 0, 0, 0, w, h, Color( 0,0,0,0) ) 
		kenma:SetTextColor(Color(255,255,255)) 
	end    
end

function kenma:DoClick() 
	--CharPosition() 
	chat.AddText(Color(255,0,0),"Press M to change char\nF2 for Thirdperson\nF1 for Character Tips") 
	chat.AddText(Color(188, 66, 245),"You have wider view because you are a setter!")
	ClearHooks()
	MainFrame2:SetVisible(false) 
	character = "kenma"
	print("char:"..character)
	SpikePower(20,700) 
	ReceivePower(10)
	TossPower(10)
	BackTossPower(10)
	--KageFrontToss(10)
	KenmaDump(10)
	KageQuickToss(10)
	BasicServe()
	--BlockPower(10)
	SetterSignal()
	net.Start("character_select")
	net.WriteString("kenma")
	net.SendToServer() 
	sound3:Stop()
	--loadPlayermodel()
end 

-- local nishi = vgui.Create( "DImageButton", LeftPanel )       
-- nishi:Dock(TOP) 
-- nishi:SetSize(150,150)    
-- nishi:SetTextColor(Color(255,255,255))                  
-- nishi:DockMargin( 0, 10 , 0, 0 )  
-- nishi:SetFont("tiny2")  
-- nishi:SetImage("materials/character/nishinoyaframe.png")
-- //nishi:SetImageColor(Color(163,163,163,169))
-- --nishi:SetImage("materials/skill/hajime.png")  
-- nishi.Paint = function( self, w, h )      
-- 	if nishi:IsHovered() then 
-- 		models:SetModel("models/haikyuu/male/Nishinoya.mdl")
-- 		local headpos = models.Entity:GetBonePosition(models.Entity:LookupBone("ValveBiped.Bip01_Head1"))
-- 		models:SetLookAt(headpos)
-- 		models:SetCamPos(headpos-Vector(-50, 0, 0))	-- Move cam in front of face
-- 		function models:LayoutEntity(ent) return end
-- 		character_skill:SetImage("materials/chart/nishinoyachart.png") 
-- 		character_name:SetText("Nishinoya Yu (LIB)")
-- 		//character_skill:SetText("Stats\n\nJump: 4/5\nSpeed: 5/5\nSpike: 0/5\n\nAbility: High Receive\nAble to charge receive bar\nto 3 power.\nCan also set the ball.\nAble to move\n around court quick.")
-- 		skill_desc:SetText("Able to charge receive bar into 3 power (low,medium,high). Able to set the ball and move around court quick. Able to dive receive. \n\nDifficulty:")
-- 		skill_difficulty:SetText("MEDIUM") 
-- 		skill_difficulty:SetTextColor(Color(240, 136, 0))
-- 		draw.RoundedBox( 0, 0, 0, w, h, Color( 255,0,0,100) )      

-- 		nishi:SetTextColor(Color(0,0,0))  
-- 	else 
-- 		draw.RoundedBox( 0, 0, 0, w, h, Color( 0,0,0,0) ) 
-- 		nishi:SetTextColor(Color(255,255,255)) 
-- 	end    
-- end

-- function nishi:DoClick() 
-- 	-- chat.AddText(Color(255,0,0),"Press M to change char\nF2 for Thirdperson\nF1 for Character Tips") 
-- 	-- character = "nishi"
-- 	-- ClearHooks()
-- 	-- MainFrame2:SetVisible(false) 
-- 	-- character = "nishinoya"
-- 	-- ReceivePower(10)
-- 	-- TossPower(10)
-- 	-- DivePower(15) 
-- 	-- net.Start("character_select")
-- 	-- net.WriteString("nishi")
-- 	-- net.SendToServer() 
-- 	-- --loadPlayermodel() 
-- 	-- sound3:Stop()
-- 	-- loadPlayermodel()
-- end 


local miya = vgui.Create( "DImageButton", LeftPanel )       
miya:Dock(TOP) 
miya:SetSize(150,150)    
miya:SetTextColor(Color(255,255,255))                  
miya:DockMargin( 0, 10 , 0, 0 )  
miya:SetFont("tiny2")  
miya:SetImage("materials/character/miya.jpg")  
miya.Paint = function( self, w, h )      
	if miya:IsHovered() then 
		spider_panel:SetVisible(true)
		models:SetModel("models/haikyuu/male/Miya.mdl")
		local headpos = models.Entity:GetBonePosition(models.Entity:LookupBone("ValveBiped.Bip01_Head1"))
		models:SetLookAt(headpos)
		models:SetCamPos(headpos-Vector(-50, 0, 0))	-- Move cam in front of face
		function models:LayoutEntity(ent) return end
		character_skill:SetImage("materials/chart/miya.png") 
		character_name:SetText("Miya Atsumu (S)")
		character_skill:SetText("Stats\n\nJump: 4/5\nSpeed: 4/5\nSpike: 3/5\n\nAbility: Spike Serve")
		skill_desc:SetText("Able to do powerful jump serve. \n\nDifficulty:")
		skill_difficulty:SetText("MEDIUM") 
		skill_difficulty:SetTextColor(Color(240, 136, 0))
		draw.RoundedBox( 0, 0, 0, w, h, Color( 255,0,0,100) )      

		miya:SetTextColor(Color(0,0,0))  
	else 
		draw.RoundedBox( 0, 0, 0, w, h, Color( 0,0,0,0) ) 
		miya:SetTextColor(Color(255,255,255)) 
	end    
end

function miya:DoClick() 
	chat.AddText(Color(255,0,0),"Press M to change char\nF2 for Thirdperson\nF1 for Character Tips") 
	chat.AddText(Color(188, 66, 245),"You have wider view because you are a setter!\nHold ALT for Setter's Signal")
	character = "miya"
	ClearHooks()
	MainFrame2:SetVisible(false) 
	SpikePower(20,800) 
	ReceivePower(10)
	TossPower(10)
	KageQuickToss(10)
	BackTossPower(10)
	MiyaServe()
	BasicServe()
	--BlockPower(10)
	SetterSignal()
	net.Start("character_select")
	net.WriteString("miya")
	net.SendToServer() 
	sound3:Stop()
	--loadPlayermodel()
end 


local ushijima = vgui.Create( "DImageButton", LeftPanel )       
ushijima:Dock(TOP) 
ushijima:SetSize(150,150)    
ushijima:SetTextColor(Color(255,255,255))                  
ushijima:DockMargin( 0, 10 , 0, 0 )  
ushijima:SetFont("tiny2")  
ushijima:SetImage("materials/character/ushijima.jpg") 
ushijima.Paint = function( self, w, h )      
	if ushijima:IsHovered() then 
		spider_panel:SetVisible(true)
		models:SetModel("models/haikyuu/male/Ushijima.mdl")
		local headpos = models.Entity:GetBonePosition(models.Entity:LookupBone("ValveBiped.Bip01_Head1"))
		models:SetLookAt(headpos)
		models:SetCamPos(headpos-Vector(-50, 0, 0))	-- Move cam in front of face
		function models:LayoutEntity(ent) return end
		character_skill:SetImage("materials/chart/ushijima.png") 
		character_name:SetText("Wakatoshi Ushijima")
		character_skill:SetText("Stats\n\nJump: 4.3/5\nSpeed: 3/5\nSpike: 5/5\n\nAbility: A powerful spike\nwhen fully charged.")
		skill_desc:SetText("A powerful spike when fully charged. \n\nDifficulty:")
		skill_difficulty:SetText("MEDIUM") 
		skill_difficulty:SetTextColor(Color(240, 136, 0))
		draw.RoundedBox( 0, 0, 0, w, h, Color( 255,0,0,100) )      

		ushijima:SetTextColor(Color(0,0,0))  
	else 
		draw.RoundedBox( 0, 0, 0, w, h, Color( 0,0,0,0) ) 
		ushijima:SetTextColor(Color(255,255,255)) 
	end    
end

function ushijima:DoClick() 
	chat.AddText(Color(255,0,0),"Press M to change char\nF2 for Thirdperson\nF1 for Character Tips") 
	character = "ushijima"
	ClearHooks()
	MainFrame2:SetVisible(false) 
	SpikePower(10,2555) 
	ReceivePower(10)
	SpikerSignal()
	--YamaguchiServe()
	BasicServe()
	--BlockPower(10)
	--TossPower(10)
	--BackTossPower(10)
	net.Start("character_select")
	net.WriteString("ushi")
	net.SendToServer() 
	sound3:Stop()
	--loadPlayermodel()
end 


local yamaguchi = vgui.Create( "DImageButton", LeftPanel )       
yamaguchi:Dock(TOP) 
yamaguchi:SetSize(150,150)    
yamaguchi:SetTextColor(Color(255,255,255))                  
yamaguchi:DockMargin( 0, 10 , 0, 0 )  
yamaguchi:SetFont("tiny2")  
yamaguchi:SetImage("materials/character/yamaguchi.jpg") 
yamaguchi.Paint = function( self, w, h )      
	if yamaguchi:IsHovered() then 
		spider_panel:SetVisible(true)
		models:SetModel("models/haikyuu/male/Yamaguchi.mdl")
		local headpos = models.Entity:GetBonePosition(models.Entity:LookupBone("ValveBiped.Bip01_Head1"))
		models:SetLookAt(headpos)
		models:SetCamPos(headpos-Vector(-50, 0, 0))	-- Move cam in front of face
		function models:LayoutEntity(ent) return end
		character_skill:SetImage("materials/chart/yamaguchi.png") 
		character_name:SetText("Tadashi Yamaguchi")
		character_skill:SetText("Stats\n\nJump: 3/5\nSpeed: 3/5\nSpike: 2.7/5\n\nAbility: A floaty serve\nthat will drop randomly.")
		skill_desc:SetText(" A floaty serve that will drop randomly that will break opponent's formation \n\nDifficulty:")
		skill_difficulty:SetText("MEDIUM") 
		skill_difficulty:SetTextColor(Color(240, 136, 0))
		draw.RoundedBox( 0, 0, 0, w, h, Color( 255,0,0,100) )      

		yamaguchi:SetTextColor(Color(0,0,0))  
	else 
		draw.RoundedBox( 0, 0, 0, w, h, Color( 0,0,0,0) ) 
		yamaguchi:SetTextColor(Color(255,255,255)) 
	end    
end

function yamaguchi:DoClick()
	hook.Remove("PlayerButtonDown","Ref",function(ply,button) end)
	chat.AddText(Color(255,0,0),"Press M to change char\nF2 for Thirdperson\nF1 for Character Tips")  
	character = "yamaguchi"
	ClearHooks()
	MainFrame2:SetVisible(false) 
	SpikePower(10,800) 
	ReceivePower(10)
	YamaguchiServe()
	BasicServe()
	SpikerSignal()
	--BlockPower(10)
	--TossPower(10)
	--BackTossPower(10)
	net.Start("character_select")
	net.WriteString("yama")
	net.SendToServer() 
	sound3:Stop()
	--loadPlayermodel()
end 

local bokuto = vgui.Create( "DImageButton", LeftPanel )       
bokuto:Dock(TOP) 
bokuto:SetSize(150,150)    
bokuto:SetTextColor(Color(255,255,255))                  
bokuto:DockMargin( 0, 10 , 0, 0 )  
bokuto:SetFont("tiny2")  
bokuto:SetImage("materials/character/bokuto.jpg") 
bokuto.Paint = function( self, w, h )       
	if bokuto:IsHovered() then 
		spider_panel:SetVisible(true)
		models:SetModel("models/haikyuu/male/Bokuto.mdl")
		local headpos = models.Entity:GetBonePosition(models.Entity:LookupBone("ValveBiped.Bip01_Head1"))
		models:SetLookAt(headpos)
		models:SetCamPos(headpos-Vector(-50, 0, 0))	-- Move cam in front of face
		function models:LayoutEntity(ent) return end
		character_skill:SetImage("materials/chart/bokuto.png") 
		character_name:SetText("Kotaro Bokuto")
		character_skill:SetText("Stats\n\nJump: 4.6/5\nSpeed: 4/5\nSpike: 4.8/5\n\nAbility: Able to make a\ncut spike.")
		skill_desc:SetText(" Able to perform cut spike. \n\nDifficulty:")
		skill_difficulty:SetText("MEDIUM") 
		skill_difficulty:SetTextColor(Color(240, 136, 0))
		draw.RoundedBox( 0, 0, 0, w, h, Color( 255,0,0,100) )      

		bokuto:SetTextColor(Color(0,0,0))  
	else 
		draw.RoundedBox( 0, 0, 0, w, h, Color( 0,0,0,0) ) 
		bokuto:SetTextColor(Color(255,255,255)) 
	end    
end

function bokuto:DoClick()
	hook.Remove("PlayerButtonDown","Ref",function(ply,button) end)
	chat.AddText(Color(255,0,0),"Press M to change char\nF2 for Thirdperson\nF1 for Character Tips")  
	character = "bokuto"
	ClearHooks()
	SpikePower(10,1800) 
	SpikerSignal()
	ReceivePower(10)
	BokutoSpike(10)
	BasicServe()
	MainFrame2:SetVisible(false) 

	net.Start("character_select")
	net.WriteString("bokuto")
	net.SendToServer() 
	sound3:Stop()
	--loadPlayermodel()
end

local tsukishima = vgui.Create( "DImageButton", LeftPanel )       
tsukishima:Dock(TOP) 
tsukishima:SetSize(150,150)    
tsukishima:SetTextColor(Color(255,255,255))                  
tsukishima:DockMargin( 0, 10 , 0, 0 )     
tsukishima:SetFont("tiny2")  
tsukishima:SetImage("materials/character/tsuki.jpg") 
tsukishima.Paint = function( self, w, h )      
	if tsukishima:IsHovered() then 
		spider_panel:SetVisible(true)
		models:SetModel("models/haikyuu/male/Tsukishima.mdl")
		local headpos = models.Entity:GetBonePosition(models.Entity:LookupBone("ValveBiped.Bip01_Head1"))
		models:SetLookAt(headpos)
		models:SetCamPos(headpos-Vector(-50, 0, 0))	-- Move cam in front of face
		function models:LayoutEntity(ent) return end
		character_skill:SetImage("materials/chart/tsukishima.png") 
		character_name:SetText("Tsukishima Kei")
		--character_skill:SetText("Stats\n\nJump: 4.6/5\nSpeed: 4/5\nSpike: 4.8/5\n\nAbility: Able to make a\ncut spike.")
		skill_desc:SetText(" Wide block range. Good to cover cut or line spike. \n\nDifficulty:")
		skill_difficulty:SetText("EASY") 
		skill_difficulty:SetTextColor(Color(88, 235, 2))
		draw.RoundedBox( 0, 0, 0, w, h, Color( 255,0,0,100) )      

		tsukishima:SetTextColor(Color(0,0,0))
	else 
		draw.RoundedBox( 0, 0, 0, w, h, Color( 0,0,0,0) ) 
		tsukishima:SetTextColor(Color(255,255,255)) 
	end    
end

function tsukishima:DoClick()
	hook.Remove("PlayerButtonDown","Ref",function(ply,button) end)
	chat.AddText(Color(255,0,0),"Press M to change char\nF2 for Thirdperson\nF1 for Character Tips")  
	character = "tsukishima"
	ClearHooks()
	SpikePower(10,800) 
	ReceivePower(10)
	SpikerSignal()
	--BlockPower(10)
	BasicServe()
	MainFrame2:SetVisible(false) 

	net.Start("character_select")
	net.WriteString("tsuki")
	net.SendToServer() 
	sound3:Stop()
	--loadPlayermodel()
end

local kuro = vgui.Create( "DImageButton", LeftPanel )       
kuro:Dock(TOP) 
kuro:SetSize(150,150)    
kuro:SetTextColor(Color(255,255,255))                  
kuro:DockMargin( 0, 10 , 0, 0 )     
kuro:SetFont("tiny2")  
kuro:SetImage("materials/character/kuro.jpg") 
kuro.Paint = function( self, w, h )      
	if kuro:IsHovered() then 
		spider_panel:SetVisible(true)
		models:SetModel("models/haikyuu/male/kuroo.mdl")
		local headpos = models.Entity:GetBonePosition(models.Entity:LookupBone("ValveBiped.Bip01_Head1"))
		models:SetLookAt(headpos)
		models:SetCamPos(headpos-Vector(-50, 0, 0))	-- Move cam in front of face
		function models:LayoutEntity(ent) return end
		character_skill:SetImage("materials/chart/tsukishima.png") 
		character_name:SetText("Tetsuro Kuro")
		--character_skill:SetText("Stats\n\nJump: 4.6/5\nSpeed: 4/5\nSpike: 4.8/5\n\nAbility: Able to make a\ncut spike.")
		skill_desc:SetText("Able to move block around. \n\nDifficulty:")
		skill_difficulty:SetText("MEDIUM") 
		skill_difficulty:SetTextColor(Color(240, 136, 0))
		draw.RoundedBox( 0, 0, 0, w, h, Color( 255,0,0,100) )      

		kuro:SetTextColor(Color(0,0,0))
	else 
		draw.RoundedBox( 0, 0, 0, w, h, Color( 0,0,0,0) ) 
		kuro:SetTextColor(Color(255,255,255)) 
	end    
end

function kuro:DoClick()
	hook.Remove("PlayerButtonDown","Ref",function(ply,button) end)
	chat.AddText(Color(255,0,0),"Press M to change char\nF2 for Thirdperson\nF1 for Character Tips")  
	character = "kuro"
	print("char:"..character)
	ClearHooks()
	SpikePower(10,1000) 
	ReceivePower(10)
	SpikerSignal()
	--BlockPower(10)
	BasicServe()
	MainFrame2:SetVisible(false) 

	net.Start("character_select")
	net.WriteString("kuro")
	net.SendToServer() 
	sound3:Stop()	
end

local sakusa = vgui.Create( "DImageButton", LeftPanel )       
sakusa:Dock(TOP) 
sakusa:SetSize(150,150)    
sakusa:SetTextColor(Color(255,255,255))                  
sakusa:DockMargin( 0, 10 , 0, 0 )     
sakusa:SetFont("tiny2")  
sakusa:SetImage("materials/character/kuro.jpg") 
sakusa.Paint = function( self, w, h )      
	if sakusa:IsHovered() then 
		spider_panel:SetVisible(true)
		models:SetModel("models/haikyuu/male/kuroo.mdl")
		local headpos = models.Entity:GetBonePosition(models.Entity:LookupBone("ValveBiped.Bip01_Head1"))
		models:SetLookAt(headpos)
		models:SetCamPos(headpos-Vector(-50, 0, 0))	-- Move cam in front of face
		function models:LayoutEntity(ent) return end
		character_skill:SetImage("materials/chart/tsukishima.png") 
		character_name:SetText("Tetsuro Kuro")
		--character_skill:SetText("Stats\n\nJump: 4.6/5\nSpeed: 4/5\nSpike: 4.8/5\n\nAbility: Able to make a\ncut spike.")
		skill_desc:SetText("Able to move block around. \n\nDifficulty:")
		skill_difficulty:SetText("MEDIUM") 
		skill_difficulty:SetTextColor(Color(240, 136, 0))
		draw.RoundedBox( 0, 0, 0, w, h, Color( 255,0,0,100) )      

		sakusa:SetTextColor(Color(0,0,0))
	else 
		draw.RoundedBox( 0, 0, 0, w, h, Color( 0,0,0,0) ) 
		sakusa:SetTextColor(Color(255,255,255)) 
	end    
end

function sakusa:DoClick()
	hook.Remove("PlayerButtonDown","Ref",function(ply,button) end)
	chat.AddText(Color(255,0,0),"Press M to change char\nF2 for Thirdperson\nF1 for Character Tips")  
	character = "sakusa"
	print("char:"..character)
	ClearHooks()
	SpikePower(10,1201) 
	ReceivePower(10)
	SpikerSignal()
	SakusaAttack(1000) 
	--BlockPower(10)
	BasicServe()
	MainFrame2:SetVisible(false) 

	net.Start("character_select")
	net.WriteString("sakusa")
	net.SendToServer() 
	sound3:Stop()	
end

local ref = vgui.Create( "DImageButton", LeftPanel )       
ref:Dock(TOP) 
ref:SetSize(150,150)    
ref:SetTextColor(Color(255,255,255))                  
ref:DockMargin( 0, 10 , 0, 0 )     
ref:SetFont("tiny2")  
ref:SetImage("materials/character/refchan2.png") 
ref.Paint = function( self, w, h )      
	if ref:IsHovered() then 
		models:SetModel("models/haikyuu/female/refchan.mdl")
		local headpos = models.Entity:GetBonePosition(models.Entity:LookupBone("ValveBiped.Bip01_Head1"))
		models:SetLookAt(headpos)
		models:SetCamPos(headpos-Vector(-40, 0, 0))	-- Move cam in front of face
		function models:LayoutEntity(ent) return end
		--character_skill:SetImage("materials/character/ref.jpg") 
		character_name:SetText("Referee-Chan")
		character_skill:SetText("Stats\n\nJump: 5/5\nSpeed: 5/5\nSpike: 0/5\n\n Do your job ref.\nR.Click - whistle\nJust dont be a retard spamming\nwhistle.")
		skill_desc:SetText("")
		draw.RoundedBox( 0, 0, 0, w, h, Color( 255,0,0,100) )      

		ref:SetTextColor(Color(0,0,0))  
	else 
		draw.RoundedBox( 0, 0, 0, w, h, Color( 0,0,0,0) ) 
		ref:SetTextColor(Color(255,255,255)) 
	end    
end

function ref:DoClick() 
	ClearHooks()
	MainFrame2:SetVisible(false) 
	
	net.Start("character_select")
	net.WriteString("ref")
	net.SendToServer() 
	sound3:Stop()

	hook.Add("PlayerButtonDown","referererere",function(ply,button)
		if button == MOUSE_RIGHT then 
			net.Start("ref")
			net.WriteString("whistle")
			net.SendToServer()
		elseif button == KEY_V then 
			net.Start("ref")
			net.WriteString("agree")
			net.SendToServer()
		elseif button == KEY_B then 
			net.Start("ref")
			net.WriteString("disagree")
			net.SendToServer()
		end 
	end) 
end 


-- reminder 
timer.Create("reminder",600,0,function() 
	chat.AddText(Color(206, 119, 252),"Have you joined our Discord server yet?")
end)





ControlFrame = vgui.Create("DFrame")  
ControlFrame:SetSize(1366,768)
ControlFrame:SetTitle("This gamemode is created by Hope")
ControlFrame:SetVisible(false) 
ControlFrame:SetBackgroundBlur( true )
ControlFrame:ShowCloseButton(false)  
ControlFrame:Center()
ControlFrame:MakePopup(true)
ControlFrame.Paint = function( self, w, h ) -- 'function Frame:Paint( w, h )' works too
draw.RoundedBox( 0, 0, 0, w, h, Color( 255,255,255,255) ) -- Draw a black box instead of the frame
end

function ControlFrame:Init()     
	self.startTime = SysTime() 
end
function ControlFrame:Paint()
	Derma_DrawBackgroundBlur( self, self.startTime)                
end

local TopPanel = vgui.Create( "DPanel", ControlFrame )       
TopPanel:Dock(TOP) 
TopPanel:SetSize(200,100)       
TopPanel.Paint = function( self, w, h )    
draw.RoundedBox( 0, 0, 0, w, h, Color( 0,0,0,0) ) -- Draw a black box instead of the frame
end

local FillPanel = vgui.Create( "DPanel", ControlFrame )       
FillPanel:Dock(FILL)
FillPanel:SetSize(1366,1366)   
FillPanel.Paint = function( self, w, h )    
draw.RoundedBox( 0, 0, 0, w, h, Color( 0,0,0,0) ) -- Draw a black box instead of the frame
end

local back = vgui.Create( "DButton", TopPanel )       
back:Dock(TOP) 
back:SetSize(100,50)   
back:SetText("BACK")   
back:SetTextColor(Color(255,255,255))                  
back:DockMargin( 0, 0 , 0, 0 )     
back:SetFont("tiny2") 
--myer_button:SetImage("materials/stalk.gif")        
back.Paint = function( self, w, h ) -- 'function Frame:Paint( w, h )' works too 
draw.RoundedBox( 0, 0, 0, w, h, Color( 0,0,0,30) )      
end 

function back:DoClick() 
	--sound3:Stop()
	surface.PlaySound("back_button.mp3")
	ControlFrame:SetVisible(false) 
end 

local character_control = vgui.Create( "DButton", FillPanel )       
character_control:Dock(TOP) 
character_control:SetSize(100,768)   
character_control:SetText("")   
character_control:SetTextColor(Color(255,255,255))                  
character_control:DockMargin( 0, 0 , 0, 0 )     
character_control:SetFont("tiny") 
--myer_button:SetImage("materials/stalk.gif")        
character_control.Paint = function( self, w, h ) -- 'function Frame:Paint( w, h )' works too 
draw.RoundedBox( 0, 0, 0, w, h, Color( 0,0,0,0) )      
end 

hook.Add("PlayerButtonDown","openControl",function(ply,button)
	if button == KEY_F1 then 
		ControlFrame:SetVisible(true)
		if character == "hinata" then 
			character_control:SetText("Hinata Shoyo\n\nAble to Jump Higher than anyone else.\nYou can Jump+CTRL for Maximum Vertical.\n\nControls\n\nF2 - Thirdperson\n(Static Serve) - R.Click\nV(On ground)- Receive (Can Hold for Higher receive)\nV(On air) - Feint\nL.Click - Spike (Hold for more Power)\nQ - Block")
		elseif character == "kageyama" then 
			character_control:SetText("Kageyama Tobio\n\nYou can do freak toss that stops a.k.a King Toss\n\nControls\n\nF2 - Thirdperson\n(Static Serve) - R.Click\n\nV(On ground)- Receive (Can Hold for Higher receive)\nV(On air) - Feint\nL.Click - Spike (Power Does nothing)\nQ - Soft Block\nC- Set(Hold for higher and farther toss)\nF- Backset(Hold for higher and farther toss)\nTips for setting: The more you aim down the lower toss arc will be\nR - King Toss\nMIDDLE MOUSE- Shoot Toss\n\nALT - Setter Signal")
		
		elseif character == "kenma" then 
		character_control:SetText("Kenma Kozume\n\nSpeciality: Dump (R- Left dump  T- Right Dump)\n\nShoot Toss: MIDDLE MOUSE")

		elseif character == "yamaguchi" then 
			character_control:SetText("Tadashi Yamaguchi\n\nWhen standing anywhere in serve line.Player can press R to activate Float Serve.\n(Static Serve) - R.Click\nFloat Serve - Press R to toss up and T to hit\nThe Float serve will drop left or right/short or long randomly.\n\nControls\n\nF2 - Thirdperson\nV(On ground)- Receive (Can Hold for Higher receive)\nV(On air) - Feint\nL.Click - Spike (Power Does nothing)\nQ - Soft Block")
		elseif character == "tsukishima" then 
			character_control:SetText("Tsukishima Kei\n\nAble to  Block with Wide range. Good to block Line or Cross.\n\n\n\nControls\n\n (Static Serve) - R.Click\nF2 - Thirdperson\nV - Receive (Can Hold for Higher receive)\nB - Spike (Power Does nothing)\nQ - Block")
	
		elseif character == "miya" then 
			character_control:SetText("Miya Atsumu\n\nWhen standing anywhere in serve line.Player can press R to activate Powerful Jump Serve.\n\nCONTROLS\n\nF2 - Thirdperson\n(Static Serve) - R.Click\nJump Serve - Press R to tossup the ball and T to hit.\nAfter hit, player can aim the ball on where to drop.(will create swing effect)\nV(On ground)- Receive (Can Hold for Higher receive)\nV(On air) - Feint\nL.Click - Spike (Power Does nothing)\nC- Set(Hold for higher and farther toss) \nF- Backset(Hold for higher and farther toss)\nMIDDLE MOUSE - Shoot Toss\n Tips for setting: The more you aim down the lower toss arc will be\n\nALT - Setter Signal")
		elseif character == "ushijima" then	
			character_control:SetText("Wakatoshi Ushijima\n\nAble to Super Spike when Bar is fully charged.\nYou can Jump+CTRL for Maximum Vertical.\n\nControls\n\nF2 - Thirdperson\nV(On ground)- Receive (Can Hold for Higher receive)\nV(On air) - Feint\nL.Click - Spike (Power Does nothing)\nQ - Soft Block")
		elseif character == "nishinoya" then	
			character_control:SetText("Yu Nishinoya\n\nAble to do High Receive to let setter do mind game better\n\nControls\n\nF2 - Thirdperson\nV - Receive (Can Hold for Higher receive)\nC - Set (Hold for more Power)\nQ - Short Dive/LongDive\nRules: You cannot set to player after 3 meter line/10ft line.")	
		elseif character == "bokuto" then 
			character_control:SetText("Kotaro Bokuto\n\nAble to do cut spike.\nYou can Jump+CTRL for Maximum Vertical.\n\nControls\n\nF2 - Thirdperson\n(Static Serve) - R.Click\nV(On ground)- Receive (Can Hold for Higher receive)\nV(On air) - Feint\nL.Click - Spike (Power Does nothing)\nR - Left Cut\nT - Right Cut\nQ - Soft Block")
		elseif character == "korai" then 
			character_control:SetText("How to use Hoshiumi Korai:\nAcquire some distance and Sprint (SHIFT) for 0.5 seconds. \nhen indicator is shown, press SPACEBAR+CTRL to Jump the highest. His reacch can go up to 400cm+!!\n\nOther ability:\nFront Set\nJump Serve")		
		end 
	end 
end)


function ClearHooks() 
	hook.Remove( "Tick", "Bokuto_Cut", function() end)
	hook.Remove( "Tick", "KeyDown_Sakusa_Spike", function() end) 
	hook.Remove("PlayerButtonDown","referererere",function(ply,button) end) 
	hook.Remove( "Tick", "KeyDown_Testis", function() end)
	hook.Remove( "Tick", "KeyDown_Tests", function() end) 
	hook.Remove( "Tick", "KeyDown_Toss", function() end)
	hook.Remove("PlayerButtonDown","miya_serve",function(ply,button) end) 
	hook.Remove("PlayerButtonDown","miya_serve2",function(ply,button) end) 
	hook.Remove( "Tick", "Kage_toss", function() end) 
	hook.Remove( "Tick", "Kage_toss2", function() end) 
	hook.Remove( "Tick", "KeyDown_Toss2", function() end)
	hook.Remove("Tick","keydownblock",function(ply,button) end)
	hook.Remove("Tick","keydowndive",function(ply,button) end)
	hook.Remove("Tick","keydownboku",function(ply,button) end) 
	hook.Remove("PlayerButtonDown","yama_serve",function(ply,button) end) 
	hook.Remove("PlayerButtonDown","yama_serve2",function(ply,button) end) 
	hook.Remove("PlayerButtonDown","basic_serve",function(ply,button) end) 
	hook.Remove("PlayerButtonDown","basic_serve2",function(ply,button) end)
	hook.Remove( "Tick", "keydowndive", function() end) 
	hook.Remove("PlayerButtonDown","FakeSpike",function() end) 
	hook.Remove("PlayerButtonDown","KillBlock",function(ply,button) end) 
	hook.Remove( "Tick", "SetterSignal", function() end) 
	hook.Remove( "Tick", "SpikerSignal", function() end)
	hook.Remove( "Tick", "keydownkenma", function() end) 
	hook.Remove( "Think", "LocalPlayerRunDetection", function() end) 
	hook.Remove("Think", "DetectKeyPresses", function() end)
	
	-- IMPORTANT: Remove spike system hook when changing characters
	hook.Remove( "Tick", "KeyDown_Spike", function() end)
	hook.Remove( "Tick", "ReceivePower_KeyRelease", function() end)
	hook.Remove("PlayerButtonDown","KeyDown_Block",function(ply,button) end)
	hook.Remove("PlayerButtonDown","basic_serve_once",function(ply,button) end)

	// mode system 
	

end

function ThirdPerson( ply, pos, ang, fov )

	if( LocalPlayer().ThirdPerson ) then

		local view = {};

		local dist = 160; 

		if character == "kageyama" or character == "miya" then 
			dist = 160;
		else
			dist = 160;
		end 

		local trace = {};

		

		trace.start = pos;

		trace.endpos = pos - ( ang:Forward() * dist );

		trace.filter = LocalPlayer();

		local trace = util.TraceLine( trace );

		if( trace.HitPos:Distance( pos ) < dist - 5 ) then

			dist = trace.HitPos:Distance( pos ) - 5;

		end;

		view.origin = pos - ( ang:Forward() * dist +  (ang:Right()*0) +    
	                                    (ang:Up()*0) );

		view.angles = ang;

		view.fov = fov;

		

		return view;

	end;

end;

hook.Add( "CalcView", "ThirdPerson", ThirdPerson );









--[[
function TutorialFrame() 

	TutorialFrame = vgui.Create("DFrame")
	TutorialFrame:SetSize(1366,768)
	TutorialFrame:SetTitle("This gamemode is created by Hope")
	TutorialFrame:SetVisible(true) 
	TutorialFrame:SetBackgroundBlur( true )
	TutorialFrame:ShowCloseButton(false)
	TutorialFrame:Center()
	TutorialFrame:MakePopup(true)
	TutorialFrame.Paint = function( self, w, h ) -- 'function Frame:Paint( w, h )' works too
	draw.RoundedBox( 0, 0, 0, w, h, Color( 255,255,255,255) ) -- Draw a black box instead of the frame
	end

	function TutorialFrame:Init()
		self.startTime = SysTime()  
	end
	function TutorialFrame:Paint() 
		Derma_DrawBackgroundBlur( self, self.startTime) 
	end

	local FillPanel = vgui.Create( "DPanel", TutorialFrame )  
	FillPanel:Dock(FILL)
	FillPanel:DockPadding(100,0,100,0)
	FillPanel.Paint = function( self, w, h )  
	draw.RoundedBox( 0, 0, 0, w, h, Color( 0,0,0,0) ) -- Draw a black box instead of the frame
	end


	setter = vgui.Create( "DButton", FillPanel )       
	setter:Dock(TOP) 
	setter:SetSize(100,768)   
	setter:SetText("SETTER TUTORIAL")   
	setter:SetTextColor(Color(255,255,255))                  
	setter:DockMargin( 0, 0 , 0, 0 )     
	setter:SetFont("tiny2") 
	--myer_button:SetImage("materials/stalk.gif")        
	setter.Paint = function( self, w, h ) -- 'function Frame:Paint( w, h )' works too 
	draw.RoundedBox( 0, 0, 0, w, h, Color( 255,0,0,80) )      
	end 

	setter.DoClick = function()
		sound3:Stop()
	    gui.OpenURL( "https://paypal.me/hopedanganronpa?locale.x=en_US" )
	end

	spiker = vgui.Create( "DButton", FillPanel )       
	spiker:Dock(TOP) 
	spiker:SetSize(100,768)   
	spiker:SetText("SPIKER TUTORIAL")   
	spiker:SetTextColor(Color(255,255,255))                  
	spiker:DockMargin( 0, 0 , 0, 0 )     
	spiker:SetFont("tiny2") 
	--myer_button:SetImage("materials/stalk.gif")        
	spiker.Paint = function( self, w, h ) -- 'function Frame:Paint( w, h )' works too 
	draw.RoundedBox( 0, 0, 0, w, h, Color(  255,0,0,80) )      
	end 

	spiker.DoClick = function()
		sound3:Stop()
	    gui.OpenURL( "https://paypal.me/hopedanganronpa?locale.x=en_US" )
	end

	serve = vgui.Create( "DButton", FillPanel )       
	serve:Dock(TOP) 
	serve:SetSize(100,768)   
	serve:SetText("SERVE TUTORIAL")   
	serve:SetTextColor(Color(255,255,255))                  
	serve:DockMargin( 0, 0 , 0, 0 )     
	serve:SetFont("tiny2") 
	--myer_button:SetImage("materials/stalk.gif")        
	serve.Paint = function( self, w, h ) -- 'function Frame:Paint( w, h )' works too 
	draw.RoundedBox( 0, 0, 0, w, h, Color(  255,0,0,80) )      
	end 

	serve.DoClick = function()
		sound3:Stop()
	    gui.OpenURL( "https://paypal.me/hopedanganronpa?locale.x=en_US" )
	end
end ]]
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

	function RulesFrame:Init()
		self.startTime = SysTime()  
	end
	function RulesFrame:Paint() 
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



if SERVER then return end

-- Variables for single arc visualization
local arcData = nil
local arcTriggered = false -- Flag to allow only one arc visualization
local arcLifetime = 5 -- Time in seconds for the arc to persist

-- Draws an arc between two positions
function DrawSetterArc(startPos, targetPos, arcHeight, segments)
    local points = {}
    for i = 0, segments do
        local t = i / segments
        local lerpPos = LerpVector(t, startPos, targetPos)
        local height = arcHeight * (1 - (t * 2 - 1) ^ 2) -- Parabolic height
        lerpPos.z = lerpPos.z + height
        table.insert(points, lerpPos)
    end

    cam.Start3D()
    render.SetColorMaterial()
    for i = 1, #points - 1 do
        render.DrawLine(points[i], points[i + 1], Color(255, 150, 0), false)
    end
    cam.End3D()
end

-- Hook to draw the arc
hook.Add("PostDrawTranslucentRenderables", "RenderSingleArc", function()
    if arcData and CurTime() <= arcData.expiryTime then
        DrawSetterArc(arcData.startPos, arcData.targetPos, arcData.arcHeight, arcData.segments)
    elseif arcData and CurTime() > arcData.expiryTime then
        -- Reset arc data and flag after the arc expires
        arcData = nil
        arcTriggered = false
    end
end)

-- Trigger the arc once
hook.Add("Think", "TriggerOneTimeArc", function()
    if input.IsKeyDown(KEY_C) and not arcTriggered then
        -- Lock the trigger
        arcTriggered = true

        -- Get the starting position slightly above the player
        local startPos = LocalPlayer():GetPos() + Vector(0, 0, 50)

        -- Define a fixed forward direction and target position
        local forward = LocalPlayer():GetForward() * 300 -- Fixed distance in front
        local targetPos = startPos + forward -- Consistent arc target position

        -- Define arc properties
        local arcHeight = 100 -- Fixed consistent height
        local segments = 20 -- Number of points for smoothness

        -- Set arc data for rendering
        arcData = {
            startPos = startPos,
            targetPos = targetPos,
            arcHeight = arcHeight,
            segments = segments,
            expiryTime = CurTime() + arcLifetime -- Time when the arc will disappear
        }

        print("Arc triggered from " .. tostring(startPos) .. " to " .. tostring(targetPos))
    end
end)
