util.AddNetworkString("MusicPlayer_Play")
util.AddNetworkString("MusicPlayer_Stop")
util.AddNetworkString("MusicPlayer_Volume")

util.AddNetworkString("MusicPlayer_Play_cl")
util.AddNetworkString("MusicPlayer_Stop_cl")
util.AddNetworkString("MusicPlayer_Volume_cl")

util.AddNetworkString("verify_admin_sv")
util.AddNetworkString("verify_admin_cl")

print("test?")

//verify if admin 
net.Receive("verify_admin_sv", function(length, player)
    net.Start("verify_admin_cl")
    net.Send(player)
end)

//local function PlayMusic(musicPath)
net.Receive("MusicPlayer_Play",function(length, ply)
    local musicPath = net.ReadString()
    local djName = ply:Nick() 

    for k,v in pairs(player.GetAll()) do 
        v:ChatPrint("[DJ "..djName.."] playing ".. musicPath)
    end 

    if not musicPath then return end

    net.Start("MusicPlayer_Play_cl")
    net.WriteString(musicPath)
    net.Broadcast()
end)

net.Receive("MusicPlayer_Stop",function(ply,bits)
    for k,v in pairs(player.GetAll()) do 
        v:ChatPrint("[DJ "..v:Name().."] stopped the music")
    end 
    
    net.Start("MusicPlayer_Stop_cl")
    net.Broadcast()
end)

net.Receive("MusicPlayer_Volume", function() 
    local volume = net.ReadFloat() 

    net.Start("MusicPlayer_Volume_cl")
    net.WriteFloat(volume)
    net.Broadcast()
end)



concommand.Add("stop_music_player", StopMusic)
