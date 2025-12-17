
local musicFiles = {
    {
        path = "music/lofi.mp3",
        category = "Chill Lofi",
    },
    {
        path = "music/hypekumix.mp3",
        category = "Haikyuu",
    },
}



local function PlayMusicClient(musicPath, volume)
    if LocalPlayer().musicStation then
        LocalPlayer().musicStation:Stop()
    end

    local musicPath = net.ReadString() 
    print(musicPath)
    LocalPlayer().musicStation = CreateSound( game.GetWorld(), musicPath)
    if LocalPlayer().musicStation then
        LocalPlayer().musicStation:SetSoundLevel( 0 ) -- play everywhere
        LocalPlayer().musicStation:PlayEx(0.4, 100)
        //LocalPlayer().musicStation:Play()
    end
end




net.Receive("MusicPlayer_Play_cl", function()
    //local musicPath = net.ReadString() 
    //local playerName = net.ReadString() 

    PlayMusicClient(musicPath, volume)
    //chat.AddText(Color(183, 128, 255),"[DJ "..playerName.."] playing ".. musicPath)
end)

net.Receive("MusicPlayer_Volume_cl", function() 
    local volume = net.ReadFloat() 

    if LocalPlayer().musicStation then
         LocalPlayer().musicStation:ChangeVolume( volume, 0 )
    end 
end)


net.Receive("MusicPlayer_Stop_cl", function() 
    if LocalPlayer().musicStation then
        LocalPlayer().musicStation:Stop()
    end 
end)

local function OpenMusicPlayer()
    local frame = vgui.Create("DFrame")
    frame:SetSize(300, 300)
    frame:SetTitle("Music Player")
    frame:SetVisible(true)
    frame:SetDraggable(true)
    frame:ShowCloseButton(true)
    frame:MakePopup() 
    frame:Center()
    function frame:Paint(w, h)
        draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 200)) 
    end

    local songList  = vgui.Create("DListView", frame)
    songList :SetSize(155, 150)
    songList :SetPos(140, 30)
    songList :AddColumn("Song Title")

    local categoryList = vgui.Create("DListView", frame)
    categoryList:SetSize(120, 150)
    categoryList:SetPos(5, 30)
    categoryList:AddColumn("Categories")
    local categoriesAdded = {} -- Table to store added categories

   for _, musicFile in ipairs(musicFiles) do
        if not categoriesAdded[musicFile.category] then
            categoryList:AddLine(musicFile.category)
            categoriesAdded[musicFile.category] = true -- Mark category as added
        end
    end

    categoryList.OnClickLine = function(parent, line, isselected)
        local selectedCategory = line:GetValue(1)
        songList:Clear()

        for _, musicFile in ipairs(musicFiles) do
            if musicFile.category == selectedCategory then
                local songTitle = string.match(musicFile.path, "^.+/(.-)%..-$")
                songList:AddLine(songTitle).musicPath = musicFile.path
            end
        end
    end

    songList.OnClickLine = function(parent, line, isselected)
        print(isselected)
        //stop prev song before start new one. 
        if LocalPlayer().musicStation then
            LocalPlayer().musicStation:Stop()
        end 
        net.Start("MusicPlayer_Play")
        net.WriteString(line.musicPath)
        net.SendToServer()
    end

    local stopButton = vgui.Create("DButton", frame)
    stopButton:SetPos(100, 200)
    stopButton:SetSize(100, 20)
    stopButton:SetText("Stop Music")
    stopButton:DockMargin(0, 0, 0, 0)
    stopButton.DoClick = function()
        net.Start("MusicPlayer_Stop")
        net.SendToServer()
    end

    local volumeSlider = vgui.Create("DNumSlider", frame)
    volumeSlider:SetPos(10, 220)
    volumeSlider:SetSize(280, 40)
    volumeSlider:SetText("Volume")
    volumeSlider:SetMin(0.1)
    volumeSlider:SetMax(1)
    volumeSlider:SetDecimals(2)
    volumeSlider:SetValue(0.4) -- Set default volume to 1.0 (full volume)
    volumeSlider.OnValueChanged = function(self, value)
        net.Start("MusicPlayer_Volume")
        net.WriteFloat(value)
        net.SendToServer()
    end


    frame:MakePopup()
end



local function PlayMusicClient(musicPath)
    if not musicPath then return end

    if LocalPlayer().musicStation then
        LocalPlayer().musicStation:Stop()
    end

    LocalPlayer().musicStation = CreateSound(LocalPlayer(), musicPath)
    LocalPlayer().musicStation:Play()
end

local function StopMusicClient()
    if LocalPlayer().musicStation then
        LocalPlayer().musicStation:Stop()
    end
end

net.Receive("MusicPlayer_Play", function()
    local musicPath = net.ReadString()
    PlayMusicClient(musicPath)
end)

net.Receive("MusicPlayer_Stop", function()
    StopMusicClient()
end)

local music_open = false  
hook.Add("PlayerButtonDown","OpenMusic",function(ply,button) 
    if button == KEY_P then
        if music_open == false then  
            music_open = true
            net.Start("verify_admin_sv")
            net.SendToServer() 
           -- OpenMusicPlayer()
            timer.Simple(1.5,function() music_open = false end)
        end  
    end 
end) 

net.Receive("verify_admin_cl", function()
    OpenMusicPlayer()
    timer.Simple(1.5,function() music_open = false end)
end)
