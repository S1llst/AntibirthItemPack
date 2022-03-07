local mod = AntibirthItemPack
function mod:onEvaluateCache(player, cacheFlag)
	local data = mod:GetData(player)

	if cacheFlag == CacheFlag.CACHE_FAMILIARS then
		local numItem = player:GetCollectibleNum(CollectibleType.COLLECTIBLE_MENORAH)
		local numFamiliars = (numItem > 0 and numItem or 0)
		
		player:CheckFamiliar(FamiliarVariant.MENORAH, numFamiliars, player:GetCollectibleRNG(CollectibleType.COLLECTIBLE_MENORAH), Isaac.GetItemConfig():GetCollectible(CollectibleType.COLLECTIBLE_MENORAH))	
	end
	
	if cacheFlag == CacheFlag.CACHE_FIREDELAY then
		if player:HasCollectible(CollectibleType.COLLECTIBLE_MENORAH) then
			if data.MenorahFlames then
				if data.MenorahFlames > 0 then
					player.MaxFireDelay = (player.MaxFireDelay / (data.SewingMachineDenominator or 2)) * (data.MenorahFlames + 1)		
				end
			end
		end
	end
end

local function DupeTear(tear)
	local nt = Isaac.Spawn(tear.Type, tear.Variant, tear.SubType, tear.Position, tear.Velocity, tear):ToTear()
	nt.Parent = tear
	nt.Color = tear.Color
	nt.FallingSpeed = tear.FallingSpeed
	nt.FallingAcceleration = tear.FallingAcceleration
	nt.Height = tear.Height
	nt.Scale = tear.Scale
	nt.CollisionDamage = tear.CollisionDamage
	nt.TearFlags = nt.TearFlags | tear.TearFlags
	return nt
end

function mod:postFireTear(tear)
	local player = mod:GetPlayerFromTear(tear)
	local tearData = mod:GetData(tear)
	if player then
		local data = mod:GetData(player)
		if player:HasCollectible(CollectibleType.COLLECTIBLE_MENORAH) then
			for i = 2, data.MenorahFlames do
				local correctedVelocity = tear.Velocity:Rotated((i-1) * -3)
				if i % 2 == 0 then
					correctedVelocity = tear.Velocity:Rotated(i * 3)
				end
				
				local spreadTear = DupeTear(tear)
				spreadTear.Velocity = correctedVelocity
				
				if tearData.FromBowl then
					mod:GetData(spreadTear).FromBowl = true
				end
			end
		end
	end
end

