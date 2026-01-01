print("Utilities")

-- Helper function to predict landing spot
function GetBallLandingPos(ent)
    if not IsValid(ent) then return nil end

    local pos = ent:GetPos()
    local vel = ent:GetVelocity()
    local gravity = Vector(0, 0, -physenv.GetGravity().z) -- Get actual gravity

    -- Simulate flight in small time steps
    local simPos = pos
    local simVel = vel
    local step = 0.05 -- Smaller steps

    for i = 1, 40 do -- Max 2 seconds simulation
        local nextPos = simPos + (simVel * step)
        simVel = simVel + (gravity * step)

        -- Trace to see if it hits the floor
        local tr = util.TraceLine({
            start = simPos,
            endpos = nextPos,
            filter = ent,
            mask = MASK_SOLID
        })

        if tr.Hit then
            return tr.HitPos
        end
        simPos = nextPos
    end

    return simPos -- Return last simulated pos if it hasn't hit yet
end

function GetLagAdjustedDelay(baseDelay)
    local ply = LocalPlayer()
    if not IsValid(ply) then return baseDelay end

    local ping = ply:Ping() / 1000
    return math.max(0.05, baseDelay - ping)
end

-- Court positions - Updated for correct map coordinates
pos1 = Vector(1419.853394, 1000.308411, -165.108414)
pos2 = Vector(602.493164, 319.357361, 398.086914)
-- Calculate the mirrored positions for the other team
pos3 = Vector(pos1.x, -pos1.y, pos1.z)
pos4 = Vector(pos2.x,319.357361, pos2.z)

-- Serve area positions
miya_pos1 = Vector(1300.494019, -261.572266, -119.701813)
miya_pos2 = Vector(670.607239, -30.208231, 199.167160)
miya_pos3 = Vector(676.425293, 888.083191, -108.272842)
miya_pos4 = Vector(1375.196899, 661.645447, 262.988831)

-- Global variables that need to be shared across modules
action_status = ""
perfectReceiveStartTime = nil
isJumping = false
isApproachAnimation = false
chargeStartTime = 0
adjustedDelay = 0

-- Global variables that should be defined elsewhere but may be missing
actionMode = actionMode or {
    block = false,
    spike = true
}

spikePower = spikePower or {
    force = 0,
    power = 0
}

character = character or ""

-- Jump system variables
jumpPower = jumpPower or 300 -- Default jump power

-- Settings variables (these should be defined in cl_setting.lua or similar)
allow_left_assist = allow_left_assist or false
allow_spike_assist = allow_spike_assist or false
allow_receive_assist = allow_receive_assist or false
allow_set_assist = allow_set_assist or false
allow_ball_prediction = allow_ball_prediction or false
allow_in_out_system = allow_in_out_system or false
groundHitTimer = groundHitTimer or nil
isBallIn = isBallIn or nil

-- Power level settings for spike mechanics
set_power_level_spike = set_power_level_spike or {}
power_level_spike = power_level_spike or {true} -- Default to strong spikes

-- Power level settings for toss mechanics
set_power_level_toss = set_power_level_toss or {}
power_level_toss = power_level_toss or {true} -- Default to front toss

-- Power level settings for receive mechanics
set_power_level_receive = set_power_level_receive or "strong"
set_power_level_receive_special = set_power_level_receive_special or "strong"

-- Global player reference
ply = ply or LocalPlayer()

-- Player aim prediction variables
playerAimPrediction = playerAimPrediction or {
    active = false,
    playerPos = nil,
    playerAng = nil,
    startTime = 0,
    duration = 1.0,
    playerName = ""
}

globalPlayerAims = globalPlayerAims or {}

-- Initialize spike mode functions (delayed to ensure all modules are loaded)
timer.Simple(3,function()
    if SpikeApproachAnimation then
        SpikeApproachAnimation()
    end
end)

hook.Add("PlayerButtonDown", "GetAimPosOnC", function(ply, button)
    if ply ~= LocalPlayer() then return end
    if button ~= KEY_C then return end

    local tr = util.TraceLine({
        start  = ply:EyePos(),
        endpos = ply:EyePos() + ply:EyeAngles():Forward() * 10000,
        filter = ply
    })

    print("Aim world position:", tr.HitPos)
end)
