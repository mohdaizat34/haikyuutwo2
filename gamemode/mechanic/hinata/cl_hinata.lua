
function HinataJump()
  -- Client-side script to detect key presses and notify the server

    hook.Add("Think", "DetectKeyPresses", function()
        -- Handle "R" key press
        if input.IsKeyDown(KEY_R) then
            if not LocalPlayer().keyRWasDown then
                LocalPlayer().keyRWasDown = true
                net.Start("PlayerJumpLeftRequest")
                net.SendToServer()
            end
        else
            LocalPlayer().keyRWasDown = false
        end

        -- Handle "T" key press
        if input.IsKeyDown(KEY_T) then
            if not LocalPlayer().keyTWasDown then
                LocalPlayer().keyTWasDown = true
                net.Start("PlayerJumpRightRequest")
                net.SendToServer()
            end
        else
            LocalPlayer().keyTWasDown = false
        end
    end)

end