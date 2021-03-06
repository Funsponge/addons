--This mod expands the functionality of the auto-name generation of blizzards in game mail system.
--Typically it will only auto-fill for names of players in your guild.
--This mod will expand it to include all your toons you've logged in as, B.Net Friends, and last 10 recently mailed individuals

local DB_PLAYER
local DB_RECENT
local currentPlayer
local currentRealm
local inboxAllButton
local old_InboxFrame_OnClick
local triggerStop = false
local numInboxItems = 0
local timeChk, timeDelay = 0, 1
local stopLoop = 10
local loopChk = 0
local skipCount = 0
local moneyCount = 0

local origHook = {}

local xanAutoMail = CreateFrame("frame","xanAutoMailFrame",UIParent)
xanAutoMail:SetScript("OnEvent", function(self, event, ...) if self[event] then return self[event](self, event, ...) end end)

--[[------------------------
	CORE
--------------------------]]

function xanAutoMail:PLAYER_LOGIN()
	
	currentPlayer = UnitName('player')
	currentRealm = GetRealmName()
	
	--do the db initialization
	self:StartupDB()
	
	--increase the mailbox history lines to 15
	SendMailNameEditBox:SetHistoryLines(15)
	
	--do the hooks
	origHook["SendMailFrame_Reset"] = SendMailFrame_Reset
	SendMailFrame_Reset = self.SendMailFrame_Reset
	
	origHook["MailFrameTab_OnClick"] = MailFrameTab_OnClick
	MailFrameTab_OnClick = self.MailFrameTab_OnClick
	
	origHook["AutoComplete_Update"] = AutoComplete_Update
	AutoComplete_Update = self.AutoComplete_Update
	
	origHook[SendMailNameEditBox] = origHook[SendMailNameEditBox] or {}
	origHook[SendMailNameEditBox]["OnEditFocusGained"] = SendMailNameEditBox:GetScript("OnEditFocusGained")
	origHook[SendMailNameEditBox]["OnChar"] = SendMailNameEditBox:GetScript("OnChar")
	SendMailNameEditBox:SetScript("OnEditFocusGained", self.OnEditFocusGained)
	SendMailNameEditBox:SetScript("OnChar", self.OnChar)
	
	--make the open all button
	inboxAllButton = CreateFrame("Button", "xanAutoMail_OpenAllBTN", InboxFrame, "UIPanelButtonTemplate")
	inboxAllButton:SetWidth(100)
	inboxAllButton:SetHeight(20)
	inboxAllButton:SetPoint("CENTER", InboxFrame, "TOP", 0, -55)
	inboxAllButton:SetText("Open All")
	inboxAllButton:SetScript("OnClick", function() xanAutoMail.GetMail() end)

	self:UnregisterEvent("PLAYER_LOGIN")
	self.PLAYER_LOGIN = nil
end

function xanAutoMail:StartupDB()
	xanAutoMailDB = xanAutoMailDB or {}
	xanAutoMailDB[currentRealm] = xanAutoMailDB[currentRealm] or {}

	--player list
	xanAutoMailDB[currentRealm]["player"] = xanAutoMailDB[currentRealm]["player"] or {}
	DB_PLAYER = xanAutoMailDB[currentRealm]["player"]
	
	--recent list
	xanAutoMailDB[currentRealm]["recent"] = xanAutoMailDB[currentRealm]["recent"] or {}
	DB_RECENT = xanAutoMailDB[currentRealm]["recent"]
	
	--check for current user
	if DB_PLAYER[currentPlayer] == nil then DB_PLAYER[currentPlayer] = true end
end

--This is called when mailed is sent
function xanAutoMail:SendMailFrame_Reset()

	--first lets get the playername
	local playerName = strtrim(SendMailNameEditBox:GetText())
	
	--if we don't have something to work with then call original function
	if string.len(playerName) < 1 then
		return origHook["SendMailFrame_Reset"]()
	end
	
	--add the name to the history
	SendMailNameEditBox:AddHistoryLine(playerName)

	--add the name to our recent DB, first check to see if it's already there
	--if so then remove it, otherwise add it to the top of the list and remove the 11 entry from the table.
	--afterwards call the original function
	for k = 1, #DB_RECENT do
		if playerName == DB_RECENT[k] then
			tremove(DB_RECENT, k)
			break
		end
	end
	tinsert(DB_RECENT, 1, playerName)
	for k = #DB_RECENT, 11, -1 do
		tremove(DB_RECENT, k)
	end
	origHook["SendMailFrame_Reset"]()
	
	-- set the name to the auto fill
	SendMailNameEditBox:SetText(playerName)
	SendMailNameEditBox:HighlightText()