function mod:onLaserUpdate(laser)
	local player = mod:GetPlayerFromTear(laser)
	local laserData = mod:GetData(laser)
	
	if player then
		local data = mod:GetData(player)
		if not laserData.isSpreadLaser then
			mod:BrimstoneBowlCharge(laser)
		end
		
		if player:HasCollectible(CollectibleType.COLLECTIBLE_MENORAH) then
			if (laser.FrameCount == 1) and (laser.Parent) then
				if (not laserData.isSpreadLaser) and (laser.Parent:ToPlayer() or laserData.IsIncubusTear) then
					if (laser.SubType == 0) and laser.Timeout ~= -1 then
						for i = 2, data.MenorahFlames do
							local correctedVelocity = laser.StartAngleDegrees - ((i-1) * 3)
							if i % 2 == 0 then
								correctedVelocity = laser.StartAngleDegrees + (i * 3)
							end

							local spreadLaser = nil
							if not laserData.IsIncubusTear then
								spreadLaser = EntityLaser.ShootAngle(laser.Variant, laser.Position, correctedVelocity, laser.Timeout, laser.PositionOffset, player)
							elseif laserData.IsIncubusTear then
								spreadLaser = EntityLaser.ShootAngle(laser.Variant, laser.Position, correctedVelocity, laser.Timeout, laser.PositionOffset, laser.Parent:ToFamiliar())
							
							end
							mod:GetData(spreadLaser).isSpreadLaser = true
							
							spreadLaser.TearFlags = laser.TearFlags
							spreadLaser:SetBlackHpDropChance(laser.BlackHpDropChance)
							spreadLaser:SetMaxDistance(laser.MaxDistance)
							spreadLaser:SetOneHit(laser.OneHit)
							spreadLaser:SetActiveRotation(laser.RotationDelay, laser.RotationDegrees, laser.RotationSpd, true)
							spreadLaser:SetTimeout(laser.Timeout)
							
							spreadLaser.CurveStrength = laser.CurveStrength
							spreadLaser.DisableFollowParent = laser.DisableFollowParent
							spreadLaser.IsActiveRotating = laser.IsActiveRotating
							spreadLaser.ParentOffset = laser.ParentOffset
							
							spreadLaser.CollisionDamage = laser.CollisionDamage
							spreadLaser.DepthOffset = laser.DepthOffset
							spreadLaser.EntityCollisionClass = laser.EntityCollisionClass
							spreadLaser.FlipX = laser.FlipX
							spreadLaser.Friction = laser.Friction
							spreadLaser.GridCollisionClass = laser.GridCollisionClass
							spreadLaser.HitPoints = laser.HitPoints
							spreadLaser.Mass = laser.Mass
							spreadLaser.MaxHitPoints = laser.MaxHitPoints
							spreadLaser.RenderZOffset = laser.RenderZOffset
							spreadLaser.SplatColor = laser.SplatColor
							spreadLaser.SpriteOffset = laser.SpriteOffset
							spreadLaser.SpriteRotation = laser.SpriteRotation
							spreadLaser.SpriteScale = laser.SpriteScale
							spreadLaser.Target = laser.Target
							spreadLaser.TargetPosition = laser.TargetPosition
							spreadLaser.Visible = laser.Visible
							spreadLaser.Size = laser.Size
							spreadLaser.SizeMulti = laser.SizeMulti

							local spreadSprite = spreadLaser:GetSprite()
							local sprite = laser:GetSprite()
							spreadSprite.Color = sprite.Color
							spreadSprite.FlipX = sprite.FlipX
							spreadSprite.FlipY = sprite.FlipY
							spreadSprite.Offset = sprite.Offset
							spreadSprite.PlaybackSpeed = sprite.PlaybackSpeed
							spreadSprite.Rotation = sprite.Rotation
							spreadSprite.Scale = sprite.Scale
						end
					elseif (laser.SubType == 2) then -- Tech X
						for i = 1, data.MenorahFlames do
							local correctedVelocity = laser.Velocity:Rotated((i-1) * -3)
							if i % 2 == 0 then
								correctedVelocity = laser.Velocity:Rotated(i * 3)
							end

							local spreadLaser = nil
							if not laserData.IsIncubusTear then
								spreadLaser = player:FireTechXLaser(player.Position, correctedVelocity, laser.Radius, player)
							elseif laserData.IsIncubusTear then
								spreadLaser = player:FireTechXLaser(player.Position, correctedVelocity, laser.Radius, laser.Parent:ToFamiliar())
							end
							mod:GetData(spreadLaser).isSpreadLaser = true
							
							spreadLaser.TearFlags = laser.TearFlags
							spreadLaser:SetBlackHpDropChance(laser.BlackHpDropChance)
							spreadLaser:SetMaxDistance(laser.MaxDistance)
							spreadLaser:SetOneHit(laser.OneHit)
							spreadLaser:SetTimeout(laser.Timeout)
							
							spreadLaser.CurveStrength = laser.CurveStrength
							spreadLaser.DisableFollowParent = laser.DisableFollowParent
							spreadLaser.IsActiveRotating = laser.IsActiveRotating
							spreadLaser.ParentOffset = laser.ParentOffset

							local spreadSprite = spreadLaser:GetSprite()
							local sprite = laser:GetSprite()
							spreadSprite.Color = sprite.Color
							spreadSprite.FlipX = sprite.FlipX
							spreadSprite.FlipY = sprite.FlipY
							spreadSprite.Offset = sprite.Offset
							spreadSprite.PlaybackSpeed = sprite.PlaybackSpeed
							spreadSprite.Rotation = sprite.Rotation
							spreadSprite.Scale = sprite.Scale
							
							laser:Remove()
						end
					end
				end
			end
		end
	end
