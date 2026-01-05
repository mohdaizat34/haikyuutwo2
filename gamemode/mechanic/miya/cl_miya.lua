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

    local canServe = true
    local delayJumpServe = 0.7

    hook.Add("PlayerButtonDown", "miya_serve", function(ply, button)
        if not canServe then return end

        local keySettingR, keySettingT

        if allow_left_assist == false then
            keySettingR = KEY_R
            keySettingT = KEY_T
        else
            keySettingR = KEY_LBRACKET
            keySettingT = KEY_SEMICOLON
        end

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

                        -- Add hook for spike on KEY_R after tossup
                        hook.Add("PlayerButtonDown", "miya_spike", function(ply, button)
                            if button == keySettingR and not ply:IsOnGround() and (ply:GetPos():WithinAABox(miya_pos1, miya_pos2) or ply:GetPos():WithinAABox(miya_pos3, miya_pos4)) then
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

                                    hook.Remove("PlayerButtonDown", "miya_spike")
                                    hook.Remove("Tick", "KeyDown_Toss")
                                    hook.Remove("Tick", "Kage_toss2")

                                    local ent = ents.FindByClass("prop_physics*")
                                    for k, v in pairs(ent) do
                                        if ply:GetPos():DistToSqr(ent[k]:GetPos()) < 170*170 then
                                            -- Function to check if the entity's physics object is on the ground
                                            function IsEntityOnGround(entity)
                                                local posBall = entity:GetPos()
                                                local traceBall = util.TraceLine({
                                                    start = posBall,
                                                    endpos = posBall - Vector(0, 0, 25),
                                                    mask = MASK_OPAQUE
                                                })
                                                return traceBall.Hit
                                            end

                                            function BallGroundCheck()
                                                if IsEntityOnGround(ent[k]) then
                                                    hook.Remove("Think", "BallChecker")
                                                    net.Start("BallHitGround")
                                                    net.WriteVector(ent[k]:GetPos())
                                                    net.WriteEntity(ent[k])
                                                    net.SendToServer()
                                                else
                                                    hook.Add("Think", "BallChecker", BallGroundCheck)
                                                end
                                            end

                                            BallGroundCheck()
                                        end
                                    end

                                    MiyaServe()
                                    timer.Create("re", 1, 1, function()
                                        chat.AddText("Set is now usable")
                                        TossPower(10)
                                        if character == "miya" then
                                            KageQuickToss(10)
                                        end
                                        timer.Stop("re")
                                    end)
                            end
                        end)
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
