--- base_commands.lua
-- @author Krzysztof Lis (Adynathos)

function Game:initCommands()
	--Convars:RegisterCommand( "command_example", Dynamic_Wrap(WarlockGameMode, 'cmdExample'), "A console command example", self )

	self.commands = {}

	self:registerCommand("set_mode", function(name, a, b)
		local pl = Convars:GetCommandClient()
		local player = GAME.players[pl:GetPlayerID()]
		
		-- Check if its the player selecting the mode
		if player == GAME.mode_selecting_player and a and b then
			GAME:setMode(tonumber(a), tonumber(b))
		end
	end)

	self:registerCommand("select_mode", function()
		local pl = Convars:GetCommandClient()
		local player = GAME.players[pl:GetPlayerID()]
		
		-- Check if its the player selecting the mode
		if player == GAME.mode_selecting_player then
			GAME:selectModes()
		end
	end)

	-- Development only commands
	if Config.DEVELOPMENT then
		self:registerCommand('f', function()
			SendToServerConsole("dota_create_fake_clients")
		end)

		self:registerCommand('s', function()
			-- dont wait and start now
			if GAME.task_start then
				GAME.task_start:cancel()
				GAME:start()
			end
		end)

		self:registerCommand('players', function()
			print("Players:")
			for uid, pl in pairs(GAME.playersByUserid) do
				print("	", pl.name, "	id = ", pl.id, " 	userid = ", pl.userid, " index = ", pl.index)
			end
		end)

		self:registerCommand('projcount', function()
				local actors = GAME:actorsOfType(Projectile)

				local count = 0
				for _ in pairs(actors) do
					count = count + 1
				end

				log("Projectile Count: " .. count)
		end)

		self:registerCommand('resetcd', function()
			GAME.pawns:foreach(function(pawn)
				pawn:resetCooldowns()
			end)
		end)

		self:registerCommand('cam', function(name, dist)
			if(arg[1]) then
				GAME.nativeMode:SetCameraDistanceOverride(tonumber(dist))
			end
		end)

		self:registerCommand('d', function()
			SendToServerConsole("disconnect")
		end)
	
		self:registerCommand('gold', function()
			for uid, pl in pairs(GAME.playersByUserid) do
				pl:addCash(1000)
			end
		end)
	
		self:registerCommand('shield', function()
			for pawn, _ in pairs(GAME.pawns) do
				GAME:addModifier(ShieldModifier:new {
					pawn = pawn,
					time = 10,
					reflect_sound = Shield.reflect_sound,
					reflect_effect = Shield.reflect_name,
					native_mod = Shield.modifier_name
				})
			end
		end)

        self:registerCommand('magnetize', function()
			for pawn, _ in pairs(GAME.pawns) do
				GAME:addModifier(MagnetizeModifier:new {
					pawn = pawn,
					time = 10,
					sign = -1,
					native_mod = Magnetize.native_mod
				})
			end
		end)

        self:registerCommand('magnetize2', function()
			for pawn, _ in pairs(GAME.pawns) do
				GAME:addModifier(MagnetizeModifier:new {
					pawn = pawn,
					time = 10,
					sign = 1,
					native_mod = Magnetize.native_mod
				})
			end
		end)
	
		self:registerCommand('rush', function()
			for pawn, _ in pairs(GAME.pawns) do
				GAME:addModifier(RushModifier:new {
					pawn = pawn,
					time = 10,
					native_mod = Rush.mod_name,
					absorb_max = 10,
					initial_speed_bonus = Rush.initial_speed_bonus
				})
			end
		end)
	
		self:registerCommand('kill', function()
			for pawn, _ in pairs(GAME.pawns) do
				pawn:die({})
			end
		end)
	
		self:registerCommand('respawn', function()
			for i, player in pairs(GAME.players) do
				if player.pawn then
					player.pawn:respawn()
				end
			end
		end)
	
		self:registerCommand("stats", function()
			for i, player in pairs(GAME.players) do
				if player.pawn then
					local p = player.pawn
					log("-- Stats for player " .. player.name .. " --")
					log("move_speed: " .. tostring(p.move_speed))
					log("max_hp: " .. tostring(p.max_hp))
					log("hp_regen: " .. tostring(p.hp_regen))
					log("mass: " .. tostring(p.mass))
					log("dmg_factor: " .. tostring(p.dmg_factor))
					log("kb_factor: " .. tostring(p.kb_factor))
					log("dmg_reduction: " .. tostring(p.dmg_reduction))
					log("debuff_factor: " .. tostring(p.debuff_factor))
					log("--------------------------")
				end
			end
		end)
	end
end

function Game:registerCommand(cmd, func)
	Convars:RegisterCommand("wl_" .. cmd, func, cmd, 0)
end

