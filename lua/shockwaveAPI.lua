local apocrypha = RegisterMod( "ShockwaveAPI", 1) -- I just use apocrypha as my mod name because what are you gonna do, stop me? I might control F + replace it later.
apocrypha.randomV = Vector(0,0)
apocrypha.zeroV = Vector(0,0)
apocrypha.sound = SFXManager()

-- ########################## --
-- ### Shockwave API v0.5  ##### --
-- ########################## --

---- Main Code ----

local shockwaves = {}

function createShockwave(player, position, damage, duration, size, damageCooldown, selfDmg, destroyGrid, color, playSound)
    -- Default Params --
    -- Player is required!
    -- Position is required!
    damage = damage or player.Damage*3
    duration = duration or 15 -- 9 is the minimum that still looks good, otherwise theres no limit
    size = size or 1
    damageCooldown = damageCooldown or -1
    if selfDmg ~= false then selfDmg = true end
    if destroyGrid ~= false then destroyGrid = true end
    color = color or Color(1,1,1,1,0,0,0)
    if not playSound then playSound = 1 end -- Play sound can be 0, 1, or 2. 0 Wont play a sound, 1 will play a sound when shockwave is created, 2 will play a sound every few frames shockwave exists, if its duration is larger than normal. 
    -- Initialization --
    if playSound then
        apocrypha.sound:Play(SoundEffect.SOUND_ROCK_CRUMBLE, 0.5, 2, false, 1)
    end
    local ent = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.ROCK_EXPLOSION, 0, position, apocrypha.zeroV, player)
    ent.Size = ent.Size * size
    ent.Parent = player
    local eData = ent:GetData()
    eData.ShockwaveData = {damage=damage, damageCooldown = damageCooldown, hitEntities = {}, duration = duration, selfDmg = selfDmg, player = player, destroyGrid = destroyGrid, playSound = playSound}
    local sprite = ent:GetSprite()
    apocrypha.randomV.X = size
    apocrypha.randomV.Y = size
    sprite.Scale = apocrypha.randomV
    sprite.Color = color
    eData.ShockwaveData.sprite = sprite
    
    return ent
end

