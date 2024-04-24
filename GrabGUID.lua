-- Delayed print function
local function DelayedPrint(message, delay)
    C_Timer.After(delay, function()
        print(message)
    end)
end

-- System message with delay
DelayedPrint("|cffffff00[Grab GUID]|r loaded. Use |cff00ff00/gg|r or |cff00ff00/grabguid|r to bring up Grab GUID frame.", 2)

-- Create the main frame
local mainFrame = CreateFrame("Frame", "GrabGUID_MainFrame", UIParent, "BasicFrameTemplate")
mainFrame:SetSize(240, 100)
mainFrame:SetPoint("CENTER")
mainFrame:SetMovable(true)
mainFrame:EnableMouse(true)
mainFrame:RegisterForDrag("LeftButton")
mainFrame:SetScript("OnDragStart", mainFrame.StartMoving)
mainFrame:SetScript("OnDragStop", mainFrame.StopMovingOrSizing)
mainFrame:Hide()  -- Hide the main frame by default

-- Function to grab target's GUID or offline player's GUID
local function GrabGUID()
    local targetGUID = UnitGUID("target")
    local targetName = UnitName("target")
    local inputName = mainFrame.infoBox:GetText()
    
    if targetGUID and targetName then
        print("|cffffff00[Grab GUID]|r Checking for player information...")
        print("|cffffcc00Player GUID:|r |cff00ff00" .. targetGUID .. " - " .. targetName .. "|r")
        mainFrame.infoBox:SetText(targetGUID .. " - " .. targetName)
    elseif inputName ~= "" then
        local friendInfo = C_FriendList.GetFriendInfo(inputName)
        if friendInfo then
            print("|cffffff00[Grab GUID]|r Checking for player information...")
            print("|cffffcc00Player GUID:|r |cff00ff00" .. friendInfo.guid .. " - " .. inputName .. "|r")
            mainFrame.infoBox:SetText(friendInfo.guid .. " - " .. inputName)
        else
            print("|cffffff00[Grab GUID]|r Checking for player information...")
            print("|cffffff00[Grab GUID]|r |cffffcc00No player found with the name '" .. inputName .. "'. Adding to friend list to check.")
            -- Add player to friend list
            C_FriendList.AddFriend(inputName)
            
            -- Retrieve player's GUID after a delay
            C_Timer.After(2, function()
                friendInfo = C_FriendList.GetFriendInfo(inputName)
                if friendInfo then
                    print("|cffffff00[Grab GUID]|r Checking for player information...")
                    print("|cffffcc00Player GUID:|r |cff00ff00" .. friendInfo.guid .. " - " .. inputName .. "|r")
                    mainFrame.infoBox:SetText(friendInfo.guid .. " - " .. inputName)
                else
                    print("|cffffff00[Grab GUID]|r |cffff0000No player found with the name '" .. inputName .. "'. Please check the name or try again later.")
                end
                
                -- Remove player from friend list
                C_FriendList.RemoveFriend(inputName)
            end)
        end
    else
        print("|cffffff00[Grab GUID]|r |cffff0000No target or player found, please select your target or input correct name into the box.|r")
    end
end

-- Create the text label for the main frame
mainFrame.label = mainFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
mainFrame.label:SetPoint("TOPLEFT", mainFrame, "TOPLEFT", 17, -5)
mainFrame.label:SetText("Select target or input player name here:")

-- Create the edit box for the main frame
mainFrame.infoBox = CreateFrame("EditBox", "GrabGUID_MainEditBox", mainFrame, "InputBoxTemplate")
mainFrame.infoBox:SetSize(198, 30) 
mainFrame.infoBox:SetPoint("TOPLEFT", mainFrame.label, "BOTTOMLEFT", 5, -10)
mainFrame.infoBox:SetAutoFocus(false)
mainFrame.infoBox:SetFontObject(GameFontHighlightSmall)
mainFrame.infoBox:SetTextInsets(0, 0, 0, 0)
mainFrame.infoBox:SetCursorPosition(0)
mainFrame.infoBox:SetMaxLetters(100)

-- Create the button for grabbing target's GUID or offline player's GUID
mainFrame.grabButton = CreateFrame("Button", "GrabGUID_Button", mainFrame, "UIPanelButtonTemplate")
mainFrame.grabButton:SetSize(110, 25) 
mainFrame.grabButton:SetPoint("BOTTOM", mainFrame, "BOTTOM", 0, 15)
mainFrame.grabButton:SetText("Grab GUID")
mainFrame.grabButton:SetScript("OnClick", GrabGUID)

-- Register slash commands
SLASH_GRABGUID1 = "/grabguid"
SlashCmdList["GRABGUID"] = function() 
    if mainFrame:IsShown() then 
        mainFrame:Hide() 
    else 
        mainFrame:Show() 
    end 
end

SLASH_GG1 = "/gg"
SlashCmdList["GG"] = function() 
    if mainFrame:IsShown() then 
        mainFrame:Hide() 
    else 
        mainFrame:Show() 
    end 
end
