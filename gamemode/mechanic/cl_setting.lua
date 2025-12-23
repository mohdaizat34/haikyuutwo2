-- this will be used in serverside and cl_mechanics.lua
allow_receive_assist = true
allow_set_assist = true
allow_spike_assist = true
allow_left_assist = false
allow_old_receive = false
allow_warmup = false
allow_ball_prediction = false -- Ball landing prediction toggle
allow_in_out_system = true -- IN/OUT referee system toggle

local frameIsOpen = false 
local PANEL = {}
local function HighlightButton(button,button2,frame)
    frame:Close() 
end

local function OpenMyUI()
    if IsValid(MyUIPanel) then
        MyUIPanel:Show()
    else
        MyUIPanel = vgui.Create("MySimpleUI")
    end
end

hook.Add("PlayerButtonDown", "OpenMyUIOnButtonPress", function(ply, button)
    if button == KEY_N then
        OpenMyUI()
    end
end)

function PANEL:Init()
    -- Modern, larger settings panel
    self:SetSize(500, 650)
    self:Center()
    self:SetTitle("")
    self:SetVisible(true)
    self:SetDraggable(true)
    self:MakePopup()
    self:ShowCloseButton(true)

    -- Custom title bar
    self.Paint = function(self, w, h)
        -- Main background with gradient
        draw.RoundedBox(12, 0, 0, w, h, Color(25, 25, 35, 240))

        -- Title bar
        draw.RoundedBoxEx(12, 0, 0, w, 50, Color(45, 45, 55, 255), true, true, false, false)

        -- Title text
        draw.SimpleText("Game Settings", "Trebuchet24", w/2, 25, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

        -- Subtitle
        draw.SimpleText("Customize your volleyball experience", "Trebuchet18", w/2, 70, Color(200, 200, 200), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end

    -- Scroll panel for content
    local scroll = vgui.Create("DScrollPanel", self)
    scroll:SetSize(460, 550)
    scroll:SetPos(20, 90)

    -- Style the scrollbar
    local sbar = scroll:GetVBar()
    function sbar:Paint(w, h)
        draw.RoundedBox(4, 0, 0, w, h, Color(45, 45, 55, 150))
    end
    function sbar.btnUp:Paint(w, h)
        draw.RoundedBox(4, 0, 0, w, h, Color(65, 65, 75, 200))
    end
    function sbar.btnDown:Paint(w, h)
        draw.RoundedBox(4, 0, 0, w, h, Color(65, 65, 75, 200))
    end
    function sbar.btnGrip:Paint(w, h)
        draw.RoundedBox(4, 0, 0, w, h, Color(100, 150, 255, 200))
    end

    local yOffset = 0

    -- Helper function to create setting sections
    local function CreateSettingSection(title, description, icon)
        -- Section header
        local header = vgui.Create("DPanel", scroll)
        header:SetSize(420, 60)
        header:SetPos(0, yOffset)
        header.Paint = function(self, w, h)
            draw.RoundedBox(8, 0, 0, w, h, Color(35, 35, 45, 200))
            -- Icon
            if icon then
                draw.SimpleText(icon, "Trebuchet24", 20, h/2, Color(100, 150, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
            end
            -- Title
            draw.SimpleText(title, "Trebuchet24", 50, 15, Color(255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
            -- Description
            draw.SimpleText(description, "Trebuchet18", 50, 35, Color(180, 180, 180), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
        end

        yOffset = yOffset + 70
        return header
    end

    -- Helper function to create toggle buttons
    local function CreateToggleButtons(yPos, yesText, noText, onYesClick, onNoClick, defaultYes)
        local togglePanel = vgui.Create("DPanel", scroll)
        togglePanel:SetSize(420, 50)
        togglePanel:SetPos(0, yPos)
        togglePanel.Paint = function(self, w, h)
            -- Subtle background
        end

        -- Store button references in the panel for proper scoping
        togglePanel.btnYes = vgui.Create("DButton", togglePanel)
        local btnYes = togglePanel.btnYes
        btnYes:SetSize(180, 40)
        btnYes:SetPos(20, 5)
        btnYes:SetTextColor(textColor)
        btnYes:SetText(yesText)
        btnYes:SetFont("Trebuchet18")
        btnYes.selected = defaultYes
        btnYes.Paint = function(self, w, h)
            local bgColor = self.selected and Color(50, 150, 50, 200) or Color(60, 60, 70, 150)
            local textColor = Color(255, 255, 255)
            draw.RoundedBox(8, 0, 0, w, h, bgColor)
            draw.SimpleText(self:GetText(), "Trebuchet18", w/2, h/2, textColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end
        btnYes.DoClick = function()
            btnYes.selected = true
            togglePanel.btnNo.selected = false
            onYesClick()
        end

        togglePanel.btnNo = vgui.Create("DButton", togglePanel)
        local btnNo = togglePanel.btnNo
        btnNo:SetSize(180, 40)
        btnNo:SetPos(220, 5)
        btnNo:SetTextColor(textColor)
        btnNo:SetText(noText)
        btnNo:SetFont("Trebuchet18")
        btnNo.selected = not defaultYes
        btnNo.Paint = function(self, w, h)
            local bgColor = self.selected and Color(150, 50, 50, 200) or Color(60, 60, 70, 150)
            local textColor = Color(255, 255, 255)
            draw.RoundedBox(8, 0, 0, w, h, bgColor)
            draw.SimpleText(self:GetText(), "Trebuchet18", w/2, h/2, textColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end
        btnNo.DoClick = function()
            btnNo.selected = true
            togglePanel.btnYes.selected = false
            onNoClick()
        end

        return togglePanel
    end

    -- Gameplay Assists Section
    CreateSettingSection("Gameplay Assists", "Receive/Set/Spike Assist?", "")

    -- Receive Assist
    CreateToggleButtons(yOffset, "ENABLED", "DISABLED",
        function()
            allow_receive_assist = true
            chat.AddText(Color(50, 200, 50), "✓ Receive Assist: ENABLED")
        end,
        function()
            allow_receive_assist = false
            chat.AddText(Color(200, 50, 50), "✗ Receive Assist: DISABLED")
        end,
        allow_receive_assist
    )
    yOffset = yOffset + 60

    -- Set Assist
    CreateToggleButtons(yOffset, "ENABLED", "DISABLED",
        function()
            allow_set_assist = true
            chat.AddText(Color(50, 200, 50), "✓ Set Assist: ENABLED")
        end,
        function()
            allow_set_assist = false
            chat.AddText(Color(200, 50, 50), "✗ Set Assist: DISABLED")
        end,
        allow_set_assist
    )
    yOffset = yOffset + 60

    -- Spike Assist
    CreateToggleButtons(yOffset, "ENABLED", "DISABLED",
        function()
            allow_spike_assist = true
            chat.AddText(Color(50, 200, 50), "✓ Spike Assist: ENABLED")
        end,
        function()
            allow_spike_assist = false
            chat.AddText(Color(200, 50, 50), "✗ Spike Assist: DISABLED")
        end,
        allow_spike_assist
    )
    yOffset = yOffset + 70

    -- Visual Features Section
    CreateSettingSection("Visual Features", "Predict where ball lands", "")

    -- Ball Landing Prediction
    CreateToggleButtons(yOffset, "SHOW", "HIDE",
        function()
            allow_ball_prediction = true
            chat.AddText(Color(50, 200, 50), "✓ Ball Landing Prediction: VISIBLE")
        end,
        function()
            allow_ball_prediction = false
            chat.AddText(Color(200, 50, 50), "✗ Ball Landing Prediction: HIDDEN")
        end,
        allow_ball_prediction
    )
    yOffset = yOffset + 70

    -- IN/OUT System Section
    CreateSettingSection("Referee System", "Show referee calls and whistle", "")

    -- IN/OUT System
    CreateToggleButtons(yOffset, "ENABLED", "DISABLED",
        function()
            allow_in_out_system = true
            chat.AddText(Color(50, 200, 50), "✓ IN/OUT System: ENABLED")
        end,
        function()
            allow_in_out_system = false
            chat.AddText(Color(200, 50, 50), "✗ IN/OUT System: DISABLED")
        end,
        allow_in_out_system
    )
    yOffset = yOffset + 70

    -- Controls Section
    -- CreateSettingSection("Control Settings", "Adjust controls for your preferences", "")

    -- -- Left Handed Controls
    -- CreateToggleButtons(yOffset, "LEFT HANDED", "RIGHT HANDED",
    --     function()
    --         allow_left_assist = true
    --         chat.AddText(Color(50, 200, 50), "✓ Left Handed Controls: ENABLED")
    --     end,
    --     function()
    --         allow_left_assist = false
    --         chat.AddText(Color(200, 50, 50), "✓ Right Handed Controls: ENABLED")
    --     end,
    --     allow_left_assist
    -- )
    -- yOffset = yOffset + 70

    -- -- Game Mode Section
    -- CreateSettingSection("Game Settings", "Casual? Competitive?", "")

    -- -- Warmup Mode
    -- CreateToggleButtons(yOffset, "WARMUP MODE", "NORMAL MODE",
    --     function()
    --         allow_warmup = true
    --         chat.AddText(Color(50, 200, 50), "✓ Warmup Mode: ENABLED (delays active)")
    --         net.Start("allow_warmup")
    --         net.WriteBool(allow_warmup)
    --         net.SendToServer()
    --     end,
    --     function()
    --         allow_warmup = false
    --         chat.AddText(Color(200, 50, 50), "✓ Normal Mode: ENABLED (no delays)")
    --         net.Start("allow_warmup")
    --         net.WriteBool(allow_warmup)
    --         net.SendToServer()
    --     end,
    --     allow_warmup
    -- )
    -- yOffset = yOffset + 60

    -- Footer with key hint
    local footer = vgui.Create("DPanel", scroll)
    footer:SetSize(420, 40)
    footer:SetPos(0, yOffset)
    footer.Paint = function(self, w, h)
        draw.RoundedBox(8, 0, 0, w, h, Color(30, 30, 40, 150))
        draw.SimpleText("Press N to open settings anytime", "Trebuchet18", w/2, h/2, Color(150, 150, 150), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end
end

vgui.Register("MySimpleUI", PANEL, "DFrame")
