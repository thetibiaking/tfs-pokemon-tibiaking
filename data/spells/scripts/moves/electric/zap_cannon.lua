local time = 100
local hits = 1
local damageMultiplier = damageMultiplierMoves.frontlinear*(1+(hits-1)/4)/hits
local areaEffect = createCombatArea(NO_AREA)
local areaDamage = createCombatArea(AREATRIPLE_BEAM6)
local combat = COMBAT_ELECTRICDAMAGE

local effects = {}
table.insert(effects, 658) --dir1
table.insert(effects, 657) --dir2
table.insert(effects, 658) --dir3
table.insert(effects, 657) --dir4

local function spellCallback(uid, position, playerPosition, damage, count, dir)
	local creature = Creature(uid)
	if creature then		
		if count <= hits then			
			doAreaCombatHealth(uid, combat, position, areaEffect, 0, 0, effects[dir+1])
			doAreaCombatHealth(uid, combat, playerPosition, areaDamage, -damage, -damage, 0)
			count = count + 1
			addEvent(spellCallback, time, uid, position, playerPosition, damage, count, dir)
		end
	end
end

function onCastSpell(creature, variant)

	local damage = damageMultiplier * creature:getTotalMagicAttack()
	local position = creature:getPosition()
	local playerPosition = creature:getPosition()
	local dir = creature:getDirection()
	position:getNextPosition(dir)
	playerPosition:getNextPosition(dir)
	if dir == 0 or dir == 1 then
		position:getNextPosition(dir+1)
	else
		position:getNextPosition(dir-1)
	end
	if dir == 1 or dir == 2 then
		for i=1,5 do
			position:getNextPosition(dir)
		end
	end

	spellCallback(creature.uid, position, playerPosition, damage, 1, dir)
	return true
end
