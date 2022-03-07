AntibirthItemPack = RegisterMod("Antibirth Item Pack", 1)
local mod = AntibirthItemPack

CollectibleType.COLLECTIBLE_BOOK_OF_DESPAIR = Isaac.GetItemIdByName("Book of Despair")
CollectibleType.COLLECTIBLE_BOWL_OF_TEARS = Isaac.GetItemIdByName("Bowl of Tears")
CollectibleType.COLLECTIBLE_DONKEY_JAWBONE = Isaac.GetItemIdByName("Donkey Jawbone")
CollectibleType.COLLECTIBLE_MENORAH = Isaac.GetItemIdByName("Menorah")
CollectibleType.COLLECTIBLE_STONE_BOMBS = Isaac.GetItemIdByName("Stone Bombs")

include("lua/shockwaveAPI.lua")
include("lua/items/BookOfDespair.lua")
include("lua/items/BowlOfTears.lua")
include("lua/items/DonkeyJawbone.lua")
include("lua/items/Menorah.lua")
include("lua/items/StoneBombs.lua")

if EID then
	include("lua/eid.lua")
end

if Encyclopedia then
	include("lua/encyclopedia.lua")
end

if CCO and CCO.JOB_MOD then
	Game():GetItemPool():RemoveCollectible(CollectibleType.COLLECTIBLE_BOOK_OF_DESPAIR) --remove our book of despair if job mod is detected
end

if ExtraBirthright then
    include("lua/ExtraBirthright.lua")
end


-----------------------------------
--Helper Functions (thanks piber)--
-----------------------------------

function mod:GetPlayers(functionCheck, ...)
	local args = {...}
	local players = {}
	local game = Game()
	
	for i=1, game:GetNumPlayers() do
		local player = Isaac.GetPlayer(i-1)
		local argsPassed = true
		
		if type(functionCheck) == "function" then
			for j=1, #args do
				if args[j] == "player" then
					args[j] = player
				elseif args[j] == "currentPlayer" then
					args[j] = i
				end
			end
			
			if not functionCheck(table.unpack(args)) then
				argsPassed = false	
			end
		end
		
		if argsPassed then
			players[#players+1] = player
		end
	end
	
	return players
end

function mod:GetPlayerFromTear(tear)
	local check = tear.Parent or mod:GetSpawner(tear) or tear.SpawnerEntity
	if check then
		if check.Type == EntityType.ENTITY_PLAYER then
			return mod:GetPtrHashEntity(check):ToPlayer()
		elseif check.Type == EntityType.ENTITY_FAMILIAR and check.Variant == FamiliarVariant.INCUBUS then
			local data = mod:GetData(tear)
			data.IsIncubusTear = true
			return check:ToFamiliar().Player:ToPlayer()
		end
	end
	return nil
end

function mod:GetSpawner(entity)
	if entity and entity.GetData then
		local spawnData = mod:GetSpawnData(entity)
		if spawnData and spawnData.SpawnerEntity then
			local spawner = mod:GetPtrHashEntity(spawnData.SpawnerEntity)
			return spawner
		end
	end
	return nil
end

function mod:GetSpawnData(entity)
	if entity and entity.GetData then
		local data = mod:GetData(entity)
		return data.SpawnData
	end
	return nil
end

function mod:GetPtrHashEntity(entity)
	if entity then
		if entity.Entity then
			entity = entity.Entity
		end
		for _, matchEntity in pairs(Isaac.FindByType(entity.Type, entity.Variant, entity.SubType, false, false)) do
			if GetPtrHash(entity) == GetPtrHash(matchEntity) then
				return matchEntity
			end
		end
	end
	return nil
end

function mod:GetData(entity)
	if entity and entity.GetData then
		local data = entity:GetData()
		if not data.AntibirthItemPack then
			data.AntibirthItemPack = {}
		end
		return data.AntibirthItemPack
	end
	return nil
end

local entitySpawnData = {}
mod:AddCallback(ModCallbacks.MC_PRE_ENTITY_SPAWN, function(_, type, variant, subType, position, velocity, spawner, seed)
	entitySpawnData[seed] = {
		Type = type,
		Variant = variant,
		SubType = subType,
		Position = position,
		Velocity = velocity,
		SpawnerEntity = spawner,
		InitSeed = seed
	}
end)
mod:AddCallback(ModCallbacks.MC_POST_TEAR_INIT, function(_, entity)
	local seed = entity.InitSeed
	local data = mod:GetData(entity)
	data.SpawnData = entitySpawnData[seed]
end)
mod:AddCallback(ModCallbacks.MC_POST_ENTITY_REMOVE, function(_, entity)
	local data = mod:GetData(entity)
	data.SpawnData = nil
end)
mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, function()
	entitySpawnData = {}
end)

function mod:GetRandomNumber(numMin, numMax, rng)
	if not numMax then
		numMax = numMin
		numMin = nil
	end
	
	rng = rng or RNG()

	if type(rng) == "number" then
		local seed = rng
		rng = RNG()
		rng:SetSeed(seed, 1)
	end
	
	if numMin and numMax then
		return rng:Next() % (numMax - numMin + 1) + numMin
	elseif numMax then
		return rng:Next() % numMin
	end
	return rng:Next()
end