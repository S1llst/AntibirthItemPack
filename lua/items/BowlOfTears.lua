local mod = AntibirthItemPack

LaserVariant = {BRIMSTONE = 1, TECHNOLOGY = 2, MEGA_BLAST = 6,  TECH_BRIMSTONE = 9, TECH_ZERO = 10, BIG_BRIM = 11, TECHSTONE = 14}
BowlMouseClick = {LEFT = 0, RIGHT = 1, WHEEL = 2, BACK = 3, FORWARD = 4}
mod.MaxExtraTears = 1

function mod:ExtraTearSum(player)
	local has20 = player:HasCollectible(CollectibleType.COLLECTIBLE_20_20)
	local num20 = player:GetCollectibleNum(CollectibleType.COLLECTIBLE_20_20)
	local hasInner = player:HasCollectible(CollectibleType.COLLECTIBLE_INNER_EYE)
	local numInner = player:GetCollectibleNum(CollectibleType.COLLECTIBLE_INNER_EYE)
	local hasMutant = player:HasCollectible(CollectibleType.COLLECTIBLE_MUTANT_SPIDER)
	local numMutant = player:GetCollectibleNum(CollectibleType.COLLECTIBLE_MUTANT_SPIDER)
	local conjoined = player:HasPlayerForm(PlayerForm.PLAYERFORM_BABY)
	local isKeeper = (player:GetPlayerType() == PlayerType.PLAYER_KEEPER) and true or false
	local isKeeperB = (player:GetPlayerType() == PlayerType.PLAYER_KEEPER_B) and true or false
	local startInnerMutant20 = (hasMutant or isKeeperB) and ((hasInner or isKeeper) and 4 or 3) or ((isKeeper and hasInner) and 3 or ((isKeeper or hasInner) and 2 or (has20 and 1 or 0)))
	local keeperInnerNum = (hasInner and isKeeper) and (1 + numInner) or (hasInner and (numInner - 1) or 0)
	local keeperBMutantNum = (hasMutant and isKeeperB) and (1 + numMutant) or (hasMutant and (numMutant - 1) or 0)
	local laterInnerMutant20 = (has20 and (num20 - 1) or 0) + keeperInnerNum + keeperBMutantNum
	local sum = (conjoined and 2 or 0) + startInnerMutant20 + laterInnerMutant20
	return sum
end

function mod:MultiTearChargeCheck(player,ludolaser)
	ludolaser = ludolaser or false
	local datap = mod:GetData(player)
	if datap.InnerMutant20 < 0 or (player:HasCollectible(CollectibleType.COLLECTIBLE_LUDOVICO_TECHNIQUE) and ludolaser) then
		datap.InnerMutant20 = mod.MaxExtraTears
		mod:ChargeBowl(player)
	else
		datap.InnerMutant20 = datap.InnerMutant20 - 1
	end
end
--firing tears updates the bowl
function mod:TearBowlCharge(entityTear)
	local player = mod:GetPlayerFromTear(entityTear)
	if player then
		local data = mod:GetData(player)
		data.InnerMutant20 = data.InnerMutant20 - 1
		local tearData = mod:GetData(entityTear)
		if not tearData.isSpreadTear and data.InnerMutant20 < 0 then
			data.InnerMutant20 = mod.MaxExtraTears
			mod:ChargeBowl(player)
		end
	end
end
mod:AddCallback(ModCallbacks.MC_POST_FIRE_TEAR, mod.TearBowlCharge)

--updating knife charge
function mod:KnifeBowlCharge(entityKnife)
	local player = mod:GetPlayerFromTear(entityKnife)
	local data = mod:GetData(entityKnife)
	
	if player then
		if entityKnife.TearFlags & TearFlags.TEAR_LUDOVICO == TearFlags.TEAR_LUDOVICO then --ludo knife
			if math.fmod(entityKnife.FrameCount,30) == 0 then
				mod:MultiTearChargeCheck(player)
			end
		elseif entityKnife.Variant == 10 and entityKnife.SubType == 0 and entityKnife.FrameCount == 1 and not mod:GetData(entityKnife).SwordSwing then --spirit sword
			mod:GetData(entityKnife).SwordSwing = true
			mod:ChargeBowl(player)
		elseif entityKnife:IsFlying() and not data.Flying then --knife flies
			data.Flying = true
			mod:MultiTearChargeCheck(player)
		elseif not entityKnife:IsFlying() and data.Flying then --one charge check
			data.Flying = nil
		end
	end
end
mod:AddCallback(ModCallbacks.MC_POST_KNIFE_UPDATE, mod.KnifeBowlCharge)

