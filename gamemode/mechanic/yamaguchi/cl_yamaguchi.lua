print("Yamaguchi Abilities")

function YamaguchiServe()
    miya_pos1 = Vector(1300.494019, -261.572266, -119.701813)
    miya_pos2 = Vector(670.607239, -30.208231, 199.167160)
    miya_pos3 = Vector( 676.425293 ,888.083191, -108.272842)
    miya_pos4 = Vector(1375.196899, 661.645447, 262.988831)

    miya_active = false

    hook.Add("PlayerButtonDown","yama_serve",function(ply,button)

        local keySettingR,keySettingT

        if allow_left_assist == false then
            keySettingR = KEY_R
            keySettingT = KEY_T
        else
            keySettingR = KEY_LBRACKET
            keySettingT = KEY_SEMICOLON
        end

        if button == keySettingR then
            if  ply:GetPos():WithinAABox( miya_pos1, miya_pos2 ) or ply:GetPos():WithinAABox( miya_pos3, miya_pos4)  then
                --net.Start("check_miya_position")
                --net.SendToServer()
                chat.AddText(Color(255,0,0),"Wait for 3 seconds to use yamaguchi float serve.")

                hook.Remove("PlayerButtonDown","yama_serve",function(ply,button) end)
                hook.Remove( "Tick", "KeyDown_Toss", function() end )


                timer.Create("yama_cd",3,1,function()
                    hook.Add("PlayerButtonDown","yama_serve2",function(ply,button)
                        if button == keySettingR then
                            if  ply:GetPos():WithinAABox( miya_pos1, miya_pos2 ) or ply:GetPos():WithinAABox( miya_pos3, miya_pos4)  then
                                net.Start("yama_ability")
                                net.WriteString("tossup")
                                net.SendToServer()
                            else
                                hook.Remove("PlayerButtonDown","yama_serve2",function() end)
                                YamaguchiServe()
                            end
                        end

                        if button == keySettingT then
                            if  ply:GetPos():WithinAABox( miya_pos1, miya_pos2 ) or ply:GetPos():WithinAABox( miya_pos3, miya_pos4)  then
                                net.Start("yama_ability")
                                net.WriteString("spike")
                                net.SendToServer()
                                --hook.Remove("PlayerButtonDown","miya_serve2",function() end)
                                YamaguchiServe()
                                --TossPower(10)
                            else
                                hook.Remove("PlayerButtonDown","yama_serve2",function() end)
                                YamaguchiServe()
                            end
                        end
                    end)
                end)
            end

            --hook.Remove("PlayerButtonDown","miya_serve",function(ply,button) end)

        else
            --hook.Remove("PlayerButtonDown","miya_serve2",function() end)
        end

    end)
end
