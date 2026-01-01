print("Jump System")

-- Flag to check if player has activated jump system
jumpActivated = false
keyDown = {}

jumpAdd = 60
charJumpPower = {
    hinata = 350 + jumpAdd,
    kageyama = 308 + jumpAdd,
    miya = 308 + jumpAdd,
    ushijima = 315 + jumpAdd,
    yamaguchi = 315 + jumpAdd,
    bokuto = 315 + jumpAdd,
    tsukishima = 290 + jumpAdd,
    korai = 395 + jumpAdd,
    kenma = 300 + jumpAdd,
    sakusa = 320 + jumpAdd,
    kuro = 310 + jumpAdd,
}

function SetJumpPowerByCharacter(char)
    if char == "hinata" then
        jumpPower = charJumpPower.hinata
    elseif char == "kageyama" then
        jumpPower = charJumpPower.kageyama
    elseif char == "miya" then
        jumpPower = charJumpPower.miya
    elseif char == "ushijima" then
        jumpPower = charJumpPower.ushijima
    elseif char == "yamaguchi" then
        jumpPower = charJumpPower.yamaguchi
    elseif char == "bokuto" then
        jumpPower = charJumpPower.bokuto
    elseif char == "tsukishima" then
        jumpPower = charJumpPower.tsukishima
    elseif char == "korai" then
        jumpPower = charJumpPower.korai
    elseif char == "kenma" then
        jumpPower = charJumpPower.kenma
    elseif char == "sakusa" then
        jumpPower = charJumpPower.sakusa
    elseif char == "kuro" then
        jumpPower = charJumpPower.kuro
    end
end

function SpikeApproachAnimation()
    local ply = LocalPlayer()
    local realDelay = 0.7
    local ping = ply:Ping() / 1000
    adjustedDelay = math.max(0.05, realDelay - ping)

    -- Remove any previous jump hooks
    hook.Remove("PlayerButtonDown", "BlockJumpSystem")
    hook.Remove("PlayerButtonDown", "SpikeJumpSystem")

    hook.Add("PlayerButtonDown", "SpikeJumpSystem", function(ply2, button)
        if ply2 ~= LocalPlayer() then return end
        if button ~= KEY_SPACE or not ply2:IsOnGround() or isJumping then return end

        isJumping = true
        chargeStartTime = CurTime()

        -- Tell server jump is starting
        net.Start("JumpApproachStart")
        net.SendToServer()

        if not isApproachAnimation then
            isApproachAnimation = true
            ply2:ConCommand("pac_event approach")
            timer.Simple(2, function()
                if IsValid(ply2) then isApproachAnimation = false end
            end)
        end

        timer.Simple(adjustedDelay, function()
            if not IsValid(ply2) then return end
            if character == "korai" then
                local fx = EffectData()
                fx:SetOrigin(ply:GetPos())
                fx:SetScale(500)
                util.Effect("ThumperDust", fx)
            end
            ply2:ConCommand("pac_event jump")
            net.Start("addVelocity")
            net.WriteString(character)
            net.WriteInt(jumpPower, 32)
            net.SendToServer()

            -- Tell server jump finished
            net.Start("JumpApproachEnd")
            net.SendToServer()

            isJumping = false
        end)
    end)
end

function BlockApproachAnimation()
    local ply = LocalPlayer()
    local realDelay = 0.3
    local ping = ply:Ping() / 1000
    adjustedDelay = math.max(0.05, realDelay - ping)

    -- Remove any previous jump hooks
    hook.Remove("PlayerButtonDown", "SpikeJumpSystem")
    hook.Remove("PlayerButtonDown", "BlockJumpSystem")

    -- Add block jump hook
   hook.Add("PlayerButtonDown", "BlockJumpSystem", function(ply2, button)
    if ply2 ~= LocalPlayer() then return end
    if button ~= KEY_SPACE or not ply2:IsOnGround() or isJumping then return end

    isJumping = true
    chargeStartTime = CurTime()

    -- Tell server jump is starting
    net.Start("JumpApproachStart")
    net.SendToServer()

    if not isApproachAnimation then
        isApproachAnimation = true
        ply2:ConCommand("pac_event approach2")
        timer.Simple(1, function()
            if IsValid(ply2) then isApproachAnimation = false end
        end)
    end

    timer.Simple(adjustedDelay, function()
        if not IsValid(ply2) then return end
        ply2:ConCommand("pac_event jump2")
        net.Start("addVelocity")
        net.WriteString(character)
        net.WriteInt(jumpPower, 32)
        net.SendToServer()

        -- Tell server jump finished
        net.Start("JumpApproachEnd")
        net.SendToServer()

        isJumping = false
    end)
end)
end

-- HUD Paint: draw charging bar + text
hook.Add("HUDPaint", "JumpChargeHUD", function()
    if not isJumping then return end

    local elapsed = CurTime() - chargeStartTime
    local fraction = math.Clamp(elapsed / adjustedDelay, 0, 1)

    local w, h = 250, 20
    local x, y = ScrW() / 2 - w / 2, ScrH() - 120

    -- Background bar
    draw.RoundedBox(4, x, y, w, h, Color(50, 50, 50, 180))
    -- Fill bar
    draw.RoundedBox(4, x, y, w * fraction, h, Color(0, 150, 255, 220))
    -- Border
    surface.SetDrawColor(255, 255, 255, 200)
    surface.DrawOutlinedRect(x, y, w, h)

    -- Text above the bar
    draw.SimpleText(
        "Approaching..",
        "Trebuchet24", -- font
        ScrW() / 2, y - 25, -- centered above bar
        Color(255, 255, 255, 255),
        TEXT_ALIGN_CENTER,
        TEXT_ALIGN_CENTER
    )
end)
