local mod = AntibirthItemPack

function mod:PostNewRoom()
	for _, player in pairs(mod:GetPlayers()) do
		local data = mod:GetData(player)
		data.ExtraSpins = 0 --just in case it gets interrupted
	end
end
mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.PostNewRoom)

function mod:PlayerHurt(TookDamage, DamageAmount, DamageFlags, DamageSource, DamageCountdownFrames)
	local player = TookDamage:ToPlayer()
	local data = mod:GetData(player)
	
	if player:HasCollectible(CollectibleType.COLLECTIBLE_DONKEY_JAWBONE) then
		if player:HasCollectible(CollectibleType.COLLECTIBLE_20_20) then
			data.ExtraSpins = data.ExtraSpins + 1
		end
		if player:HasCollectible(CollectibleType.COLLECTIBLE_INNER_EYE) then
			data.ExtraSpins = data.ExtraSpins + 2
		end
		if player:HasCollectible(CollectibleType.COLLECTIBLE_MUTANT_SPIDER) then
			data.ExtraSpins = data.ExtraSpins + 3
		end
		
		mod:SpawnJawbone(player)
	end
end
mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, mod.PlayerHurt, EntityType.ENTITY_PLAYER)


function mod:JawboneUpdate(jawbone)
	local player = mod:GetPlayerFromTear(jawbone)
	local data = mod:GetData(player)
	local sprite = jawbone:GetSprite()
	
	if sprite:IsPlaying("SpinLeft") or sprite:IsPlaying("SpinUp") or sprite:IsPlaying("SpinRight") or sprite:IsPlaying("SpinDown") then
		jawbone.Position = player.Position
		SFXManager():Stop(SoundEffect.SOUND_TEARS_FIRE)
	else
		jawbone:Remove()
		if data.ExtraSpins > 0 then
			mod:SpawnJawbone(player)
			data.ExtraSpins = data.ExtraSpins - 1
		end
	end
end
mod:AddCallback(ModCallbacks.MC_POST_TEAR_UPDATE, mod.JawboneUpdate, 1001)

function mod:MeatySound(entityTear, collider, low)
	if collider:IsActiveEnemy(true) then
		SFXManager():Play(SoundEffect.SOUND_MEATY_DEATHS)
	end
end
mod:AddCallback(ModCallbacks.MC_PRE_TEAR_COLLISION, mod.MeatySound, 1001)

function mod:SpawnJawbone(player)
	local jawbone = Isaac.Spawn(2, 1001, 0, player.Position, Vector.Zero, player):ToTear()
	local data = mod:GetData(jawbone)
	
	data.isJawbone = true
	jawbone.Parent = player
	jawbone.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ENEMIES
	jawbone.GridCollisionClass = GridCollisionClass.COLLISION_SOLID
	jawbone.CollisionDamage = (player.Damage * 8) + 10
	jawbone:AddTearFlags(TearFlags.TEAR_PIERCING | TearFlags.TEAR_SPECTRAL | TearFlags.TEAR_SHIELDED | TearFlags.TEAR_HP_DROP)
	if player:HasCollectible(CollectibleType.COLLECTIBLE_IPECAC) then
		jawbone:AddTearFlags(TearFlags.TEAR_POISON)
	end
	if player:HasCollectible(CollectibleType.COLLECTIBLE_URANUS) then
		jawbone:AddTearFlags(TearFlags.TEAR_ICE)
	end
	if player:HasCollectible(CollectibleType.COLLECTIBLE_HOLY_LIGHT) then
		jawbone:AddTearFlags(TearFlags.TEAR_LIGHT_FROM_HEAVEN)
	end
	if player:HasCollectible(CollectibleType.COLLECTIBLE_HEAD_OF_THE_KEEPER) then
		jawbone:AddTearFlags(TearFlags.TEAR_COIN_DROP_DEATH)
	end
	
	local sprite = jawbone:GetSprite()
	local headDirection = player:GetHeadDirection()
	if player:HasCollectible(CollectibleType.COLLECTIBLE_20_20) or player:HasCollectible(CollectibleType.COLLECTIBLE_INNER_EYE) or player:HasCollectible(CollectibleType.COLLECTIBLE_MUTANT_SPIDER) then
		sprite.PlaybackSpeed = 2
	end
	
	if headDirection == Direction.LEFT then
		sprite:Play("SpinLeft", true)
	elseif headDirection == Direction.UP then
		sprite:Play("SpinUp", true)
	elseif headDirection == Direction.RIGHT then
		sprite:Play("SpinRight", true)
	elseif headDirection == Direction.DOWN then
		sprite:Play("SpinDown", true)
	end
	
	SFXManager():Play(SoundEffect.SOUND_SWORD_SPIN)
end

--Minimap Items Compatibility
if MiniMapiItemsAPI then
    local frame = 1
    local donkeyjawboneSprite = Sprite()
    donkeyjawboneSprite:Load("gfx/ui/minimapitems/antibirthitempack_donkeyjawbone_icon.anm2", true)
    MiniMapiItemsAPI:AddCollectible(CollectibleType.COLLECTIBLE_DONKEY_JAWBONE, donkeyjawboneSprite, "CustomIconDonkeyJawbone", frame)
end
