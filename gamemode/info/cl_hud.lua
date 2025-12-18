
-- Custom font for the UI
surface.CreateFont("ActionModeFont", {
    font = "Trebuchet MS",
    size = 20,
    weight = 600,
    antialias = true,
})

-- Larger font for icons
surface.CreateFont("IconFont", {
    font = "Trebuchet MS",
    size = 24,
    weight = 700,
    antialias = true,
    outline = false

})

-- Serve area vectors
miya_pos1 = Vector(1300.494019, -261.572266, -119.701813)
miya_pos2 = Vector(670.607239, -30.208231, 199.167160)
miya_pos3 = Vector(676.425293, 888.083191, -108.272842)
miya_pos4 = Vector(1375.196899, 661.645447, 262.988831)

-- Court positions
pos1 = Vector(1419.853394, 1000.308411, -165.108414)
pos2 = Vector(602.493164, 319.357361, 398.086914)
pos3 = Vector(pos1.x, -pos1.y, pos1.z)
pos4 = Vector(pos2.x,319.357361, pos2.z)

local control_panel_open = true

local MainFrame = vgui.Create("DFrame")
MainFrame:SetSize(ScrW()/4, ScrH() * 0.8)
MainFrame:SetPos(ScrW() * 0.75, ScrH()/14.4)
MainFrame:SetTitle("Help & Controls (Press F3 to hide)")
MainFrame:SetVisible(true)
MainFrame:SetBackgroundBlur( true )
MainFrame:ShowCloseButton(false)
MainFrame.Paint = function( self, w, h )
    draw.RoundedBox(8, 0, 0, w, h, Color(25,25,35,200))
end

local scroll = vgui.Create("DScrollPanel", MainFrame)
scroll:Dock(FILL)

-- Rules section
local rulesHeader = vgui.Create("DLabel", scroll)
rulesHeader:Dock(TOP)
rulesHeader:SetText("Gameplay Mechanics")
rulesHeader:SetFont("Trebuchet24")
rulesHeader:SetTextColor(Color(255,255,0))
rulesHeader:SizeToContents()
rulesHeader:DockMargin(10, 10, 10, 5)

-- Rules list for easy addition
local rules = {
    "1. PERFECT RECEIVE depends on timing and distance — the closer you are to the ball, the higher the success rate.",
    "2. PERFECT RECEIVE is 100% guaranteed while crouching.",
    "3. SERVE is only allowed from the service area — right-click to serve when inside the zone.",
    "4. ACTION MODE: SPIKE allows the player to spike the ball while airborne, but disables BLOCK and SET.",
    "5. ACTION MODE: BLOCK allows the player to block while airborne and enables SET.",
    "6. ACTION MODE: Can't be switched while airborne or approaching",
}

for _, ruleText in ipairs(rules) do
    local ruleLabel = vgui.Create("DLabel", scroll)
    ruleLabel:Dock(TOP)
    ruleLabel:SetText(ruleText)
    ruleLabel:SetFont("CenterPrintText")
    ruleLabel:SetTextColor(Color(255,255,255))
    ruleLabel:SetWrap(true)
    ruleLabel:SetAutoStretchVertical(true)
    ruleLabel:DockMargin(10, 5, 10, 10)
end

-- Features & Controls section
local controlsHeader = vgui.Create("DLabel", scroll)
controlsHeader:Dock(TOP)
controlsHeader:SetText("Features & Controls")
controlsHeader:SetFont("Trebuchet24")
controlsHeader:SetTextColor(Color(255,255,0))
controlsHeader:SizeToContents()
controlsHeader:DockMargin(10, 10, 10, 5)

