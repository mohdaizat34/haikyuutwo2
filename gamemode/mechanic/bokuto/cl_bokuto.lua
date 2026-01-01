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
