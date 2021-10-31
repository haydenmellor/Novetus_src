showServerNotifications = true

--function made by rbxbanland
function newWaitForChild(newParent,name)
	local returnable = nil
	if newParent:findFirstChild(name) then
		returnable = newParent:findFirstChild(name)
	else 
		repeat wait() returnable = newParent:findFirstChild(name)  until returnable ~= nil
	end
	return returnable
end

function KickPlayer(Player,reason)
	if (game.Lighting:findFirstChild("SkipSecurity") ~= nil) then
		do return end
	end

	if (Player ~= nil) then
		for _,Child in pairs(Server:children()) do
			name = "ServerReplicator|"..Player.Name.."|"..Player.userId.."|"..Player.AnonymousIdentifier.Value
			if (Server:findFirstChild(name) ~= nil) then
				Child:CloseConnection()
			end
		end
	end
end

function newWaitForChildSecurity(newParent,name)
	local returnable = nil
	local loadAttempts = 0
	local maxAttempts = 5
	while loadAttempts < maxAttempts do
		if newParent:findFirstChild(name) then
			returnable = newParent:findFirstChild(name)
			break
		end
		wait()
		loadAttempts = loadAttempts + 1
		print("Player '" .. newParent.Name .. "' trying to connect. Number of attempts: "..loadAttempts)
	end
		
	if (loadAttempts == maxAttempts) then
		KickPlayer(newParent, "Modified Client")
	end
		
	return returnable
end

function LoadCharacterNew(playerApp,newChar)
	PlayerService = game:service("Players")
	Player = PlayerService:playerFromCharacter(newChar)
	
	local function kick()
		KickPlayer(Player, "Modified Client")
	end
	
	if (playerApp == nil) then
		kick()
	end
	
	if (not Player:findFirstChild("Appearance")) then
		kick()
	end
	
	if ((playerApp:children() == 0) or (playerApp:children() == nil)) then
		kick()
	end
	
	local path = "rbxasset://../../../shareddata/charcustom/"
	
	local charparts = {[1] = newWaitForChild(newChar,"Head"),[2] = newWaitForChild(newChar,"Torso"),[3] = newWaitForChild(newChar,"Left Arm"),[4] = newWaitForChild(newChar,"Right Arm"),[5] = newWaitForChild(newChar,"Left Leg"),[6] = newWaitForChild(newChar,"Right Leg")}
	for _,newVal in pairs(playerApp:children()) do
		if (newVal.Name == "Body Color") then 
			pcall(function() 
				charparts[newVal.ColorIndex.Value].BrickColor = newVal.Value 
			end)
		end
	end
end

function InitalizeClientAppearance(Player,Hat1ID,Hat2ID,Hat3ID,HeadColorID,TorsoColorID,LeftArmColorID,RightArmColorID,LeftLegColorID,RightLegColorID,TShirtID,ShirtID,PantsID,FaceID,HeadID,ItemID)
	local newCharApp = Instance.new("IntValue",Player)
	newCharApp.Name = "Appearance"
	--BODY COLORS
	for i=1,6,1 do
		local BodyColor = Instance.new("BrickColorValue",newCharApp)
		if (i == 1) then
			if (HeadColorID ~= nil) then
				BodyColor.Value = BrickColor.new(HeadColorID)
			else
				BodyColor.Value = BrickColor.new(1)
			end
		elseif (i == 2) then
			if (TorsoColorID ~= nil) then
				BodyColor.Value = BrickColor.new(TorsoColorID)
			else
				BodyColor.Value = BrickColor.new(1)
			end
		elseif (i == 3) then
			if (LeftArmColorID ~= nil) then
				BodyColor.Value = BrickColor.new(LeftArmColorID)
			else
				BodyColor.Value = BrickColor.new(1)
			end
		elseif (i == 4) then
			if (RightArmColorID ~= nil) then
				BodyColor.Value = BrickColor.new(RightArmColorID)
			else
				BodyColor.Value = BrickColor.new(1)
			end
		elseif (i == 5) then
			if (LeftLegColorID ~= nil) then
				BodyColor.Value = BrickColor.new(LeftLegColorID)
			else
				BodyColor.Value = BrickColor.new(1)
			end
		elseif (i == 6) then
			if (RightLegColorID ~= nil) then
				BodyColor.Value = BrickColor.new(RightLegColorID)
			else
				BodyColor.Value = BrickColor.new(1)
			end
		end
		BodyColor.Name = "Body Color"
		local indexValue = Instance.new("NumberValue")
		indexValue.Name = "ColorIndex"
		indexValue.Parent = BodyColor
		indexValue.Value = i
	end
