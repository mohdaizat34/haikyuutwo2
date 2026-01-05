print("Spike Mechanics")

-- Global variables for spike system
action_status = ""
groundHitTimer = nil
scoringPending = false -- Client-side scoring pending flag

-- Countdown timer variables for immediate ball hit indication
countdownActive = false
countdownStartTime = 0
countdownDuration = 0

-- Debug UI for ball ground check delay
local debugDelayActive = false
local debugDelayTime = 0
local debugDelayCancelled = false
local debugDelayCompleted = false
local debugDelayResultTime = 0

-- Court boundaries for IN/OUT detection
court_min = Vector(800.388855, -32.057045, -55.968750)
court_max = Vector(1199.963135, 671.806091, -55.968750)

position = ""

-- Player aim prediction after spike
playerAimPrediction = {
    active = false,
    playerPos = nil,
    playerAng = nil,
    startTime = 0,
    duration = 1.0,
    playerName = ""
}

-- Global aim predictions from all players
globalPlayerAims = {}

-- Spike display info
local spikeDisplay = {
    active = false,
    pos = Vector(0, 0, 0),
    reach = 0,
    nick = "",
    startTime = 0
}

spikePower = {
    force = 0,
    power = 0
}

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

-- Spike sound effects
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
                        local playerTeam = LocalPlayer():Team()
                        -- Only allow spiking balls in player's own court area (prevent stealing balls from opponent area)
                        local detection_sqr = 115 * 115
                        local playerTeam = LocalPlayer():Team()

                        local ballPos = ent[k]:GetPos()
                        local NET_Y = 318.4  -- Match server-side court boundary
                        local GAP_SIZE = 5  -- Size of the unspikeable gap between nets

                        -- Check if ball is in the gap between nets
                        local isBallInGap = ballPos.y >= NET_Y - GAP_SIZE and ballPos.y <= NET_Y + GAP_SIZE

                        -- Strict court boundary check - prevent spiking balls on opponent's side or in gap
                        local isBallOnMySide =
                            (playerTeam == 2 and ballPos.y < NET_Y - GAP_SIZE) or
                            (playerTeam == 1 and ballPos.y > NET_Y + GAP_SIZE)



                       if LocalPlayer():GetPos():DistToSqr(ballPos) < detection_sqr and isBallOnMySide then

                            release_ball_spike = true
                            ply:ConCommand("pac_event spike")
                            SpikeSoundEffect(currentSpikepower)


                            -- Determine spike type based on power level
                            local spikeType = "strong"
                            if set_power_level_spike == power_level_spike[1] then
                                spikeType = "weak"
                                surface.PlaySound("spike.mp3")
                            end

                            SpikeSendToServer(spikeType,currentSpikepower,ent[k],ent[k]:GetPos(),allow_spike_assist)

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
                                    endpos = posBall - Vector(0, 0, 15), -- Slightly reduced from 20 to 15 units
                                    mask = MASK_OPAQUE
                                })

                                -- Return true if the trace hits the ground, false otherwise
                                return traceBall.Hit
                            end

                            -- Function to check if the entity's physics object is on the ground and create a ground marker if so
                            function BallGroundCheck()
                                -- Usage example
                                if IsEntityOnGround(ent[k]) then
                                    -- Capture the position where the ball hit the ground
                                    local hitGroundPos = ent[k]:GetPos()

                                    -- Set scoring pending for delayed sending (like server-side)
                                    scoringPending = true

                                    -- Start immediate countdown UI when ball hits ground
                                    countdownActive = true
                                    countdownStartTime = CurTime()
                                    countdownDuration = 0.7
                                    print("BALL HIT GROUND - SHOWING MESSAGE")

                                    -- Activate debug UI
                                    debugDelayActive = true
                                    debugDelayTime = CurTime() + 0.7
                                    debugDelayCancelled = false

                                    -- Delay sending by 0.7 seconds to match server-side scoring delay
                                    timer.Simple(0.7, function()
                                        debugDelayActive = false -- Deactivate active countdown
                                        debugDelayCompleted = true -- Show result
                                        debugDelayResultTime = CurTime() + 3 -- Show result for 3 seconds
                                        countdownActive = false -- Hide countdown when sending

                                        if scoringPending then
                                            hook.Remove("Think", "BallChecker") -- Remove the hook as it's no longer needed
                                            -- Send the position from when the ball hit the ground
                                            net.Start("BallHitGround")
                                            net.WriteVector(hitGroundPos)
                                            net.WriteEntity(ent[k])
                                            net.SendToServer()
                                            CreateGroundMarker(hitGroundPos, ent[k]) -- Create a ground marker at the hit position
                                        end
                                    end)
                                else
                                    hook.Add("Think", "BallChecker", BallGroundCheck) -- Add the hook to keep checking
                                end
                            end

                            -- Start checking if the ball is on the ground
                            BallGroundCheck()
                            timer.Simple(1,function() release_ball_spike = false end)
                        elseif LocalPlayer():GetPos():DistToSqr(ballPos) < detection_sqr and isBallInGap then
                            -- Ball is in the gap between nets - show warning and prevent spike
                            ply:ChatPrint("Can't spike ball in the gap between nets!")
                            timer.Simple(1,function() release_ball_spike = false end)
                        elseif LocalPlayer():GetPos():DistToSqr(ballPos) < detection_sqr and not isBallOnMySide then
                            -- Ball is in opponent's area - show warning and prevent spike
                            ply:ChatPrint("Can't spike ball over other team area!")
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

