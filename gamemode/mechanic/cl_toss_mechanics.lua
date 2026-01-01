print("Toss Mechanics")

-- Internal state for TossPower HUD
local TossPowerState = {
    holding = false,
    power = 0
}

--------------------------------------------------
-- HUD VISUAL (LOW / MID / HIGH) for TossPower
--------------------------------------------------
hook.Add("HUDPaint", "TossPowerHUD", function()
    if not TossPowerState.holding then return end
    if TOSS_SET_FORCE <= 0 then return end

    local w, h = 320, 36
    local x, y = ScrW() / 2 - w / 2, ScrH() * 0.65

    -- Background
    draw.RoundedBox(10, x, y, w, h, Color(20, 20, 20, 220))

    -- Fill %
    local pct = math.Clamp(TossPowerState.power / 20, 0, 1)
    local fillW = w * pct

    local col = Color(120, 200, 255)
    local label = "LOW POWER"

    if TossPowerState.power >= TOSS_SET_FORCE then
        col = Color(120, 255, 120)
        label = "MID POWER"
    end
    if TossPowerState.power >= 20 then
        col = Color(255, 120, 120)
        label = "HIGH POWER"
    end

    draw.RoundedBox(10, x + 4, y + 4, fillW - 8, h - 8, col)

    draw.SimpleText(
        label,
        "Trebuchet24",
        x + w / 2,
        y + h / 2,
        color_white,
        TEXT_ALIGN_CENTER,
        TEXT_ALIGN_CENTER
    )
end)

function TossPower(setForce)
    TOSS_SET_FORCE = setForce or 0

    if TOSS_SET_FORCE <= 0 then return end

    ply = LocalPlayer()
    powertossbar = 0
    powertoss = 0
    --jumpcount = 0
    buttonpresstoss = 0

    hook.Add( "Tick", "KeyDown_Toss", function()
        if not actionMode.block then return end

        local keySetting = MOUSE_LEFT

        if (input.IsButtonDown(keySetting)) then
            buttonpresstoss = 1
            powertoss = powertoss + 1

            -- HUD STATE
            TossPowerState.holding = true
            TossPowerState.power = powertoss

        else
            if buttonpresstoss == 1 then
                buttonpresstoss = 0
                TossPowerState.holding = false

                if powertoss <= TOSS_SET_FORCE then

                    TossSendToServer("weak","front")
                    powertoss = 0
                    print( "reset" )

                elseif powertoss < 20 then
                    TossSendToServer("medium","front")
                    powertoss = 0
                    print( "reset" )

                else
                    TossSendToServer("high","front")
                    powertoss = 0
                    print( "reset" )
                end
                powertoss = 0

                TossPowerState.power = 0
            end
        end
    end)
end

-- Internal state for BackTossPower HUD
local BackTossPowerState = {
    holding = false,
    power = 0
}

--------------------------------------------------
-- HUD VISUAL (LOW / MID / HIGH) for BackTossPower
--------------------------------------------------
hook.Add("HUDPaint", "BackTossPowerHUD", function()
    if not BackTossPowerState.holding then return end
    if BACK_TOSS_SET_FORCE <= 0 then return end

    local w, h = 320, 36
    local x, y = ScrW() / 2 - w / 2, ScrH() * 0.65

    -- Background
    draw.RoundedBox(10, x, y, w, h, Color(20, 20, 20, 220))

    -- Fill %
    local pct = math.Clamp(BackTossPowerState.power / 20, 0, 1)
    local fillW = w * pct

    local col = Color(120, 200, 255)
    local label = "LOW POWER"

    if BackTossPowerState.power >= BACK_TOSS_SET_FORCE then
        col = Color(120, 255, 120)
        label = "MID POWER"
    end
    if BackTossPowerState.power >= 20 then
        col = Color(255, 120, 120)
        label = "HIGH POWER"
    end

   draw.RoundedBox(10, x + 4, y + 4, fillW - 8, h - 8, col)

    draw.SimpleText(
        label,
        "Trebuchet24",
        x + w / 2,
        y + h / 2,
        color_white,
        TEXT_ALIGN_CENTER,
        TEXT_ALIGN_CENTER
    )
end)