end

function LoadSecurity(playerApp,Player,ServerSecurityLocation)
	local function kick()
		KickPlayer(Player, "Modified Client")
	end
	
	if (playerApp == nil) then
		kick()
	end
	
	if (not Player:findFirstChild("Security")) then
		kick()
	end
	
	if (not playerApp:findFirstChild("ClientEXEMD5") or not playerApp:findFirstChild("LauncherMD5") or not playerApp:findFirstChild("ClientScriptMD5")) then
		kick()
	end
	
	for _,newVal in pairs(playerApp:children()) do
		if (newVal.Name == "ClientEXEMD5") then
			if (newVal.Value ~= ServerSecurityLocation.Security.ClientEXEMD5.Value or newVal.Value == "") then
				kick()
				break
			end
		end
				
		if (newVal.Name == "LauncherMD5") then
			if (newVal.Value ~= ServerSecurityLocation.Security.LauncherMD5.Value or newVal.Value == "") then
				kick()
				break
			end
		end
				
		if (newVal.Name == "ClientScriptMD5") then
			if (newVal.Value ~= ServerSecurityLocation.Security.ClientScriptMD5.Value or newVal.Value == "") then
				kick()
				break
			end
		end
	end
end

function InitalizeSecurityValues(Location,ClientEXEMD5,LauncherMD5,ClientScriptMD5)
	Location = Instance.new("IntValue", Location)
	Location.Name = "Security"
	
	local clientValue = Instance.new("StringValue", Location)
	clientValue.Value = ClientEXEMD5 or ""
	clientValue.Name = "ClientEXEMD5"

	local launcherValue = Instance.new("StringValue", Location)
	launcherValue.Value = LauncherMD5 or ""
	launcherValue.Name = "LauncherMD5"

	local scriptValue = Instance.new("StringValue", Location)
	scriptValue.Value = ClientScriptMD5 or ""
	scriptValue.Name = "ClientScriptMD5"
end

function InitalizeTripcode(Location,Tripcode)
	local code = Instance.new("StringValue", Location)
	code.Value = Tripcode or ""
	code.Name = "Tripcode"
end

function LoadTripcode(Player)
	local function kick()
		KickPlayer(Player, "Modified Client")
	end
	
	if (not Player:findFirstChild("Tripcode")) then
		kick()
	end
	
	for _,newVal in pairs(Player:children()) do
		if (newVal.Name == "Tripcode") then
			if (newVal.Value == "") then
				kick()
				break
			end
		end
	end
end

function PingMasterServer(online, ServerBrowserAddress, ServerBrowserName, ServerIP, Port, Client)
	local pingURL = "http://" .. ServerBrowserAddress .. "/query.php?name=" .. ServerBrowserName .. "&ip=" .. ServerIP .. "&port=" .. Port .. "&client=" .. Client
	game:httpGet(pingURL .. "&online=" .. online)
end

print("ROBLOX Client version '0.3.368.0' loaded.")

