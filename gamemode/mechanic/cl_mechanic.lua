action_status = ""
local groundHitTimer = nil

print("Mechanic")
hook.Remove( "Tick", "KeyDown_Testis", function() end)
hook.Remove( "Tick", "KeyDown_Tests", function() end) 
hook.Remove( "Tick", "KeyDown_Toss", function() end)
hook.Remove("PlayerButtonDown","miya_serve",function(ply,button) end) 
hook.Remove( "Tick", "Kage_toss", function() end) 
hook.Remove( "Tick", "Kage_toss2", function() end) 
hook.Remove( "Tick", "KeyDown_Toss2", function() end)

local MainFrame2 = vgui.Create("DFrame")  
MainFrame2:SetSize(1366,768)
MainFrame2:SetTitle("This gamemode is created by Hope")
MainFrame2:SetVisible(false) 
MainFrame2:SetBackgroundBlur( false )
MainFrame2:ShowCloseButton(false)  
MainFrame2:Center()
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
ball_detect:SetText("")
ball_detect:SetTextColor(Color(0,0,0))     
ball_detect:SetSize(64, 64)  
ball_detect:DockMargin( 0, 5 , 0, 0 )         
ball_detect:SetFont("tiny") 
ball_detect.Paint = function( self, w, h ) -- 'function Frame:Paint( w, h )' works too 	
	draw.RoundedBox( 255, 0, 0, w, h, Color( 0,0,0,0) )
end
 
pos1 = Vector( -134.029663, 764.290222,-71.224037)
pos2 = Vector(  -556.752686, 324.668060, 218.018539)
-- Calculate the mirrored positions for the right side with reduced width
pos3 = Vector(pos1.x, -pos1.y, pos1.z)
pos4 = Vector(pos2.x,319.357361, pos2.z)

-- Court boundaries for IN/OUT detection
court_min = Vector(800.388855, -32.057045, -55.968750)
court_max = Vector(1199.963135, 671.806091, -55.968750)

position = ""
// added on 2025/12/13
local actionMode = {
    block = false,  -- start with spike active
    spike = true
}

-- Action mode switch notification
local actionModeNotification = {
    show = false,
    text = "",
    color = Color(255, 255, 255),
    startTime = 0,
    duration = 1.5
}

-- Player aim prediction after spike
local playerAimPrediction = {
    active = false,
    playerPos = nil,
    playerAng = nil,
    startTime = 0,
    duration = 1.0,
    playerName = ""
}

-- Global aim predictions from all players
local globalPlayerAims = {}

spikePower = {
    force = 0,
    power = 0
}

jumpAdd = 60 
charJumpPower = {
	hinata = 350 + jumpAdd,
	kageyama = 308 + jumpAdd,
	miya = 308 + jumpAdd,
	ushijima = 315 + jumpAdd,
	yamaguchi = 315 + jumpAdd,
	bokuto = 315 + jumpAdd,
	tsukishima = 290 + jumpAdd,
	korai = 395 + jumpAdd,
	kenma = 300 + jumpAdd,
	sakusa = 320 + jumpAdd,
	kuro = 310 + jumpAdd,
}

-- Flag to check if player has activated jump system
local jumpActivated = false
local keyDown = {}

function SetJumpPowerByCharacter(char) 
	if char == "hinata" then 
		jumpPower = charJumpPower.hinata
	elseif char == "kageyama" then 
		jumpPower = charJumpPower.kageyama
	elseif char == "miya" then 
		jumpPower = charJumpPower.miya
	elseif char == "ushijima" then 
		jumpPower = charJumpPower.ushijima
	elseif char == "yamaguchi" then
		jumpPower = charJumpPower.yamaguchi
	elseif char == "bokuto" then
		jumpPower = charJumpPower.bokuto
	elseif char == "tsukishima" then
		jumpPower = charJumpPower.tsukishima
	elseif char == "korai" then
		jumpPower = charJumpPower.korai
	elseif char == "kenma" then
		jumpPower = charJumpPower.kenma
	elseif char == "sakusa" then
		jumpPower = charJumpPower.sakusa
	elseif char == "kuro" then
		jumpPower = charJumpPower.kuro
	end
end 

function SetSpikePowerByCharacter(char)
    if char == "tsukishima" then
        spikePower.force = 10
        spikePower.power = 800
    elseif char == "korai" then
        spikePower.force = 10
        spikePower.power = 1300
    elseif char == "kenma" then
        spikePower.force = 20
        spikePower.power = 700
	elseif char == "sakusa" then
		spikePower.force = 10
        spikePower.power = 1201
	elseif char == "kageyama" then
		spikePower.force = 20
        spikePower.power = 800
	elseif char == "hinata" then
		spikePower.force = 10
        spikePower.power = 1150
	elseif char == "bokuto" then
		spikePower.force = 10
        spikePower.power = 1350
	elseif char == "kuro" then
		spikePower.force = 10
        spikePower.power = 1000
	elseif char == "miya" then
		spikePower.force = 20
        spikePower.power = 800
	elseif char == "ushijima" then
		spikePower.force = 10
        spikePower.power = 2555
	elseif char == "yamaguchi" then
		spikePower.force = 10
        spikePower.power = 800
    end
    
    -- Reinitialize spike system with new power values if spike mode is active
    if actionMode.spike then
        hook.Remove("Tick", "KeyDown_Spike")
        SpikePower(spikePower.force, spikePower.power)
    end
end

function GM:PlayerInitialSpawn(ply)

end 

function DefaultSwichMode() 
	actionMode.block = false
	actionMode.spike = true

	hook.Remove("PlayerButtonDown", "BlockJumpSystem")
	hook.Remove("PlayerButtonDown", "KeyDown_Block")
	SpikeApproachAnimation()
	SpikePower(spikePower.force,spikePower.power)

	-- Show spike mode notification
	actionModeNotification.show = true
	actionModeNotification.text = "SPIKE MODE"
	actionModeNotification.color = Color(255, 165, 0) -- Orange
	actionModeNotification.startTime = CurTime()

end 
function SwitchActionMode()
-- Think hook for switching modes (available immediately on spawn)

	hook.Add("CreateMove", "DisableDefaultJump", function(cmd)
		if LocalPlayer():IsValid() then
			cmd:RemoveKey(IN_JUMP)
		end
	end)

	DefaultSwichMode()

	hook.Add("Think", "SwitchActionMode", function()
	ply = LocalPlayer()
	if not IsValid(ply) then return end
	-- Don't allow mode switch if player is mid-air or during approach animation
	if not ply:IsOnGround() or isApproachAnimation then return end
	-- Only allow toggle if jump system is activated

	if input.IsKeyDown(KEY_4) then
		if not keyDown[KEY_4] then
			keyDown[KEY_4] = true

			if actionMode.block then
				actionMode.block = false
				actionMode.spike = true

				hook.Remove("PlayerButtonDown", "BlockJumpSystem")
				hook.Remove("PlayerButtonDown", "KeyDown_Block")
				SpikeApproachAnimation()
				SpikePower(spikePower.force,spikePower.power)

				-- Show spike mode notification
				actionModeNotification.show = true
				actionModeNotification.text = "SPIKE MODE"
				actionModeNotification.color = Color(255, 165, 0) -- Orange
				actionModeNotification.startTime = CurTime()
			else
				actionMode.block = true
				actionMode.spike = false

				hook.Remove("PlayerButtonDown", "SpikeJumpSystem")
				hook.Remove("Tick", "KeyDown_Spike")
				BlockApproachAnimation()
				BlockSystem()

				-- Show block mode notification
				actionModeNotification.show = true
				actionModeNotification.text = "BLOCK MODE"
				actionModeNotification.color = Color(0, 150, 255) -- Blue
				actionModeNotification.startTime = CurTime()
			end

			chat.AddText("Current mode: " .. (actionMode.block and "block" or "spike"))
		end
	else
		keyDown[KEY_4] = false
	end

	end)
end 

-- HUD notice
-- Create a custom bold font
surface.CreateFont("JumpNoticeFont", {
    font = "Trebuchet MS",  -- base font
    size = 48,              -- bigger size
    weight = 700,           -- thicker/bolder
    antialias = true,
    outline = true          -- optional: adds outline for extra visibility
})

-- Action mode notification font
surface.CreateFont("ActionModeNotificationFont", {
    font = "Trebuchet MS",
    size = 48,
    weight = 700,
    antialias = true,
    outline = false
})


//some UI shit for actionMode 
-- Custom font for the UI
surface.CreateFont("ActionModeFont", {
    font = "Trebuchet MS",
    size = 20,
    weight = 600,
    antialias = true,
})