--updating ludo charge and fired from bowl tears
function mod:TearUpdate(entityTear)
	local player = mod:GetPlayerFromTear(entityTear)
	--updating charges with ludo
	if player then
		if not mod:GetData(entityTear).FromBowl and entityTear.TearFlags & TearFlags.TEAR_LUDOVICO == TearFlags.TEAR_LUDOVICO then
			if player:HasWeaponType(WeaponType.WEAPON_LUDOVICO_TECHNIQUE)  then
				if math.fmod(entityTear.FrameCount,8) == 0 then
					mod:MultiTearChargeCheck(player)
				end
			end
		end
		--updating slight height and acceleration of tears from bowl
		if entityTear.FrameCount == 1 and mod:GetData(entityTear).FromBowl then
			local rng = player:GetCollectibleRNG(CollectibleType.COLLECTIBLE_BOWL_OF_TEARS)
			entityTear.Height = mod:GetRandomNumber(-40,-24,rng)
			entityTear.FallingAcceleration = 1 / mod:GetRandomNumber(1,5,rng)
		end
	end
end
mod:AddCallback(ModCallbacks.MC_POST_TEAR_UPDATE, mod.TearUpdate)

--chargin lasers
function mod:BrimstoneBowlCharge(entityLaser)
	
	if entityLaser.SpawnerType == EntityType.ENTITY_PLAYER and not mod:GetData(entityLaser).isSpreadLaser then
		local player = mod:GetPlayerFromTear(entityLaser)
		if player:HasCollectible(CollectibleType.COLLECTIBLE_LUDOVICO_TECHNIQUE) then
			if math.fmod(entityLaser.FrameCount,8) == 0 then
				mod:MultiTearChargeCheck(player,true)
			end
		elseif entityLaser.Variant ~= LaserVariant.MEGA_BLAST and entityLaser.Variant ~= LaserVariant.TECH_ZERO then
			if (entityLaser.Variant == LaserVariant.BRIMSTONE or entityLaser.Variant == LaserVariant.TECH_BRIMSTONE
			or entityLaser.Variant == LaserVariant.BIG_BRIM or entityLaser.Variant == LaserVariant.TECHNOLOGY and entityLaser.SubType == 2
			or entityLaser.Variant == LaserVariant.TECHSTONE) and 
			math.fmod(entityLaser.FrameCount,4) == 1 or entityLaser.Variant == LaserVariant.TECHNOLOGY and entityLaser.FrameCount == 1 then
				mod:MultiTearChargeCheck(player)
			end
		end
	end
end
--mod:AddCallback(ModCallbacks.MC_POST_LASER_UPDATE, mod.BrimstoneBowlCharge)

--haha bombs go boom
function mod:BombBowlCharge(entityBomb)
	local player = mod:GetPlayerFromTear(entityBomb)
	if player and not mod:GetData(entityBomb).isSpreadTear then
		mod:MultiTearChargeCheck(player)
	end
end
--mod:AddCallback(ModCallbacks.MC_POST_BOMB_INIT, mod.BombBowlCharge)

--that one scene from Dr. Strangelove 
function mod:EpicBowlCharge(entityRocet)
	local player = mod:GetPlayerFromTear(entityRocet)
	if player then
		mod:ChargeBowl(player)
	end
end

mod:AddCallback(ModCallbacks.MC_POST_EFFECT_INIT, mod.EpicBowlCharge, EffectVariant.ROCKET)

--lifting and hiding bowl
function mod:UseBowl(_,_,player,_,slot)
	local data = mod:GetData(player)
	if data.HoldingBowl ~= slot then
		data.HoldingBowl = slot
		player:AnimateCollectible(CollectibleType.COLLECTIBLE_BOWL_OF_TEARS, "LiftItem", "PlayerPickup")
	else
		data.HoldingBowl = nil
		player:AnimateCollectible(CollectibleType.COLLECTIBLE_BOWL_OF_TEARS, "HideItem", "PlayerPickup")
	end
	local returntable = {Discharge = false, Remove = false, ShowAnim = false} --don't discharge, don't remove item, don't show animation
	return returntable
end
mod:AddCallback(ModCallbacks.MC_USE_ITEM, mod.UseBowl, CollectibleType.COLLECTIBLE_BOWL_OF_TEARS)

--reseting state/slot number on new room
function mod:BowlRoomUpdate()
	for _,player in pairs(Isaac.FindByType(EntityType.ENTITY_PLAYER)) do
		mod:GetData(player).HoldingBowl = nil
	end
end
mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.BowlRoomUpdate)

--taiking damage to reset state/slot number
function mod:DamagedWithBowl(player)
	mod:GetData(player).HoldingBowl = nil
end
mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, mod.DamagedWithBowl, EntityType.ENTITY_PLAYER)