function CSServer(Port,PlayerLimit,ClientEXEMD5,LauncherMD5,ClientScriptMD5,Notifications,ServerBrowserName,ServerBrowserAddress,ServerIP,Client)
	Server = game:service("NetworkServer")
	RunService = game:service("RunService")
	PlayerService = game:service("Players")
	game:service("Visit"):setUploadUrl("")
	Server:start(Port, 20)
	RunService:run()
	showServerNotifications = Notifications
	game.Workspace:insertContent("rbxasset://Fonts//libraries.rbxm")
	if (showServerNotifications) then
		PlayerService.maxPlayers = PlayerLimit + 1
		--create a fake player to record connections and disconnections
		notifyPlayer = game:service("Players"):createLocalPlayer(-1)
		notifyPlayer.Name = "[SERVER]"
	else
		PlayerService.maxPlayers = PlayerLimit
	end
	
	local playerCount = 0
	PlayerService.ChildAdded:connect(function(Player)
		-- create anonymous player identifier. This is so we can track clients without tripcodes
		playerCount = playerCount + 1
		
		local code = Instance.new("StringValue", Player)
		code.Value = playerCount
		code.Name = "AnonymousIdentifier"
	
		-- rename all Server replicators in NetworkServer to "ServerReplicator"
		for _,Child in pairs(Server:children()) do
			name = "ServerReplicator|"..Player.Name.."|"..Player.userId.."|"..Player.AnonymousIdentifier.Value
			if (Server:findFirstChild(name) == nil) then
				if (string.match(Child.Name, "ServerReplicator") == nil) then
					Child.Name = name
				end
			end
		end
	
		Player.Chatted:connect(function(msg)
			print(Player.Name.."; "..msg)
		end)
		
		if (PlayerService.numPlayers > PlayerService.maxPlayers) then
			KickPlayer(Player, "Too many players on server.")
		else
			print("Player '" .. Player.Name .. "' with ID '" .. Player.userId .. "' added")
			if (showServerNotifications) then
				game.Players:Chat("Player '" .. Player.Name .. "' joined")
			end
			Player:LoadCharacter()
			LoadSecurity(newWaitForChildSecurity(Player,"Security"),Player,game.Lighting)
			newWaitForChildSecurity(Player,"Tripcode")
			LoadTripcode(Player)
			pcall(function() print("Player '" .. Player.Name .. "-" .. Player.userId .. "' security check success. Tripcode: '" .. Player.Tripcode.Value .. "'") end)
			if (Player.Character ~= nil) then
				LoadCharacterNew(newWaitForChildSecurity(Player,"Appearance"),Player.Character)
			end
		end
		
		coroutine.resume(coroutine.create(function()
			while Player ~= nil do
				wait(0.1)
				if (Player.Character ~= nil) then
					if (Player.Character:findFirstChild("Humanoid") and (Player.Character.Humanoid.Health == 0)) then
						wait(5)
						Player:LoadCharacter()
						LoadCharacterNew(newWaitForChildSecurity(Player,"Appearance"),Player.Character)
					elseif (Player.Character.Parent == nil) then 
						wait(5)
						Player:LoadCharacter()
						LoadCharacterNew(newWaitForChildSecurity(Player,"Appearance"),Player.Character)
					end
				end
			end
		end))
	end)
	PlayerService.PlayerRemoving:connect(function(Player)
		print("Player '" .. Player.Name .. "' with ID '" .. Player.userId .. "' leaving")
		if (showServerNotifications) then
			game.Players:Chat("Player '" .. Player.Name .. "' left")
		end
	end)
	InitalizeSecurityValues(game.Lighting,ClientEXEMD5,LauncherMD5,ClientScriptMD5)
	PingMasterServer(1, ServerBrowserAddress, ServerBrowserName, ServerIP, Port, Client)
	Server.IncommingConnection:connect(IncommingConnection)
	pcall(function() game.Close:connect(function() PingMasterServer(0, ServerBrowserAddress, ServerBrowserName, ServerIP, Port, Client) Server:stop() end) end)
end

