print("Miya Abilities")

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