-- Controls
-- Controls
local controls = {
    -- Basic Movement / Jump
    "[SPACEBAR] - Jump",

    -- Ball Interaction
    "[E] - Pickup ball",
    "[KEY_V (hold)] - Receive (On Ground)",
    "[MOUSE_LEFT (hold)] - Spike [ACTION SPIKE] / Set [ACTION BLOCK]",
    "[MOUSE_RIGHT (Behind serve line)] - Basic Serve",

    -- Power & Action Modes
    "[KEY_1] - Set Spike Power",
    "[KEY_2] - Set Receive Power",
    "[KEY_3] - Set Shoot Toss: FRONT / BACK",
    "[KEY_4] - Set Action Mode: BLOCK / SET",

    -- Character / Team
    "[F1] - Character Controls",
    "[KEY_M] - Change Character / Switch Team",

    -- Communication / Emotes
    "[KEY_K / KEY_L] - Taunt / Cheer",
    "[KEY_B] - Communication (After joining a team)",

    -- Game Settings
    "[KEY_N] - Game Settings",
}


for _, text in ipairs(controls) do
    local lbl = vgui.Create("DLabel", scroll)
    lbl:Dock(TOP)
    lbl:SetText(text)
    lbl:SetFont("CenterPrintText")
    lbl:SetTextColor(Color(255,255,255))
    lbl:DockMargin(10, 5, 10, 0)
end

hook.Add("PlayerButtonDown", "Hide Control Panel", function(ply, button)
    if button == KEY_F3 then
        -- Check if enough time has passed since the last action
        if not control_panel_cooldown or control_panel_cooldown < CurTime() then
            -- Toggle the control panel state
            control_panel_open = not control_panel_open

            -- Set the visibility of the MainFrame accordingly
            MainFrame:SetVisible(control_panel_open)

            -- Set the cooldown time (1 second delay before next action can be triggered)
            control_panel_cooldown = CurTime() + 0.5
        end
    end
end)


power_level_receive_special = {"Weak","Strong","Ultra"}
power_level_receive = {"Weak","Strong"}
power_level_spike = {"Weak","Strong"}
power_level_toss = {"Front","Back"}

set_power_level_receive_special = power_level_receive_special[1] -- Default power level for "Receive SPECIAL" mode
set_power_level_receive = power_level_receive[1] -- Default power level for "Receive" mode
set_power_level_spike = power_level_spike[1] -- Default power level for "Spike" mode
set_power_level_toss = power_level_toss[1] -- Default power level for "Spike" mode

