PlaytimeDB = PlaytimeDB or {}
local cachingPlaytime = true

local o = ChatFrame_DisplayTimePlayed
ChatFrame_DisplayTimePlayed = function(...)
	if (cachingPlaytime) then
		cachingPlaytime = false
		return
	end
	return o(...)
end

local Playtime = CreateFrame("Frame")
Playtime:RegisterEvent("PLAYER_LOGIN")
Playtime:RegisterEvent("PLAYER_LOGOUT")
Playtime:RegisterEvent("TIME_PLAYED_MSG")

Playtime:SetScript("OnEvent", function(self, event, ...)
return self[event] and self[event](self, ...)
end)

function Playtime:PLAYER_LOGIN()
	SavePlaytime()
end

function Playtime:PLAYER_LOGOUT()
	SavePlaytime()
end

function Playtime:TIME_PLAYED_MSG(total, currentLevel)
	local p = UnitName("player")	
	local r = GetRealmName()
	PlaytimeDB[p.." ("..r..")"] = total
end

function SavePlaytime()
	cachingPlaytime = true
	RequestTimePlayed()
end

function ShowPlaytime()
	SavePlaytime()
	
	local totaltime = 0
	for player,time in pairs(PlaytimeDB) do
print("|cffaaaaaa"..player..": "..secondsToDays(time) )
		totaltime = totaltime + time
	end

	print("Total Playtime: "..secondsToDays(totaltime) )
end

function secondsToDays(inputSeconds)
 fdays = math.floor(inputSeconds/86400)
 fhours = math.floor((bit.mod(inputSeconds,86400))/3600)
 fminutes = math.floor(bit.mod((bit.mod(inputSeconds,86400)),3600)/60)
 fseconds = math.floor(bit.mod(bit.mod((bit.mod(inputSeconds,86400)),3600),60))
 return fdays.." days, "..fhours.." hours, "..fminutes.." minutes, "..fseconds.." seconds"
end

SLASH_PLAYTIME1 = '/playtime';

local function handler(msg, editbox)
	if msg and (msg == 'clear') then
		PlaytimeDB = {}
		SavePlaytime()
	else
		ShowPlaytime()
	end
end

SlashCmdList["PLAYTIME"] = handler;