function BackTossPower(setForce)
    BACK_TOSS_SET_FORCE = setForce or 0

    if BACK_TOSS_SET_FORCE <= 0 then return end

    powertossbar2 = 0
    powertoss2 = 0
    --jumpcount = 0
    buttonpresstoss2 = 0

    hook.Add( "Tick", "KeyDown_Toss2", function()
        local keySetting
        if allow_left_assist == false then
            keySetting = KEY_F
        else
            keySetting = KEY_RBRACKET
        end


        if (input.IsButtonDown(keySetting)) then
            buttonpresstoss2 = 1
            powertoss2 = powertoss2 + 1

            -- HUD STATE
            BackTossPowerState.holding = true
            BackTossPowerState.power = powertoss2

        else
            if buttonpresstoss2 == 0 then

            elseif buttonpresstoss2 == 1 then
                buttonpresstoss2 = 0
                BackTossPowerState.holding = false

                if powertoss2 <= BACK_TOSS_SET_FORCE then

                    TossSendToServer("weak","back")
                    powertoss2 = 0
                    print( "reset" )

                elseif powertoss2 < 20 then
                    TossSendToServer("medium","back")
                    powertoss2 = 0
                    print( "reset" )

                else
                    TossSendToServer("high","back")
                    powertoss2 = 0
                    print( "reset" )
                end
                powertoss2 = 0

                BackTossPowerState.power = 0
            end
        end
    end)
end

function TossSendToServer(powertype,frontback)
    groundHitTimer = nil
    LocalPlayer():ConCommand("pac_event toss")
    if ply:GetPos():WithinAABox( pos1, pos2 ) then
        position = "left"
    else
        position = "right"
    end
    net.Start("toss_power")
    net.WriteString(position)
    net.WriteString(powertype)
    net.WriteString(frontback)
    net.WriteBool(allow_set_assist)
    net.SendToServer()
end

--------------------------------------------------
-- KAGE QUICK TOSS (REFACTORED, SAFE, VISUAL HUD)
--------------------------------------------------

-- Internal state (SAFE globals)
local KageToss = {
    power = 0,
    bar = 0,
    holding = false,
    mode = "front"
}

local KAGE_SET_FORCE = 0
local TOSS_SET_FORCE = 0
local BACK_TOSS_SET_FORCE = 0

--------------------------------------------------
-- HUD VISUAL (LOW / MID / HIGH)
--------------------------------------------------
function KageQuickTossHUD()
    hook.Add("HUDPaint", "KageQuickTossHUD", function()
        if not KageToss.holding then return end
        if KAGE_SET_FORCE <= 0 then return end

        local w, h = 320, 36
        local x, y = ScrW() / 2 - w / 2, ScrH() * 0.65

        -- Background
        draw.RoundedBox(10, x, y, w, h, Color(20, 20, 20, 220))

        -- Fill %
        local pct = math.Clamp(KageToss.power / 20, 0, 1)
        local fillW = w * pct

        local col = Color(120, 200, 255)
        local label = "LOW POWER"

        if KageToss.power >= KAGE_SET_FORCE then
            col = Color(120, 255, 120)
            label = "MID POWER"
        end
        if KageToss.power >= 20 then
            col = Color(255, 120, 120)
            label = "HIGH POWER"
        end

        draw.RoundedBox(10, x + 4, y + 4, fillW - 8, h - 8, col)

        draw.SimpleText(
            label,
            "Trebuchet24",
            x + w / 2,
            y + h / 2,
            color_white,
            TEXT_ALIGN_CENTER,
            TEXT_ALIGN_CENTER
        )
    end)
end

--------------------------------------------------
-- MAIN FUNCTION (LOGIC UNCHANGED)
--------------------------------------------------
function KageQuickToss(setForce)
    -- FIX nil comparison
    KAGE_SET_FORCE = setForce or 0

    if KAGE_SET_FORCE <= 0 then return end

    -- Reset state
    KageToss.power = 0
    KageToss.bar = 0
    KageToss.holding = false

    hook.Remove("Tick", "Kage_toss2")

    hook.Add("Tick", "Kage_toss2", function()
        if not actionMode.block then return end

        if input.IsButtonDown(MOUSE_MIDDLE) then
            KageToss.holding = true

            if set_power_level_toss == power_level_toss[1] then
                -- FRONT QUICK TOSS
                KageToss.mode = "front"
                KageToss.power = KageToss.power + 1
            else
                -- BACK SHOOT TOSS
                KageToss.mode = "back"
                KageToss.power = KageToss.power + 1
            end
        else
            if not KageToss.holding then return end
            KageToss.holding = false

            --------------------------------
            -- RELEASE LOGIC (UNCHANGED)
            --------------------------------
            if KageToss.mode == "front" then
                if KageToss.power <= KAGE_SET_FORCE then
                    KageSendToServer("weak", "front", "quick")
                    chat.AddText("Short Toss!")
                elseif KageToss.power < 20 then
                    KageSendToServer("medium", "front", "quick")
                    chat.AddText("Medium Toss!")
                else
                    KageSendToServer("high", "front", "quick")
                    chat.AddText("Power Toss!")
                end
            else
                KageSendToServer("shoot", "back", "quick")
                chat.AddText("Back Shoot Toss!")
            end

            -- Reset
            KageToss.power = 0
            KageToss.bar = 0
        end
    end)
