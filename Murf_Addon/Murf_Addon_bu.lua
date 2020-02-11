--DEFAULT_CHAT_FRAME:AddMessage("Hail "..UnitName("player").."! Type \'|cFFFFFF33/murf on|r\' or \'|cFFFFFF33/murf off|r\' to enable/disable kill stats.",1,.75,.18)

--local MyFrame = CreateFrame("Frame",nil,UIParent)
local flag = true
local count = 0
local lTime = GetTime()
local prevTime = 0
local xp = UnitXP("player")
local xpPrev = 0
local xpMax = UnitXPMax("player")

--MyFrame:AddMessage("Time is "..lTime,1,0,1)


--WelcomeHome = LibStub("AceAddon-3.0"):NewAddon("WelcomeHome", "AceConsole-3.0")
--WelcomeHome = LibStub("AceAddon-3.0"):NewAddon("WelcomeHome", "AceConsole-3.0", "AceEvent-3.0")
MyAddon = LibStub("AceAddon-3.0"):NewAddon("OmegaSTATS", "AceConsole-3.0")
MyAddon:Print(string.format("Hail "..UnitName("player").."! Type \'|cFFFFFF33/gs|r\' to toggle STATS"))

--MyFrame:RegisterEvent("PLAYER_XP_UPDATE")
--MyFrame:SetScript("OnEvent",
--    function(self, event, ...)
--	    local arg1 = ...
		--xpPrev = xp
		--xp = UnitXP("player")
		--xpMax = UnitXPMax("player")
		--                         xpRemain / xpEarned
		--local mobKillCount = ceil((xpMax-xp)/(xp-xpPrev))
		
		--prevTime = lTime
		--lTime = GetTime()
		--local tDiff = lTime - prevTime
		--local secTillLevel = tDiff * mobKillCount
		--local minTillLevel = secTillLevel / 60
		--local hrTillLevel = minTillLevel / 60
		--count = count + 1
		--local percentDone = (count * 100)/(count + mobKillCount)
		
--		if flag == true then
			--local kcountmsg = string.format("Killed |cFFFFFF33%d|r (|cFF00FFFF%.2f seconds|r).",count,tDiff)
			--local ktimemsg = string.format(" Kill |cFFFFFF33%d (%.1f%%)|r more (|cFF00FFFF%.2f hours|r) till next level.",mobKillCount,percentDone,hrTillLevel)
			--DEFAULT_CHAT_FRAME:AddMessage(kcountmsg..ktimemsg,1,.75,.18)			
--		end
--	end)
	
SLASH_MURF1 = "/murf"
SLASH_MURF2 = "/moyf"
function SlashCmdList.MURF(msg)
	if string.lower(msg) == "on" then 
		DEFAULT_CHAT_FRAME:AddMessage("<murf stats ON>",1,.75,.18)
		flag = true
	elseif string.lower(msg) == "off" then
		DEFAULT_CHAT_FRAME:AddMessage("<murf stats OFF>",1,.75,.18)
		flag = false
	elseif string.lower(msg) == "reset" then
		DEFAULT_CHAT_FRAME:AddMessage("<count RESET>",1,.75,.18)
		count = 0
	else
		DEFAULT_CHAT_FRAME:AddMessage("<command not recognized>",1,.75,.18)
	end
end

-- #####################################################
-- Storage variables
local Stats1Value = 0
local Stats2Value = 0
local Stats3Value = 0

-- A function for creating display strings
local function DisplayString(parent)
	local f = parent:CreateFontString(nil, "OVERLAY")
	f:SetFont("Fonts/ARIALN.TTF", 12)
	f:SetJustifyH("LEFT")
	f:SetJustifyV("TOP")
	return f
end

-- Create a basic frame you can drag around the screen
local f = CreateFrame("Frame", "GreyhavenStats", UIParent)
f:SetBackdrop({ bgFile = "Interface/DialogFrame/UI-DialogBox-Background-Dark", edgeFile = "", tile = true, edgeSize = 32, tileSize = 32, insets = { left = 0, right = 0, top = 0, bottom = 0, 	}, })
f:SetSize(200, 100) -- adjust the size as required.
f:SetPoint("LEFT", 20, 0)
f:SetMovable(true)
f:SetClampedToScreen(true)
f:EnableMouse(true)
f:RegisterForDrag("LeftButton") 
f:SetUserPlaced()
f:SetScript("OnDragStart", function(self) self:StartMoving() end) 
f:SetScript("OnDragStop", function(self) self:StopMovingOrSizing() end)