function CSConnect(UserID,ServerIP,ServerPort,PlayerName,Hat1ID,Hat2ID,Hat3ID,HeadColorID,TorsoColorID,LeftArmColorID,RightArmColorID,LeftLegColorID,RightLegColorID,TShirtID,ShirtID,PantsID,FaceID,HeadID,IconType,ItemID,ClientEXEMD5,LauncherMD5,ClientScriptMD5,Tripcode,Ticket)
	local suc, err = pcall(function()
		client = game:service("NetworkClient")
		player = game:service("Players"):createLocalPlayer(UserID)
		InitalizeSecurityValues(player,ClientEXEMD5,LauncherMD5,ClientScriptMD5)
		InitalizeTripcode(player,Tripcode)
		player:SetSuperSafeChat(false)
		pcall(function() player:SetUnder13(false) end)
		pcall(function() player:SetAccountAge(365) end)
		player:SetAdminMode(true)
		pcall(function() player.Name=PlayerName or "" end)
		game:service("Visit"):setUploadUrl("")
		InitalizeClientAppearance(player,Hat1ID,Hat2ID,Hat3ID,HeadColorID,TorsoColorID,LeftArmColorID,RightArmColorID,LeftLegColorID,RightLegColorID,TShirtID,ShirtID,PantsID,FaceID,HeadID,ItemID)		
	end)

	local function dieerror(errmsg)
		game:SetMessage(errmsg)
		wait(math.huge)
	end

	if not suc then
		dieerror(err)
	end

	local function disconnect(peer,lostconnection)
		game:SetMessage("You have lost connection to the game")
	end

	local function connected(url, replicator)
		replicator.Disconnection:connect(disconnect)
		local marker = nil
		local suc, err = pcall(function()
			game:SetMessageBrickCount()
			marker = replicator:SendMarker()
		end)
		if not suc then
			dieerror(err)
		end
		marker.Received:connect(function()
			local suc, err = pcall(function()
				game:ClearMessage()
			end)
			if not suc then
				dieerror(err)
			end
		end)
	end

	local function rejected()
		dieerror("Failed to connect to the Game. (Connection rejected)")
	end

	local function failed(peer, errcode, why)
		dieerror("Failed to connect to the Game. (ID="..errcode..")")
	end

	local suc, err = pcall(function()
		game:SetMessage("Connecting to server...")
		client.ConnectionAccepted:connect(connected)
		client.ConnectionRejected:connect(rejected)
		client.ConnectionFailed:connect(failed)
		client:connect(ServerIP,ServerPort, 0, 20)
		game.GuiRoot.MainMenu["Toolbox"]:remove()
		game.GuiRoot.MainMenu["Edit Mode"]:remove()
		game.GuiRoot.RightPalette.ReportAbuse:remove()
		game.GuiRoot.ChatMenuPanel:remove()
	end)

	if not suc then
		local x = Instance.new("Message")
		x.Text = err
		x.Parent = workspace
		wait(math.huge)
	end
end

function CSSolo(UserID,PlayerName,Hat1ID,Hat2ID,Hat3ID,HeadColorID,TorsoColorID,LeftArmColorID,RightArmColorID,LeftLegColorID,RightLegColorID,TShirtID,ShirtID,PantsID,FaceID,HeadID,IconType,ItemID)
	game:service("RunService"):run()
	local plr = game.Players:createLocalPlayer(UserID)
	game.Workspace:insertContent("rbxasset://Fonts//libraries.rbxm")
	plr.Name = PlayerName
	plr:SetAdminMode(true)
	plr:LoadCharacter()
	InitalizeClientAppearance(plr,Hat1ID,Hat2ID,Hat3ID,HeadColorID,TorsoColorID,LeftArmColorID,RightArmColorID,LeftLegColorID,RightLegColorID,TShirtID,ShirtID,PantsID,FaceID,HeadID,ItemID)
	LoadCharacterNew(newWaitForChild(plr,"Appearance"),plr.Character,false)
	game:service("Visit"):setUploadUrl("")
	while true do 
		wait(0.001)
		if (plr.Character ~= nil) then
			if (plr.Character:findFirstChild("Humanoid") and (plr.Character.Humanoid.Health == 0)) then
				wait(5)
				plr:LoadCharacter()
				LoadCharacterNew(newWaitForChild(plr,"Appearance"),plr.Character)
			elseif (plr.Character.Parent == nil) then 
				wait(5)
				plr:LoadCharacter() -- to make sure nobody is deleted.
				LoadCharacterNew(newWaitForChild(plr,"Appearance"),plr.Character)
			end
		end
	end
end

function CSStudio()
end

_G.CSServer=CSServer
_G.CSConnect=CSConnect
_G.CSSolo=CSSolo
_G.CSStudio=CSStudio
