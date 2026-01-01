print("Block Mechanics")

default_block = false
blocking = false
local isBlocking = false

function BlockSystem()
    hook.Add("PlayerButtonDown","KeyDown_Block",function(ply,button)

        local keySetting
        if allow_left_assist == false then
            keySetting = KEY_Q
        else
            keySetting = KEY_P
        end

        if button == keySetting then

            if blocking == true then

            else
                ply:ConCommand("pac_event block")
                blocking = true
                timer.Simple(1,function() blocking = false end)

                default_block = true

                print("char:"..character)

                ply:ConCommand("pac_event block")
                if !ply:IsOnGround() and isBlocking == false then
                    if ply:GetPos():WithinAABox( pos1, pos2 ) then
                        isBlocking = true
                        net.Start("create_wall")
                        net.WriteString("left")
                        net.WriteString("default")
                        net.WriteString(character)
                        net.WriteBool(default_block)
                        net.SendToServer()
                        timer.Simple(1,function() isBlocking = false end)
                    elseif ply:GetPos():WithinAABox( pos3, pos4 ) then
                        isBlocking = true
                        net.Start("create_wall")
                        net.WriteString("right")
                        net.WriteString("default")
                        net.WriteString(character)
                        net.WriteBool(default_block)
                        net.SendToServer()
                        timer.Simple(1,function() isBlocking = false end)
                    end
                end
            end
        end

        if character == "kuro" then
            if !actionMode.block then return end
            if button == KEY_R then  // when kuro lean left
                if !ply:IsOnGround() and isBlocking == false then
                    isBlocking = true
                    ply:ConCommand("pac_event blockleft")
                    net.Start("create_wall")
                    net.WriteString("left")
                    net.WriteString("block_left")
                    net.WriteString("kuro")
                    net.WriteBool(default_block)
                    net.SendToServer()
                    timer.Simple(1,function() isBlocking = false end)
                end
            elseif button == KEY_T then // when kuro lean right
                if !ply:IsOnGround() and isBlocking == false then
                    isBlocking = true
                    ply:ConCommand("pac_event blockright")
                    net.Start("create_wall")
                    net.WriteString("right")
                    net.WriteString("block_right")
                    net.WriteString("kuro")
                    net.WriteBool(default_block)
                    net.SendToServer()
                    timer.Simple(1,function() isBlocking = false end)
                end
            end
        end
    end)
end

-- =========================
-- KURO LEAN BLOCKS (AIR ONLY)
-- =========================
hook.Add("PlayerButtonDown", "KuroLeanBlock", function(ply, button)
    if character ~= "kuro" then return end
    if not actionMode.block then return end
    if ply:IsOnGround() then return end
    if isBlocking then return end

    if button == KEY_R then
        isBlocking = true
        default_block = false

        ply:ConCommand("pac_event blockleft")

        net.Start("create_wall")
        net.WriteString("left")
        net.WriteString("block_left")
        net.WriteString("kuro")
        net.WriteBool(default_block)
        net.SendToServer()

    elseif button == KEY_T then
        isBlocking = true
        default_block = false

        ply:ConCommand("pac_event blockright")

        net.Start("create_wall")
        net.WriteString("right")
        net.WriteString("block_right")
        net.WriteString("kuro")
        net.WriteBool(default_block)
        net.SendToServer()
    end

    timer.Simple(1, function()
        isBlocking = false
    end)
end)

function BlockSendToServer(powertype)
    if ply:GetPos():WithinAABox( pos1, pos2 ) then
        position = "left"
    else
        position = "right"
    end
    net.Start("block_power")
    net.WriteString(position)
    net.WriteString(powertype)
    net.SendToServer()
end