end

-- Internal state for KageFrontToss HUD
local KageFrontTossState = {
    holding = false,
    power = 0
}

--------------------------------------------------
-- HUD VISUAL (LOW / MID / HIGH) for KageFrontToss
--------------------------------------------------
function KageFrontTossHUD()
    hook.Add("HUDPaint", "KageFrontTossHUD", function()
        if not KageFrontTossState.holding then return end
        if KAGE_SET_FORCE <= 0 then return end

        local w, h = 320, 36
        local x, y = ScrW() / 2 - w / 2, ScrH() * 0.65

        -- Background
        draw.RoundedBox(10, x, y, w, h, Color(20, 20, 20, 220))

        -- Fill %
        local pct = math.Clamp(KageFrontTossState.power / 20, 0, 1)
        local fillW = w * pct

        local col = Color(120, 200, 255)
        local label = "LOW POWER"

        if KageFrontTossState.power >= KAGE_SET_FORCE then
            col = Color(120, 255, 120)
            label = "MID POWER"
        end
        if KageFrontTossState.power >= 20 then
            col = Color(255, 120, 120)
            label = "HIGH POWER"
        end

    draw.RoundedBox(10, x + 4, y + 4, fillW - 8, h - 8, col)

        draw.SimpleText(
            label,
            "Trebuchet24",
            x + w / 2,
            y + h / 2,
            color_white,
            TEXT_ALIGN_CENTER,
            TEXT_ALIGN_CENTER
        )
    end)
end

function KageFrontToss(setForce)
    -- safety
    KAGE_SET_FORCE = setForce or 0

    powertossbarkage = 0
    powertosskage = 0
    buttonpresstosskage = 0

    hook.Remove("Tick", "Kage_toss")

    hook.Add("Tick", "Kage_toss", function()
        if not actionMode.block then return end

        local keySetting
        if allow_left_assist == false then
            keySetting = KEY_R
        else
            keySetting = KEY_LBRACKET
        end

        --------------------------------------------------
        -- HOLD
        --------------------------------------------------
        if input.IsButtonDown(keySetting) then
            buttonpresstosskage = 1

            powertosskage = powertosskage + 1

            -- HUD STATE
            KageFrontTossState.holding = true
            KageFrontTossState.power = powertosskage

            -- HUD MIRROR (SAME AS QUICK TOSS)
            KageToss.holding = true
            KageToss.power = powertosskage
            KageToss.mode = "front"

        else
            --------------------------------------------------
            -- RELEASE
            --------------------------------------------------
            if buttonpresstosskage == 0 then return end
            buttonpresstosskage = 0

            KageFrontTossState.holding = false
            KageToss.holding = false

            if powertosskage <= KAGE_SET_FORCE then
                KageSendToServer("weak", "front", "king")
                chat.AddText("Short Toss!")
            elseif powertosskage < 20 then
                KageSendToServer("medium", "front", "king")
                chat.AddText("Medium Toss!")
            else
                KageSendToServer("high", "front", "king")
                chat.AddText("Power Toss!")
            end

            -- RESET (IMPORTANT FOR HUD)
            powertosskage = 0

            KageFrontTossState.power = 0
            KageToss.power = 0
        end
    end)
end

function KageSendToServer(powertype,frontback,tosstype)
    if ply:GetPos():WithinAABox( pos1, pos2 ) then
        position = "left"
    else
        position = "right"
    end
    net.Start("kage_toss_ability")
    net.WriteString(position)
    net.WriteString(powertype)
    net.WriteString(frontback)
    net.WriteString(tosstype)
    net.WriteBool(allow_set_assist)
    net.SendToServer()
end
