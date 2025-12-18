GM.Name = "Gmod Volleyball 2.0 | Haikyuu Volleyball"
GM.Author = "Hope"
GM.Website = "No sir"
GM.Version = "shrug emoji"

function GM:Initialize() 
	
	self.baseclass.Initialize(self) 

end   
 


if SERVER then return end -- Only run on client side





-- if CLIENT then
--     local RotateLeft = false
--     local RotateRight = false

--     net.Receive("RotateLeft", function()
--         RotateLeft = true
--     end)

--     net.Receive("RotateRight", function()
--         RotateRight = true
--     end)

--     hook.Add("CalcView", "AdjustCameraView", function(ply, pos, angles, fov)
--         local view = {}
--         local rotSpeed = 2 -- Adjust rotation speed as needed

--         if RotateLeft then
--             angles.yaw = angles.yaw - rotSpeed
--             RotateLeft = false
--         elseif RotateRight then
--             angles.yaw = angles.yaw + rotSpeed
--             RotateRight = false
--         end

--         view.origin = pos
--         view.angles = angles
--         view.fov = fov

--         return view
--     end)

--     hook.Add("KeyPress", "RotateCamera", function(ply, key)
--         if key == KEY_Q then
--             net.Start("RotateLeft")
--             net.SendToServer()
--         elseif key == KEY_E then
--             net.Start("RotateRight")
--             net.SendToServer()
--         end
--     end)
-- else
--     util.AddNetworkString("RotateLeft")
--     util.AddNetworkString("RotateRight")
-- end

-- if SERVER then `
-- 	util.AddNetworkString("VolleyballUpdate")

-- 	local ball =  ents.FindByClass( "prop_physics*" )

-- 	local function UpdateBall(pos, vel)
-- 		net.Start("VolleyballUpdate")
-- 		net.WriteVector(pos)
-- 		net.WriteVector(vel)
-- 		net.Broadcast()
-- 	end

-- 	hook.Add("Think", "VolleyballPhysics", function()
-- 		for k,v in pairs(ball) do 
-- 			local phys = ball[k]:GetPhysicsObject()
-- 			if IsValid(phys) then
-- 				ball[k]:SetPos(ball[k]:GetPos() + ball[k]:GetVelocity() * FrameTime())
-- 			end
-- 			UpdateBall(ball[k]:GetPos(), ball[k]:GetVelocity())
-- 		end 
-- 	end)

-- end 


	-- -- Client-side code
	-- local ball = {
	-- 	pos = Vector(0, 0, 100),
	-- 	vel = Vector(0, 0, 0),
	-- 	radius = 20
	-- }

	-- net.Receive("VolleyballUpdate", function()
	-- 	ball.pos = net.ReadVector()
	-- 	ball.vel = net.ReadVector()
	-- end)

	-- hook.Add("HUDPaint", "DrawVolleyball", function()
	-- 	surface.SetDrawColor(255, 255, 255)
	-- 	surface.DrawCircle(ball.pos.x, ball.pos.y, ball.radius, Color(255, 255, 255))
	-- end)


	-- hook.Add("CreateMove", "CustomViewAngles", function(cmd)
	-- 	print("your mom")
	-- 	-- Check if the F key is pressed
	-- 	local buttonPressed = input.IsButtonDown(KEY_F)
	
	-- 	-- If the F key is pressed, lock player rotation
	-- 	if buttonPressed then
	-- 		-- Get the current view angles
	-- 		local ang = cmd:GetViewAngles()
	
	-- 		-- Lock player rotation left or right
	-- 		ang.y = ang.y -- Retain the current yaw angle for camera movement
	
	-- 		-- Set the modified angles to lock player rotation
	-- 		cmd:SetViewAngles(ang)
	
	-- 		-- Prevent player from rotating the body
	-- 		cmd:SetAngles(ang)
	-- 	end
	-- end)




