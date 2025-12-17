-- Server-side script to handle jump requests

util.AddNetworkString("PlayerJumpLeftRequest")
util.AddNetworkString("PlayerJumpRightRequest")

net.Receive("PlayerJumpLeftRequest", function(len, ply)
    if ply:IsOnGround() then
        -- Simulate pressing the jump key
        ply:ConCommand("+jump")

        
        timer.Simple(0.1,function()
            if  ply:IsOnGround() then

            else 
                ply:Freeze(true)
                timer.Simple(0.1,function() ply:Freeze(false) end)

                -- Calculate the forward and left velocity
                local forward = ply:GetForward() * -20 -- Adjust the value as needed
                local left = ply:GetRight() * -200-- Adjust the value as needed
                local up = Vector(0, 0, 50) -- Adjust the jump height as needed

                -- Apply the combined velocity
                local jumpVelocity = forward + left + up
                ply:SetVelocity(jumpVelocity) 
            end 
        end) 

        -- Add a slight delay before releasing the jump key
        timer.Simple(0.1, function()
            if IsValid(ply) then
                ply:ConCommand("-jump")
            end
        end)
    end
end)

net.Receive("PlayerJumpRightRequest", function(len, ply)
    if ply:IsOnGround() then
        -- Simulate pressing the jump key
        ply:ConCommand("+jump")

        
        timer.Simple(0.1,function()
            if  ply:IsOnGround() then

            else 
                ply:Freeze(true)
                timer.Simple(0.1,function() ply:Freeze(false) end)

                -- Calculate the forward and left velocity
                local forward = ply:GetForward() * -20   -- Adjust the value as needed
                local left = ply:GetRight() * 200-- Adjust the value as needed
                local up = Vector(0, 0, 0) -- Adjust the jump height as needed

                -- Apply the combined velocity
                local jumpVelocity = forward + left + up
                ply:SetVelocity(jumpVelocity) 
            end 
        end) 


        -- Add a slight delay before releasing the jump key
        timer.Simple(0.1, function()
            if IsValid(ply) then
                ply:ConCommand("-jump")
            end
        end)
    end
end)
