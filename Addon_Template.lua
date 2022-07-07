local this = {}

-- executes before the game starts (server, solo, studio)
-- arguments: Script - returns the script type name (Server, Solo, Studio), Client - returns the Client name.
function this:PreInit(Script, Client)
end

-- executes after the game starts (server, solo, studio)
-- arguments: none
function this:PostInit()
end

-- executes after a character loads (server, solo, studio)
-- arguments: Player - Player getting a character loaded, Appearance - The object containing the appearance values 
-- notes: in play solo, you may have to respawn once to see any print outputs.
function this:OnLoadCharacter(Player, Appearance)
end

-- executes after a player joins (server)
-- arguments: Player - the Player joining
function this:OnPlayerAdded(Player)
end

-- executes after a player leaves (server)
-- arguments: Player - the Player leaving
function this:OnPlayerRemoved(Player)
end

-- executes after a player gets kicked (server)
-- arguments: Player - the Player getting kicked, Reason - the reason the player got kicked
function this:OnPlayerKicked(Player, Reason)
end

-- executes before a player gets kicked (server)
-- arguments: Player - the Player getting kicked, Reason - the reason the player got kicked
function this:OnPrePlayerKicked(Player, Reason)
end

-- DO NOT MODIFY THIS. this is required to load this addon into the game.

function AddModule(t)
	table.insert(t, this)
end

_G.CSScript_AddModule=AddModule