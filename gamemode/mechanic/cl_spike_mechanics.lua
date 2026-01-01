print("Spike Mechanics")

-- Global variables for spike system
action_status = ""
groundHitTimer = nil

-- Court boundaries for IN/OUT detection
court_min = Vector(800.388855, -32.057045, -55.968750)
court_max = Vector(1199.963135, 671.806091, -55.968750)

position = ""

-- Player aim prediction after spike
playerAimPrediction = {
    active = false,
    playerPos = nil,
    playerAng = nil,
    startTime = 0,
    duration = 1.0,
    playerName = ""
}

-- Global aim predictions from all players
globalPlayerAims = {}

spikePower = {
    force = 0,
    power = 0
}

function SetSpikePowerByCharacter(char)
    if char == "tsukishima" then
        spikePower.force = 10
        spikePower.power = 800
    elseif char == "korai" then
        spikePower.force = 10
        spikePower.power = 1300
    elseif char == "kenma" then
        spikePower.force = 20
        spikePower.power = 700
    elseif char == "sakusa" then
        spikePower.force = 10
        spikePower.power = 1201
    elseif char == "kageyama" then
        spikePower.force = 20
        spikePower.power = 800
    elseif char == "hinata" then
        spikePower.force = 10
        spikePower.power = 1150
    elseif char == "bokuto" then
        spikePower.force = 10
        spikePower.power = 1350
    elseif char == "kuro" then
        spikePower.force = 10
        spikePower.power = 1000
    elseif char == "miya" then
        spikePower.force = 20
        spikePower.power = 800
    elseif char == "ushijima" then
        spikePower.force = 10
        spikePower.power = 2555
    elseif char == "yamaguchi" then
        spikePower.force = 10
        spikePower.power = 800
    end

    -- Reinitialize spike system with new power values if spike mode is active
    if actionMode.spike then
        hook.Remove("Tick", "KeyDown_Spike")
        SpikePower(spikePower.force, spikePower.power)
    end
end

-- Spike sound effects
randomSoundBokuto = {"boku/spike2.mp3","boku/bokutospike2.mp3"}
randomSoundHinata = {"hina/hinataspike2.mp3","hina/hinataspike3.mp3"}
randomSoundKorai = {"korai/hoshiumispike1.wav","korai/hoshiumispike2.wav"}

function SpikeSoundEffect(power)
    if (ply:Ping() >120) then
        -- Handle sound effects and trails based on power
        if power > 2500 then -- Ushijima
            ply:EmitSound("ushi/ushijimaspike2.wav", 70, 100, 1, CHAN_AUTO)
        elseif power == 1150 then -- Hinata
            local hinataSound = table.Random(randomSoundHinata)
            ply:EmitSound(hinataSound, 70, 100, 1, CHAN_AUTO)
        elseif power == 1350 then -- Bokuto
            local bokutoSound = table.Random(randomSoundBokuto)
            ply:EmitSound(bokutoSound, 70, 100, 1, CHAN_AUTO)
        elseif power == 1300 then -- Korai
            local koraiSound = table.Random(randomSoundKorai)
            ply:EmitSound(koraiSound, 70, 100, 1, CHAN_AUTO)
        elseif power == 1200 then -- Kuro
        end
    end
end

