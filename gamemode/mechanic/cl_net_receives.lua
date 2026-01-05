print("Net Receives")

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
            ang:RotateAroundAxis(ang.Right(), 90)
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
    local isBallInCourt = net.ReadBool()

    isBallIn = isBallInCourt
    CreateGroundMarker(ballPos, isBallIn)

    print(isBallIn and "BALL IN" or "BALL OUT")
    -- if allow_in_out_system then
    -- 	timer.Simple(0.8,function()	surface.PlaySound("whistle.mp3") end)
    -- end

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

-- Court boundaries for Team 1 and Team 2 (split vertically - top/bottom)
TEAM1_COURT_MIN = Vector(794.318298, 318.4, -100)  -- Top half court (full width)
TEAM1_COURT_MAX = Vector(1207.460327, 676.799255, 100)
TEAM2_COURT_MIN = Vector(794.318298, -40.005096, -100) -- Bottom half court (full width)
TEAM2_COURT_MAX = Vector(1207.460327, 318.4, 100)

-- Score tracking
local teamScores = {0, 0} -- Index 1 = Team 1 (Blue), Index 2 = Team 2 (Red)

-- Score updates
net.Receive("UpdateScore", function()
    local scoringTeam = net.ReadInt(8)
    local newScore = net.ReadInt(16)
    local reason = net.ReadString()

    -- Update local score tracking
    teamScores[scoringTeam] = newScore

    print("SCORE UPDATE: Team " .. scoringTeam .. " now has " .. newScore .. " points")
    print("Reason: " .. reason)

    -- You can add HUD updates here if needed
    -- For example, update a scoreboard or display the score change
end)

-- Countdown timer variables
local countdownActive = false
local countdownStartTime = 0
local countdownDuration = 0

-- Countdown updates
net.Receive("StartCountdown", function()
    countdownDuration = 0.7 -- Always start at 0.7 seconds
    countdownStartTime = CurTime()
    countdownActive = true
end)

