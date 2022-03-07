--Mod Icon
EID:setModIndicatorName("Antibirth Item Pack")
local iconSprite = Sprite()
iconSprite:Load("gfx/eid_icon_AntibirthItemPack.anm2", true)
EID:addIcon("Antibirth Item Pack Icon", "AntibirthItemPack", 0, 32, 32, 6, 6, iconSprite)
EID:setModIndicatorIcon("Antibirth Item Pack Icon")

--Book of Despair
EID:addCollectible(CollectibleType.COLLECTIBLE_BOOK_OF_DESPAIR, "↑ {{Tears}} +100% Tears up when used", "Book of Despair", "en_us")
EID:addCollectible(CollectibleType.COLLECTIBLE_BOOK_OF_DESPAIR, "↑ {{Tears}} Lágrimas +100% al usarlo", "El Libro de la Desesperación", "spa")
EID:addCollectible(CollectibleType.COLLECTIBLE_BOOK_OF_DESPAIR, "↑ {{Tears}} +100% к скорострельности", "Книга отчаяния", "ru")
EID:addCollectible(CollectibleType.COLLECTIBLE_BOOK_OF_DESPAIR, "↑ {{Tears}} +100% Lágrimas quando usado", "Livro de Despeiro", "pt_br")
EID:assignTransformation("collectible", CollectibleType.COLLECTIBLE_BOOK_OF_DESPAIR, "12") -- Bookworm

--Bowl of Tears
EID:addCollectible(CollectibleType.COLLECTIBLE_BOWL_OF_TEARS, "Fires a cluster of tears#Each tear shot by Isaac increases item charge by one", "Bowl of Tears", "en_us")
EID:addCollectible(CollectibleType.COLLECTIBLE_BOWL_OF_TEARS, "Otorga una recarga por cada lágrima que dispare el jugador#Al usarse, dispara una ráfaga de lágrimas en la dirección seleccionada", "Tazón de Lágrimas", "spa")
EID:addCollectible(CollectibleType.COLLECTIBLE_BOWL_OF_TEARS, "Стреляет скоплением слёз#Каждый выстрел слезы Исааком увеличивает заряд артефакта на один", "Чаша слёз", "ru")
EID:addCollectible(CollectibleType.COLLECTIBLE_BOWL_OF_TEARS, "Attire uma cacho de lágrimas#Cada lágrima atirada por Isaac aumenta a carga da barra de espaço por um", "Tigela de Lágrimas", "pt_br")

--Donkey Jawbone
EID:addCollectible(CollectibleType.COLLECTIBLE_DONKEY_JAWBONE, "Upon taking damage, this item causes you do a spin attack, dealing damage to nearby enemies and blocking projectiles for a short while", "Donkey Jawbone", "en_us")
EID:addCollectible(CollectibleType.COLLECTIBLE_DONKEY_JAWBONE, "Al recibir daño, realizarás un ataque giratorio, dañando a los enemigos cercanos y bloqueando proyectiles por un momento", "Quijada de burro", "spa")
EID:addCollectible(CollectibleType.COLLECTIBLE_DONKEY_JAWBONE, "При получении урона заставляет совершить круговую атаку, которая наносит урон ближайшим врагам и на короткое время блокирует снаряды", "Ослиная челюсть", "ru")
EID:addCollectible(CollectibleType.COLLECTIBLE_DONKEY_JAWBONE, "Quando for atingido, esse item cause que você faça um ataque de giro, causando dano para inimigos próximos e bloqueando projéteis por uma duração curta", "Maxilar de Burro", "pt_br")

--Menorah
EID:addCollectible(CollectibleType.COLLECTIBLE_MENORAH, "Spawns a menorah familiar that causes Isaac's tears to be multiplied by the number of lit candles#Halves tear delay and then multiplies it by the sum of lit candles plus 1", "Menorah", "en_us")
EID:addCollectible(CollectibleType.COLLECTIBLE_MENORAH, "Genera un familiar Menorah#El número de lágirmas Isaac aumentan en función de las velas encendidas, máximo 7 velas#↓ {{Tears}} Menos lágrimas mientras más velas encendidas#Las velas se encienden recibiendo daño", "Menorah", "spa")
EID:addCollectible(CollectibleType.COLLECTIBLE_MENORAH, "Создает подсвечник, который заставляет слезы Исаака размножиться на количество зажжённых свечей#Уменьшает скорострельность, а затем умножает её на количество зажженных свечей плюс 1", "Менора", "ru")
EID:addCollectible(CollectibleType.COLLECTIBLE_MENORAH, "Gere um familiar menorah que causa as lágrimas des Isaac para ser multiplicadas por o número de velas acesas#O tempo entre cada lágrima e dividido por 2, e consequentemente multiplicado por a soma das velas acesas mais 1", "Menorah", "pt_br")

--Stone Bombs
EID:addCollectible(CollectibleType.COLLECTIBLE_STONE_BOMBS, "Placed bombs now explode and create rock waves in all 4 cardinal directions#The rock waves can damage enemies, destroy objects, and reveal secret rooms#+5 Bombs", "Stone Bombs", "en_us")
EID:addCollectible(CollectibleType.COLLECTIBLE_STONE_BOMBS, "Las bombas colocadas ahora generan olas de piedra en los 4 puntos cardinales al explotar#Las olas de piedra pueden dañar enemigos, destruir objetos y revelar salas secretas#+5 bombas", "Bombas de Piedra", "spa")
EID:addCollectible(CollectibleType.COLLECTIBLE_STONE_BOMBS, "Бомбы теперь создают каменные волны во все 4-е основные стороны#Каменные волны могут наносить урон врагам, разрушать объекты и открывать секретные комнаты# + 5 бомб", "Каменные бомбы", "ru")
EID:addCollectible(CollectibleType.COLLECTIBLE_STONE_BOMBS, "Bombas colocadas agora explodem e criam ondas de pedra em 4 direções cardeais#As ondas de pedra podem causar dano aos inimigos, destruir objetos, e relevar salas sexretas#+5 Bombas", "Bombas de Pedra", "pt_br")

if Sewn_API then
	Sewn_API:AddFamiliarDescription(
		FamiliarVariant.MENORAH,
		"Higher fire rate per flame",
		"Higher fire rate per flame#You can keep firing even with no flames"
	)
end