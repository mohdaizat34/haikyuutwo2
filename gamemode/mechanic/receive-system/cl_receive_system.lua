print("cl_receive_system")


local targetEntity

hook.Add("Think", "FindTargetEntity", function()
    if not IsValid(targetEntity) then
        for _, ent in ipairs(ents.GetAll()) do
            if ent:GetClass() == "prop_physics" then
                targetEntity = ent
                break
            end
        end
    end
end)

hook.Add("HUDPaint", "DistanceBarHUD", function()
    if not IsValid(LocalPlayer()) or not IsValid(targetEntity) then return end
    if not input.IsKeyDown(KEY_V) then return end

    local ply = LocalPlayer()
    local distanceSqr = ply:GetPos():DistToSqr(targetEntity:GetPos())

    -- Squared thresholds
    local perfectDistSqr = 50*50
    local badDistSqr     = 85*85
    local maxDistSqr     = 100*100

    local barWidth, barHeight = 300, 25
    local x, y = ScrW()/2 - barWidth/2, ScrH() - 100

    -- Zone widths
    local perfectWidth = barWidth * (perfectDistSqr / maxDistSqr)
    local badWidth     = barWidth * ((badDistSqr - perfectDistSqr) / maxDistSqr)
    local outWidth     = barWidth - perfectWidth - badWidth

    -- Determine zone colors (dim by default, light up if indicator inside)
    local outColor     = (distanceSqr > badDistSqr) and Color(0, 0, 0, 200) or Color(0, 0, 0, 200)
    local badColor     = (distanceSqr <= badDistSqr and distanceSqr > perfectDistSqr) and Color(255, 165, 0, 200) or Color(255, 165, 0, 100)
    local perfectColor = (distanceSqr <= perfectDistSqr) and Color(50, 200, 50, 200) or Color(50, 100, 50, 100)

    -- Draw bar zones
    draw.RoundedBox(4, x, y, outWidth, barHeight, outColor)
    draw.RoundedBox(4, x + outWidth, y, badWidth, barHeight, badColor)
    draw.RoundedBox(4, x + outWidth + badWidth, y, perfectWidth, barHeight, perfectColor)

    colorOut = Color(135, 134, 134) 
    colorBad = Color(255, 0, 0)
    colorPerfect = Color(120,255,120)

    -- Draw labels inside bars, slightly brighter
    draw.SimpleText("Out of Reach", "DermaDefaultBold", x + outWidth/2, y + barHeight/2, colorOut, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    draw.SimpleText("Bad",          "DermaDefaultBold", x + outWidth + badWidth/2, y + barHeight/2,colorBad, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    draw.SimpleText("Perfect",      "DermaDefaultBold", x + outWidth + badWidth + perfectWidth/2, y + barHeight/2, colorPerfect, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

    -- Indicator
    local indicator = math.Clamp(1 - distanceSqr / maxDistSqr, 0, 1)
    local indicatorX = x + indicator * barWidth
    draw.RoundedBox(4, indicatorX - 5, y - 5, 10, barHeight + 10, Color(255, 255, 0, 255))

    -- Draw main zone text above bar
    local zoneText = ""
    if distanceSqr <= perfectDistSqr then
        zoneText = "Perfect Receive"
    elseif distanceSqr <= badDistSqr then
        zoneText = "Bad Receive"
    else
        zoneText = "Out of Reach"
    end

    draw.SimpleText(zoneText, "DermaDefaultBold", x + barWidth/2, y - 20, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
end)