-- -- Court visualization
-- hook.Add("PostDrawTranslucentRenderables", "DrawCourtBoundaries", function()
--     -- Team 1 court (Blue - Top half) - full court width
--     local team1Min = Vector(794.318298, 318.4, -55.968750)  -- From floor level
--     local team1Max = Vector(1207.460327, 676.799255, 50)    -- Up to reasonable height

--     -- Team 2 court (Red - Bottom half) - full court width
--     local team2Min = Vector(794.318298, -40.005096, -55.968750) -- From floor level
--     local team2Max = Vector(1207.460327, 318.4, 50)           -- Up to reasonable height

--     -- Draw Team 1 court (Blue)
--     render.SetMaterial(Material("models/wireframe"))
--     render.DrawWireframeBox(team1Min, Angle(0,0,0), Vector(0,0,0), team1Max - team1Min, Color(0, 0, 255, 100), true)

--     -- Draw Team 2 court (Red)
--     render.DrawWireframeBox(team2Min, Angle(0,0,0), Vector(0,0,0), team2Max - team2Min, Color(255, 0, 0, 100), true)

--     -- Draw labels
--     cam.Start3D2D((team1Min + team1Max) / 2 + Vector(0, 0, 50), Angle(0, 0, 0), 1)
--         draw.SimpleText("TEAM 1 (BLUE)", "DermaLarge", 0, 0, Color(0, 0, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
--     cam.End3D2D()

--     cam.Start3D2D((team2Min + team2Max) / 2 + Vector(0, 0, 50), Angle(0, 0, 0), 1)
--         draw.SimpleText("TEAM 2 (RED)", "DermaLarge", 0, 0, Color(255, 0, 0, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
--     cam.End3D2D()
-- end)

-- Receive message display
local receiveMessage = ""
local receiveMessageColor = Color(255, 255, 255)
local receiveMessageTime = 0

net.Receive("ReceiveMessage", function()
    receiveMessage = net.ReadString()
    local isPerfect = net.ReadBool()
    receiveMessageColor = isPerfect and Color(0, 255, 0) or Color(255, 0, 0)
    receiveMessageTime = CurTime() + 3 -- Display for 3 seconds
end)

-- Score announcement messages
net.Receive("ScoreAnnouncement", function()
    local message1 = net.ReadString()
    local message2 = net.ReadString()
    -- Display as HUD message instead of chat
    receiveMessage = message2
    receiveMessageColor = Color(255, 255, 255) -- White for score announcements
    receiveMessageTime = CurTime() + 4 -- Display for 4 seconds (longer for score announcements)
end)

-- Function to draw outlined text for better readability
local function DrawOutlinedText(text, font, x, y, color, alignX, alignY, outlineColor, outlineWidth)
    outlineColor = outlineColor or Color(0, 0, 0, 255)
    outlineWidth = outlineWidth or 1

    -- Draw outline by drawing text in black at offset positions
    for ox = -outlineWidth, outlineWidth, outlineWidth do
        for oy = -outlineWidth, outlineWidth, outlineWidth do
            if ox ~= 0 or oy ~= 0 then
                draw.SimpleText(text, font, x + ox, y + oy, outlineColor, alignX, alignY)
            end
        end
    end

    -- Draw main text on top
    draw.SimpleText(text, font, x, y, color, alignX, alignY)
end

-- Minimalistic Modern Score UI
hook.Add("HUDPaint", "DrawScoreUI", function()
    local screenWidth = ScrW()
    local screenHeight = ScrH()

    -- UI dimensions and positioning (smaller, more compact)
    local uiWidth = 300
    local uiHeight = 60
    local uiX = (screenWidth - uiWidth) / 2
    local uiY = 30

    if not allow_competitive_mode then return end 
    -- Subtle background with high transparency
    draw.RoundedBox(12, uiX, uiY, uiWidth, uiHeight, Color(20, 20, 20, 180))

    -- Thin border
    surface.SetDrawColor(255, 255, 255, 50)
    surface.DrawOutlinedRect(uiX, uiY, uiWidth, uiHeight, 1)

    -- Check if competitive mode is enabled
    if allow_competitive_mode then
        -- Blue Team Score (Left side)
        local blueScoreX = uiX + uiWidth / 4
        local scoreY = uiY + uiHeight / 2

        -- Blue score text (minimal, large numbers)
        draw.SimpleText(tostring(teamScores[1]), "DermaLarge", blueScoreX, scoreY, Color(100, 150, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        draw.SimpleText("", "Trebuchet18", blueScoreX, scoreY + 20, Color(200, 200, 200), TEXT_ALIGN_CENTER)

        -- Red Team Score (Right side)
        local redScoreX = uiX + (3 * uiWidth) / 4

        -- Red score text
        draw.SimpleText(tostring(teamScores[2]), "DermaLarge", redScoreX, scoreY, Color(255, 100, 100), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        draw.SimpleText("", "Trebuchet18", redScoreX, scoreY + 20, Color(200, 200, 200), TEXT_ALIGN_CENTER)

        -- Separator
        local centerX = uiX + uiWidth / 2
        surface.SetDrawColor(255, 255, 255, 30)
        surface.DrawLine(centerX, uiY + 10, centerX, uiY + uiHeight - 10)
    else
        -- Casual Mode - Show "CASUAL MODE" in center
        local centerX = uiX + uiWidth / 2
        local scoreY = uiY + uiHeight / 2

        draw.SimpleText("CASUAL MODE", "DermaLarge", centerX, scoreY, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end

    -- Check if player is in opposite team area and show warning
    if allow_competitive_mode then
        local ply = LocalPlayer()
        if IsValid(ply) then
            local plyPos = ply:GetPos()
            local team = ply:Team()

            -- Check if player is in opposite team area
            local inOppositeArea = false
            if team == 1 then
                -- Team 1 player in Team 2 area
                inOppositeArea = plyPos:WithinAABox(TEAM2_COURT_MIN, TEAM2_COURT_MAX)
            elseif team == 2 then
                -- Team 2 player in Team 1 area
                inOppositeArea = plyPos:WithinAABox(TEAM1_COURT_MIN, TEAM1_COURT_MAX)
            end

            if inOppositeArea then
                -- Display warning in center of screen
                local centerX = screenWidth / 2
                local centerY = screenHeight / 2 + 50 -- Below center
                DrawOutlinedText("WRONG TEAM AREA!", font, centerX, centerY, Color(255, 0, 0), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
            end
        end
    end

    -- Optional: Add a subtle glow effect for active team (if needed, but keeping minimal)

    -- Display receive message on top right (simplified with smaller font)
    if CurTime() < receiveMessageTime and receiveMessage ~= "" then
        local messageY = 100 -- Below the score UI
        local rightMargin = 20 -- Margin from right edge

        -- Position from right edge
        local messageX = screenWidth - rightMargin

        -- Use smaller font for better fit
        local font = "Trebuchet18" -- Smaller than Trebuchet24

        -- Simple message display
        surface.SetFont(font)
        local textWidth = surface.GetTextSize(receiveMessage)
        DrawOutlinedText(receiveMessage, font, messageX - textWidth, messageY, receiveMessageColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
    end
end)
