-- local spawned_npcs = {}

-- function SpawnSetter()
--     local setter_npc = ents.Create("npc_citizen")
--     setter_npc:SetPos(Vector(1269.144409, 606.471191, 50.591343))
--     setter_npc:Spawn()
--     //setter_npc:SetModel("models/haikyuu/male/kageyama2.mdl")

--     -- Store the NPC in a global table for future reference
--     table.insert(spawned_npcs, setter_npc)
-- end

-- function MoveNPC(ply)
--     for _, npc in ipairs(spawned_npcs) do
--         if npc:IsValid() then
--             npc:SetLastPosition(ply:GetEyeTrace().HitPos)
--             npc:SetSchedule(SCHED_FORCED_GO) -- Forces the NPC to move to the target position

--             -- Calculate the angle to face the player
--             local npc_pos = npc:GetPos()
--             local player_pos = ply:GetPos()
--             local angle = (player_pos - npc_pos):Angle()
            
--             -- Update NPC angle
--             timer.Create("npc_facing_" .. npc:EntIndex(), 2, 0, function()
--                 if npc:IsValid() then
--                     npc:SetAngles(angle)
--                 else
--                     timer.Remove("npc_facing_" .. npc:EntIndex())
--                 end
--             end)
--         end
--     end
-- end

-- hook.Add("PlayerButtonDown", "SpawnSetter", function(ply, button)
--     if button == KEY_F then
--         SpawnSetter()
--     end

--     if button == KEY_J then
--         MoveNPC(ply)
--     end

--     if button == KEY_P then
--         print(ply:GetModel())
--     end
-- end)
