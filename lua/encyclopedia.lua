local Wiki = {
	BookOfDespair = {
		{ -- Effect
			{str = "Effect", fsize = 2, clr = 3, halign = 0},
			{str = "Halves tear delay for the current room."},
		},
		{ -- Trivia
			{str = "Trivia", fsize = 2, clr = 3, halign = 0},
			{str = "This item originated from the Binding of Isaac: Community Remix mod."},
			{str = "Upon use, Isaac starts crying, similar to his appearance after picking up Torn Photo."},
			{str = "Book Of Despair was one of the few items not imported into Repentance, alongside Bowl of Tears, Donkey Jawbone, Knife Piece 3, Menorah, Stone Bombs, and Voodoo Pin."},
		},
	},
	BowlOfTears = {
		{ -- Effect
			{str = "Effect", fsize = 2, clr = 3, halign = 0},
			{str = "Each tear shot by the player increases item charge by one."},
			{str = "Upon use, shoots a burst of tears in a selected direction."},
		},
		{ -- Notes
			{str = "Notes", fsize = 2, clr = 3, halign = 0},
			{str = "This item can be considered a combination of Isaac's Tears and Monstro's Lung."},
		},
		{ -- Interactions
			{str = "Interactions", fsize = 2, clr = 3, halign = 0},
			{str = "Chocolate Milk: Using Bowl of Tears while charging chocolate milk releases a cluster of tears which damage scales with how long you've been charging. Use while fully charged for maximum impact."},
			{str = "The Parasite / Cricket's_Body: Tears shot by the Bowl Of Tears split, dealing additional damage."},
			{str = "Dr. Fetus: No effect."},
		},
		{ -- Trivia
			{str = "Trivia", fsize = 2, clr = 3, halign = 0},
			{str = "This item originated from the Binding of Isaac: Community Remix mod."},
			{str = "Bowl of Tears was one of the few items not imported into Repentance, alongside Book Of Despair, Donkey Jawbone, Knife Piece 3, Menorah, Stone Bombs, and Voodoo Pin."},
		},
	},
	DonkeyJawbone = {
		{ -- Effect
			{str = "Effect", fsize = 2, clr = 3, halign = 0},
			{str = "When Isaac takes damage, a spin attack will damage enemies around him, doing his current damage with a multiplier."},
			{str = " - The spin attack blocks projectiles."},
			{str = " - When an enemy is killed with the spin attack, it has a chance to drop a red heart on the floor."},
		},
		{ -- Notes
			{str = "Interactions", fsize = 2, clr = 3, halign = 0},
			{str = "20/20: Grants 1 additional spin."},
			{str = "Ipecac: Spin attack poisons enemies."},
			{str = "Mutant Spider: Grants 3 additional spins."},
			{str = "The Inner Eye: Grants 2 additional spins."},
			{str = "Head of the Keeper: Enemies killed by the spin attack drop coins"},
			{str = "Holy Light: Spin attack summons holy light upon enemies hit"},
			{str = "Uranus: Enemies killed by the spin attack are frozen."},
		},
		{ -- Trivia
			{str = "Trivia", fsize = 2, clr = 3, halign = 0},
			{str = "This item is a reference to a passage from the Book of Judges in which Samson kills one thousand Philistines using only the jawbone of a donkey."},
			{str = "This item originated from the Binding of Isaac: Community Remix mod, being known as 'the sword' before release."},
			{str = " - In the Binding of Isaac: Community Remix, this item was similar to Mom's Knife. It was changed to the way it is now due to Samson's changes in Rebirth."},    
			{str = "Donkey Jawbone was one of the few items not imported into Repentance, alongside Book Of Despair, Bowl of Tears, Knife Piece 3, Menorah, Stone Bombs, and Voodoo Pin. It was replaced by Bloody Gust. However, its sprite was implemented as the weapon used by Tainted Samson."},	
		},
	},
	Menorah = {
		{ -- Effect
			{str = "Effect", fsize = 2, clr = 3, halign = 0},
			{str = "Spawns a menorah familiar that causes Isaac's tears to be multiplied by the number of lit candles."},
			{str = "The menorah starts with one candle lit, and each time Isaac is hit, another candle is lit, up to a maximum of 7 tears per shot."},
			{str = "Being hit an additional time will release blue flames that damage enemies and set the menorah to 0 for a bit, effectively making him blindfolded. After that time has passed, the candle will reset itself back to 1 lit candle."},
			{str = "Halves tear delay and then multiplies it by the sum of lit candles plus 1. This means that Isaac has the same tear delay at one candle, and 50% more tear delay at 2 candles, and so on."},
		},
		{ -- Notes
			{str = "Notes", fsize = 2, clr = 3, halign = 0},
			{str = "Menorah multiplies the original tear, rather than add additional tears to each volley. That means if the original tear has a random tear effect, all other tears will have it (and conversely, the additional tears will never have a tear effect if the original didn't)."},
		},
		{ -- Trivia
			{str = "Trivia", fsize = 2, clr = 3, halign = 0},
			{str = "Menorah was one of the few items not imported into Repentance, alongside Book Of Despair, Bowl of Tears, Donkey Jawbone, Knife Piece 3, Stone Bombs, and Voodoo Pin."},
		},
	},
	StoneBombs = {
		{ -- Effect
			{str = "Effect", fsize = 2, clr = 3, halign = 0},
			{str = "Grants 5 bombs."},
			{str = "Bombs release rock waves in the cardinal directions."},
			{str = "Rock waves can damage enemies, destroy obstacles, and reveal secret rooms."},
			{str = "Rock waves keep going until they hit a pit, metal block, or wall."},
		},
		{ -- Notes
			{str = "Notes", fsize = 2, clr = 3, halign = 0},
			{str = "Rock waves can be used to open the door to the Mines with a single bomb, if it is placed a slight distance away, so that the blast and rock wave hit the door."},
			{str = "Because the rock waves are released in all four cardinal directions, it can be used to check every single wall in a normal-sized room for a secret room."},
		},
		{ -- Trivia
			{str = "Trivia", fsize = 2, clr = 3, halign = 0},
			{str = "Stone Bombs was one of the few items not imported into Repentance, alongside Book Of Despair, Bowl of Tears, Donkey Jawbone, Knife Piece 3, Menorah, and Voodoo Pin."},
		},
	},
}