end

--this is called when one of the mailtabs is clicked
--we have to autofill the name when the tabs are clicked
function xanAutoMail:MailFrameTab_OnClick(tab)
	origHook["MailFrameTab_OnClick"](self, tab)
	if tab == 2 then
		local playerName = DB_RECENT[1]
		if playerName and SendMailNameEditBox:GetText() == "" then
			SendMailNameEditBox:SetText(playerName)
			SendMailNameEditBox:HighlightText()
		end
	end
end

--this function is called each time a character is pressed in the playername field of the mail window
function xanAutoMail:OnChar(...)
	if self:GetUTF8CursorPosition() ~= strlenutf8(self:GetText()) then return end
	local text = strupper(self:GetText())
	local textlen = strlen(text)
	local foundName

	--check player toons
	for k, v in pairs(DB_PLAYER) do
		if strfind(strupper(k), text, 1, 1) == 1 then
			foundName = k
			break
		end
	end

	--check our recent list
	if not foundName then
		for k = 1, #DB_RECENT do
			local playerName = DB_RECENT[k]
			if strfind(strupper(playerName), text, 1, 1) == 1 then
				foundName = playerName
				break
			end
		end
	end

	--Check our RealID friends
	if not foundName then
		local numBNetTotal, numBNetOnline = BNGetNumFriends()
		for i = 1, numBNetOnline do
			local presenceID, givenName, surname, toonName, toonID, client = BNGetFriendInfo(i)
			if (toonName and client == BNET_CLIENT_WOW and CanCooperateWithToon(toonID)) then
				if strfind(strupper(toonName), text, 1, 1) == 1 then
					foundName = toonName
					break
				end
			end
		end
	end

	--call the original onChar to display the dropdown
	origHook[SendMailNameEditBox]["OnChar"](self, ...)
	
	--if we found a name then override the one in the editbox
	if foundName then
		self:SetText(foundName)
		self:HighlightText(textlen, -1)
		self:SetCursorPosition(textlen)
	end

end

function xanAutoMail:OnEditFocusGained(...)
	SendMailNameEditBox:HighlightText()
end

function xanAutoMail:AutoComplete_Update(editBoxText, utf8Position, ...)
	if self ~= SendMailNameEditBox then
		origHook["AutoComplete_Update"](self, editBoxText, utf8Position, ...)
	end
end

--[[------------------------
	OPEN ALL MAIL
--------------------------]]

xanAutoMail:RegisterEvent("MAIL_INBOX_UPDATE")
xanAutoMail:RegisterEvent("MAIL_SHOW")

local function colorMoneyText(value)
	if not value then return "" end
	local gold = abs(value / 10000)
	local silver = abs(mod(value / 100, 100))
	local copper = abs(mod(value, 100))
	
	local GOLD_ABRV = "g"
	local SILVER_ABRV = "s"
	local COPPER_ABRV = "c"
	
	local WHITE = "ffffff"
	local COLOR_COPPER = "eda55f"
	local COLOR_SILVER = "c7c7cf"
	local COLOR_GOLD = "ffd700"

	if value >= 10000 or value <= -10000 then
		return format("|cff%s%d|r|cff%s%s|r |cff%s%d|r|cff%s%s|r |cff%s%d|r|cff%s%s|r", WHITE, gold, COLOR_GOLD, GOLD_ABRV, WHITE, silver, COLOR_SILVER, SILVER_ABRV, WHITE, copper, COLOR_COPPER, COPPER_ABRV)
	elseif value >= 100 or value <= -100 then
		return format("|cff%s%d|r|cff%s%s|r |cff%s%d|r|cff%s%s|r", WHITE, silver, COLOR_SILVER, SILVER_ABRV, WHITE, copper, COLOR_COPPER, COPPER_ABRV)
	else
		return format("|cff%s%d|r|cff%s%s|r", WHITE, copper, COLOR_COPPER, COPPER_ABRV)
	end
end

local function bagCheck()
	local totalFree = 0
	for i=0, NUM_BAG_SLOTS do
		local numberOfFreeSlots = GetContainerNumFreeSlots(i)
		totalFree = totalFree + numberOfFreeSlots
	end
	return totalFree
