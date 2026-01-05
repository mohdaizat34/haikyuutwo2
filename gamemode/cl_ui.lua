-- Define a custom font with a larger size
surface.CreateFont("LargeCharacterTitle", {
    font = "Trebuchet24", -- Font name
    size = 48,            -- Font size (change as needed)
    weight = 700          -- Font weight (optional)
})

-- Initialize the list of characters
local characters = {"Hinata Shoyo", "Kageyama Tobio", "Sakusa Kiyoomi", "Kotaro Bokuto", "Tetsuro Kuro","Atsumu Miya", "Ushijima Wakatoshi",
"Yamaguchi Tadashi", "Tsukishima Kei","Hoshiumi Korai","Kenma Kozume"}


local characterImages = {
    ["Hinata Shoyo"] = {path = "materials/character/hinanew.png", size = {425, 587}},
    ["Kageyama Tobio"] = {path = "materials/character/kagenew2.png", size = {467, 534}},
    ["Sakusa Kiyoomi"] = {path = "materials/character/sakusanew.png", size = {656, 380}},
    ["Kotaro Bokuto"] = {path = "materials/character/bokutonew.png", size = {446, 559}},
    ["Tetsuro Kuro"] = {path = "materials/character/kuronew.png", size = {420, 594}},
    ["Atsumu Miya"] = {path = "materials/character/miya_new4.png", size = {278, 600}},
    ["Ushijima Wakatoshi"] = {path = "materials/character/ushijimanew.png", size = {420, 594}},
    ["Yamaguchi Tadashi"] = {path = "materials/character/yamanew.png", size = {420, 594}},
    ["Tsukishima Kei"] = {path = "materials/character/tsukinew.png", size = {420, 594}},
    ["Hoshiumi Korai"] = {path = "materials/character/korainew.png", size = {420, 594}},
    ["Kenma Kozume"] = {path = "materials/character/kenmanew.png", size = {420, 594}},
}

local selectedCharacterIndex = 1


--print("this is cl is working fine ")
local FirstFrame = vgui.Create("DFrame") 
FirstFrame:SetSize(1366,768)
FirstFrame:SetTitle("This gamemode is created by Hope")    
FirstFrame:SetVisible(true) 
FirstFrame:SetBackgroundBlur( true )
FirstFrame:ShowCloseButton(true) 
FirstFrame:Center()  
FirstFrame:MakePopup(true)
FirstFrame.Paint = function( self, w, h ) -- 'function Frame:Paint( w, h )' works too
draw.RoundedBox( 0, 0, 0, w, h, Color( 255,255,255,255) ) -- Draw a black box instead of the frame
end

function FirstFrame:Init() 
	self.startTime = SysTime() 
end    
function FirstFrame:Paint() 
	Derma_DrawBackgroundBlur( self, self.startTime ) 
end
 
local StartButton = vgui.Create( "DButton", FirstFrame ) 
StartButton:Dock(FILL)
StartButton:SetText("Press Anywhere")  
StartButton:SetTextColor(Color(255,255,255))  
StartButton:DockMargin( 0, 50 , 0, 0 )
StartButton:SetFont("Big2") 
StartButton.Paint = function( self, w, h ) -- 'function Frame:Paint( w, h )' works too
draw.RoundedBox( 0, 0, 0, w, h, Color( 0,0,0,0) )    
end

local pinkblackText = vgui.Create( "DButton", FirstFrame ) 
pinkblackText:Dock(BOTTOM)
pinkblackText:SetText("If you experience purple & black texture click here and rejoin")  
pinkblackText:SetTextColor(Color(255,255,255))  
pinkblackText:DockMargin( 0, 50 , 0, 0 )
pinkblackText:SetFont("Trebuchet24") 
pinkblackText.Paint = function( self, w, h ) -- 'function Frame:Paint( w, h )' works too
draw.RoundedBox( 0, 0, 0, w, h, Color( 232,33,33,88) )    
end
pinkblackText.DoClick = function()
	--sound3:Stop()
	gui.OpenURL( "https://steamcommunity.com/workshop/filedetails/?id=1933957019" )
end

local hide = {
	["CHudHealth"] = true,
	["CHudBattery"] = true
}

hook.Add( "HUDShouldDraw", "HideHUD", function( name )
	if ( hide[ name ] ) then return false end

	-- Don't return anything here, it may break other addons that rely on this hook.
end ) 

function StartButton:DoClick()

	FirstFrame:Close()
	CreateCharacterSelectMenu() 
end 