-- Bottom-left HUD: Receive + Spike (Manage Power)
hook.Add("HUDPaint", "ManagePowerBottomLeftUI", function()
    local ply = LocalPlayer()
    if not IsValid(ply) then return end

    local w, h = 220, 90
    local padding = 10
    local x, y = 30, ScrH() - h - 30

    draw.RoundedBox(8, x+3, y+3, w, h, Color(0,0,0,120))
    draw.RoundedBox(8, x, y, w, h, Color(40,40,40,220))

    draw.SimpleText("Manage Power", "ActionModeFont", x + w/2, y + 10, Color(255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)

    local barHeight = 20
    local barPadding = 12

    -- RECEIVE / RECEIVE SPECIAL
    local receiveText = (character == "kuro" or character == "kenma") and set_power_level_receive_special or set_power_level_receive
    local receiveColor
    if receiveText == "Weak" then receiveColor = Color(255, 187, 0)
    elseif receiveText == "Strong" then receiveColor = Color(248,37,0)
    elseif receiveText == "Ultra" then receiveColor = Color(197,0,0) end

    draw.RoundedBox(6, x + 15, y + 35, w - 30, barHeight, Color(50,50,50,180))
    draw.RoundedBox(6, x + 15, y + 35, w - 30, barHeight, receiveColor)
    draw.SimpleText("Receive: "..receiveText.." [KEY_2]", "ActionModeFont", x + w/2, y + 45, Color(255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

    -- SPIKE
    local spikeColor = (set_power_level_spike == "Weak") and Color(255, 187, 0) or Color(255,54,54)
    draw.RoundedBox(6, x + 15, y + 35 + barHeight + barPadding, w - 30, barHeight, Color(50,50,50,180))
    draw.RoundedBox(6, x + 15, y + 35 + barHeight + barPadding, w - 30, barHeight, spikeColor)
    draw.SimpleText("Spike: "..set_power_level_spike.." [KEY_1]", "ActionModeFont", x + w/2, y + 45 + barHeight + barPadding, Color(255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
end)

-- Top of Action Mode HUD: Shoot Toss
hook.Add("HUDPaint", "ManageTossAboveActionModeUI", function()
    local ply = LocalPlayer()
    if not IsValid(ply) then return end
    if not (character == "kageyama" or character == "miya" or character == "kenma") then return end

    local actionModeW, actionModeH = 150, 60
    local padding = 10
    local x, y = ScrW() - actionModeW - 30, ScrH() - actionModeH*2 - 30 - padding

    draw.RoundedBox(8, x+2, y+2, actionModeW, actionModeH, Color(0,0,0,150))
    draw.RoundedBox(8, x, y, actionModeW, actionModeH, Color(40,40,40,220))

    draw.SimpleText("Shoot Toss", "ActionModeFont", x + actionModeW/2, y + 8, Color(255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)

    local tossColor = (set_power_level_toss == "Front") and Color(255, 187, 0) or Color(255,54,54)
    draw.RoundedBox(6, x + 10, y + 25, actionModeW - 20, 20, Color(50,50,50,180))
    draw.RoundedBox(6, x + 10, y + 25, actionModeW - 20, 20, tossColor)
    draw.SimpleText(set_power_level_toss:upper().." [KEY_3]", "ActionModeFont", x + actionModeW/2, y + 35, Color(255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
end)





--// Controls to set mode and power //---
-- Variables to track button presses and the time of the last press
local modeButtonPressed = false
local powerButtonPressed = false
local tossButtonPressed = false
local lastModePressTime = 0
local lastPowerPressTime = 0
local lastTossPressTime = 0
local pressDelay = 0.2  -- Adjust this value as needed

hook.Add("PlayerButtonDown", "setMode", function(ply, button)
    -- Check if the mode button is already pressed or if not enough time has passed since the last press
    if button ~= KEY_2 or CurTime() - lastModePressTime < pressDelay then
        return
    end
    
    -- Update the time of the last press
    lastModePressTime = CurTime()

    if character == "kuro" or character == "kenma" then 
        if set_power_level_receive_special == power_level_receive_special[1] then
            set_power_level_receive_special = power_level_receive_special[2]  -- set high 
            print("power level (Receive): "..set_power_level_receive)
        elseif set_power_level_receive_special == power_level_receive_special[2] then  -- if high
            set_power_level_receive_special = power_level_receive_special[3] -- set low
            print("power level (Receive): "..set_power_level_receive)
        elseif set_power_level_receive_special == power_level_receive_special[3] then  -- if high
            set_power_level_receive_special = power_level_receive_special[1] -- set low
            print("power level (Receive): "..set_power_level_receive)
        end 
    else
        if set_power_level_receive == power_level_receive[1] then -- if low
            set_power_level_receive = power_level_receive[2]  -- set high 
            print("power level (Receive): "..set_power_level_receive)
        elseif set_power_level_receive == power_level_receive[2] then  -- if high
            set_power_level_receive = power_level_receive[1] -- set low
            print("power level (Receive): "..set_power_level_receive)
        end 
    end 
end)


hook.Add("PlayerButtonUp", "setMode", function(ply, button)
    -- Reset the mode button state when released
    if button == KEY_2 then
        modeButtonPressed = false
    end
end)


hook.Add("PlayerButtonUp", "setMode", function(ply, button)
    -- Reset the mode button state when released
    if button == KEY_2 then
        modeButtonPressed = false
    end
end)

hook.Add("PlayerButtonDown", "setPower", function(ply, button)
    -- Check if the power button is already pressed or if not enough time has passed since the last press
    if button ~= KEY_1 or CurTime() - lastPowerPressTime < pressDelay then
        return
    end
    
    -- Update the time of the last press
    lastPowerPressTime = CurTime()

    -- Your existing code for setting power goes here

    if set_power_level_spike == power_level_spike[1] then -- if low
        set_power_level_spike = power_level_spike[2]  -- set high 
        print("power level (Spike): "..set_power_level_spike)
    elseif set_power_level_spike == power_level_spike[2] then  -- if high
        set_power_level_spike = power_level_spike[1] -- set low
        print("power level (Spike): "..set_power_level_spike)
    end 

end)



hook.Add("PlayerButtonUp", "setPower", function(ply, button)
    -- Reset the power button state when released
    if button == KEY_1 then
        tossButtonPressed = false
    end
end)


hook.Add("PlayerButtonDown", "setToss", function(ply, button)
    -- Check if the power button is already pressed or if not enough time has passed since the last press
    if button ~= KEY_3 or CurTime() - lastTossPressTime < pressDelay then
        return
    end
    
    -- Update the time of the last press
    lastTossPressTime = CurTime()

    -- Your existing code for setting power goes here

    if set_power_level_toss == power_level_toss[1] then -- if low
        set_power_level_toss = power_level_toss[2]  -- set high 
        //print("power level (Spike): "..set_power_level_spike)
    elseif set_power_level_toss == power_level_toss[2] then  -- if high
        set_power_level_toss = power_level_toss[1] -- set low
        //print("power level (Spike): "..set_power_level_spike)
    end 

end)



hook.Add("PlayerButtonUp", "setToss", function(ply, button)
    -- Reset the power button state when released
    if button == KEY_3 then
        tossButtonPressed = false
    end
end)

--// End Controls Mode & Power //-- 


--// Start Serve line detection //-- 
hook.Add("PlayerTick","DetectServeLine",function(ply)
    if  ply:GetPos():WithinAABox( miya_pos1, miya_pos2 ) or ply:GetPos():WithinAABox( miya_pos3, miya_pos4)  then 
        action_status = "You are in service area, Right Click to serve"
    else 

    end 
end)
--// End Start Serve line detection //--------------

team.SetUp( 1, "Blue", Color( 71, 255, 227 ) ) 
team.SetUp( 2, "Green", Color( 255, 83, 83) ) 

function DrawAdminIndicator(ply,char)
	local zOffset = 80
	local x = ply:GetPos().x			
	local y = ply:GetPos().y			
	local z = ply:GetPos().z			
	local pos = Vector(x,y,z+zOffset)	
	local pos2d = pos:ToScreen()


    draw.DrawText(ply:Nick(),"Default",pos2d.x,pos2d.y, team.GetColor( ply:Team() ),TEXT_ALIGN_CENTER)

	
	--end
end

function LoopThroughPlayers()
	for k,v in pairs (player.GetAll()) do 
		--if v:IsAdmin() then			
			DrawAdminIndicator(v,character)	
		--end
	end
end
hook.Add("HUDPaint", "TopLeftIcons", function()
    -- Help icon
    surface.SetMaterial(Material("icon16/help.png"))
    surface.SetDrawColor(255,255,255,255)
    surface.DrawTexturedRect(10, 10, 24, 24)
    draw.SimpleText("Guides [F3]", "IconFont", 40, 10, Color(255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)

    -- Settings icon
    surface.SetMaterial(Material("icon16/wrench.png"))
    surface.SetDrawColor(255,255,255,255)
    surface.DrawTexturedRect(10, 40, 24, 24)
    draw.SimpleText("Settings [N]", "IconFont", 40, 40, Color(255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)

    -- Menu icon
    surface.SetMaterial(Material("icon16/user_red.png"))
    surface.SetDrawColor(255,255,255,255)
    surface.DrawTexturedRect(10, 70, 24, 24)
    draw.SimpleText("Character [M]", "IconFont", 40, 70, Color(255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
end)

hook.Add("HUDPaint", "LoopThroughPlayers", LoopThroughPlayers)

-- Vertical sidebar for F3 toggle reminder
hook.Add("HUDPaint", "LeftSidebarF3", function()
    if not control_panel_open then return end
    local text = "F3 TO CLOSE/OPEN"
    local font = "Trebuchet24"
    surface.SetFont(font)
    local textWidth, textHeight = surface.GetTextSize(text)
    local x = ScrW() * 0.75 - 40 - textWidth  -- Adjust to fit beside the panel
    local y = ScrH() / 2 - textHeight / 2  -- Center vertically
    -- Draw background for contrast
    draw.RoundedBox(8, x - 5, y - 5, textWidth + 10, textHeight + 10, Color(0, 0, 0, 150))
    -- Draw text horizontally
    draw.SimpleText(text, font, x, y, Color(255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
end)