-- Add a close button if you like
--                   (frametype, framename, parentframe, inheritsframe)
f.close = CreateFrame("Button", "$parentClose", f, "UIPanelCloseButton")
f.close:SetSize(24, 24)
f.close:SetPoint("TOPRIGHT")
f.close:SetScript("OnClick", function(self) self:GetParent():Hide() end)

-- Experiment adding a reset button
f.reset = CreateFrame("Button", "ResetButton", f, "UIPanelButtonTemplate")
f.reset:SetSize(60,24)
f.reset:SetPoint("BOTTOMLEFT")
f.reset:SetText("Reset")
f.reset:SetScript("OnClick", function(self) 
		MyAddon:Print("Count Reset") 
		count = 0 
	end)


-- Place some display strings.
f.Title = DisplayString(f)
f.Title:SetTextColor(0.5, 0.5, 0.5)
f.Title:SetPoint("TOPLEFT", 3, -3)
f.Title:SetPoint("TOPRIGHT", -3, -3)

f.Stats1 = DisplayString(f)
f.Stats1:SetPoint("TOPLEFT", f.Title, "BOTTOMLEFT", 0, -5)
f.Stats1:SetPoint("TOPRIGHT", f.Title, "BOTTOMRIGHT", 0, -5)

f.Stats2 = DisplayString(f)
f.Stats2:SetTextColor(1, 1, 0)
f.Stats2:SetPoint("TOPLEFT", f.Stats1, "BOTTOMLEFT", 0, -4)
f.Stats2:SetPoint("TOPRIGHT", f.Stats1, "BOTTOMRIGHT", 0, -4)

f.Stats3 = DisplayString(f)
f.Stats3:SetTextColor(0, 1, 0)
f.Stats3:SetPoint("TOPLEFT", f.Stats2, "BOTTOMLEFT", 0, -4)
f.Stats3:SetPoint("TOPRIGHT", f.Stats2, "BOTTOMRIGHT", 0, -4)

-- Add Some default text
f.Title:SetText("          OmegaSTATS")
f.Stats1:SetText("Kill Count")
f.Stats2:SetText("Kills Remaing")
f.Stats3:SetText("Time Remaining")

-- An event handler to update the display strings
f:SetScript("OnEvent", function(self, event, ...)
	if event == "PLAYER_XP_UPDATE" then
		xpPrev = xp
		xp = UnitXP("player")
		xpMax = UnitXPMax("player")
		--                         xpRemain / xpEarned
		local mobKillCount = ceil((xpMax-xp)/(xp-xpPrev))
		prevTime = lTime
		lTime = GetTime()
		local tDiff = lTime - prevTime
		
		local tDiff = lTime - prevTime
		local secTillLevel = tDiff * mobKillCount
		local minTillLevel = secTillLevel / 60
		local hrs = math.floor(minTillLevel / 60)
		local mins = math.ceil(minTillLevel % 60)
		count = count + 1
		local percentDone = (count * 100)/(count + mobKillCount)
		
		self.Stats1:SetText(string.format("Killed |cFFFFFF33%d|r. Last kill took |cFF00FFFF%.2f seconds|r.",count,tDiff))
		self.Stats2:SetText(string.format("Kill |cFFFFFF33%d (%.1f%%)|r more",mobKillCount,percentDone))
		self.Stats3:SetText(string.format("(|cFF00FFFF%.0f hours %.0f minutes|r) till next level.",hrs, mins))
	elseif event == "EVENT_FOR_STATS2" then
		Stats2Value = Stats1Value + 10
	elseif event == "EVENT_FOR_STATS3" then
		Stats3Value = Stats1Value + 15
	end
	
end)

-- Register the event(s) to listen for to update the stats.
f:RegisterEvent("PLAYER_XP_UPDATE")
--f:RegisterEvent("EVENT_FOR_STATS2")
--f:RegisterEvent("EVENT_FOR_STATS2")


-- Create a slash command to show/hide the frame
SLASH_GREAYHAVENSTATS1 = "/gs"
SlashCmdList["GREAYHAVENSTATS"] = function(msg)	
	f:SetShown(not f:IsShown())
end