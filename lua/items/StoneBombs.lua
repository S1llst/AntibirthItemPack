local mod = AntibirthItemPack

local bombs = {}

local directions = {
	Vector(1, 0),
	Vector(0, 1),
	Vector(-1, 0),
	Vector(0, -1),
}

function mod:SB_BombUpdate(bomb)
	local player = mod:GetPlayerFromTear(bomb)
	if player then
		if bomb.Type == EntityType.ENTITY_BOMB then
			if bomb.Variant ~= BombVariant.BOMB_THROWABLE then
				if player:HasCollectible(CollectibleType.COLLECTIBLE_STONE_BOMBS) then
					local sprite = bomb:GetSprite()
					
					if bomb.FrameCount == 1 then
						if bomb.Variant == BombVariant.BOMB_NORMAL then
							if not bomb:HasTearFlags(TearFlags.TEAR_BRIMSTONE_BOMB) then
								if bomb:HasTearFlags(TearFlags.TEAR_GOLDEN_BOMB) then
									sprite:ReplaceSpritesheet(0, "gfx/items/pick ups/bombs/costumes/stone_bombs_gold.png")
									sprite:LoadGraphics()
								else
									sprite:ReplaceSpritesheet(0, "gfx/items/pick ups/bombs/costumes/stone_bombs.png")
									sprite:LoadGraphics()
								end
							end
						end
					end
					
					bombs[bomb.Index] = {bomb=bomb, sprite=sprite, dmg=bomb.ExplosionDamage, player=player}
				end
			end
		end
	end
end
mod:AddCallback(ModCallbacks.MC_POST_BOMB_UPDATE, mod.SB_BombUpdate)

function mod:SB_HandleShockwaves()	
	local room = Game():GetRoom()
	local height = room:GetGridHeight()
	local width = room:GetGridWidth()

	for k, v in pairs(bombs) do
		local bomb = v.bomb

		if not v.i and v.sprite:IsPlaying("Explode") then
			v.i = 3
			v.pos = bomb.Position
		end

		if v.i then
			v.i = v.i + 1
			local i = v.i
			local flag = false
			local index = room:GetGridIndex(v.pos)
			local gridpos = Vector(index%width, math.floor(index/width))

			if i % 4 == 0 then
				for _, dir in pairs(directions) do
					local gridpos = gridpos + dir*i/4
					local index = gridpos.X+gridpos.Y*width
					if gridpos.X>0 and gridpos.X<width and gridpos.Y>0 and gridpos.Y<height then
						local pos2 = room:GetGridPosition(index, 1)

						if room:IsPositionInRoom(pos2, 0) then
							local gridAtPosition = room:GetGridEntityFromPos(pos2)
							if (not gridAtPosition) or (gridAtPosition:GetType() ~= GridEntityType.GRID_PIT) then
								createShockwave(v.player, pos2, 25, 30, 1, -1, false, true)														
								flag = true
							end
						end
					end
				end

				if not flag then
					bombs[k] = nil
				end
			end
		end
	end
end
mod:AddCallback(ModCallbacks.MC_POST_UPDATE, mod.SB_HandleShockwaves)

function mod:SB_PostNewRoom()
	bombs = {}
end

--Minimap Items Compatibility
if MiniMapiItemsAPI then
    local frame = 1
    local stonebombsSprite = Sprite()
    stonebombsSprite:Load("gfx/ui/minimapitems/antibirthitempack_stonebombs_icon.anm2", true)
    MiniMapiItemsAPI:AddCollectible(CollectibleType.COLLECTIBLE_STONE_BOMBS, stonebombsSprite, "CustomIconStoneBombs", frame)
end

mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.SB_PostNewRoom)