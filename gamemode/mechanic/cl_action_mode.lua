print("Action Mode System")

-- Action mode switch notification
actionModeNotification = {
    show = false,
    text = "",
    color = Color(255, 255, 255),
    startTime = 0,
    duration = 1.5
}



function DefaultSwitchMode()
    actionMode.block = false
    actionMode.spike = true

    hook.Remove("PlayerButtonDown", "BlockJumpSystem")
    hook.Remove("PlayerButtonDown", "KeyDown_Block")
    SpikeApproachAnimation()
    SpikePower(spikePower.force,spikePower.power)

    -- Show spike mode notification
    actionModeNotification.show = true
    actionModeNotification.text = "SPIKE MODE"
    actionModeNotification.color = Color(255, 165, 0) -- Orange
    actionModeNotification.startTime = CurTime()
end

function SwitchActionMode()
    -- Think hook for switching modes (available immediately on spawn)
    hook.Add("CreateMove", "DisableDefaultJump", function(cmd)
        if LocalPlayer():IsValid() then
            cmd:RemoveKey(IN_JUMP)
        end
    end)

    DefaultSwitchMode()

    local keyDown = {}

    hook.Add("Think", "SwitchActionMode", function()
        ply = LocalPlayer()
        if not IsValid(ply) then return end
        -- Don't allow mode switch if player is mid-air or during approach animation
        if not ply:IsOnGround() or isApproachAnimation then return end
        -- Only allow toggle if jump system is activated

        if input.IsKeyDown(KEY_4) then
            if not keyDown[KEY_4] then
                keyDown[KEY_4] = true

                if actionMode.block then
                    actionMode.block = false
                    actionMode.spike = true

                    hook.Remove("PlayerButtonDown", "BlockJumpSystem")
                    hook.Remove("PlayerButtonDown", "KeyDown_Block")
                    SpikeApproachAnimation()
                    SpikePower(spikePower.force,spikePower.power)

                    -- Show spike mode notification
                    actionModeNotification.show = true
                    actionModeNotification.text = "SPIKE MODE"
                    actionModeNotification.color = Color(255, 165, 0) -- Orange
                    actionModeNotification.startTime = CurTime()
                else
                    actionMode.block = true
                    actionMode.spike = false

                    hook.Remove("PlayerButtonDown", "SpikeJumpSystem")
                    hook.Remove("Tick", "KeyDown_Spike")
                    BlockApproachAnimation()
                    BlockSystem()

                    -- Show block mode notification
                    actionModeNotification.show = true
                    actionModeNotification.text = "BLOCK MODE"
                    actionModeNotification.color = Color(0, 150, 255) -- Blue
                    actionModeNotification.startTime = CurTime()
                end

                chat.AddText("Current mode: " .. (actionMode.block and "block" or "spike"))
            end
        else
            keyDown[KEY_4] = false
        end
    end)
end

-- Action mode switch notification HUD
hook.Add("HUDPaint", "ActionModeSwitchNotification", function()
    if not actionModeNotification.show then return end

    local elapsed = CurTime() - actionModeNotification.startTime
    if elapsed > actionModeNotification.duration then
        actionModeNotification.show = false
        return
    end

    -- Fade out effect
    local alpha = 255
    if elapsed > actionModeNotification.duration * 0.7 then
        alpha = 255 * (1 - (elapsed - actionModeNotification.duration * 0.7) / (actionModeNotification.duration * 0.3))
    end

    -- Position at top center
    local x, y = ScrW() / 2, ScrH() * 0.15
    local font = "ActionModeNotificationFont"

    -- Draw shadow/outline
    for dx = -3, 3 do
        for dy = -3, 3 do
            if dx ~= 0 or dy ~= 0 then
                draw.SimpleText(actionModeNotification.text, font, x + dx, y + dy, Color(0, 0, 0, alpha), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
            end
        end
    end

    -- Draw main text
    draw.SimpleText(actionModeNotification.text, font, x, y, Color(actionModeNotification.color.r, actionModeNotification.color.g, actionModeNotification.color.b, alpha), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
end)