Encyclopedia.AddItem({
	ID = CollectibleType.COLLECTIBLE_BOOK_OF_DESPAIR,
	WikiDesc = Wiki.BookOfDespair,
	Pools = {
	  	Encyclopedia.ItemPools.POOL_LIBRARY,
		Encyclopedia.ItemPools.POOL_TREASURE,
		Encyclopedia.ItemPools.POOL_GREED_TREASURE,
		Encyclopedia.ItemPools.POOL_ULTRA_SECRET,
	},
})

Encyclopedia.AddItem({
	ID = CollectibleType.COLLECTIBLE_BOWL_OF_TEARS,
	WikiDesc = Wiki.BowlOfTears,
	Pools = {
		Encyclopedia.ItemPools.POOL_ANGEL,
		Encyclopedia.ItemPools.POOL_GREED_ANGEL,
	},
})

Encyclopedia.AddItem({
	ID = CollectibleType.COLLECTIBLE_DONKEY_JAWBONE,
	WikiDesc = Wiki.DonkeyJawbone,
	Pools = {
		Encyclopedia.ItemPools.POOL_TREASURE,
		Encyclopedia.ItemPools.POOL_GREED_TREASURE,
	},
})

Encyclopedia.AddItem({
	ID = CollectibleType.COLLECTIBLE_MENORAH,
	WikiDesc = Wiki.Menorah,
	Pools = {
		Encyclopedia.ItemPools.POOL_ANGEL,
		Encyclopedia.ItemPools.POOL_GREED_ANGEL,
	},
})

Encyclopedia.AddItem({
	ID = CollectibleType.COLLECTIBLE_STONE_BOMBS,
	WikiDesc = Wiki.StoneBombs,
	Pools = {
		Encyclopedia.ItemPools.POOL_BOMB_BUM,
		Encyclopedia.ItemPools.POOL_TREASURE,
		Encyclopedia.ItemPools.POOL_GREED_TREASURE,
	},
})