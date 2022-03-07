local mod = AntibirthItemPack

function mod:UseBookOfDespair(_Type, RNG, player)
	local data = mod:GetData(player)
	if GiantBookAPI and data.DespairPower < 1 then
		GiantBookAPI.playGiantBook("Appear", "Despair.png", Color(0.9, 0.9, 0.9, 1, 0, 0, 0), Color(0.9, 0.9, 0.9, 0.6, 0, 0, 0), Color(0.9, 0.9, 0.9, 0.5, 0, 0, 0))
	end
	SFXManager():Play(SoundEffect.SOUND_BOOK_PAGE_TURN_12, 0.8, 0, false, 1)
	
	data.DespairPower = data.DespairPower + 1
    player:AddCacheFlags(CacheFlag.CACHE_FIREDELAY)
	player:EvaluateItems()
    return true
end

function mod:OnNewRoom()
    for i = 0, Game():GetNumPlayers() - 1 do
        local player = Game():GetPlayer(i)
		local data = mod:GetData(player)
		
        data.DespairPower = 0
		
        player:AddCacheFlags(CacheFlag.CACHE_FIREDELAY)
		player:EvaluateItems()
    end
end

function mod:Despair_CacheEval(player, cacheFlag)
	local data = mod:GetData(player)
	if data.DespairPower == nil then
		data.DespairPower = 0
	end
	if data.DespairPower > 0 then
		for power = 1, data.DespairPower do
			player.MaxFireDelay = player.MaxFireDelay / 2.0
		end
	end
end

function mod:Despair_Costume(player)
	local tornConfig = Isaac.GetItemConfig():GetCollectible(CollectibleType.COLLECTIBLE_TORN_PHOTO)
	local data = mod:GetData(player)
	
	if not player:HasCollectible(CollectibleType.COLLECTIBLE_TORN_PHOTO) then --Adding another torn photo costume is redundant if you have torn photo already
		if not data.costumes then
			data.costumes = 0
		end
		
		while data.DespairPower > data.costumes do
			player:AddCostume(tornConfig, false)
			data.costumes = data.costumes + 1
		end
		while data.DespairPower < data.costumes do
			data.costumes = data.costumes - 1
			if data.costumes <= 0 then
				player:TryRemoveCollectibleCostume(CollectibleType.COLLECTIBLE_TORN_PHOTO, true)
			end
		end
	end
end

--Minimap Items Compatibility
if MiniMapiItemsAPI then
    local frame = 1
    local bookofdespairSprite = Sprite()
    bookofdespairSprite:Load("gfx/ui/minimapitems/antibirthitempack_bookofdespair_icon.anm2", true)
    MiniMapiItemsAPI:AddCollectible(CollectibleType.COLLECTIBLE_BOOK_OF_DESPAIR, bookofdespairSprite, "CustomIconBookOfDepair", frame)
end

mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.OnNewRoom)
mod:AddCallback(ModCallbacks.MC_USE_ITEM, mod.UseBookOfDespair, CollectibleType.COLLECTIBLE_BOOK_OF_DESPAIR)
mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, mod.Despair_CacheEval, CacheFlag.CACHE_FIREDELAY)
mod:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, mod.Despair_Costume)