end

local function mailLoop(this, arg1)
	timeChk = timeChk + arg1
	if triggerStop then return end
	
	if (timeChk > timeDelay) then
		timeChk = 0
		
		--check for last or no messages
		if numInboxItems <= 0 then
			--double check that there aren't anymore mail items
			--we use a loop check just in case to prevent infinite loops
			if GetInboxNumItems() > 0 and skipCount ~= GetInboxNumItems() and loopChk < stopLoop then
				loopChk = loopChk + 1
				numInboxItems = GetInboxNumItems()
			else
				triggerStop = true
				xanAutoMail:StopMail()
				return
			end
		end

		--lets get the mail
		local _, _, _, _, money, COD, _, numItems, wasRead, _, _, _, isGM = GetInboxHeaderInfo(numInboxItems)
		
		if money > 0 or (numItems and numItems > 0) and COD <= 0 and not isGM then
			--stop the loop if the mail was already read
			if wasRead and loopChk > 0 then
				triggerStop = true
				xanAutoMail:StopMail()
				return
			elseif bagCheck() < 1 then
				triggerStop = true
				xanAutoMail:StopMail()
				DEFAULT_CHAT_FRAME:AddMessage("xanAutoMail: Your bags are full")
			else
				if money > 0 then moneyCount = moneyCount + money end
				AutoLootMailItem(numInboxItems)
			end
		else
			skipCount = skipCount + 1
		end
		
		--decrease count
		numInboxItems = numInboxItems - 1
	end
end

function xanAutoMail:GetMail()
	if GetInboxNumItems() == 0 then return end
	
	xanAutoMail_OpenAllBTN:Disable() --disable the button to prevent further clicks
	triggerStop = false
	timeChk, timeDelay = 0, 0.5
	loopChk = 0
	skipCount = 0
	moneyCount = 0
	numInboxItems = GetInboxNumItems()
	
	old_InboxFrame_OnClick = InboxFrame_OnClick
	InboxFrame_OnClick = function() end
	
	--register for inventory full error
	xanAutoMail:RegisterEvent("UI_ERROR_MESSAGE")
	
	--initiate the loop
	xanAutoMail:SetScript("OnUpdate", mailLoop)
end

function xanAutoMail:StopMail()
	xanAutoMail_OpenAllBTN:Enable() --enable the button again
	if old_InboxFrame_OnClick then
		InboxFrame_OnClick = old_InboxFrame_OnClick
		old_InboxFrame_OnClick = nil
	end
	xanAutoMail:UnregisterEvent("UI_ERROR_MESSAGE")
	xanAutoMail:SetScript("OnUpdate", nil)
	--check for money output
	if moneyCount > 0 then
		DEFAULT_CHAT_FRAME:AddMessage("xanAutoMail: Total money from mailbox ["..colorMoneyText(moneyCount).."]")
	end
end

--this is to stop the loop if our bags are filled
function xanAutoMail:UI_ERROR_MESSAGE(event, arg1)
	if arg1 == ERR_INV_FULL then
		triggerStop = true
		xanAutoMail:StopMail()
		DEFAULT_CHAT_FRAME:AddMessage("xanAutoMail: Your bags are full")
	end
end

--sometimes the mailbox is full, if this happens we have to make changes to the button position
local function inboxFullCheck()
	local nItem, nTotal = GetInboxNumItems()
	if nItem and nTotal then
		if ( nTotal > nItem) or InboxTooMuchMail:IsVisible() and not inboxAllButton.movedBottom then
			inboxAllButton:ClearAllPoints()
			inboxAllButton:SetPoint("CENTER", InboxFrame, "BOTTOM", -10, 100)
			inboxAllButton.movedBottom = true
		elseif (( nTotal < nItem) or not InboxTooMuchMail:IsVisible()) and inboxAllButton.movedBottom then
			inboxAllButton.movedBottom = nil
			inboxAllButton:ClearAllPoints()
			inboxAllButton:SetPoint("CENTER", InboxFrame, "TOP", 0, -55)
		end 
	end
end

function xanAutoMail:MAIL_INBOX_UPDATE()
	inboxFullCheck()
end

function xanAutoMail:MAIL_SHOW()
	inboxFullCheck()
end

if IsLoggedIn() then xanAutoMail:PLAYER_LOGIN() else xanAutoMail:RegisterEvent("PLAYER_LOGIN") end



























