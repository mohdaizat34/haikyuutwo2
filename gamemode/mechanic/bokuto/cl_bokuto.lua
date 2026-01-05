print("Bokuto Abilities")

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
                        local ballPos = ent[k]:GetPos()
                        local toBall = ballPos - ply:EyePos()
                        local distOk = toBall:LengthSqr() < detection_sqr

                        -- easy mode cone (wide)
                        local aimDot = ply:GetAimVector():Dot(toBall:GetNormalized())
                        local aimOk = aimDot > 0.4   -- EASY MODE

                        -- Strict court boundary check - prevent spiking balls on opponent's side
                        local playerTeam = LocalPlayer():Team()
                        local NET_Y = 318
                        local isBallOnMySide =
                            (playerTeam == 2 and ballPos.y < NET_Y) or
                            (playerTeam == 1 and ballPos.y > NET_Y)

                        if distOk and aimOk and isBallOnMySide then

                            ply:ConCommand("pac_event spike")
                            surface.PlaySound("spike.mp3")

                            release_ball_spike = true
                            --SpikeSakusaSendToServer("strong",spikepower,ent[k],ent[k]:GetPos(),"left",allow_spike_assist)
                            CutSendToServer("right","power",ent[k])
                            -- Ball ground check for bokuto spike
                            local groundHitDetected = false
                            function IsEntityOnGround(entity)
                                local posBall = entity:GetPos()
                                local traceBall = util.TraceLine({
                                    start = posBall,
                                    endpos = posBall - Vector(0, 0, 15),
                                    mask = MASK_OPAQUE
                                })
                                return traceBall.Hit
                            end
                            function BallGroundCheck()
                                if not groundHitDetected and IsEntityOnGround(ent[k]) then
                                    groundHitDetected = true
                                    local hitGroundPos = ent[k]:GetPos()
                                    scoringPending = true
                                    feintCountdownActive = true
                                    feintCountdownStartTime = CurTime()
                                    feintCountdownDuration = 0.7
                                    feintDebugDelayActive = true
                                    feintDebugDelayTime = CurTime() + 0.7
                                    feintDebugDelayCancelled = false
                                    timer.Simple(0.7, function()
                                        feintDebugDelayActive = false
                                        feintDebugDelayCompleted = true
                                        feintDebugDelayResultTime = CurTime() + 3
                                        feintCountdownActive = false
                                        if scoringPending then
                                            hook.Remove("Think", "BallChecker")
                                            net.Start("BallHitGround")
                                            net.WriteVector(hitGroundPos)
                                            net.WriteEntity(ent[k])
                                            net.SendToServer()
                                        end
                                    end)
                                elseif not groundHitDetected then
                                    hook.Add("Think", "BallChecker", BallGroundCheck)
                                end
                            end
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

                        local ballPos = ent[k]:GetPos()
                        -- Strict court boundary check - prevent spiking balls on opponent's side
                        local playerTeam = LocalPlayer():Team()
                        local NET_Y = 318
                        local isBallOnMySide =
                            (playerTeam == 2 and ballPos.y < NET_Y) or
                            (playerTeam == 1 and ballPos.y > NET_Y)

                        if LocalPlayer():GetPos():DistToSqr( ballPos ) < 115*115 and isBallOnMySide then
                            ply:ConCommand("pac_event spike")
                            surface.PlaySound("spike.mp3")
                            release_ball_spike = true
                            CutSendToServer("left","power",ent[k])
                            -- Ball ground check for bokuto spike
                            local groundHitDetected = false
                            function IsEntityOnGround(entity)
                                local posBall = entity:GetPos()
                                local traceBall = util.TraceLine({
                                    start = posBall,
                                    endpos = posBall - Vector(0, 0, 15),
                                    mask = MASK_OPAQUE
                                })
                                return traceBall.Hit
                            end
                            function BallGroundCheck()
                                if not groundHitDetected and IsEntityOnGround(ent[k]) then
                                    groundHitDetected = true
                                    local hitGroundPos = ent[k]:GetPos()
                                    scoringPending = true
                                    feintCountdownActive = true
                                    feintCountdownStartTime = CurTime()
                                    feintCountdownDuration = 0.7
                                    feintDebugDelayActive = true
                                    feintDebugDelayTime = CurTime() + 0.7
                                    feintDebugDelayCancelled = false
                                    timer.Simple(0.7, function()
                                        feintDebugDelayActive = false
                                        feintDebugDelayCompleted = true
                                        feintDebugDelayResultTime = CurTime() + 3
                                        feintCountdownActive = false
                                        if scoringPending then
                                            hook.Remove("Think", "BallChecker")
                                            net.Start("BallHitGround")
                                            net.WriteVector(hitGroundPos)
                                            net.WriteEntity(ent[k])
                                            net.SendToServer()
                                        end
                                    end)
                                elseif not groundHitDetected then
                                    hook.Add("Think", "BallChecker", BallGroundCheck)
                                end
                            end
                            BallGroundCheck()

                            timer.Simple(1,function() release_ball_spike = false end)
                        end
                    end
                end
            end
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