-- Function to create the character selection menu
function CreateCharacterSelectMenu()

    menuOpen = true

    surface.PlaySound("inventorymusic.mp3")

    //surface.PlaySound("engine2.mp3")
    -- Create the main frame
    local frame = vgui.Create("DFrame")
    frame:SetTitle("Character Selection")
    frame:SetSize(ScrW(), ScrH())
    frame:Center()
    frame:ShowCloseButton(false)
    frame:MakePopup()
    frame.OnClose = function()
        LocalPlayer():ConCommand("stopsound")
        menuOpen = false
    end
    frame.Paint = function( self, w, h ) -- 'function Frame:Paint( w, h )' works too
        draw.RoundedBox( 0, 0, 0, w, h, Color( 255,255,255,0) ) -- Draw a black box instead of the frame
    end
    
    function frame:Init() 
        self.startTime = SysTime() 
    end    
    function frame:Paint() 
        Derma_DrawBackgroundBlur( self, self.startTime ) 
    end


     -- Position the buttons below the title
    local buttonWidth = 150
    local buttonHeight = 30
    local buttonSpacing = 20 -- Space between the two buttons

    -- Green Team Button
    greenTeamButton = vgui.Create("DButton", frame)
    greenTeamButton:SetText("Red Team")
    greenTeamButton:SetFont("Trebuchet24")
    greenTeamButton:SetVisible(false)
    greenTeamButton:SetSize(buttonWidth, buttonHeight)
    greenTeamButton:SetPos(frame:GetWide() / 2 - buttonWidth - buttonSpacing / 2, 110)
    greenTeamButton:SetTextColor(Color(255, 255, 255))
    greenTeamButton.Paint = function(self, w, h)
        draw.RoundedBox(8, 0, 0, w, h, Color(255, 0, 0))
    end

    function greenTeamButton:DoClick() 
        frame:Close()
        menuOpen = false
        LocalPlayer():ConCommand("stopsound")
        net.Start("changeteam")
        net.WriteString("red") //red
        net.WriteString(character)
        net.SendToServer() 
    end 

    -- Blue Team Button
    blueTeamButton = vgui.Create("DButton", frame)
    blueTeamButton:SetText("Blue Team")
    blueTeamButton:SetFont("Trebuchet24")
    blueTeamButton:SetSize(buttonWidth, buttonHeight)
    blueTeamButton:SetVisible(false)
    blueTeamButton:SetPos(frame:GetWide() / 2 + buttonSpacing / 2, 110)
    blueTeamButton:SetTextColor(Color(255, 255, 255))
    blueTeamButton.Paint = function(self, w, h)
        draw.RoundedBox(8, 0, 0, w, h, Color(0, 0, 255))
    end

    function blueTeamButton:DoClick() 
        frame:Close()
        menuOpen = false
        LocalPlayer():ConCommand("stopsound")
        net.Start("changeteam")
        net.WriteString("blue") //blue
        net.SendToServer() 
    end 

    -- Add the Discord icon button
    local discordIcon = vgui.Create("DImageButton", frame)
    discordIcon:SetSize(50, 50) -- Size of the Discord icon
    discordIcon:SetImage("materials/discord.png") -- Set your Discord icon image path
    discordIcon:SetPos(frame:GetWide() - 148, frame:GetTall() - 74) -- Position it in the bottom-right corner

    -- Function to open the Discord link when clicked
    discordIcon.DoClick = function()
        gui.OpenURL("https://discord.com/invite/RpAARAqgBp") -- Replace with your Discord link
    end

    -- Add the YouTube icon button next to Discord
    local youtubeIcon = vgui.Create("DImageButton", frame)
    youtubeIcon:SetSize(50, 50) -- Size of the YouTube icon
    youtubeIcon:SetImage("materials/youtube.png") -- Set your YouTube icon image path
    youtubeIcon:SetPos(frame:GetWide() - 74, frame:GetTall() - 74) -- Position it next to Discord

    -- Function to open the YouTube link when clicked
    youtubeIcon.DoClick = function()
        gui.OpenURL("https://www.youtube.com/@speed_hacks1337") -- Replace with your YouTube link
    end

    

    -- Create the panel to display the selected character's image
    local charPanel = vgui.Create("DPanel", frame)
    charPanel:SetSize(ScrW(), ScrH() * 0.6)
    charPanel:SetPos(0, ScrH() * 0.2)
    charPanel:SetBackgroundColor(Color(50, 50, 50, 200)) 

    local background_image = vgui.Create("DImage", charPanel) 
	background_image:SetSize(ScrW(),ScrH())
	background_image:SetImage("materials/court.png") 
	background_image:SetImageColor(Color(255, 255, 255,80))

    -- Label to show the character's name at the top
    local charLabel = vgui.Create("DLabel", frame)
    charLabel:SetFont("LargeCharacterTitle")
    charLabel:SetText(characters[selectedCharacterIndex])
    charLabel:SetTextColor(Color(255, 255, 255))
    charLabel:SizeToContents()
    charLabel:SetPos((ScrW() - charLabel:GetWide()) / 2, ScrH() * 0.05) 

    -- Image to display the selected character
    local hinata = vgui.Create("DImage", charPanel)
    hinata:SetSize(100, 100) -- Start with a small size
    hinata:SetPos((charPanel:GetWide() - hinata:GetWide()) / 2, (charPanel:GetTall() - hinata:GetTall()) / 2)
    hinata:SetAlpha(0) -- Start with the image hidden

    -- Function to animate the image pop-up
    local function AnimateImagePopUp()
        local charData = characterImages[characters[selectedCharacterIndex]]
        
        -- Set new image path
        hinata:SetImage(charData.path)
        
        -- Initialize with a small size
        local initialSize = 300
        hinata:SetSize(initialSize, initialSize)
        hinata:SetPos((charPanel:GetWide() - initialSize) / 2, (charPanel:GetTall() - initialSize) / 2) -- Center the small image
        hinata:SetAlpha(0) -- Start with transparent

        -- Animation parameters
        local targetWidth, targetHeight = charData.size[1], charData.size[2]
        local scaleUp = 0
        local fadeIn = 0
        
        -- Timer for animation
        timer.Create("ImagePopUp", 0.01, 100, function()
            scaleUp = scaleUp + 20
            fadeIn = fadeIn + 10
            
            -- Calculate new size
            local newWidth = math.min(initialSize + scaleUp, targetWidth)
            local newHeight = math.min(initialSize + scaleUp, targetHeight)
            
            -- Set new size and position
            hinata:SetSize(newWidth, newHeight)
            hinata:SetPos((charPanel:GetWide() - newWidth) / 2, (charPanel:GetTall() - newHeight) / 2)
            
            -- Set alpha for fade-in
            hinata:SetAlpha(math.min(fadeIn, 255))
            
            -- End animation when the image reaches its final size and fully visible
            if newWidth >= targetWidth and newHeight >= targetHeight and fadeIn >= 255 then
                timer.Remove("ImagePopUp")
            end
        end)
    end


   -- Function to update the character label and image with animation
    local function UpdateCharacterDisplay()
        charLabel:SetText(characters[selectedCharacterIndex])
        charLabel:SizeToContents()
        charLabel:SetPos((ScrW() - charLabel:GetWide()) / 2, ScrH() * 0.05)
        
        selectedCharacter = characters[selectedCharacterIndex]
        -- Start the pop-up animation
        AnimateImagePopUp()
    end


    -- Initialize the display with the first character
    UpdateCharacterDisplay()

    -- Calculate positions for balanced Next and Back buttons
    local buttonYPos = ScrH() * 0.4 -- Vertical position of the buttons
    local buttonWidth, buttonHeight = 100, 100 -- Size of the buttons
    local buttonOffset = ScrW() * 0.3 -- Offset from the center

    -- Create the Back arrow button
    local backButton = vgui.Create("DButton", frame)
    backButton:SetText("")
    backButton:SetFont("Trebuchet24")
    backButton:SetImage("materials/hud/back_button.png")
    backButton:SetSize(buttonWidth, buttonHeight)
    backButton:SetPos((ScrW() / 2) - buttonOffset - (buttonWidth / 2), buttonYPos) -- Centered and balanced
    backButton.Paint = function(self, w, h)
        -- Set the background color to translucent black
        surface.SetDrawColor(0, 0, 0, 0)
        surface.DrawRect(0, 0, w, h)

        -- Draw the arrow icon in blue
        surface.SetDrawColor(0, 0, 255)
        surface.SetFont("Trebuchet24")
        local textWidth, textHeight = surface.GetTextSize("←")
        surface.SetTextPos((w - textWidth) / 2, (h - textHeight) / 2)
        surface.DrawText("←")
    end
    backButton.DoClick = function()
        selectedCharacterIndex = (selectedCharacterIndex - 2) % #characters + 1
        UpdateCharacterDisplay()
    end

    -- Create the Next arrow button
    local nextButton = vgui.Create("DButton", frame)
    nextButton:SetText("")
    nextButton:SetFont("Trebuchet24")
    nextButton:SetImage("materials/hud/next_button.png")
    nextButton:SetSize(buttonWidth, buttonHeight)
    nextButton:SetPos((ScrW() / 2) + buttonOffset - (buttonWidth / 2), buttonYPos) -- Centered and balanced
    nextButton.Paint = function(self, w, h)
        -- Set the background color to translucent black
        surface.SetDrawColor(0, 0, 0, 0)
        surface.DrawRect(0, 0, w, h)

        -- Draw the arrow icon in blue
        surface.SetDrawColor(0, 0, 255)
        surface.SetFont("Trebuchet24")
        local textWidth, textHeight = surface.GetTextSize("→")
        surface.SetTextPos((w - textWidth) / 2, (h - textHeight) / 2)
        surface.DrawText("→")
    end
    nextButton.DoClick = function()
        surface.PlaySound("click.wav")
        selectedCharacterIndex = (selectedCharacterIndex % #characters) + 1
        UpdateCharacterDisplay()
    end


    -- Create the Choose button
    local chooseButton = vgui.Create("DButton", frame)
    chooseButton:SetSize(ScrW() * 0.15, ScrH() * 0.07) -- Button size
    chooseButton:SetPos((ScrW() - chooseButton:GetWide()) / 2, ScrH() * 0.9) -- Centered horizontally and placed lower on the screen
    chooseButton:SetText("Choose")
    chooseButton:SetTextColor(Color(255,255,255))
    chooseButton:SetFont("Trebuchet24")
    -- Style the Choose button
    chooseButton.Paint = function(self, w, h)
        -- Set the background color to a solid or translucent color
        surface.SetDrawColor(0, 149, 241, 235) -- Black with 200 alpha for translucency
        surface.DrawRect(0, 0, w, h)
    end

  -- Map each character to their stats
local characterStats = {
    ["Hinata Shoyo"] = {Speed = 100, Power = 70, Jump = 90},
    ["Kageyama Tobio"] = {Speed = 75, Power = 60, Jump = 70},
    ["Sakusa Kiyoomi"] = {Speed = 70, Power = 70, Jump = 80},
    ["Kotaro Bokuto"] = {Speed = 70, Power = 77, Jump = 80},
    ["Tetsuro Kuro"] = {Speed = 70, Power = 70, Jump = 80},
    ["Atsumu Miya"] = {Speed = 75, Power = 60, Jump = 70},
    ["Ushijima Wakatoshi"] = {Speed = 75, Power = 100, Jump = 80},
    ["Yamaguchi Tadashi"] = {Speed = 65, Power = 70, Jump = 65},
    ["Tsukishima Kei"] = {Speed = 70, Power = 70, Jump = 65},
    ["Hoshiumi Korai"] = {Speed = 70, Power = 75, Jump = 100},
    ["Kenma Kozume"] = {Speed = 75, Power = 65, Jump = 70},
}

    -- Function to create an animated progress bar (adjusted for selected character)
    local function CreateStatBar(statName, statValue, yPos, parent)
        local label = vgui.Create("DLabel", parent)
        label:SetText(statName)
        label:SetFont("Trebuchet24")
        label:SizeToContents()
        label:SetPos(50, yPos)

        local progressBar = vgui.Create("DPanel", parent)
        progressBar:SetSize(300, 20)
        progressBar:SetPos(50, yPos + 30)

        local currentWidth = 0
        local targetWidth = 3 * statValue -- Scale the value to fit the progress bar width

        progressBar.Paint = function(self, w, h)
            surface.SetDrawColor(0, 0, 0, 150)
            surface.DrawRect(0, 0, w, h)
            surface.SetDrawColor(255, 85, 0)
            surface.DrawRect(0, 0, currentWidth, h)
        end

       -- Animate the progress bar
        local animationSpeed = 2.5 -- Increase this value to speed up the animation

        timer.Create("ProgressBarAnimation" .. statName, 0.01, targetWidth / animationSpeed, function()
            currentWidth = currentWidth + animationSpeed
            if currentWidth >= targetWidth then
                currentWidth = targetWidth -- Ensure it doesn't exceed the target
                timer.Remove("ProgressBarAnimation" .. statName)
            end
        end)
    end

    -- Function to update the character stats in the pop-up
    local function UpdateCharacterStats(popupFrame)
        local yPos = 50
        local selectedStats = characterStats[characters[selectedCharacterIndex]]
        
        for statName, statValue in pairs(selectedStats) do
            CreateStatBar(statName, statValue, yPos, popupFrame)
            yPos = yPos + 80 -- Adjust vertical spacing between bars
        end
    end

    chooseButton.DoClick = function()
        -- Create the pop-up frame
        local popupFrame = vgui.Create("DFrame")
        popupFrame:SetTitle("Character Stats")
        popupFrame:SetSize(400, 600)
        popupFrame:Center()
        popupFrame:SetVisible(true)
        popupFrame:ShowCloseButton(true)
        popupFrame:SetDraggable(true)
        popupFrame:MakePopup()
        popupFrame.Paint = function( self, w, h ) -- 'function Frame:Paint( w, h )' works too
            draw.RoundedBox( 0, 0, 0, w, h, Color( 0,0,0,203) ) -- Draw a black box instead of the frame
        end

        function popupFrame:Init() 
            self.startTime = SysTime() 
        end    
        function popupFrame:Paint() 
            Derma_DrawBackgroundBlur( self, self.startTime ) 
        end


        -- Pop-up animation (fade and move up)
        popupFrame:SetPos(ScrW() / 2 - popupFrame:GetWide() / 2, ScrH())
        popupFrame:MoveTo(ScrW() / 2 - popupFrame:GetWide() / 2, ScrH() / 2 - popupFrame:GetTall() / 2, 0.5, 0, 1)

        -- Update the stats based on the selected character
        UpdateCharacterStats(popupFrame)

        -- Positioning skill_desc at the bottom of popupFrame
        local skill_desc = vgui.Create("DLabel", popupFrame)
        skill_desc:SetSize(360, 180) -- Adjust size as needed
        skill_desc:SetText("A skilled spiker who excels thanks to his powerful jumping and running abilities.")
        skill_desc:SetTextColor(Color(255, 255, 255))
        skill_desc:SetWrap(true)
        skill_desc:SetFont("Trebuchet24")
        skill_desc:SetPos(20, popupFrame:GetTall() - 250) -- Adjust the 130 to move it higher

        skill_desc.Paint = function(self, w, h)
            draw.RoundedBox(0, 0, 0, w, h, Color(255, 255, 255, 0))
        end

        if selectedCharacter == "Hinata Shoyo" then 
            character = "hinata"
            skill_desc:SetText("Position: Middle Blocker\n\nA skilled spiker who excels thanks to his powerful jumping and running abilities.")
        elseif selectedCharacter == "Kageyama Tobio" then 
            character = "kageyama"
            skill_desc:SetText("Position: Setter\n\nA 'King' setter who can control the momentum of his sets, making it easier for spikers.")
        elseif selectedCharacter == "Sakusa Kiyoomi" then 
            character = "sakusa"
            skill_desc:SetText("Position: Wing Spiker\n\nCapable of curving his spikes with his natural wrist technique.")
        elseif selectedCharacter == "Kotaro Bokuto" then 
            character = "bokuto"
            skill_desc:SetText("Position: Wing Spiker\n\nPhysically strong with the ability to execute powerful cross shots") 
        elseif selectedCharacter == "Tetsuro Kuro" then 
            character = "kuro"
            skill_desc:SetText("Position: Middle Blocker\n\nAble to lean left or right to cover a larger blocking area when positioned.") 
        elseif selectedCharacter == "Atsumu Miya" then
            character = "miya" 
            skill_desc:SetText("Position: Setter\n\nA setter who can deliver a powerful jump serve.") 
        elseif selectedCharacter == "Ushijima Wakatoshi" then 
            character = "ushijima"
            skill_desc:SetText("Position: Wing Spiker\n\nCapable of delivering extraordinary spiking power.") 
        elseif selectedCharacter == "Yamaguchi Tadashi" then 
            character = "yamaguchi"
            skill_desc:SetText("Position: Middle Blocker/Pinch Server\n\nDespite lacking physical attributes, he can execute a float serve that makes the ball's landing unpredictable.")
        elseif selectedCharacter == "Tsukishima Kei" then 
            character = "tsukishima"
            skill_desc:SetText("Position: Middle Blocker\n\nAble to block with an extended coverage area.")
        elseif selectedCharacter == "Hoshiumi Korai" then 
            character = "korai"
            skill_desc:SetText("Position: Wing Spiker\n\nA highly versatile spiker who excels at setting and can achieve impressive height with a running approach.")
        elseif selectedCharacter == "Kenma Kozume" then 
            character = "kenma"
            skill_desc:SetText("Position: Setter\n\nA calm setter who can effortlessly dump the ball to the left or right whenever needed.")
        end 

        local confirm_button = vgui.Create("DButton", popupFrame)
        confirm_button:SetSize(360, 60) -- Adjust size as needed
        confirm_button:SetText("Confirm")
        confirm_button:SetTextColor(Color(255, 255, 255))
        confirm_button:SetFont("Trebuchet24")
        confirm_button:Dock(BOTTOM) -- Adjust the 130 to move it higher

        confirm_button.Paint = function(self, w, h)
            draw.RoundedBox(0, 0, 0, w, h, Color(0, 80, 240))
        end

        local function SetupCharacter()
            if character == "hinata" then
                SpikerSignal()
                chat.AddText(Color(255,0,0),"Press M to change char\nF2 for Thirdperson\nF1 for Character Tips")
                ClearHooks()
                MainFrame2:SetVisible(false)
                SwitchActionMode()
                SetSpikePowerByCharacter(character)
                SetJumpPowerByCharacter(character)
                ReceivePower(10)
                BasicServe()
                SpikerSignal()
                net.Start("character_select")
                net.WriteString("hinata")
                net.SendToServer()

            elseif character == "kageyama" then
                chat.AddText(Color(255,0,0),"Press M to change char\nF2 for Thirdperson\nF1 for Character Tips")
                chat.AddText(Color(188, 66, 245),"You have wider view because you are a setter!")
                ClearHooks()
                KageQuickTossHUD()
                KageFrontTossHUD()
                KageKingTossHUD()
                SwitchActionMode()
                SetSpikePowerByCharacter(character)
                SetJumpPowerByCharacter(character)
                ReceivePower(10)
                TossPower(10)
                BackTossPower(10)
                //KageFrontToss(10)
                KageQuickToss(10)
                KageKingToss(10)
                BasicServe()
                --BlockPower(10)
                SetterSignal()
                net.Start("character_select")
                net.WriteString("kage")
                net.SendToServer()

            elseif character == "sakusa" then
                hook.Remove("PlayerButtonDown","Ref",function(ply,button) end)
                chat.AddText(Color(255,0,0),"Press M to change char\nF2 for Thirdperson\nF1 for Character Tips")
                ClearHooks()
                SwitchActionMode()
                SetSpikePowerByCharacter(character)
                SetJumpPowerByCharacter(character)
                ReceivePower(10)
                SpikerSignal()
                SakusaAttack(1000)
                --BlockPower(10)
                BasicServe()

                net.Start("character_select")
                net.WriteString("sakusa")
                net.SendToServer()

            elseif character == "bokuto" then
                hook.Remove("PlayerButtonDown","Ref",function(ply,button) end)
                chat.AddText(Color(255,0,0),"Press M to change char\nF2 for Thirdperson\nF1 for Character Tips")
                ClearHooks()
                SwitchActionMode()
                SetSpikePowerByCharacter(character)
                SetJumpPowerByCharacter(character)
                SpikerSignal()
                ReceivePower(10)
                BokutoSpike(10)
                BasicServe()

                net.Start("character_select")
                net.WriteString("bokuto")
                net.SendToServer()

            elseif character == "kuro" then
                hook.Remove("PlayerButtonDown","Ref",function(ply,button) end)
                chat.AddText(Color(255,0,0),"Press M to change char\nF2 for Thirdperson\nF1 for Character Tips")
                ClearHooks()
                SwitchActionMode()
                SetSpikePowerByCharacter(character)
                SetJumpPowerByCharacter(character)
                ReceivePower(10)
                SpikerSignal()
                --BlockPower(10)
                BasicServe()
                MainFrame2:SetVisible(false)

                net.Start("character_select")
                net.WriteString("kuro")
                net.SendToServer()

            elseif character == "miya" then
                chat.AddText(Color(255,0,0),"Press M to change char\nF2 for Thirdperson\nF1 for Character Tips")
                chat.AddText(Color(188, 66, 245),"You have wider view because you are a setter!\nHold ALT for Setter's Signal")
                ClearHooks()
                KageQuickTossHUD()
                KageFrontTossHUD()
                MainFrame2:SetVisible(false)
                SwitchActionMode()
                SetSpikePowerByCharacter(character)
                SetJumpPowerByCharacter(character)
                ReceivePower(10)
                TossPower(10)
                KageQuickToss(10)
                BackTossPower(10)
                MiyaServe()
                BasicServe()
                --BlockPower(10)
                SetterSignal()
                net.Start("character_select")
                net.WriteString("miya")
                net.SendToServer()

            elseif character == "ushijima" then
                chat.AddText(Color(255,0,0),"Press M to change char\nF2 for Thirdperson\nF1 for Character Tips")
                ClearHooks()
                MainFrame2:SetVisible(false)
                SwitchActionMode()
                SetSpikePowerByCharacter(character)
                SetJumpPowerByCharacter(character)
                ReceivePower(10)
                SpikerSignal()
                --YamaguchiServe()
                BasicServe()
                --BlockPower(10)
                --TossPower(10)
                --BackTossPower(10)
                net.Start("character_select")
                net.WriteString("ushi")
                net.SendToServer()

            elseif character == "yamaguchi" then
                hook.Remove("PlayerButtonDown","Ref",function(ply,button) end)
                chat.AddText(Color(255,0,0),"Press M to change char\nF2 for Thirdperson\nF1 for Character Tips")
                ClearHooks()
                MainFrame2:SetVisible(false)
                SwitchActionMode()
                SetSpikePowerByCharacter(character)
                SetJumpPowerByCharacter(character)
                ReceivePower(10)
                YamaguchiServe()
                BasicServe()
                SpikerSignal()
                --BlockPower(10)
                --TossPower(10)
                --BackTossPower(10)
                net.Start("character_select")
                net.WriteString("yama")
                net.SendToServer()

            elseif character == "tsukishima" then
                hook.Remove("PlayerButtonDown","Ref",function(ply,button) end)
                chat.AddText(Color(255,0,0),"Press M to change char\nF2 for Thirdperson\nF1 for Character Tips")
                ClearHooks()
                SwitchActionMode()
                SetSpikePowerByCharacter(character)
                SetJumpPowerByCharacter(character)
                ReceivePower(10)
                SpikerSignal()
                --BlockPower(10)
                BasicServe()
                MainFrame2:SetVisible(false)

                net.Start("character_select")
                net.WriteString("tsuki")
                net.SendToServer()

            elseif character == "korai" then
                hook.Remove("PlayerButtonDown","Ref",function(ply,button) end)
                chat.AddText(Color(255,0,0),"Press M to change char\nF2 for Thirdperson\nF1 for Character Tips")
                ClearHooks()
                KageFrontTossHUD()
                SwitchActionMode()
                SetSpikePowerByCharacter(character)
                SetJumpPowerByCharacter(character)
                ReceivePower(10)
                SpikerSignal()
                BasicServe()
                -- ability
                //KoraiJumpBoost()
                --MiyaServe()
                TossPower(10)

                MainFrame2:SetVisible(false)

                net.Start("character_select")
                net.WriteString("korai")
                net.SendToServer()

            elseif character == "kenma" then
                	--CharPosition()
                chat.AddText(Color(255,0,0),"Press M to change char\nF2 for Thirdperson\nF1 for Character Tips")
                chat.AddText(Color(188, 66, 245),"You have wider view because you are a setter!")
                ClearHooks()
                KageQuickTossHUD()
                KageFrontTossHUD()
                MainFrame2:SetVisible(false)
                SwitchActionMode()
                SetSpikePowerByCharacter(character)
                SetJumpPowerByCharacter(character)
                ReceivePower(10)
                TossPower(10)
                BackTossPower(10)
                --KageFrontToss(10)
                KenmaDump(10)
                KageQuickToss(10)
                BasicServe()
                --BlockPower(10)
                SetterSignal()
                net.Start("character_select")
                net.WriteString("kenma")
                net.SendToServer()

            end
        end

        function confirm_button:DoClick()
            surface.PlaySound("confirm.mp3")
            frame:Close()
            popupFrame:Close()
            menuOpen = false

            //LocalPlayer():ConCommand("stopsound")

            -- Check if player already has a team
            if LocalPlayer():Team() == 1 or LocalPlayer():Team() == 2 then
                -- Player already has a team, skip team selection
                SetupCharacter()
            else
                -- Create team selection screen
                local teamPanel = vgui.Create("DPanel")
                teamPanel:SetSize(ScrW(), ScrH())
                teamPanel:SetPos(0, 0)
                teamPanel:SetBackgroundColor(Color(0, 0, 0, 200))
                teamPanel:MakePopup()

                local teamText = vgui.Create("DLabel", teamPanel)
                teamText:SetText("Choose Your Team")
                teamText:SetFont("Trebuchet24")
                teamText:SetTextColor(Color(255, 255, 255))
                teamText:SizeToContents()
                teamText:SetPos((ScrW() - teamText:GetWide()) / 2, ScrH() * 0.3)

                local redButton = vgui.Create("DButton", teamPanel)
                redButton:SetSize(200, 50)
                redButton:SetPos(ScrW() / 2 - 250, ScrH() / 2)
                redButton:SetText("Red Team")
                redButton:SetFont("Trebuchet24")
                redButton:SetTextColor(Color(255, 255, 255))
                redButton.Paint = function(self, w, h)
                    draw.RoundedBox(8, 0, 0, w, h, Color(255, 0, 0))
                end
                redButton.DoClick = function()
                    teamPanel:Remove()
                    local team = "red"
                    net.Start("changeteam")
                    net.WriteString(team)
                    net.WriteString(character)
                    net.SendToServer()
                    SetupCharacter()
                end

                local blueButton = vgui.Create("DButton", teamPanel)
                blueButton:SetSize(200, 50)
                blueButton:SetPos(ScrW() / 2 + 50, ScrH() / 2)
                blueButton:SetText("Blue Team")
                blueButton:SetFont("Trebuchet24")
                blueButton:SetTextColor(Color(255, 255, 255))
                blueButton.Paint = function(self, w, h)
                    draw.RoundedBox(8, 0, 0, w, h, Color(0, 0, 255))
                end
                blueButton.DoClick = function()
                    teamPanel:Remove()
                    local team = "blue"
                    net.Start("changeteam")
                    net.WriteString(team)
                    net.WriteString(character)
                    net.SendToServer()
                    SetupCharacter()
                end
            end
        end
        -- Table that maps each image path to its description
    local characterDescriptions = {
        ["materials/hud/spiker.png"] = "This character excels as an attacker",
        ["materials/hud/muscle.png"] = "This character relies on physical attributes",
        ["materials/hud/setter.png"] = "This character has setter controls",
        ["materials/hud/smart.png"] = "This character relies on skills",
        ["materials/hud/defender.png"] = "This character has a strong blocking ability",
        ["materials/hud/receive-specialist.png"] = "A receive specialist that have more controls",
        -- Add more descriptions as needed
    }

    local function ShowDescriptionPopup(parent, description)
        local descPopup = vgui.Create("DFrame")
        descPopup:SetSize(300, 100)
        descPopup:Center()  -- Center the DFrame in the parent
        descPopup:SetTitle("Description")
        descPopup:SetDraggable(true)
        descPopup:ShowCloseButton(true)
        descPopup:MakePopup()
    
        -- Create the description label
        local label = vgui.Create("DLabel", descPopup)
        label:SetText(description)
        label:SetFont("Trebuchet18")  -- Set font size as needed
        label:SizeToContents()
    
        -- Calculate position to center the label in the DFrame
        local frameWidth, frameHeight = descPopup:GetSize()
        local labelWidth, labelHeight = label:GetSize()
        label:SetPos((frameWidth - labelWidth) / 2, (frameHeight - labelHeight) / 2)
    
        -- Optionally add padding around the label if desired
        -- label:SetPos((frameWidth - labelWidth) / 2, (frameHeight - labelHeight) / 2 + 10)
    end

    -- Using the existing code structure
    local characterImages = {
        ["Hinata Shoyo"] = {
            additionalImages = {
                "materials/hud/spiker.png",
                "materials/hud/muscle.png",
            }
        },
        ["Kageyama Tobio"] = {
            additionalImages = {
                "materials/hud/setter.png",
                "materials/hud/smart.png",
            }
        },
        ["Sakusa Kiyoomi"] = {
            additionalImages = {
                "materials/hud/spiker.png",
                "materials/hud/smart.png",
            }
        },
        ["Kotaro Bokuto"] = {
            additionalImages = {
                "materials/hud/spiker.png",
                "materials/hud/muscle.png",
                "materials/hud/smart.png",
            }
        },
        ["Tetsuro Kuro"] = {
            additionalImages = {
                "materials/hud/spiker.png",
                "materials/hud/defender.png",
                "materials/hud/receive-specialist.png",
            }
        },
        ["Atsumu Miya"] = {
            additionalImages = {
                "materials/hud/setter.png",
                "materials/hud/smart.png",
            }
        },
        ["Ushijima Wakatoshi"] = {
            additionalImages = {
                "materials/hud/spiker.png",
                "materials/hud/muscle.png",
            }
        },
        ["Yamaguchi Tadashi"] = {
            additionalImages = {
                "materials/hud/spiker.png",
                "materials/hud/smart.png",
            }
        },
        ["Tsukishima Kei"] = {
            additionalImages = {
                "materials/hud/spiker.png",
                "materials/hud/defender.png",
            }
        },
        ["Hoshiumi Korai"] = {
            additionalImages = {
                "materials/hud/spiker.png",
                "materials/hud/setter.png",
                "materials/hud/muscle.png",
            }
        },
        ["Kenma Kozume"] = {
            additionalImages = {
                "materials/hud/setter.png",
                "materials/hud/smart.png",
            }
        },
        -- Add more characters as needed
    }

        -- Assuming selectedCharacterIndex is set
        local charData = characterImages[characters[selectedCharacterIndex]]
        local additionalImages = charData and charData.additionalImages or {}

        -- Add images below the stats, stacked horizontally
        local imageWidth, imageHeight = 60, 60 -- Example size for placeholder images
        local padding = 10
        local startX = (popupFrame:GetWide() - (3 * imageWidth + 2 * padding)) / 2
        local startY = popupFrame:GetTall() * 0.45

        for i, imgPath in ipairs(additionalImages) do
            local image = vgui.Create("DImageButton", popupFrame)
            image:SetSize(imageWidth, imageHeight)
            image:SetPos(startX + (i - 1) * (imageWidth + padding), startY)
            image:SetImage(imgPath)

            -- When the image is clicked, show a description
            function image:DoClick()
                local description = characterDescriptions[imgPath]
                if description then
                    ShowDescriptionPopup(popupFrame, description)
                else
                    print("No description available for this image.")
                end
            end
        end
    end 
end





hook.Add("PlayerButtonDown","openMenu",function(ply,button)
	if button == KEY_M then 
        if menuOpen == true then 

        else 
            CreateCharacterSelectMenu() 
            greenTeamButton:SetVisible(true)
            blueTeamButton:SetVisible(true)
        end 
	end 
end)

-- Open the character selection menu
concommand.Add("open_char_select", CreateCharacterSelectMenu)