-- Action Mode HUD (Bottom-Right)
hook.Add("HUDPaint", "ActionModeUI", function()
    local ply = LocalPlayer()
    if not IsValid(ply) then return end

    local w, h = 150, 60                 -- panel size
     local x, y = ScrW() - w - 30, ScrH() - h - 30  -- bottom-right padding, lowered

    -- Background box with subtle shadow
    draw.RoundedBox(8, x+2, y+2, w, h, Color(0, 0, 0, 150))  -- shadow
    draw.RoundedBox(8, x, y, w, h, Color(40, 40, 40, 220))    -- main panel

    -- Title
    draw.SimpleText("Action Mode", "ActionModeFont", x + w/2, y + 10, Color(255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)

    -- Current mode text
    local modeText = actionMode.block and "BLOCK [KEY_4]" or "SPIKE [KEY_4]"

    -- Measure text width
    surface.SetFont("ActionModeFont")
    local textW, textH = surface.GetTextSize(modeText)

    -- Draw bar width slightly larger than text
    local barPadding = 10
    local barWidth = textW + barPadding * 2
    local barX = x + (w - barWidth)/2
    local barY = y + 30
    local barHeight = 20

    -- Bar background
    draw.RoundedBox(6, barX, barY, barWidth, barHeight, Color(50,50,50,200))
    -- Bar fill color
    local modeColor = actionMode.block and Color(0, 150, 255) or Color(255, 100, 0)
    draw.RoundedBox(6, barX, barY, barWidth, barHeight, modeColor)

    -- Mode text
    draw.SimpleText(modeText, "ActionModeFont", x + w/2, barY + barHeight/2, Color(255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
end)





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


----------//spike mechanics//-------------------------
randomSoundBokuto = {"boku/spike2.mp3","boku/bokutospike2.mp3"}
randomSoundHinata = {"hina/hinataspike2.mp3","hina/hinataspike3.mp3"}
randomSoundKorai = {"korai/hoshiumispike1.wav","korai/hoshiumispike2.wav"} 

function SpikeSoundEffect(power) 
	if (ply:Ping() >120) then 
		-- Handle sound effects and trails based on power
		if power > 2500 then -- Ushijima
			ply:EmitSound("ushi/ushijimaspike2.wav", 70, 100, 1, CHAN_AUTO)
		elseif power == 1150 then -- Hinata
			local hinataSound = table.Random(randomSoundHinata)
			ply:EmitSound(hinataSound, 70, 100, 1, CHAN_AUTO)
		elseif power == 1350 then -- Bokuto
			local bokutoSound = table.Random(randomSoundBokuto)
			ply:EmitSound(bokutoSound, 70, 100, 1, CHAN_AUTO)
		elseif power == 1300 then -- Korai
			local koraiSound = table.Random(randomSoundKorai)
			ply:EmitSound(koraiSound, 70, 100, 1, CHAN_AUTO)
		elseif power == 1200 then -- Kuro
		end
	end
end 
function SpikePower(setForce,spikepower)
	ply = LocalPlayer() 
	powerbar = 0  
	power = 0 
	jumpcount = 0 
	buttonpress = 0 
	local ent =  ents.FindByClass( "prop_physics*" )

	--spikepower = 0 
	--jumpcount = 0 
	buttonpressrec = 0 
	local ply = LocalPlayer() 
	local release_ball_spike = false 
	
	-- Store the spike power values for this instance
	local currentSpikepower = spikepower

	hook.Add( "Tick", "KeyDown_Spike", function()
		-- Update spike power from global table in case character changed
		currentSpikepower = spikePower.power
		if !ply:IsOnGround()  then
			if release_ball_spike == false then 
				if (input.IsButtonDown(MOUSE_LEFT)) then
					release_ball_spike = false
					action_status = "SPIKING"
					-- detect ball when hold button
					local ent =  ents.FindByClass( "prop_physics*" )
					for k, v in pairs( ent ) do    
						physObj = ent[k]:GetPhysicsObject()

						local detection_sqr = 115*115 
						if LocalPlayer():GetPos():DistToSqr( ent[k]:GetPos() ) < detection_sqr then
							release_ball_spike = true
							ply:ConCommand("pac_event spike")
							SpikeSoundEffect(currentSpikepower)
						

							if set_power_level_spike == power_level_spike[1] then
								SpikeSendToServer("weak",currentSpikepower,ent[k],ent[k]:GetPos(),allow_spike_assist)
								
								--// START ADD VELOCITY TO FAKE BALL //-----------
								if LocalPlayer():Ping() > 120 then
									local fake_ball = ClientsideModel(ent[k]:GetModel())
									fake_ball:SetRenderMode(RENDERMODE_TRANSALPHA)
									fake_ball:SetColor(Color(255, 255, 255,70))  -- 50% transparency
									fake_ball:SetPos(ent[k]:GetPos())
									fake_ball:PhysicsInit(SOLID_VPHYSICS)  -- Initialize physics
									-- Define the function to apply a downward force to the ball
									local phys = fake_ball:GetPhysicsObject()
									phys:EnableDrag(true)
									//phys:SetDamping( 2.1, 45 )
									phys:SetMaterial("gmod_bouncy")
									phys:SetMass(20)
									phys:SetVelocity(LocalPlayer():GetAimVector() * spikepower)
									phys:GetPhysicsObject():AddAngleVelocity(Vector(0,5000,0))
									
		
									timer.Simple(0.1, function()
										if IsValid(fake_ball) then
											fake_ball:Remove()
										end
									end)
								end
								-- END FAKE BALL VELOCITY -------------------------

								-- Function to check if the entity's physics object is on the ground
								function IsEntityOnGround(entity)
									-- Get the position of the entity
									local posBall = entity:GetPos()
									
									-- Trace a line downward to check for ground collision
									local traceBall = util.TraceLine({
										start = posBall,
										endpos = posBall - Vector(0, 0, 20), -- Adjust the length based on your needs
										mask = MASK_OPAQUE
									})
									
									-- Return true if the trace hits the ground, false otherwise
									return traceBall.Hit
								end



								-- Function to check if the entity's physics object is on the ground and create a ground marker if so
								function BallGroundCheck() 
									-- Usage example
									if IsEntityOnGround(ent[k]) then
										
										hook.Remove("Think", "BallChecker") -- Remove the hook as it's no longer needed
										net.Start("BallHitGround")
										net.WriteVector(ent[k]:GetPos())
										net.WriteEntity(ent[k])
										net.SendToServer()
										--CreateGroundMarker(ent[k]:GetPos()) -- Create a ground marker at the position of the entity
									else
										hook.Add("Think", "BallChecker", BallGroundCheck) -- Add the hook to keep checking
									end
								end 

								-- Start checking if the ball is on the ground
								BallGroundCheck()

							else 

								
								SpikeSendToServer("strong",currentSpikepower,ent[k],ent[k]:GetPos(),allow_spike_assist)

								--// START ADD VELOCITY TO FAKE BALL //-----------
								if LocalPlayer():Ping() > 120 then
									local fake_ball = ClientsideModel(ent[k]:GetModel())
									fake_ball:SetRenderMode(RENDERMODE_TRANSALPHA)
									fake_ball:SetColor(Color(255, 255, 255,70))  -- 50% transparency
									fake_ball:SetPos(ent[k]:GetPos())
									fake_ball:PhysicsInit(SOLID_VPHYSICS)  -- Initialize physics
									-- Define the function to apply a downward force to the ball
									local phys = fake_ball:GetPhysicsObject()
									phys:SetMaterial("gmod_bouncy")
									phys:SetMass(20)
									phys:EnableDrag(true)
									//phys:SetDamping( 2.1, 45 )
									phys:SetVelocity(LocalPlayer():GetAimVector() * spikepower)


									-- Remove the clone and text after some time
									timer.Simple(0.1,function() 
										if IsValid(fake_ball) then
											fake_ball:Remove()
										end
									end)
								end 
								-- END FAKE BALL VELOCITY -------------------------
								-- Function to check if the entity's physics object is on the ground
								function IsEntityOnGround(entity)
									-- Get the position of the entity
									local posBall = entity:GetPos()
									
									-- Trace a line downward to check for ground collision
									local traceBall = util.TraceLine({
										start = posBall,
										endpos = posBall - Vector(0, 0, 20), -- Adjust the length based on your needs
										mask = MASK_OPAQUE
									})
									
									-- Return true if the trace hits the ground, false otherwise
									return traceBall.Hit
								end



								-- Function to check if the entity's physics object is on the ground and create a ground marker if so
								function BallGroundCheck() 
									-- Usage example
									if IsEntityOnGround(ent[k]) then
										hook.Remove("Think", "BallChecker") -- Remove the hook as it's no longer needed
										net.Start("BallHitGround")
										net.WriteVector(ent[k]:GetPos())
										net.WriteEntity(ent[k])
										net.SendToServer()
										--CreateGroundMarker(ent[k]:GetPos()) -- Create a ground marker at the position of the entity
									else
										hook.Add("Think", "BallChecker", BallGroundCheck) -- Add the hook to keep checking
									end
								end 

								-- Start checking if the ball is on the ground
								BallGroundCheck()
							end 
							timer.Simple(1,function() release_ball_spike = false end)
						end	
					end	
				else 
					action_status = ""
				end 
			else 
				
			
			end 
		end
	end) 
end 	

--- WHEN BLOCKED ------------------------------------------------------------

net.Receive("PrintEveryone",function(bits,ply)
	local getMessage = net.ReadString() 

	draw.DrawText(getMessage, "CloseCaption_BoldItalic", ScrW()/2.09, ScrH()/5.54, Color(255, 0, 0))
	timer.Simple(2,function() 
		getMessage = "" 
	end)
end) 

--- Cool Effects SPIKE -----------------------------------------------------


function LastSpikeClient(playerNick,ball,ballPos,playerEnt) 
	
	function GetHeightInCm(vec)
		local units = vec.z
		local cm = units * 1.9
		local roundedCm = math.Round(cm)  -- Round to the nearest whole number
		return roundedCm
	end
	

	local clone = ClientsideModel(ball:GetModel())  
	
	clone:SetPos(ballPos)  -- Set the position of the clone to the player's position
	clone:SetAngles(ball:GetAngles())  -- Set the angles of the clone to the player's angles

	-- Make the clone translucent
	clone:SetRenderMode(RENDERMODE_TRANSALPHA)
	clone:SetColor(Color(255, 255, 255, 70))  -- 50% transparency
	local heightInCm = GetHeightInCm(ballPos)
	-- Add standing 3D2D text above the clone
	hook.Add("PostDrawOpaqueRenderables", "DrawPlayerSpikeText", function()
		if IsValid(clone) then
			local pos = clone:GetPos() + Vector(0, 0, 30) -- Adjust the height of the text
			local ang = LocalPlayer():EyeAngles()
			ang:RotateAroundAxis(ang:Forward(), 90)
			ang:RotateAroundAxis(ang:Right(), 90)
			if playerEnt:Ping() > 100 then
				cam.Start3D2D(pos, Angle(0, ang.y, 90), 0.5) -- Adjust the scale (0.1)
					draw.DrawText("Relocate for "..playerNick.." "..heightInCm.."cm | "..playerEnt:Ping().."ping", "Trebuchet24", 0, 0, Color(255, 255, 255), TEXT_ALIGN_CENTER)
				cam.End3D2D()
			else 
				cam.Start3D2D(pos, Angle(0, ang.y, 90), 0.5) -- Adjust the scale (0.1)
					draw.DrawText(playerNick.." Spiked Here "..heightInCm.."cm", "Trebuchet24", 0, 0, Color(255, 255, 255), TEXT_ALIGN_CENTER)
				cam.End3D2D()
			end 
		end
	end)

	-- Remove the clone and text after some time
	timer.Simple(5, function()
		if IsValid(clone) then
			clone:Remove()
			hook.Remove("PostDrawOpaqueRenderables", "DrawPlayerSpikeText")
		end
	end)
end 

local clones = ClientsideModel("models/pejal_models/volleyball/mikasa.mdl") 
local BALL_RADIUS = 0

hook.Add("InitPostEntity", "CalcBallRadius", function()
    local temp = ClientsideModel("models/pejal_models/volleyball/mikasa.mdl")
    if not IsValid(temp) then return end

    local mins, maxs = temp:GetModelBounds()
    BALL_RADIUS = math.max(
        math.abs(mins.x), math.abs(maxs.x),
        math.abs(mins.y), math.abs(maxs.y)
    )

    temp:Remove()
end)


-- Function to create a visual marker at the position of the entity
function CreateGroundMarker(pos,ball)
	 
	local x = Vector(5, 5, 5)

	-- Define the hook to draw the box and text
	hook.Add("PostDrawTranslucentRenderables", "BoxWithText", function()
		
		clones:SetPos(pos)  -- Set the position of the clone to the player's position
		//clone:SetAngles(ball:GetAngles())  -- Set the angles of the clone to the player's angles
	
		-- Make the clone translucent
		clones:SetRenderMode(RENDERMODE_TRANSALPHA)
		clones:SetColor(Color(255, 255, 255, 150))  -- 50% transparency

		cam.IgnoreZ(false) -- disables previous call

		-- Draw text above the box using cam.Start3D2D
		local text = "Ball Mark Check"
		local textPos = pos + Vector(0, 0, 5 + 5) -- Adjust the vertical offset
		local textFont = "DermaDefault" -- Adjust the font as needed
		local textScale = 0.4 -- Adjust the scale of the text
		local textCol = Color(255, 255, 255) -- Adjust the color of the text

		-- Set up the 3D2D rendering with a 90-degree rotation around the X-axis
		cam.Start3D2D(textPos, Angle(0, 0, 0), textScale)
		draw.SimpleText(text, textFont, 0, 0, textCol, TEXT_ALIGN_CENTER)
		cam.End3D2D()
		
	end)
end

courtMin = Vector(794.318298, -40.005096, -100)
courtMax = Vector(1207.460327, 676.799255, 100)

 function IsBallInCourt(ballPos)
    if not isvector(ballPos) then return false end

    -- Expand court by ball radius
    local min = courtMin
    local max = courtMax 

    return ballPos:WithinAABox(min, max)
end


-- global state
isBallIn = nil

net.Receive("BallHitGroundClient", function()
    local ballPos = net.ReadVector()
    local ballEnt = net.ReadEntity()

    isBallIn = IsBallInCourt(ballPos)
	CreateGroundMarker(ballPos, isBallIn)

    print(isBallIn and "BALL IN" or "BALL OUT")
	if allow_in_out_system then
		timer.Simple(0.8,function()	surface.PlaySound("whistle.mp3") end)
	end

    groundHitTimer = CurTime() + 3.5
end)



-- illusion effect
net.Receive("illusion_effect", function(bits, ply)
	local playerNick = net.ReadString()
	local ballEnt = net.ReadEntity()
	local ballPos = net.ReadVector()
	local playerEnt = net.ReadEntity()

	ballEnt:SetNoDraw(false)
	//LastSpikeClient(playerNick,ballEnt,ballPos,playerEnt)
end)

-- Receive player aim predictions from other players
net.Receive("PlayerAimPrediction", function()
	local playerName = net.ReadString()
	local playerPos = net.ReadVector()
	local playerAng = net.ReadAngle()

	-- Store the prediction for this player
	globalPlayerAims[playerName] = {
		active = true,
		playerPos = playerPos,
		playerAng = playerAng,
		startTime = CurTime(),
		duration = 1.0
	}
end)

function SpikeSendToServer(powertype,spikepower,entity,entityPos,allow_spike_assist)
	if ply:GetPos():WithinAABox( pos1, pos2 ) then
		position = "left"
	else
		position = "right"
	end

	-- Activate player aim prediction after spike - capture current aim direction
	playerAimPrediction.active = true
	playerAimPrediction.playerPos = ply:EyePos() -- Use eye position for accurate aim line start
	playerAimPrediction.playerAng = ply:EyeAngles() -- This captures where they're looking when hitting the ball
	playerAimPrediction.startTime = CurTime()
	playerAimPrediction.playerName = ply:Nick()

	net.Start("spike_power_hinata")
	net.WriteString(position)
	net.WriteString(powertype)
	net.WriteInt(spikepower,32)
	net.WriteString(character)
	net.WriteEntity(entity)
	net.WriteVector(entityPos)
	net.WriteBool(allow_spike_assist)
	net.SendToServer()
end
----------//spike END mechanics//-------------------------

--- RECEIVE MECHANICS START --------------------------------
isReceived = false
function ReceiveSendToServer(powertype,ent,allow_old_mechanic, zoneText)
	groundHitTimer = nil
	chat.AddText("receive accuracy:", zoneText)

	if ply:GetPos():WithinAABox( pos1, pos2 ) then
		position = "left"
		ply:ConCommand("pac_event receive")
		print("on left side ")
		isReceived = true
		--ply:ConCommand("pac_event receive")
		-- local ball_pos_x = ent:GetPos().x
		-- local player_pos_x = LocalPlayer():GetPos().x
		-- local player_orientation = ply:GetAngles().y  -- Get player's Y-angle (0° to 360°)

		-- -- Convert player_orientation to a range of 0° to 360° (if needed)
		-- player_orientation = player_orientation % 360

		-- -- Define angle ranges for left, forward, and right orientations
		-- local left_angle_range = 180 - 45  -- 135° to 225°
		-- local right_angle_range = 45       -- 0° to 45° and 315° to 360°

		-- -- Determine if the ball is more to the right or left
		-- local is_ball_on_right = false
		-- if player_orientation >= left_angle_range and player_orientation <= right_angle_range then
		-- 	-- Player is facing forward or slightly to the right
		-- 	is_ball_on_right = ball_pos_x > player_pos_x
		-- else
		-- 	-- Player is facing left or significantly to the right
		-- 	is_ball_on_right = ball_pos_x < player_pos_x
		-- end

		-- -- Play animation based on ball position
		-- if is_ball_on_right and position == "left" then
		-- 	print("right")
		-- 	ply:ConCommand("pac_event receiveright")
		-- 	-- Play animation: receive right
		-- else
		-- 	print("left")
		-- 	-- Play animation: receive left
		-- 	ply:ConCommand("pac_event receiveleft")
		-- end

	else
		print("on right side ")
		position = "right"
		ply:ConCommand("pac_event receive")
		isReceived = true
		--ply:ConCommand("pac_event receive")
		-- local ball_pos_x = ent:GetPos().x
		-- local player_pos_x = LocalPlayer():GetPos().x
		-- local player_orientation = ply:GetAngles().y  -- Get player's Y-angle (0° to 360°)

		-- -- Convert player_orientation to a range of 0° to 360° (if needed)
		-- player_orientation = player_orientation % 360

		-- -- Define angle ranges for left, forward, and right orientations
		-- local left_angle_range = 180 - 45  -- 135° to 225°
		-- local right_angle_range = 45       -- 0° to 45° and 315° to 360°

		-- -- Determine if the ball is more to the right or left
		-- local is_ball_on_right = false
		-- if player_orientation >= left_angle_range and player_orientation <= right_angle_range then
		-- 	-- Player is facing forward or slightly to the right
		-- 	is_ball_on_right = ball_pos_x > player_pos_x
		-- else
		-- 	-- Player is facing left or significantly to the right
		-- 	is_ball_on_right = ball_pos_x < player_pos_x
		-- end

		-- -- Play animation based on ball position
		-- if is_ball_on_right and position == "right" then
		-- 	print("left")
		-- 	ply:ConCommand("pac_event receiveleft")
		-- 	-- Play animation: receive right
		-- else
		-- 	print("right")
		-- 	ply:ConCommand("pac_event receiveright")
		-- end
	end

	if powertype == "feint" then
		//play feint animation
		ply:ConCommand("pac_event spike")
	end

	net.Start("receive_power")
	net.WriteString(position)
	net.WriteString(powertype)
	net.WriteEntity(ent)
	net.WriteBool(allow_receive_assist)
	net.WriteVector(ent:GetPos())
	net.WriteBool(allow_old_mechanic)
	net.WriteString(character)
	net.WriteString(zoneText)
	net.SendToServer()
end

function TossSendToServer(powertype,frontback)
	groundHitTimer = nil
	LocalPlayer():ConCommand("pac_event toss")
	if ply:GetPos():WithinAABox( pos1, pos2 ) then
		position = "left"
	else
		position = "right"
	end
	net.Start("toss_power")
	net.WriteString(position)
	net.WriteString(powertype)
	net.WriteString(frontback)
	net.WriteBool(allow_set_assist)
	net.SendToServer()


end



-- local shouldOccur3 = true  
-- local delay3 = 1 
-- local meg_cd2=1 

-- function DiveSendToServer(powertype)  
-- 	if ply:GetPos():WithinAABox( pos1, pos2 ) then
-- 		position = "left"
-- 	else 
-- 		position = "right"
-- 	end 
-- 	if shouldOccur3 then 
-- 		meg_cd = 64 
-- 		net.Start("dive_power")
-- 		net.WriteString(position)
-- 		net.WriteString(powertype)
-- 		net.SendToServer()

-- 		timer.Create("stopmovement",1,1,function() 

-- 			net.Start("revertspeed")
-- 			net.WriteString("libero")
-- 			net.SendToServer()
-- 		end)

-- 		ply:PrintMessage( HUD_PRINTTALK, "You used your ability" )
-- 		shouldOccur3 = false   
-- 		timer.Create("meg_cd2",1,1,function() meg_cd2=meg_cd2-1  end) 
-- 		timer.Simple( delay3, function() shouldOccur3 = true end )
-- 	else

-- 	end     
-- end 
function GetLagAdjustedDelay(baseDelay)
    local ply = LocalPlayer()
    if not IsValid(ply) then return baseDelay end

    local ping = ply:Ping() / 1000
    return math.max(0.05, baseDelay - ping)
end


-- Serve area vectors
 miya_pos1 = Vector(1300.494019, -261.572266, -119.701813)
 miya_pos2 = Vector(670.607239, -30.208231, 199.167160)
 miya_pos3 = Vector(676.425293, 888.083191, -108.272842)
 miya_pos4 = Vector(1375.196899, 661.645447, 262.988831)

local canServe = true
local delayJumpServe = 0.7
function BasicServe()
    hook.Add("PlayerButtonDown", "basic_serve_once", function(ply, button)
        if not canServe then return end
        if button == MOUSE_RIGHT then

            if ply:GetPos():WithinAABox(miya_pos1, miya_pos2) or
               ply:GetPos():WithinAABox(miya_pos3, miya_pos4) then

                jumpActivated = true
                canServe = false

                actionMode.block = false
                actionMode.spike = true

                hook.Remove("PlayerButtonDown", "BlockJumpSystem")
                hook.Remove("PlayerButtonDown", "KeyDown_Block")

                SpikeApproachAnimation()
                SpikePower(spikePower.force, spikePower.power)

                ply:ConCommand("pac_event jumpserve")

                net.Start("JumpApproachStart")
                net.SendToServer()

                -- SMART LAG-COMPENSATED DELAY
                local adjustedDelay = GetLagAdjustedDelay(delayJumpServe)

                timer.Simple(adjustedDelay, function()
                    net.Start("basic_serve")
                    net.SendToServer()

                    timer.Simple(0.8, function()
                        ply:ConCommand("pac_event jump")

                        net.Start("addVelocity")
						net.WriteString(character)
                        net.WriteInt(450, 32)
                        net.SendToServer()

                        net.Start("JumpApproachEnd")
                        net.SendToServer()

                        isJumping = false
                    end)
                end)

                timer.Simple(1, function()
                    canServe = true
                end)
            else
                chat.AddText(Color(255, 100, 100), "Not in area to use serve.")
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
	net.WriteBool(allow_set_assist)
	net.SendToServer()
end 

--------------------------------------------------
-- KAGE QUICK TOSS (REFACTORED, SAFE, VISUAL HUD)
--------------------------------------------------

-- Internal state (SAFE globals)
local KageToss = {
    power = 0,
    bar = 0,
    holding = false,
    mode = "front"
}

local KAGE_SET_FORCE = 0
local TOSS_SET_FORCE = 0
local BACK_TOSS_SET_FORCE = 0

--------------------------------------------------
-- HUD VISUAL (LOW / MID / HIGH)
--------------------------------------------------
function KageQuickTossHUD() 
	hook.Add("HUDPaint", "KageQuickTossHUD", function()
		if not KageToss.holding then return end
		if KAGE_SET_FORCE <= 0 then return end

		local w, h = 320, 36
		local x = ScrW() / 2 - w / 2
		local y = ScrH() * 0.65

		-- Background
		draw.RoundedBox(10, x, y, w, h, Color(20, 20, 20, 220))

		-- Fill %
		local pct = math.Clamp(KageToss.power / 20, 0, 1)
		local fillW = w * pct

		local col = Color(120, 200, 255)
		local label = "LOW POWER"

		if KageToss.power >= KAGE_SET_FORCE then
			col = Color(120, 255, 120)
			label = "MID POWER"
		end
		if KageToss.power >= 20 then
			col = Color(255, 120, 120)
			label = "HIGH POWER"
		end

		draw.RoundedBox(10, x + 4, y + 4, fillW - 8, h - 8, col)

		draw.SimpleText(
			label,
			"Trebuchet24",
			x + w / 2,
			y + h / 2,
			color_white,
			TEXT_ALIGN_CENTER,
			TEXT_ALIGN_CENTER
		)
	end)
end 

--------------------------------------------------
-- MAIN FUNCTION (LOGIC UNCHANGED)
--------------------------------------------------
function KageQuickToss(setForce)
    -- FIX nil comparison
    KAGE_SET_FORCE = setForce or 0

    if KAGE_SET_FORCE <= 0 then return end

    -- Reset state
    KageToss.power = 0
    KageToss.bar = 0
    KageToss.holding = false

    hook.Remove("Tick", "Kage_toss2")

    hook.Add("Tick", "Kage_toss2", function()
        if not actionMode.block then return end

        if input.IsButtonDown(MOUSE_MIDDLE) then
            KageToss.holding = true

            if set_power_level_toss == power_level_toss[1] then
                -- FRONT QUICK TOSS
                KageToss.mode = "front"
                KageToss.power = KageToss.power + 1
            else
                -- BACK SHOOT TOSS
                KageToss.mode = "back"
                KageToss.power = KageToss.power + 1
            end
        else
            if not KageToss.holding then return end
            KageToss.holding = false

            --------------------------------
            -- RELEASE LOGIC (UNCHANGED)
            --------------------------------
            if KageToss.mode == "front" then
                if KageToss.power <= KAGE_SET_FORCE then
                    KageSendToServer("weak", "front", "quick")
                    chat.AddText("Short Toss!")
                elseif KageToss.power < 20 then
                    KageSendToServer("medium", "front", "quick")
                    chat.AddText("Medium Toss!")
                else
                    KageSendToServer("high", "front", "quick")
                    chat.AddText("Power Toss!")
                end
            else
                KageSendToServer("shoot", "back", "quick")
                chat.AddText("Back Shoot Toss!")
            end

            -- Reset
            KageToss.power = 0
            KageToss.bar = 0
        end
    end)
end



-- Internal state for KageFrontToss HUD
local KageFrontTossState = {
    holding = false,
    power = 0
}

--------------------------------------------------
-- HUD VISUAL (LOW / MID / HIGH) for KageFrontToss
--------------------------------------------------
function KageFrontTossHUD()
	hook.Add("HUDPaint", "KageFrontTossHUD", function()
		if not KageFrontTossState.holding then return end
		if KAGE_SET_FORCE <= 0 then return end

		local w, h = 320, 36
		local x = ScrW() / 2 - w / 2
		local y = ScrH() * 0.65

		-- Background
		draw.RoundedBox(10, x, y, w, h, Color(20, 20, 20, 220))

		-- Fill %
		local pct = math.Clamp(KageFrontTossState.power / 20, 0, 1)
		local fillW = w * pct

		local col = Color(120, 200, 255)
		local label = "LOW POWER"

		if KageFrontTossState.power >= KAGE_SET_FORCE then
			col = Color(120, 255, 120)
			label = "MID POWER"
		end
		if KageFrontTossState.power >= 20 then
			col = Color(255, 120, 120)
			label = "HIGH POWER"
		end

	draw.RoundedBox(10, x + 4, y + 4, fillW - 8, h - 8, col)

		draw.SimpleText(
			label,
			"Trebuchet24",
			x + w / 2,
			y + h / 2,
			color_white,
			TEXT_ALIGN_CENTER,
			TEXT_ALIGN_CENTER
		)
	end)
end 

function KageFrontToss(setForce)
    -- safety
    KAGE_SET_FORCE = setForce or 0

    powertossbarkage = 0
    powertosskage = 0
    buttonpresstosskage = 0

    hook.Remove("Tick", "Kage_toss")

    hook.Add("Tick", "Kage_toss", function()
        if not actionMode.block then return end

        local keySetting
        if allow_left_assist == false then
            keySetting = KEY_R
        else
            keySetting = KEY_LBRACKET
        end

        --------------------------------------------------
        -- HOLD
        --------------------------------------------------
        if input.IsButtonDown(keySetting) then
            buttonpresstosskage = 1

            powertosskage = powertosskage + 1

            -- HUD STATE
            KageFrontTossState.holding = true
            KageFrontTossState.power = powertosskage

            -- HUD MIRROR (SAME AS QUICK TOSS)
            KageToss.holding = true
            KageToss.power = powertosskage
            KageToss.mode = "front"

        else
            --------------------------------------------------
            -- RELEASE
            --------------------------------------------------
            if buttonpresstosskage == 0 then return end
            buttonpresstosskage = 0

            KageFrontTossState.holding = false
            KageToss.holding = false

            if powertosskage <= KAGE_SET_FORCE then
                KageSendToServer("weak", "front", "king")
                chat.AddText("Short Toss!")
            elseif powertosskage < 20 then
                KageSendToServer("medium", "front", "king")
                chat.AddText("Medium Toss!")
            else
                KageSendToServer("high", "front", "king")
                chat.AddText("Power Toss!")
            end

            -- RESET (IMPORTANT FOR HUD)
            powertosskage = 0

            KageFrontTossState.power = 0
            KageToss.power = 0
        end
    end)
end

 


function CutSendToServer(direction,power,entBall)  
	if ply:GetPos():WithinAABox( pos1, pos2 ) then
		position = "left"
	else 
		position = "right"
	end 
	print(entBall:GetPos())
	net.Start("bokuto_cut")
	net.WriteString(position)
	net.WriteString(direction)
	net.WriteString(power)
	net.WriteEntity(entBall)
	net.WriteVector(entBall:GetPos())
	net.SendToServer()
end

function MiyaServe()
	 miya_pos1 = Vector(1300.494019, -261.572266, -119.701813) 
	 miya_pos2 = Vector(670.607239, -30.208231, 199.167160) 
	 miya_pos3 = Vector( 676.425293 ,888.083191, -108.272842) 
	 miya_pos4 = Vector(1375.196899, 661.645447, 262.988831) 

	 miya_active = false 


	hook.Add("PlayerButtonDown","miya_serve",function(ply,button)
		

		local keySettingR,keySettingT 

		if allow_left_assist == false then
			keySettingR = KEY_R
			keySettingT = KEY_T
		else 
			keySettingR = KEY_LBRACKET
			keySettingT = KEY_SEMICOLON
		end


		if  ply:GetPos():WithinAABox( miya_pos1, miya_pos2 ) or ply:GetPos():WithinAABox( miya_pos3, miya_pos4)  then 
			if button == keySettingR then

				net.Start("check_miya_position")
				net.SendToServer() 
				--chat.AddText(Color(255,0,0),"Miya Serve is active")

				hook.Remove("PlayerButtonDown","miya_serve",function(ply,button) end) 
				--hook.Remove( "Tick", "KeyDown_Toss", function() end )
				hook.Remove( "Tick", "Kage_toss2", function() end)

				hook.Add("PlayerButtonDown","miya_serve2",function(ply,button)
					if button == keySettingR then
						if  ply:GetPos():WithinAABox( miya_pos1, miya_pos2 ) or ply:GetPos():WithinAABox( miya_pos3, miya_pos4)  then 
							
							net.Start("miya_ability")
							net.WriteString("tossup")
							net.SendToServer()

						else 
							hook.Remove("PlayerButtonDown","miya_serve2",function() end) 
							MiyaServe()
						end 
					end 

					if button == keySettingT then 
						if  ply:GetPos():WithinAABox( miya_pos1, miya_pos2 ) or ply:GetPos():WithinAABox( miya_pos3, miya_pos4)  then 
							if character == "miya" then 
								net.Start("miya_ability")
								net.WriteString("spike")
								net.WriteString("miya")
								net.SendToServer()
							elseif character == "korai" then 
								-- net.Start("miya_ability")
								-- net.WriteString("spike")
								-- net.WriteString("korai")
								-- net.SendToServer()
							end 

							hook.Remove("PlayerButtonDown","miya_serve2",function() end) 
							hook.Remove( "Tick", "KeyDown_Toss", function() end )
							hook.Remove( "Tick", "Kage_toss2", function() end)

							local ent =  ents.FindByClass( "prop_physics*" )
							for k, v in pairs( ent ) do  
								if ply:GetPos():DistToSqr( ent[k]:GetPos() ) < 170*170 then  
									-- END FAKE BALL VELOCITY -------------------------
									-- Function to check if the entity's physics object is on the ground
									function IsEntityOnGround(entity)
										-- Get the position of the entity
										local posBall = entity:GetPos()
										
										-- Trace a line downward to check for ground collision
										local traceBall = util.TraceLine({
											start = posBall,
											endpos = posBall - Vector(0, 0, 25), -- Adjust the length based on your needs
											mask = MASK_OPAQUE
										})
										
										-- Return true if the trace hits the ground, false otherwise
										return traceBall.Hit
									end

										-- Function to check if the entity's physics object is on the ground and create a ground marker if so
									function BallGroundCheck() 
										-- Usage example
										if IsEntityOnGround(ent[k]) then
											hook.Remove("Think", "BallChecker") -- Remove the hook as it's no longer needed
											net.Start("BallHitGround")
											net.WriteVector(ent[k]:GetPos())
											net.WriteEntity(ent[k])
											net.SendToServer()
											--CreateGroundMarker(ent[k]:GetPos()) -- Create a ground marker at the position of the entity
										else
											hook.Add("Think", "BallChecker", BallGroundCheck) -- Add the hook to keep checking
										end
									end 

									-- Start checking if the ball is on the ground
									BallGroundCheck()

								end 
							end 


							MiyaServe()
							timer.Create("re",1,1,function() 
								chat.AddText("Set is now usable")
								TossPower(10)
								if character == "miya" then 
									KageQuickToss(10)
								end 
								timer.Stop("re")
							end) 
						
						else 
							--hook.Remove("PlayerButtonDown","miya_serve2",function() end)
							--TossPower(10)
							--KageQuickToss(10)
							if character == "miya" then 
								net.Start("miya_ability")
								net.WriteString("spike")
								net.WriteString("miya")
								net.SendToServer()
							elseif character == "korai" then 
								-- net.Start("miya_ability")
								-- net.WriteString("spike")
								-- net.WriteString("korai")
								-- net.SendToServer()
							end 

							hook.Remove("PlayerButtonDown","miya_serve2",function() end) 
							hook.Remove( "Tick", "KeyDown_Toss", function() end )
							hook.Remove( "Tick", "Kage_toss2", function() end)
							
							local ent =  ents.FindByClass( "prop_physics*" )
							for k, v in pairs( ent ) do  
								if ply:GetPos():DistToSqr( ent[k]:GetPos() ) < 170*170 then  
									-- END FAKE BALL VELOCITY -------------------------
									-- Function to check if the entity's physics object is on the ground
									function IsEntityOnGround(entity)
										-- Get the position of the entity
										local posBall = entity:GetPos()
										
										-- Trace a line downward to check for ground collision
										local traceBall = util.TraceLine({
											start = posBall,
											endpos = posBall - Vector(0, 0, 25), -- Adjust the length based on your needs
											mask = MASK_OPAQUE
										})
										
										-- Return true if the trace hits the ground, false otherwise
										return traceBall.Hit
									end

									-- Function to check if the entity's physics object is on the ground and create a ground marker if so
									function BallGroundCheck() 
										-- Usage example
										if IsEntityOnGround(ent[k]) then
											hook.Remove("Think", "BallChecker") -- Remove the hook as it's no longer needed
											net.Start("BallHitGround")
											net.WriteVector(ent[k]:GetPos())
											net.WriteEntity(ent[k])
											net.SendToServer()
											--CreateGroundMarker(ent[k]:GetPos()) -- Create a ground marker at the position of the entity
										else
											hook.Add("Think", "BallChecker", BallGroundCheck) -- Add the hook to keep checking
										end
									end 

									-- Start checking if the ball is on the ground
									BallGroundCheck()

								end 
							end 


							MiyaServe()


							hook.Remove("PlayerButtonDown","miya_serve2",function() end)
							MiyaServe()
							TossPower(10)
							if character == "miya" then 
								KageQuickToss(10)
							end 						
						end 
					end 
				end) 
			end 

		else 

		end 


	end)
end 




-- if release_ball_spike == false then 
-- 	if (input.IsButtonDown(MOUSE_LEFT)) then
-- 		release_ball_spike = false
-- 		action_status = "SPIKING"
-- 		-- detect ball when hold button
-- 		local ent =  ents.FindByClass( "prop_physics*" )
-- 		for k, v in pairs( ent ) do    
-- 			physObj = ent[k]:GetPhysicsObject()

			
-- 			if LocalPlayer():GetPos():DistToSqr( ent[k]:GetPos() ) < 115*115 then
-- 				ply:ConCommand("pac_event spike") 
-- 				surface.PlaySound("spike.mp3")
				
-- 				release_ball_spike = true
-- 				if set_power_level_spike == power_level_spike[1] then
-- 					SpikeSendToServer("weak",spikepower,ent[k],ent[k]:GetPos(),allow_spike_assist)

function BokutoSpike(setForce)

	ply = LocalPlayer() 
	powerbar = 0  
	power = 0 
	jumpcount = 0 
	buttonpress = 0 
	local ent =  ents.FindByClass( "prop_physics*" )

	--spikepower = 0 
	--jumpcount = 0 
	buttonpressrec = 0 
	local ply = LocalPlayer() 
	local release_ball_spike = false  

	
	hook.Add( "Tick", "Bokuto_Cut", function()
	
		local ent =  ents.FindByClass( "prop_physics*" )
		local keySettingR,keySettingT 

		if allow_left_assist == false then
			keySettingR = KEY_R
			keySettingT = KEY_T
		else 
			keySettingR = KEY_LBRACKET
			keySettingT = KEY_SEMICOLON
		end


		if !ply:IsOnGround()  then
			if release_ball_spike == false then 
				if (input.IsButtonDown(keySettingR)) then
					local detection_sqr = 115*115
					local ent =  ents.FindByClass( "prop_physics*" )
					for k, v in pairs( ent ) do
						local toBall = ent[k]:GetPos() - ply:EyePos()
						local distOk = toBall:LengthSqr() < detection_sqr

						-- easy mode cone (wide)
						local aimDot = ply:GetAimVector():Dot(toBall:GetNormalized())
						local aimOk = aimDot > 0.4   -- EASY MODE

						if distOk and aimOk then

							ply:ConCommand("pac_event spike") 
							surface.PlaySound("spike.mp3")
							
                            release_ball_spike = true
                            --SpikeSakusaSendToServer("strong",spikepower,ent[k],ent[k]:GetPos(),"left",allow_spike_assist) 
							CutSendToServer("right","power",ent[k])
                            -- Function to check if the entity's physics object is on the ground
                            function IsEntityOnGround(entity)
                                -- Get the position of the entity
                                local posBall = entity:GetPos()
                                
                                -- Trace a line downward to check for ground collision
                                local traceBall = util.TraceLine({
                                    start = posBall,
                                    endpos = posBall - Vector(0, 0, 23), -- Adjust the length based on your needs
                                    mask = MASK_OPAQUE
                                })
                                
                                -- Return true if the trace hits the ground, false otherwise
                                return traceBall.Hit
                            end



                            -- Function to check if the entity's physics object is on the ground and create a ground marker if so
                            function BallGroundCheck() 
                                -- Usage example
                                if IsEntityOnGround(ent[k]) then
                                    hook.Remove("Think", "BallChecker") -- Remove the hook as it's no longer needed
                                    net.Start("BallHitGround")
                                    net.WriteVector(ent[k]:GetPos())
                                    net.WriteEntity(ent[k])
                                    net.SendToServer()
                                    --CreateGroundMarker(ent[k]:GetPos()) -- Create a ground marker at the position of the entity
                                else
                                    hook.Add("Think", "BallChecker", BallGroundCheck) -- Add the hook to keep checking
                                end
                            end 

                            -- Start checking if the ball is on the ground
                            BallGroundCheck()
							
							timer.Simple(1,function() release_ball_spike = false end)
						end	
					end	

				elseif (input.IsButtonDown(keySettingT)) then
					//action_status = ""
                    release_ball_spike = false
					//action_status = "SPIKING"
					-- detect ball when hold button
					local ent =  ents.FindByClass( "prop_physics*" )
					for k, v in pairs( ent ) do
						physObj = ent[k]:GetPhysicsObject()

						
						if LocalPlayer():GetPos():DistToSqr( ent[k]:GetPos() ) < 115*115 then
							ply:ConCommand("pac_event spike") 
							surface.PlaySound("spike.mp3")
                            release_ball_spike = true
							CutSendToServer("left","power",ent[k])
                            -- Function to check if the entity's physics object is on the ground
                            function IsEntityOnGround(entity)
                                -- Get the position of the entity
                                local posBall = entity:GetPos()
                                
                                -- Trace a line downward to check for ground collision
                                local traceBall = util.TraceLine({
                                    start = posBall,
                                    endpos = posBall - Vector(0, 0, 23), -- Adjust the length based on your needs
                                    mask = MASK_OPAQUE
                                })
                                
                                -- Return true if the trace hits the ground, false otherwise
                                return traceBall.Hit
                            end



                            -- Function to check if the entity's physics object is on the ground and create a ground marker if so
                            function BallGroundCheck() 
                                -- Usage example
                                if IsEntityOnGround(ent[k]) then
                                    hook.Remove("Think", "BallChecker") -- Remove the hook as it's no longer needed
                                    net.Start("BallHitGround")
                                    net.WriteVector(ent[k]:GetPos())
                                    net.WriteEntity(ent[k])
                                    net.SendToServer()
                                    --CreateGroundMarker(ent[k]:GetPos()) -- Create a ground marker at the position of the entity
                                else
                                    hook.Add("Think", "BallChecker", BallGroundCheck) -- Add the hook to keep checking
                                end
                            end 

                            -- Start checking if the ball is on the ground
                            BallGroundCheck()
						
							timer.Simple(1,function() release_ball_spike = false end)
						end	
					end	
				end 
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

		local keySettingR,keySettingT 

		if allow_left_assist == false then
			keySettingR = KEY_R
			keySettingT = KEY_T
		else 
			keySettingR = KEY_LBRACKET
			keySettingT = KEY_SEMICOLON
		end


		if button == keySettingR then
			if  ply:GetPos():WithinAABox( miya_pos1, miya_pos2 ) or ply:GetPos():WithinAABox( miya_pos3, miya_pos4)  then 
				--net.Start("check_miya_position")
				--net.SendToServer() 
				chat.AddText(Color(255,0,0),"Wait for 3 seconds to use yamaguchi float serve.")

				hook.Remove("PlayerButtonDown","yama_serve",function(ply,button) end) 
				hook.Remove( "Tick", "KeyDown_Toss", function() end )


				timer.Create("yama_cd",3,1,function() 
					hook.Add("PlayerButtonDown","yama_serve2",function(ply,button)
						if button == keySettingR then
							if  ply:GetPos():WithinAABox( miya_pos1, miya_pos2 ) or ply:GetPos():WithinAABox( miya_pos3, miya_pos4)  then 
								net.Start("yama_ability")
								net.WriteString("tossup")
								net.SendToServer()
							else 
								hook.Remove("PlayerButtonDown","yama_serve2",function() end) 
								YamaguchiServe()
							end 
						end 

						if button == keySettingT then 
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




-- Whenever the player wants to enable jumping (e.g., through a command or other logic):
-- Set jumpDisabled to false
-- Example: jumpDisabled = false




--- receive old mechanic 
-- BASIC 
-- function ReceivePower(setForce)
-- 	ply = LocalPlayer() 
-- 	powerreceivebar = 0  
-- 	powerreceive = 0 
-- 	--jumpcount = 0 
-- 	buttonpressrec = 0 


-- 	hook.Add( "Tick", "KeyDown_Testis", function()

-- 		if (input.IsButtonDown(KEY_V)) then
-- 			buttonpressrec = 1 
-- 			MainFrame2:SetVisible(true)
-- 			powerreceive = powerreceive + 1 
-- 			powerreceivebar = powerreceivebar + 0.04  
-- 			DProgress:SetFraction( powerreceivebar )
-- 			print( "Player is charging receive power! Power: ".. powerreceivebar )

-- 		else 
-- 			if buttonpressrec == 0 then 

-- 			elseif buttonpressrec == 1 then 
-- 				buttonpressrec = 0 
-- 				MainFrame2:SetVisible(false)
-- 				if character == "nishinoya" then 
-- 					if powerreceive < setForce then 
					
-- 						ReceiveSendToServer("weak")
-- 						chat.AddText("Short Receive!")
-- 						powerreceive = 0
-- 						powerreceivebar = 0 
-- 						DProgress:SetFraction( powerreceivebar )  
-- 						print( "reset" )

-- 					elseif powerreceive < 20 then  
-- 						ReceiveSendToServer("strong")
-- 						chat.AddText("Long Receive!")
-- 						powerreceive = 0  
-- 						powerreceivebar = 0 
-- 						DProgress:SetFraction( powerreceivebar ) 
-- 						print( "reset" )
-- 					else 
-- 						ReceiveSendToServer("highball")
-- 						chat.AddText("High ball Receive!")
-- 						powerreceive = 0  
-- 						powerreceivebar = 0 
-- 						DProgress:SetFraction( powerreceivebar ) 
-- 						print( "reset" )
-- 					end   
-- 				else 

-- 					if powerreceive < setForce then 
					
-- 						ReceiveSendToServer("weak")
-- 						chat.AddText("Short Receive!")
-- 						powerreceive = 0
-- 						powerreceivebar = 0 
-- 						DProgress:SetFraction( powerreceivebar )  
-- 						print( "reset" )

-- 					else 
-- 						ReceiveSendToServer("strong")
-- 						chat.AddText("Long Receive!")
-- 						powerreceive = 0  
-- 						powerreceivebar = 0 
-- 						DProgress:SetFraction( powerreceivebar ) 
-- 						print( "reset" )
-- 					end  
-- 				end 

-- 				powerreceive = 0
-- 				powerreceivebar = 0 
-- 				DProgress:SetFraction( powerreceivebar )  
-- 			end 
-- 		end  
-- 	end) 
-- end 



-- Helper function to predict landing spot
local function GetBallLandingPos(ent)
    if not IsValid(ent) then return nil end

    local pos = ent:GetPos()
    local vel = ent:GetVelocity()
    local gravity = Vector(0, 0, -physenv.GetGravity().z) -- Get actual gravity

    -- Simulate flight in small time steps
    local simPos = pos
    local simVel = vel
    local step = 0.05 -- Smaller steps

    for i = 1, 40 do -- Max 2 seconds simulation
        local nextPos = simPos + (simVel * step)
        simVel = simVel + (gravity * step)

        -- Trace to see if it hits the floor
        local tr = util.TraceLine({
            start = simPos,
            endpos = nextPos,
            filter = ent,
            mask = MASK_SOLID
        })

        if tr.Hit then
            return tr.HitPos
        end
        simPos = nextPos
    end

    return simPos -- Return last simulated pos if it hasn't hit yet
end

-- BASIC
function ReceivePower()
    local ply = LocalPlayer()
    local keySetting = allow_left_assist and KEY_APOSTROPHE or KEY_V
    local hasSent = false
    local lastReceiveTime = 0

  	local PERFECT_DIST_SQR = 30*30  -- ~30 units
	local BAD_DIST_SQR     = 70*70  -- ~70 units
	local MAX_DIST_SQR     = 100*100 -- ~100 units max detection

    -- Determine zone text based on distance
    local function GetZoneText(distSqr)
        if distSqr <= PERFECT_DIST_SQR then return "Perfect Receive"
        elseif distSqr <= BAD_DIST_SQR then return "Bad Receive"
        else return "Out of Reach" end
    end

    local function GetSendType()
        if character == "kuro" or character == "kenma" then
            return string.lower(set_power_level_receive_special)
        else
            return string.lower(set_power_level_receive)
        end
    end

    hook.Add("Tick", "ReceivePower_HoldDetect", function()
        if not IsValid(ply) then return end
        local holding = input.IsButtonDown(keySetting)

        if holding and ply:IsOnGround() then
            local closestEnt
            local closestDistSqr = MAX_DIST_SQR

            -- Find closest ball based on current position
            for _, ent in ipairs(ents.FindByClass("prop_physics*")) do
                if IsValid(ent) then
                    local distSqr = ply:GetPos():DistToSqr(ent:GetPos())

                    if distSqr < closestDistSqr then
                        closestDistSqr = distSqr
                        closestEnt = ent
                    end
                end
            end

            if IsValid(closestEnt) and closestDistSqr <= MAX_DIST_SQR then
                local zoneText = GetZoneText(closestDistSqr)
                if ply:Crouching() then
                    zoneText = "Perfect Receive"
                end
                action_status = zoneText

                -- Send to server once when detected within range and cooldown passed
                if not hasSent and CurTime() - lastReceiveTime > 0.5 then
                    local sendType = GetSendType()
                    ReceiveSendToServer(sendType, closestEnt, false, zoneText)

                    -- PERFECT feedback
                    if zoneText == "Perfect Receive" then
                        surface.PlaySound("perfect.mp3")
                        perfectReceiveStartTime = CurTime()
                    end

                    hasSent = true
				end
                -- Optional: visual feedback for current position
                debugoverlay.Sphere(closestEnt:GetPos(), 10, 0.1, zoneText == "Perfect Receive" and Color(0,255,0) or Color(255,200,0), true)
            else
                action_status = ""
                hasSent = false
            end
        else
            action_status = ""
            hasSent = false
        end
    end)
end



-- Internal state for TossPower HUD
local TossPowerState = {
    holding = false,
    power = 0
}

--------------------------------------------------
-- HUD VISUAL (LOW / MID / HIGH) for TossPower
--------------------------------------------------
hook.Add("HUDPaint", "TossPowerHUD", function()
    if not TossPowerState.holding then return end
    if TOSS_SET_FORCE <= 0 then return end

    local w, h = 320, 36
    local x = ScrW() / 2 - w / 2
    local y = ScrH() * 0.65

    -- Background
    draw.RoundedBox(10, x, y, w, h, Color(20, 20, 20, 220))

    -- Fill %
    local pct = math.Clamp(TossPowerState.power / 20, 0, 1)
    local fillW = w * pct

    local col = Color(120, 200, 255)
    local label = "LOW POWER"

    if TossPowerState.power >= TOSS_SET_FORCE then
        col = Color(120, 255, 120)
        label = "MID POWER"
    end
    if TossPowerState.power >= 20 then
        col = Color(255, 120, 120)
        label = "HIGH POWER"
    end

    draw.RoundedBox(10, x + 4, y + 4, fillW - 8, h - 8, col)

    draw.SimpleText(
        label,
        "Trebuchet24",
        x + w / 2,
        y + h / 2,
        color_white,
        TEXT_ALIGN_CENTER,
        TEXT_ALIGN_CENTER
    )
end)

function TossPower(setForce)
	TOSS_SET_FORCE = setForce or 0

	if TOSS_SET_FORCE <= 0 then return end

	ply = LocalPlayer()
	powertossbar = 0
	powertoss = 0
	--jumpcount = 0
	buttonpresstoss = 0



	hook.Add( "Tick", "KeyDown_Toss", function()
		if not actionMode.block then return end

		local keySetting = MOUSE_LEFT

		if (input.IsButtonDown(keySetting)) then
			buttonpresstoss = 1
			powertoss = powertoss + 1

			-- HUD STATE
			TossPowerState.holding = true
			TossPowerState.power = powertoss

		else
			if buttonpresstoss == 1 then
				buttonpresstoss = 0
				TossPowerState.holding = false

				if powertoss <= TOSS_SET_FORCE then

					TossSendToServer("weak","front")
					powertoss = 0
					print( "reset" )

				elseif powertoss < 20 then
					TossSendToServer("medium","front")
					powertoss = 0
					print( "reset" )

				else
					TossSendToServer("high","front")
					powertoss = 0
					print( "reset" )
				end
				powertoss = 0

				TossPowerState.power = 0
			end
		end
	end)
end



-- Internal state for BackTossPower HUD
local BackTossPowerState = {
    holding = false,
    power = 0
}

--------------------------------------------------
-- HUD VISUAL (LOW / MID / HIGH) for BackTossPower
--------------------------------------------------
hook.Add("HUDPaint", "BackTossPowerHUD", function()
    if not BackTossPowerState.holding then return end
    if BACK_TOSS_SET_FORCE <= 0 then return end

    local w, h = 320, 36
    local x = ScrW() / 2 - w / 2
    local y = ScrH() * 0.65

    -- Background
    draw.RoundedBox(10, x, y, w, h, Color(20, 20, 20, 220))

    -- Fill %
    local pct = math.Clamp(BackTossPowerState.power / 20, 0, 1)
    local fillW = w * pct

    local col = Color(120, 200, 255)
    local label = "LOW POWER"

    if BackTossPowerState.power >= BACK_TOSS_SET_FORCE then
        col = Color(120, 255, 120)
        label = "MID POWER"
    end
    if BackTossPowerState.power >= 20 then
        col = Color(255, 120, 120)
        label = "HIGH POWER"
    end

   draw.RoundedBox(10, x + 4, y + 4, fillW - 8, h - 8, col)

    draw.SimpleText(
        label,
        "Trebuchet24",
        x + w / 2,
        y + h / 2,
        color_white,
        TEXT_ALIGN_CENTER,
        TEXT_ALIGN_CENTER
    )
end)

function BackTossPower(setForce)
	BACK_TOSS_SET_FORCE = setForce or 0

	if BACK_TOSS_SET_FORCE <= 0 then return end

	powertossbar2 = 0
	powertoss2 = 0
	--jumpcount = 0
	buttonpresstoss2 = 0

	hook.Add( "Tick", "KeyDown_Toss2", function()
		local keySetting
		if allow_left_assist == false then
			keySetting = KEY_F
		else
			keySetting = KEY_RBRACKET
		end


		if (input.IsButtonDown(keySetting)) then
			buttonpresstoss2 = 1
			powertoss2 = powertoss2 + 1

			-- HUD STATE
			BackTossPowerState.holding = true
			BackTossPowerState.power = powertoss2

		else
			if buttonpresstoss2 == 0 then

			elseif buttonpresstoss2 == 1 then
				buttonpresstoss2 = 0
				BackTossPowerState.holding = false

				if powertoss2 <= BACK_TOSS_SET_FORCE then

					TossSendToServer("weak","back")
					powertoss2 = 0
					print( "reset" )

				elseif powertoss2 < 20 then
					TossSendToServer("medium","back")
					powertoss2 = 0
					print( "reset" )

				else
					TossSendToServer("high","back")
					powertoss2 = 0
					print( "reset" )
				end
				powertoss2 = 0

				BackTossPowerState.power = 0
			end
		end
	end)
end




default_block = false 
blocking = false  
local isBlocking = false

function BlockSystem() 
	hook.Add("PlayerButtonDown","KeyDown_Block",function(ply,button)	

		local keySetting 
		if allow_left_assist == false then
			keySetting = KEY_Q
		else 
			keySetting = KEY_P
		end
		
		if button == keySetting then
			
			if blocking == true then
			
			else 
				ply:ConCommand("pac_event block")
				blocking = true  
				timer.Simple(1,function() blocking = false end)

				default_block = true 
			
				print("char:"..character)
			
				ply:ConCommand("pac_event block") 
				if !ply:IsOnGround() and isBlocking == false then 
					if ply:GetPos():WithinAABox( pos1, pos2 ) then
						isBlocking = true 
						net.Start("create_wall")
						net.WriteString("left")
						net.WriteString("default")
						net.WriteString(character)
						net.WriteBool(default_block)
						net.SendToServer() 
						timer.Simple(1,function() isBlocking = false end)
					elseif ply:GetPos():WithinAABox( pos3, pos4 ) then 
						isBlocking = true 
						net.Start("create_wall")
						net.WriteString("right")
						net.WriteString("default")
						net.WriteString(character)
						net.WriteBool(default_block)
						net.SendToServer() 
						timer.Simple(1,function() isBlocking = false end)
					end 
				end 
			end 
		end 
	
		if character == "kuro" then 
			if !actionMode.block then return end 
			if button == KEY_R then  // when kuro lean left
				if !ply:IsOnGround() and isBlocking == false then
					isBlocking = true 
					ply:ConCommand("pac_event blockleft")
					net.Start("create_wall")
					net.WriteString("left")
					net.WriteString("block_left")
					net.WriteString("kuro")
					net.WriteBool(default_block)
					net.SendToServer() 
					timer.Simple(1,function() isBlocking = false end)
				end 
			elseif button == KEY_T then // when kuro lean right
				if !ply:IsOnGround() and isBlocking == false then
					isBlocking = true 
					ply:ConCommand("pac_event blockright")
					net.Start("create_wall")
					net.WriteString("right")
					net.WriteString("block_right")
					net.WriteString("kuro")
					net.WriteBool(default_block)
					net.SendToServer() 
					timer.Simple(1,function() isBlocking = false end)
				end 
			end 
		end 
	end)
end 	

-- =========================
-- KURO LEAN BLOCKS (AIR ONLY)
-- =========================
hook.Add("PlayerButtonDown", "KuroLeanBlock", function(ply, button)
    if character ~= "kuro" then return end
    if not actionMode.block then return end
    if ply:IsOnGround() then return end
    if isBlocking then return end

    if button == KEY_R then
        isBlocking = true
        default_block = false

        ply:ConCommand("pac_event blockleft")

        net.Start("create_wall")
        net.WriteString("left")
        net.WriteString("block_left")
        net.WriteString("kuro")
        net.WriteBool(default_block)
        net.SendToServer()

    elseif button == KEY_T then
        isBlocking = true
        default_block = false

        ply:ConCommand("pac_event blockright")

        net.Start("create_wall")
        net.WriteString("right")
        net.WriteString("block_right")
        net.WriteString("kuro")
        net.WriteBool(default_block)
        net.SendToServer()
    end

    timer.Simple(1, function()
        isBlocking = false
    end)
end)

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

activateJumpBoost = false  
activateNoJumpBoost = false 

-- function KoraiJumpBoost()
-- 	print("Korai Jump Boost activated")
-- 	isRunning = false
-- 	timerName = "RunTimer"
	
-- 	if character == "korai" then 
-- 		hook.Add("Think", "LocalPlayerRunDetection", function()
-- 			local ply = LocalPlayer()
-- 			if IsValid(ply) and ply:Alive() and ply:IsOnGround() then
-- 				velocity = ply:GetVelocity():Length2D() -- Get the 2D velocity length (ignoring vertical component)
-- 				runSpeed = ply:GetRunSpeed()
		
-- 				if velocity > runSpeed * 0.8 then -- You can adjust the threshold as needed
-- 					-- Player is running
-- 					if not isRunning then
-- 						isRunning = true
-- 						timer.Create(timerName, 0.5, 1, function()
-- 							action_status = "JUMP BOOST ACQUIRED!"
-- 							activateJumpBoost = true 

-- 							if activateJumpBoost then 
								
-- 								net.Start("hoshiumi_jump")
-- 								net.WriteString("boost")
-- 								net.WriteString("im korai")
-- 								net.SendToServer()

-- 								hook.Add("PlayerButtonDown","koraiJump",function(ply,button) 
-- 									if button == KEY_SPACE then 
-- 										local randomSoundKoraiJump = {"korai/highjump1.wav","korai/highjump2.wav"} 
-- 										hook.Remove("PlayerButtonDown","koraiJump",function(ply,button) end)
-- 										surface.PlaySound(table.Random(randomSoundKoraiJump), 80, 100, 1, CHAN_AUTO )
-- 									end 
-- 								end)

								
-- 								timer.Simple(0.5,function() activateJumpBoost = false end)
-- 							end
-- 						end)
-- 					end
-- 				else
-- 					-- Player is not running
-- 					if isRunning then
-- 						isRunning = false
-- 						timer.Remove(timerName)
-- 						action_status = ""
-- 						if activateNoJumpBoost == false then 
-- 							activateNoJumpBoost = true  
-- 							net.Start("hoshiumi_jump")
-- 							net.WriteString("noboost")
-- 							net.SendToServer()

-- 							timer.Simple(1,function() activateNoJumpBoost = false end)
-- 						end 
-- 					end
-- 				end
-- 			end
-- 		end)
-- 	else 
-- 		hook.Remove("Think", "LocalPlayerRunDetection", function() end) 
-- 	end 
-- end 


//Jump system
-- disable jump 


function SpikeApproachAnimation()
    local ply = LocalPlayer()
    local realDelay = 0.7
    local ping = ply:Ping() / 1000
    adjustedDelay = math.max(0.05, realDelay - ping)
    
    -- Remove any previous jump hooks
    hook.Remove("PlayerButtonDown", "BlockJumpSystem")
    hook.Remove("PlayerButtonDown", "SpikeJumpSystem")
    
    hook.Add("PlayerButtonDown", "SpikeJumpSystem", function(ply2, button)
		if ply2 ~= LocalPlayer() then return end
		if button ~= KEY_SPACE or not ply2:IsOnGround() or isJumping then return end

		isJumping = true
		chargeStartTime = CurTime()

		-- Tell server jump is starting
		net.Start("JumpApproachStart")
		net.SendToServer()

		if not isApproachAnimation then
			isApproachAnimation = true
			ply2:ConCommand("pac_event approach") 
			timer.Simple(2, function()
				if IsValid(ply2) then isApproachAnimation = false end
			end)
		end

		timer.Simple(adjustedDelay, function()
			if not IsValid(ply2) then return end
			if character == "korai" then 
				local fx = EffectData()
				fx:SetOrigin(ply:GetPos())
				fx:SetScale(500)
				util.Effect("ThumperDust", fx)
			end 
			ply2:ConCommand("pac_event jump")
			net.Start("addVelocity")
			net.WriteString(character)
			net.WriteInt(jumpPower, 32)
			net.SendToServer()

			-- Tell server jump finished
			net.Start("JumpApproachEnd")
			net.SendToServer()

			isJumping = false
		end)
	end)
end

function BlockApproachAnimation()
    local ply = LocalPlayer()
    local realDelay = 0.3
    local ping = ply:Ping() / 1000
    adjustedDelay = math.max(0.05, realDelay - ping)
    
    -- Remove any previous jump hooks
    hook.Remove("PlayerButtonDown", "SpikeJumpSystem")
    hook.Remove("PlayerButtonDown", "BlockJumpSystem")
    
    -- Add block jump hook
   hook.Add("PlayerButtonDown", "BlockJumpSystem", function(ply2, button)
    if ply2 ~= LocalPlayer() then return end
    if button ~= KEY_SPACE or not ply2:IsOnGround() or isJumping then return end

    isJumping = true
    chargeStartTime = CurTime()

    -- Tell server jump is starting
    net.Start("JumpApproachStart")
    net.SendToServer()

    if not isApproachAnimation then
        isApproachAnimation = true
        ply2:ConCommand("pac_event approach2")
        timer.Simple(1, function()
            if IsValid(ply2) then isApproachAnimation = false end
        end)
    end

    timer.Simple(adjustedDelay, function()
        if not IsValid(ply2) then return end
        ply2:ConCommand("pac_event jump2")
        net.Start("addVelocity")
		net.WriteString(character)
        net.WriteInt(jumpPower, 32)
        net.SendToServer()

        -- Tell server jump finished
        net.Start("JumpApproachEnd")
        net.SendToServer()

        isJumping = false
    end)
end)

end


-- HUD Paint: draw charging bar + text
hook.Add("HUDPaint", "JumpChargeHUD", function()
    if not isJumping then return end

    local elapsed = CurTime() - chargeStartTime
    local fraction = math.Clamp(elapsed / adjustedDelay, 0, 1)

    local w, h = 250, 20
    local x, y = ScrW() / 2 - w / 2, ScrH() - 120

    -- Background bar
    draw.RoundedBox(4, x, y, w, h, Color(50, 50, 50, 180))
    -- Fill bar
    draw.RoundedBox(4, x, y, w * fraction, h, Color(0, 150, 255, 220))
    -- Border
    surface.SetDrawColor(255, 255, 255, 200)
    surface.DrawOutlinedRect(x, y, w, h)

    -- Text above the bar
    draw.SimpleText(
        "Approaching..",
        "Trebuchet24", -- font
        ScrW() / 2, y - 25, -- centered above bar
        Color(255, 255, 255, 255),
        TEXT_ALIGN_CENTER,
        TEXT_ALIGN_CENTER
    )
end)



-- Trigger inside ReceivePower() when zoneText == "Perfect Receive"
-- perfectReceiveStartTime = CurTime()

hook.Add("HUDPaint", "PerfectReceiveHUD", function()
    if not perfectReceiveStartTime then return end

    local duration = 1.2 -- seconds
    local elapsed = CurTime() - perfectReceiveStartTime
    if elapsed > duration then
        perfectReceiveStartTime = nil
        return
    end

    -- Fade alpha
    local alpha = 255
    if elapsed > duration * 0.7 then
        alpha = 255 * (1 - (elapsed - duration*0.7)/(duration*0.3))
    end

    -- Draw the image
    local mat = Material("hud/pass.png") -- make sure this exists
    surface.SetMaterial(mat)
    surface.SetDrawColor(255, 255, 255, alpha)
    local w, h = 150, 150
    surface.DrawTexturedRect((ScrW()-w)/2, 80, w, h)

    -- Big bold text with outline
    local text = "PERFECT!"
    local font = "Trebuchet24"

    -- Shadow/outline
    for dx=-2,2 do
        for dy=-2,2 do
            if dx ~= 0 or dy ~= 0 then
                draw.SimpleText(text, font, ScrW()/2 + dx, 250 + dy, Color(0,0,0,alpha), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
            end
        end
    end

    -- Main text
    draw.SimpleText(text, font, ScrW()/2, 250, Color(0,255,100,alpha), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
end)

-- Action mode switch notification HUD
hook.Add("HUDPaint", "ActionModeSwitchNotification", function()
    if not actionModeNotification.show then return end

    local elapsed = CurTime() - actionModeNotification.startTime
    if elapsed > actionModeNotification.duration then
        actionModeNotification.show = false
        return
    end

    -- Fade out effect
    local alpha = 255
    if elapsed > actionModeNotification.duration * 0.7 then
        alpha = 255 * (1 - (elapsed - actionModeNotification.duration * 0.7) / (actionModeNotification.duration * 0.3))
    end

    -- Position at top center
    local x, y = ScrW() / 2, ScrH() * 0.15
    local font = "ActionModeNotificationFont"

    -- Draw shadow/outline
    for dx = -3, 3 do
        for dy = -3, 3 do
            if dx ~= 0 or dy ~= 0 then
                draw.SimpleText(actionModeNotification.text, font, x + dx, y + dy, Color(0, 0, 0, alpha), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
            end
        end
    end

    -- Draw main text
    draw.SimpleText(actionModeNotification.text, font, x, y, Color(actionModeNotification.color.r, actionModeNotification.color.g, actionModeNotification.color.b, alpha), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
end)

-- Player aim prediction HUD after spike
hook.Add("HUDPaint", "PlayerAimPredictionHUD", function()
    -- Check if ball prediction is enabled in settings (keeping same setting name)
    if not allow_ball_prediction then return end

    -- Draw local player aim prediction
    if playerAimPrediction.active then
        -- Check if prediction should still be active
        local elapsed = CurTime() - playerAimPrediction.startTime
        if elapsed > playerAimPrediction.duration then
            playerAimPrediction.active = false
        else
            -- Calculate fade alpha
            local alpha = 255
            if elapsed > playerAimPrediction.duration * 0.7 then
                alpha = 255 * (1 - (elapsed - playerAimPrediction.duration * 0.7) / (playerAimPrediction.duration * 0.3))
            end

            -- Draw aim line from player eye position in eye direction, traced to hit point
            local startPos = playerAimPrediction.playerPos
            local aimDir = playerAimPrediction.playerAng:Forward()

            -- Trace line of sight
            local trace = util.TraceLine({
                start = startPos,
                endpos = startPos + aimDir * 1000, -- Long trace
                filter = LocalPlayer(),
                mask = MASK_SOLID
            })

            local endPos = trace.HitPos

            -- Convert to screen positions
            local startScreen = startPos:ToScreen()
            local endScreen = endPos:ToScreen()

            if startScreen.visible or endScreen.visible then
                -- Draw aim line (orange)
                surface.SetDrawColor(255, 165, 0, alpha)
                surface.DrawLine(startScreen.x, startScreen.y, endScreen.x, endScreen.y)

                -- Draw small circle at end of aim line
                local color = Color(255, 165, 0)
                local radius = 8
                local x, y = endScreen.x, endScreen.y

                -- Draw outer glow
                for i = 1, 2 do
                    draw.RoundedBox(radius + i * 1, x - (radius + i * 1) / 2, y - (radius + i * 1) / 2, radius + i * 2, radius + i * 2, Color(color.r, color.g, color.b, alpha * 0.4 / i))
                end

                -- Draw main circle
                draw.RoundedBox(radius, x - radius / 2, y - radius / 2, radius, radius, Color(color.r, color.g, color.b, alpha))

                -- Draw center dot
                draw.RoundedBox(2, x - 1, y - 1, 2, 2, Color(255, 255, 255, alpha))
            end
        end
    end

    -- Draw global player aim predictions from other players
    for playerName, prediction in pairs(globalPlayerAims) do
        if prediction.active then
            -- Check if prediction should still be active
            local elapsed = CurTime() - prediction.startTime
            if elapsed > prediction.duration then
                globalPlayerAims[playerName] = nil
            else
                -- Calculate fade alpha
                local alpha = 255
                if elapsed > prediction.duration * 0.7 then
                    alpha = 255 * (1 - (elapsed - prediction.duration * 0.7) / (prediction.duration * 0.3))
                end

                -- Draw aim line from player eye position in eye direction, traced to hit point
                local startPos = prediction.playerPos
                local aimDir = prediction.playerAng:Forward()

                -- Trace line of sight
                local trace = util.TraceLine({
                    start = startPos,
                    endpos = startPos + aimDir * 1000, -- Long trace
                    filter = LocalPlayer(),
                    mask = MASK_SOLID
                })

                local endPos = trace.HitPos

                -- Convert to screen positions
                local startScreen = startPos:ToScreen()
                local endScreen = endPos:ToScreen()

                if startScreen.visible or endScreen.visible then
                    -- Draw aim line (orange, slightly more transparent for global)
                    surface.SetDrawColor(255, 165, 0, alpha * 0.8)
                    surface.DrawLine(startScreen.x, startScreen.y, endScreen.x, endScreen.y)

                    -- Draw small circle at end of aim line
                    local color = Color(255, 165, 0)
                    local radius = 6 -- Smaller for global predictions
                    local x, y = endScreen.x, endScreen.y

                    -- Draw outer glow
                    for i = 1, 2 do
                        draw.RoundedBox(radius + i * 1, x - (radius + i * 1) / 2, y - (radius + i * 1) / 2, radius + i * 2, radius + i * 2, Color(color.r, color.g, color.b, alpha * 0.3 / i))
                    end

                    -- Draw main circle
                    draw.RoundedBox(radius, x - radius / 2, y - radius / 2, radius, radius, Color(color.r, color.g, color.b, alpha))

                    -- Draw center dot
                    draw.RoundedBox(1.5, x - 0.75, y - 0.75, 1.5, 1.5, Color(255, 255, 255, alpha))
                end
            end
        end
    end
end)

//ball mark  <-- reference
hook.Add("HUDPaint", "GroundHitNotification", function()
    if not allow_in_out_system or not groundHitTimer or isBallIn == nil then return end

    local elapsed = CurTime() - (groundHitTimer - 3.5)

    if elapsed < 0.7 then
        local time = math.floor(elapsed * 10) / 10
        draw.SimpleText(tostring(time), "Trebuchet24",
            ScrW()/2, ScrH()*0.1,
            Color(255,255,0),
            TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP
        )
        return
    end

    if elapsed < 3.5 then
        local groundText  = isBallIn and "IN" or "OUT"
        local groundColor = isBallIn and Color(0,255,0) or Color(255,0,0)

        local mat = Material("referee.png")
        surface.SetMaterial(mat)
        surface.SetDrawColor(255,255,255,255)

        local imgW, imgH = 128, 128
        local y = ScrH() * 0.1 - imgH / 2

        surface.DrawTexturedRect(
            ScrW()/2 - imgW - 10,
            y,
            imgW,
            imgH
        )

        draw.SimpleText(
            groundText,
            "Trebuchet24",
            ScrW()/2 + 10,
            ScrH()*0.1,
            groundColor,
            TEXT_ALIGN_LEFT,
            TEXT_ALIGN_TOP
        )
    end
end)


-- Initialize spike mode functions
timer.Simple(3,function()
	SpikeApproachAnimation()
end)


hook.Add("PlayerButtonDown", "GetAimPosOnC", function(ply, button)
    if ply ~= LocalPlayer() then return end
    if button ~= KEY_C then return end

    local tr = util.TraceLine({
        start  = ply:EyePos(),
        endpos = ply:EyePos() + ply:EyeAngles():Forward() * 10000,
        filter = ply
    })

    print("Aim world position:", tr.HitPos)
end)

//first pos  1199.963135 -32.057045 -55.968750
// second pos 800.388855 671.806091 -55.968750









-------- Nak check postiion player -----------

-- local function IsInside( pos, ent )
-- 	if ( not IsValid( ent ) ) then return false end

-- 	local vmin = ent:OBBMins()
-- 	local vmax = ent:OBBMaxs()
-- 	local vpos = ent:WorldToLocal( pos )



-- 	return vpos:WithinAABox( vmax, vmin )
-- end

 
-- hook.Add("PlayerButtonDown","checkPosition",function(ply,button)
-- 	if button == KEY_P then
		
-- 		hook.Add("PostDrawTranslucentRenderables", "TestPlayerInBox", function()
-- 			// Check if the player is inside the box
-- 			local col = Color(255, 0, 0)
-- 			// Draw the box
-- 			render.DrawWireframeBox(Vector(0,0,0), Angle(0,0,0), pos1, pos2, col, true)
-- 			render.DrawWireframeBox(Vector(0,0,0), Angle(0,0,0), pos3, pos4, col, true)
-- 		end) 


-- 	end 
-- end)

-- Client-side script to detect the "R" key press and notify the server

-- hook.Add("Think", "DetectRKeyPress", function()
--     if input.IsKeyDown(KEY_R) then
--         -- Prevent multiple triggers by checking if the key was previously down
--         if not LocalPlayer().keyRWasDown then
--             LocalPlayer().keyRWasDown = true
--             -- Send a net message to the server
--             net.Start("PlayerJumpRequest")
--             net.SendToServer()
--         end
--     else
--         LocalPlayer().keyRWasDown = false
--     end
-- end)
-- end)