function createShockwaveRing(player, center, radius, direction, angleWidth, spacing, damage, duration, size, damageCooldown, selfDmg, destroyGrid, color, playSound)
    local rings = {}
    -- Although this function technically works for non-full rings, they don't look as smooth as they could if I used other methods to create them. I tried to fix the problems with a little math, but idk what I need to do exactly to make it better
    size = size or 1 -- This is a little redundant but I don't care enough rn
    spacing = spacing or 35*size
    direction = direction or apocrypha.zeroV
    angleWidth = angleWidth or 360
    -- We basically need to create shockwaves every so much distance around the ring, the question is basically "how many" since we can just rotate a vector by an angle to get the final result. 
    -- How much distance is there? Well let's just try perimeter for now
    -- 2*math.pi*radius
    local perimeter = math.pi*2*radius
    local numShockwaves = math.max(1, math.floor(perimeter/spacing + 0.5))
    local angleOffset = 360/numShockwaves
    local angle = direction:GetAngleDegrees()
    apocrypha.randomV.X = radius
    apocrypha.randomV.Y = 0
    apocrypha.randomV = apocrypha.randomV:Rotated(angle)
    local hitTable = nil
    for i = 0,numShockwaves do
        local currOffset = angleOffset*i
        if currOffset > angleWidth/2 then
            break
        end
        apocrypha.randomV.X = radius
        apocrypha.randomV.Y = 0
        apocrypha.randomV = apocrypha.randomV:Rotated(angle + currOffset)
        local shockwave = createShockwave(player, center + apocrypha.randomV, damage, duration, size, damageCooldown, selfDmg, destroyGrid, color, playSound)
        local data = shockwave:GetData()
        rings[#rings+1] = shockwave
        if i == 0 then
            hitTable = data.ShockwaveData.hitEntities
        else
            data.ShockwaveData.hitEntities = hitTable
            apocrypha.randomV.X = radius
            apocrypha.randomV.Y = 0
            apocrypha.randomV = apocrypha.randomV:Rotated(angle - currOffset)
            local shockwave2 = createShockwave(player, center + apocrypha.randomV, damage, duration, size, damageCooldown, selfDmg, destroyGrid, color, playSound)
            local data2 = shockwave2:GetData()
            data2.ShockwaveData.hitEntities = hitTable
            rings[#rings+1] = shockwave2
        end
    end
    return rings
end

function apocrypha:shockwaveUpdate()
    local player = Isaac.GetPlayer(0)
    local room = Game():GetRoom()
    local checkedHitTables = {}
    
  --  for i, ent in ipairs(Isaac.GetRoomEntities()) do; Isaac.DebugString(ent.Type .. " / " .. ent.Size .. " / " .. tostring(ent:IsVulnerableEnemy())); end 
  -- cry about it :troll:
    
    for i, ent in pairs(Isaac.FindByType(EntityType.ENTITY_EFFECT, EffectVariant.ROCK_EXPLOSION, -1, false, false)) do
        local data = ent:GetData()
        
        if data.ShockwaveData then
            -- Updating Damage Cooldown --
            if not checkedHitTables[tostring(data.ShockwaveData.hitEntities)] then
                checkedHitTables[tostring(data.ShockwaveData.hitEntities)] = true
                for InitSeed, cooldown in pairs(data.ShockwaveData.hitEntities) do
                    if cooldown >= 0 then
                        if cooldown <= 1 then
                            data.ShockwaveData.hitEntities[InitSeed] = nil
                        else
                            data.ShockwaveData.hitEntities[InitSeed] = cooldown - 1
                        end
                    end
                end
            end
            
            -- Entity Collision Code --
            for i, enemy in ipairs(Isaac.FindInRadius(ent.Position, 40, EntityPartition.ENEMY | EntityPartition.PLAYER)) do
                if i == 1 then
                   -- print("Hit entities:")
                end
               -- print("  " .. i .. ". " .. enemy.HitPoints .. "/" .. enemy.MaxHitPoints)
                if enemy:IsVulnerableEnemy() or enemy:ToPlayer() or enemy.Type == EntityType.ENTITY_FIREPLACE then
                    local str = "    - Is Vulnerable ("
                    if enemy:IsVulnerableEnemy() then
                        str = str .. "Enemy)"
                    elseif enemy:ToPlayer() then
                        str = str .. "Player)"
                    else
                        str = str .. "Fireplace)"
                    end
                   -- print(str)
                    if data.ShockwaveData.selfDmg or (enemy.InitSeed ~= data.ShockwaveData.player.InitSeed) then -- This is pure self damage, but it might be better to make this "Doesnt damage players" incase you have an entity summon this. Oh well!
                       -- print("    - Is not protected self damage")
                        if (data.ShockwaveData.damageCooldown == 0 or not data.ShockwaveData.hitEntities[enemy.InitSeed]) and (enemy.EntityCollisionClass ~= EntityCollisionClass.ENTCOLL_NONE and enemy.EntityCollisionClass ~= EntityCollisionClass.ENTCOLL_PLAYERONLY) then
                               -- print("    - Isn't on damage cooldown")
                            --if enemy.Position:Distance(ent.Position) < enemy.Size + ent.Size then
                                data.ShockwaveData.hitEntities[enemy.InitSeed] = data.ShockwaveData.damageCooldown
                                if enemy:ToPlayer() then
                                    if not enemy:ToPlayer():HasCollectible(CollectibleType.COLLECTIBLE_PYROMANIAC) then -- This was basically just to make it so crackwaves don't heal with pyromaniac. 
                                        enemy:TakeDamage(1, DamageFlag.DAMAGE_EXPLOSION, EntityRef(ent), 0)
                                    end
                                else
                                    enemy:TakeDamage(data.ShockwaveData.damage, 0, EntityRef(ent), 0)
                                end
                            --end
                        end
                    end
                end
            end
            
            -- Grid Collision Code --
            if data.ShockwaveData.destroyGrid then
				for i = 0, room:GetGridSize() do
					local Grid = room:GetGridEntity(i)
					
					if Grid then
						if Grid.Position:Distance(ent.Position) <= (40) then
							local gType = Grid:GetType()
						
							if gType == GridEntityType.GRID_ROCK_BOMB
							or gType == GridEntityType.GRID_TNT
							then
								Grid:Destroy(false)
							else
								room:DestroyGrid(i, true)
							end
						end
					end
				end
            end
            
            -- Looping Animation --
            if data.ShockwaveData.duration > 0 then
                data.ShockwaveData.duration = data.ShockwaveData.duration - 1
                local currentFrame = data.ShockwaveData.sprite:GetFrame()
                if currentFrame > 6 then
                    if data.ShockwaveData.duration > (10 + currentFrame) then
                        data.ShockwaveData.sprite:Play("Break", true)
                        data.ShockwaveData.sprite:SetLayerFrame(0, 3)
                        if data.ShockwaveData.playSound == 2 and data.ShockwaveData.duration % 2 == 0 then
                            apocrypha.sound:Play(SoundEffect.SOUND_ROCK_CRUMBLE, 0.5, 1, false, 1)
                        end
                    elseif data.ShockwaveData.duration < (16 - currentFrame) then
                        local frameDiff = 16 - currentFrame - data.ShockwaveData.duration
                        data.ShockwaveData.sprite:SetLayerFrame(0, currentFrame + frameDiff)
                    end
                end
            else
                data.ShockwaveData.sprite:SetLastFrame()
            end
            
        end
    end
end

apocrypha:AddCallback(ModCallbacks.MC_POST_UPDATE, apocrypha.shockwaveUpdate)
