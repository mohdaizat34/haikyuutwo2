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

    isBallIn = IsBallInCourt(ballPos)
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
