--// HUD Code exported by Hope using Exho's HUD Designer //--
--// First Time Guide Gmod VB 2.0 Exported on Mon Apr  1 23:41:05 2024 //--

-- --Layer: 1
-- draw.RoundedBox(4, ScrW()/32, ScrH()/1.82, ScrW()/6.86, ScrH()/5.4, Color(52, 39, 241, 255))
-- draw.RoundedBox(4, ScrW()/1.45, ScrH()/9.39, ScrW()/6.86, ScrH()/5.4, Color(52, 39, 241, 255))

-- --Layer: 2
-- draw.RoundedBox(4, ScrW()/9.6, ScrH()/1.47, ScrW()/16, ScrH()/27, Color(225, 225, 225, 255))


-- --// End HUD Code //--

-- -- Function to create a popup with custom position and description
-- function CreatePopup(posX,posY, desc,url,buttonVisible)
--     surface.PlaySound("click.wav")
--     local frame = vgui.Create("DFrame")
--     frame:SetSize(300, 250)
--     frame:SetTitle("")
--     frame:SetPos(posX, posY)
--     frame:MakePopup()
 
--     local descLabel = vgui.Create("DLabel", frame)
--     descLabel:Dock(TOP)
--     descLabel:SetText(desc)
--     descLabel:SetWrap(true)
--     --descLabel:SetPos(10, 200)
--     descLabel:SetSize(280, 200)
--     descLabel:SetFont("ChatFont")

--     local okButton = vgui.Create("DButton", frame)
--     okButton:Dock(BOTTOM)
--     okButton:SetText("Watch tutorial video (Youtube)")
--     okButton:SetPos(100, 100)
--     okButton:SetSize(100, 30)
--     okButton:SetVisible(buttonVisible)
--     okButton.DoClick = function()
--         gui.OpenURL(url)
--     end
-- end


-- -- Function to create the DHTML panel
-- local function CreateDHTMLPanel(url, width, height)
--     -- Create a new DFrame
--     frame = vgui.Create("DFrame")
--     frame:SetSize(width, height)
--     frame:SetTitle("Web Viewer")
--     frame:SetVisible(true)
--     frame:Center()
--     frame:MakePopup()
--     frame:ShowCloseButton(true)

--     -- Create a DHTML panel inside the frame
--     local htmlPanel = vgui.Create("DHTML", frame)
--     htmlPanel:SetSize(width, height)
--     htmlPanel:Center()
--     htmlPanel:ShowCloseButton(true)

--     -- Load the specified URL into the DHTML panel
--     htmlPanel:OpenURL(url)
-- end

-- -- Example usage:
-- -- Create a DHTML panel with a given URL, width, and height
-- local url = "https://www.youtube.com/playlist?list=PL8wEWXFbXJ6YC3aOkUkfJBxzYStreoaul"
-- local width = 1366
-- local height = 768
-- timer.Simple(3,function() CreateDHTMLPanel(url, width, height) end)



-- Example usage
--CreatePopup(ScrW()/9.6, ScrH()/1.47, "This panel is to adjust your power level for both spiking and receiving, simply press KEY_1 to set the power and KEY_2 to select the mode.\n\nTo test, press/hold KEY_V to receive, \nMOUSE_LEFT to spike while jumping.","https://example.com")

--CreatePopup(ScrW()/9.6, ScrH()/1.47, "You can learn the controls here, F3 to hide/show. For more tutorial visit (url)","https://example.com")