end

function mod:onBombUpdate(bomb)
	local player = mod:GetPlayerFromTear(bomb)
	local bombData = mod:GetData(bomb)
	
	if player then
		local data = mod:GetData(player)
		if bomb.FrameCount == 1 and not bombData.isSpreadBomb then 
			mod:BombBowlCharge(bomb)
		end
		if player:HasCollectible(CollectibleType.COLLECTIBLE_MENORAH) then
			if (bomb.FrameCount == 1) and (bomb.Parent) and (bomb.IsFetus == true) then
				if (not bombData.isSpreadBomb) and (bomb.Parent:ToPlayer() or bombData.IsIncubusTear) then
					for i = 1, data.MenorahFlames do
						local correctedVelocity = bomb.Velocity:Rotated((i-1) * -3)
						if i % 2 == 0 then
							correctedVelocity = bomb.Velocity:Rotated(i * 3)
						end
						
						local spreadBomb = nil
						if not bombData.IsIncubusTear then
							--spreadBomb = player:FireBomb(bomb.Position, correctedVelocity, player)
							spreadBomb = Isaac.Spawn(bomb.Type,bomb.Variant,bomb.SubType,bomb.Position,correctedVelocity,player):ToBomb()
						elseif bombData.IsIncubusTear then
							--spreadBomb = player:FireBomb(bomb.Position, correctedVelocity, bomb.Parent:ToFamiliar())
							spreadBomb = Isaac.Spawn(bomb.Type,bomb.Variant,bomb.SubType,bomb.Position,correctedVelocity,bomb.Parent:ToFamiliar()):ToBomb()
						end
						mod:GetData(spreadBomb).isSpreadBomb = true
						
						spreadBomb.ExplosionDamage = bomb.ExplosionDamage
						spreadBomb.Flags = bomb.Flags
						spreadBomb.IsFetus = bomb.IsFetus
						spreadBomb.RadiusMultiplier = bomb.RadiusMultiplier
						
						local spreadSprite = spreadBomb:GetSprite()
						local sprite = bomb:GetSprite()
						spreadSprite.Color = sprite.Color
						spreadSprite.FlipX = sprite.FlipX
						spreadSprite.FlipY = sprite.FlipY
						spreadSprite.Offset = sprite.Offset
						spreadSprite.PlaybackSpeed = sprite.PlaybackSpeed
						spreadSprite.Rotation = sprite.Rotation
						spreadSprite.Scale = sprite.Scale
						
						bomb:Remove()
					end
				end
			end
		end
	end
end

function mod:onFamiliarInit(menorah)
	local player = menorah.Player
	local data = mod:GetData(player)
	data.MenorahFlames = 1
	
    menorah.IsFollower = true
	menorah:AddToFollowers()
end

function mod:onFamiliarUpdate(menorah)
	local sprite = menorah:GetSprite()
	local player = menorah.Player
	local data = mod:GetData(player)
		
	if data.MenorahFlames == 1 then
		sprite:Play("Idle1", false)
	elseif data.MenorahFlames == 2 then
		sprite:Play("Idle2", false)		
	elseif data.MenorahFlames == 3 then
		sprite:Play("Idle3", false)
	elseif data.MenorahFlames == 4 then
		sprite:Play("Idle4", false)
	elseif data.MenorahFlames == 5 then
		sprite:Play("Idle5", false)
	elseif data.MenorahFlames == 6 then
		sprite:Play("Idle6", false)
	elseif data.MenorahFlames == 7 then
		sprite:Play("Idle7", false)
	elseif data.MenorahFlames == 0 then
		sprite:Play("Burst", false)
		if sprite:IsEventTriggered("Burst") then
			data.MenorahTimer = menorah.FrameCount
			if not data.SewingMachineUltra then
				player:SetShootingCooldown(240)
			end
			local shotSpeed = player.ShotSpeed * 10
			
			for i=1,8 do
				local projVel = Vector(0,1) * shotSpeed
				if i == 2 then
					projVel = Vector(0,-1) * shotSpeed
				elseif i == 3 then
					projVel = Vector(1,0) * shotSpeed
				elseif i == 4 then
					projVel = Vector(-1,0) * shotSpeed
				elseif i == 5 then
					projVel = Vector(1,1) * shotSpeed
				elseif i == 6 then
					projVel = Vector(1,-1) * shotSpeed
				elseif i == 7 then
					projVel = Vector(-1,1) * shotSpeed
				elseif i == 8 then
					projVel = Vector(-1,-1) * shotSpeed
				end
				local flame = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.BLUE_FLAME, 0, menorah.Position, projVel, menorah):ToEffect()
				flame:SetDamageSource(EntityType.ENTITY_PLAYER)
				flame.LifeSpan = 60
				flame.Timeout = 60
				flame.State = 1
				flame.CollisionDamage = 23
			end
		end
	end
	
	if data.MenorahFlames == 0 then
		if data.MenorahTimer then
			if menorah.FrameCount == data.MenorahTimer + 120 then
				data.MenorahFlames = 1
			end
		end
	end
	menorah:FollowParent()