function SpikeSendToServer(powertype,spikepower,entity,entityPos,allow_spike_assist)
    if isSpiked then return end
    -- Cancel any pending scoring (ball was touched)
    scoringPending = false
    debugDelayCancelled = true -- Mark debug UI as cancelled
    -- Set local client-side cooldown to prevent rapid successive spikes
    isSpiked = true
    timer.Simple(1, function() isSpiked = false end)

    if ply:GetPos():WithinAABox( pos1, pos2 ) then
        position = "left"
    else
        position = "right"
    end

    -- Calculate approximate CM reach (centimeters)
    local reachCM = math.Round((ply:GetPos().z + 50) * 2.54) -- Approximate conversion from units to cm

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
    net.WriteVector(entityPos) -- Ball position for hand display
    net.WriteInt(reachCM, 16) -- CM reach value
    net.SendToServer()
end

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

-- Receive spike position info from server
net.Receive("SpikePositionInfo", function()
    spikeDisplay.active = true
    spikeDisplay.pos = net.ReadVector()
    spikeDisplay.reach = net.ReadInt(16)
    spikeDisplay.nick = net.ReadString()
    spikeDisplay.startTime = CurTime()
end)

-- Ball hit ground indicator
hook.Add("HUDPaint", "BallHitIndicator", function()
    if countdownActive then
        -- Position in center of screen for maximum visibility
        local indicatorY = ScrH() * 0.2  -- Top 20% of screen
        local indicatorX = ScrW() / 2

        -- Determine what message to show
        local indicatorText
        local textColor

        if debugDelayCancelled then
            -- Ball was received/touched - show cancel message
            indicatorText = "SCORING CANCELLED"
            textColor = Color(255, 0, 0) -- Red for cancelled
        else
            -- Normal countdown
            indicatorText = "Ball Hit Ground"
            textColor = Color(255, 255, 0) -- Yellow for active
        end

        surface.SetFont("Trebuchet24")
        local textWidth, textHeight = surface.GetTextSize(indicatorText)

        -- Smaller background box
        draw.RoundedBox(10, indicatorX - textWidth/2 - 15, indicatorY - 8, textWidth + 30, textHeight + 16, Color(0, 0, 0, 200))

        -- Border
        surface.SetDrawColor(textColor.r, textColor.g, textColor.b, 255)
        surface.DrawOutlinedRect(indicatorX - textWidth/2 - 15, indicatorY - 8, textWidth + 30, textHeight + 16, 2)

        -- Text with appropriate color
        draw.SimpleText(indicatorText, "Trebuchet24", indicatorX, indicatorY + textHeight/2, textColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end

    -- Spike position display
    if spikeDisplay.active and CurTime() - spikeDisplay.startTime < 5 then
        local screenPos = spikeDisplay.pos:ToScreen()
        if screenPos.visible then
            -- Draw hand.png
            surface.SetMaterial(Material("materials/hand.png"))
            surface.SetDrawColor(255, 255, 255, 255)
            local size = 64
            surface.DrawTexturedRect(screenPos.x - size/2, screenPos.y - size/2, size, size)

            -- Draw player nick above the hand
            draw.SimpleText(spikeDisplay.nick, "Trebuchet24", screenPos.x, screenPos.y - size/2 - 30, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)

            -- Draw reach text below the hand
            draw.SimpleText(tostring(spikeDisplay.reach) .. " CM", "Trebuchet24", screenPos.x, screenPos.y + size/2 + 10, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
        end
    else
        spikeDisplay.active = false
    end
end)