--shooting tears from bowl
function mod:BowlShoot(player)
	local data = mod:GetData(player)
	if mod.MaxExtraTears ~= mod:ExtraTearSum(player) then
		mod.MaxExtraTears = mod:ExtraTearSum(player)
		data.InnerMutant20 = mod.MaxExtraTears
	end
	if not data.InnerMutant20 then
		data.InnerMutant20 = mod.MaxExtraTears
	end
	local rng = player:GetCollectibleRNG(CollectibleType.COLLECTIBLE_BOWL_OF_TEARS)
	if data.HoldingBowl ~= -1 then
		if player:GetActiveItem(ActiveSlot.SLOT_SECONDARY) == CollectibleType.COLLECTIBLE_BOWL_OF_TEARS and data.HoldingBowl then
			data.HoldingBowl = nil
			player:AnimateCollectible(CollectibleType.COLLECTIBLE_BOWL_OF_TEARS, "HideItem", "PlayerPickup")
		end
	end
	if data.HoldingBowl then
		local idx = player.ControllerIndex
		local left = Input.GetActionValue(ButtonAction.ACTION_SHOOTLEFT,idx)
		local right = Input.GetActionValue(ButtonAction.ACTION_SHOOTRIGHT,idx)
		local up = Input.GetActionValue(ButtonAction.ACTION_SHOOTUP,idx)
		local down = Input.GetActionValue(ButtonAction.ACTION_SHOOTDOWN,idx)
		local mouseclick = Input.IsMouseBtnPressed(BowlMouseClick.LEFT)
		if left > 0 or right > 0 or down > 0 or up > 0 or mouseclick then
			local angle
			if mouseclick then
				angle = (Input.GetMousePosition(true) - player.Position):Normalized():GetAngleDegrees()
			else
				angle = Vector(right-left,down-up):Normalized():GetAngleDegrees()
			end
			local shootVector = Vector.FromAngle(angle)
			local charge = data.HoldingBowl ~= -1 and mod:GetCharge(player,data.HoldingBowl) or 6
			for i= 1,mod:GetRandomNumber(charge+4,charge*2+4,rng) do
				local angle = Vector(mod:GetRandomNumber(-2,2,rng),mod:GetRandomNumber(-2,2,rng))
				local tear = player:FireTear(player.Position,shootVector*player.ShotSpeed*mod:GetRandomNumber(6,13,rng) + angle + player.Velocity,false,true,false,player)
				mod:GetData(tear).FromBowl = true
			end
			if data.HoldingBowl == -1 then
				for slot = 0,2 do
					if player:GetActiveItem(slot) == CollectibleType.COLLECTIBLE_BOWL_OF_TEARS then
						if charge < 6 then
							player:SetSoulCharge(player:GetSoulCharge() - 6 + charge)
							player:SetBloodCharge(player:GetBloodCharge() - 6 + charge)
						end
						player:SetActiveCharge(0,slot)
					end
				end
			elseif data.HoldingBowl ~= -1 then
				if charge < 6 then
					player:SetSoulCharge(player:GetSoulCharge() - 6 + charge)
					player:SetBloodCharge(player:GetBloodCharge() - 6 + charge)
				end
				player:SetActiveCharge(0,data.HoldingBowl)
			end
			data.HoldingBowl = nil
			player:AnimateCollectible(CollectibleType.COLLECTIBLE_BOWL_OF_TEARS, "HideItem", "PlayerPickup")
			if player:HasCollectible(CollectibleType.COLLECTIBLE_BOOK_OF_VIRTUES) then
				for i=1, 3 do
					player:AddWisp(CollectibleType.COLLECTIBLE_BOWL_OF_TEARS, player.Position)
				end
			end
		end
	end
end
mod:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, mod.BowlShoot)


--self explanatory
function mod:GetCharge(player,slot)
	return player:GetActiveCharge(slot) + player:GetBatteryCharge(slot)
end

--hud and sfx reactions in all slots
function mod:ChargeBowl(player)
	for slot = 0,2 do
		if player:GetActiveItem(slot) == CollectibleType.COLLECTIBLE_BOWL_OF_TEARS then
			local charge = mod:GetCharge(player,slot)
			local battery = player:HasCollectible(CollectibleType.COLLECTIBLE_BATTERY)
			if not battery and charge < 6 or battery and charge < 12 then
				player:SetActiveCharge(charge+1,slot)
				Game():GetHUD():FlashChargeBar(player,slot)
				if charge == 5 or charge == 11 then
					SFXManager():Play(SoundEffect.SOUND_ITEMRECHARGE)
				else
					SFXManager():Play(SoundEffect.SOUND_BEEP)
				end
			end
		end
	end
end

function mod:WispUpdate(wisp)
	local player = wisp.Player
	local data = mod:GetData(wisp)
	if player:HasCollectible(CollectibleType.COLLECTIBLE_BOWL_OF_TEARS) then
		if wisp.SubType == CollectibleType.COLLECTIBLE_BOWL_OF_TEARS then
			if not data.Timeout then
				data.Timeout = 90
			end
			if data.Timeout > 0 then
				data.Timeout = data.Timeout - 1
			else
				wisp:Kill()
			end
		end
	end
end

--Minimap Items Compatibility
if MiniMapiItemsAPI then
    local frame = 1
    local bowloftearsSprite = Sprite()
    bowloftearsSprite:Load("gfx/ui/minimapitems/antibirthitempack_bowloftears_icon.anm2", true)
    MiniMapiItemsAPI:AddCollectible(CollectibleType.COLLECTIBLE_BOWL_OF_TEARS, bowloftearsSprite, "CustomIconBowlOfTears", frame)
end

mod:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, mod.WispUpdate, FamiliarVariant.WISP)