function SpikePower(setForce,spikepower)
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

    -- Store the spike power values for this instance
    local currentSpikepower = spikepower

    hook.Add( "Tick", "KeyDown_Spike", function()
        -- Update spike power from global table in case character changed
        currentSpikepower = spikePower.power
        if !ply:IsOnGround()  then
            if release_ball_spike == false then
                if (input.IsButtonDown(MOUSE_LEFT)) then
                    release_ball_spike = false
                    action_status = "SPIKING"
                    -- detect ball when hold button
                    local ent =  ents.FindByClass( "prop_physics*" )
                    for k, v in pairs( ent ) do
                        physObj = ent[k]:GetPhysicsObject()

                        local detection_sqr = 115*115
                        if LocalPlayer():GetPos():DistToSqr( ent[k]:GetPos() ) < detection_sqr then
                            release_ball_spike = true
                            ply:ConCommand("pac_event spike")
                            SpikeSoundEffect(currentSpikepower)


                            if set_power_level_spike == power_level_spike[1] then
                                SpikeSendToServer("weak",currentSpikepower,ent[k],ent[k]:GetPos(),allow_spike_assist)

                                --// START ADD VELOCITY TO FAKE BALL //-----------
                                if LocalPlayer():Ping() > 120 then
                                    local fake_ball = ClientsideModel(ent[k]:GetModel())
                                    fake_ball:SetRenderMode(RENDERMODE_TRANSALPHA)
                                    fake_ball:SetColor(Color(255, 255, 255,70))  -- 50% transparency
                                    fake_ball:SetPos(ent[k]:GetPos())
                                    fake_ball:PhysicsInit(SOLID_VPHYSICS)  -- Initialize physics
                                    -- Define the function to apply a downward force to the ball
                                    local phys = fake_ball:GetPhysicsObject()
                                    phys:EnableDrag(true)
                                    //phys:SetDamping( 2.1, 45 )
                                    phys:SetMaterial("gmod_bouncy")
                                    phys:SetMass(20)
                                    phys:SetVelocity(LocalPlayer():GetAimVector() * spikepower)
                                    phys:GetPhysicsObject():AddAngleVelocity(Vector(0,5000,0))


                                    timer.Simple(0.1, function()
                                        if IsValid(fake_ball) then
                                            fake_ball:Remove()
                                        end
                                    end)
                                end
                                -- END FAKE BALL VELOCITY -------------------------

                                -- Function to check if the entity's physics object is on the ground
                                function IsEntityOnGround(entity)
                                    -- Get the position of the entity
                                    local posBall = entity:GetPos()

                                    -- Trace a line downward to check for ground collision
                                    local traceBall = util.TraceLine({
                                        start = posBall,
                                        endpos = posBall - Vector(0, 0, 20), -- Adjust the length based on your needs
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

                            else


                                SpikeSendToServer("strong",currentSpikepower,ent[k],ent[k]:GetPos(),allow_spike_assist)

                                --// START ADD VELOCITY TO FAKE BALL //-----------
                                if LocalPlayer():Ping() > 120 then
                                    local fake_ball = ClientsideModel(ent[k]:GetModel())
                                    fake_ball:SetRenderMode(RENDERMODE_TRANSALPHA)
                                    fake_ball:SetColor(Color(255, 255, 255,70))  -- 50% transparency
                                    fake_ball:SetPos(ent[k]:GetPos())
                                    fake_ball:PhysicsInit(SOLID_VPHYSICS)  -- Initialize physics
                                    -- Define the function to apply a downward force to the ball
                                    local phys = fake_ball:GetPhysicsObject()
                                    phys:SetMaterial("gmod_bouncy")
                                    phys:SetMass(20)
                                    phys:EnableDrag(true)
                                    //phys:SetDamping( 2.1, 45 )
                                    phys:SetVelocity(LocalPlayer():GetAimVector() * spikepower)


                                    -- Remove the clone and text after some time
                                    timer.Simple(0.1,function()
                                        if IsValid(fake_ball) then
                                            fake_ball:Remove()
                                        end
                                    end)
                                end
                                -- END FAKE BALL VELOCITY -------------------------
                                -- Function to check if the entity's physics object is on the ground
                                function IsEntityOnGround(entity)
                                    -- Get the position of the entity
                                    local posBall = entity:GetPos()

                                    -- Trace a line downward to check for ground collision
                                    local traceBall = util.TraceLine({
                                        start = posBall,
                                        endpos = posBall - Vector(0, 0, 20), -- Adjust the length based on your needs
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
                            timer.Simple(1,function() release_ball_spike = false end)
                        end
                    end
                else
                    action_status = ""
                end
            else


            end
        end
    end)
end

function SpikeSendToServer(powertype,spikepower,entity,entityPos,allow_spike_assist)
    if ply:GetPos():WithinAABox( pos1, pos2 ) then
        position = "left"
    else
        position = "right"
    end

    -- Activate player aim prediction after spike - capture current aim direction
    playerAimPrediction.active = true
    playerAimPrediction.playerPos = ply:EyePos() -- Use eye position for accurate aim line start
    playerAimPrediction.playerAng = ply:EyeAngles() -- This captures where they're looking when hitting the ball
    playerAimPrediction.startTime = CurTime()
    playerAimPrediction.playerName = ply:Nick()

    net.Start("spike_power_hinata")
    net.WriteString(position)
    net.WriteString(powertype)
    net.WriteInt(spikepower,32)
    net.WriteString(character)
    net.WriteEntity(entity)
    net.WriteVector(entityPos)
    net.WriteBool(allow_spike_assist)
    net.SendToServer()
end

-- Receive player aim predictions from other players
net.Receive("PlayerAimPrediction", function()
    local playerName = net.ReadString()
    local playerPos = net.ReadVector()
    local playerAng = net.ReadAngle()

    -- Store the prediction for this player
    globalPlayerAims[playerName] = {
        active = true,
        playerPos = playerPos,
        playerAng = playerAng,
        startTime = CurTime(),
        duration = 1.0
    }
end)
