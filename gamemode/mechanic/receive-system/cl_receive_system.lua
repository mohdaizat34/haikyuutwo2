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

-- BASIC - Advanced ReceivePower function
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

--- RECEIVE MECHANICS START --------------------------------
isReceived = false
function ReceiveSendToServer(powertype,ent,allow_old_mechanic, zoneText)
	groundHitTimer = nil
	chat.AddText("receive accuracy:", zoneText)

	-- Position detection: if in pos1-pos2 area, you're on "right" team, else "left" team
	if ply:GetPos():WithinAABox( pos1, pos2 ) then
		position = "right"
		ply:ConCommand("pac_event receive")
		print("on right side ")
		isReceived = true
	else
		position = "left"
		ply:ConCommand("pac_event receive")
		print("on left side ")
		isReceived = true
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
