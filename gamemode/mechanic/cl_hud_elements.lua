print("HUD Elements")

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

-- Perfect receive HUD
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

--ball mark  <-- reference
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