end

function mod:onDamage(tookDamage, damageAmount, damageFlags, damageSource, damageCountdownFrames)
	local player = tookDamage:ToPlayer()
	local data = mod:GetData(player)
		
	if player:HasCollectible(CollectibleType.COLLECTIBLE_MENORAH) then
		if data.MenorahFlames > 0 then
			data.MenorahFlames = data.MenorahFlames + 1
				
			if data.MenorahFlames > 7 then
				data.MenorahFlames = 0
			end
					
			player:AddCacheFlags(CacheFlag.CACHE_FIREDELAY)
			player:EvaluateItems()
		end
	end
end


if Sewn_API then
	Sewn_API:MakeFamiliarAvailable(FamiliarVariant.MENORAH, CollectibleType.COLLECTIBLE_MENORAH)

	local function MenorahSewingUpdateDefault(_, menorah)
		local data = mod:GetData(menorah.Player)
		data.SewingMachineDenominator = 3
	end
	local function MenorahSewingUpdateUltra(_, menorah)
		local data = mod:GetData(menorah.Player)
		data.SewingMachineDenominator = 4
		data.SewingMachineUltra = true
	end

	Sewn_API:AddCallback(Sewn_API.Enums.ModCallbacks.FAMILIAR_UPDATE, MenorahSewingUpdateDefault, FamiliarVariant.MENORAH)
	Sewn_API:AddCallback(Sewn_API.Enums.ModCallbacks.FAMILIAR_UPDATE, MenorahSewingUpdateUltra, FamiliarVariant.MENORAH,  Sewn_API.Enums.FamiliarLevelFlag.FLAG_ULTRA)
end

--Minimap Items Compatibility
if MiniMapiItemsAPI then
    local frame = 1
    local menorahSprite = Sprite()
    menorahSprite:Load("gfx/ui/minimapitems/antibirthitempack_menorah_icon.anm2", true)
    MiniMapiItemsAPI:AddCollectible(CollectibleType.COLLECTIBLE_MENORAH, menorahSprite, "CustomIconMenorah", frame)
end

mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, mod.onEvaluateCache, CacheFlag.CACHE_FAMILIARS)
mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, mod.onEvaluateCache, CacheFlag.CACHE_FIREDELAY)
mod:AddCallback(ModCallbacks.MC_POST_FIRE_TEAR, mod.postFireTear)
mod:AddCallback(ModCallbacks.MC_POST_LASER_UPDATE, mod.onLaserUpdate)
mod:AddCallback(ModCallbacks.MC_POST_BOMB_UPDATE, mod.onBombUpdate)
mod:AddCallback(ModCallbacks.MC_FAMILIAR_INIT, mod.onFamiliarInit, FamiliarVariant.MENORAH)
mod:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, mod.onFamiliarUpdate, FamiliarVariant.MENORAH)
mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, mod.onDamage, EntityType.ENTITY_PLAYER)