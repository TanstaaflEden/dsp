-----------------------------------
-- Area: Waughroon Shrine
-- MOB: Heavy Metal Crab
-- BCNM Fight: Crustacean Conundrum
-----------------------------------
mixins = {require("scripts/mixins/job_special")};

function onMobSpawn(mob)

	--A combination of mods to bring all damage dealt into the 0-2 range per hit

	mob:addMod(dsp.mod.DMGPHYS,-67)
	mob:addMod(dsp.mod.DMGBREATH,-92)
	mob:addMod(dsp.mod.UDMGPHYS,0)
	mob:addMod(dsp.mod.UDMGBREATH,-92)
	mob:addMod(dsp.mod.UDMGMAGIC,-80)
	
	mob:setMod(dsp.mod.VIT,300)
    mob:setMod(dsp.mod.DEF,3000)
	mob:setMod(dsp.mod.RDEF,3000)
	mob:setMod(dsp.mod.CRIT_DEF_BONUS,50)
	
	mob:setMod(dsp.mod.MDEF,1000)
end

function onMobFight(mob, target)
	local uDamagePhysical = 0
	
	--Stronger weapons get a larger reduction in order to bring everyone down to 0-2 DMG per hit
	
	local uDamagePhysicalW = (target:getWeaponDmg() - 8) * -5
	local uDamagePhysicalS = (target:getOffhandDmg() - 8) * -5
	
	--Finds the largest reduction to apply to UDMGPHYS

	if (uDamagePhysical > uDamagePhysicalW) then
		uDamagePhysical = uDamagePhysicalW
	end
	
	if (uDamagePhysical > uDamagePhysicalS) then
		uDamagePhysical = uDamagePhysicalS
	end
	
	--Caps the reduction to UDMGPHYS at -75
	
	if (uDamagePhysical < -75) then
		uDamagePhysical = -75
	end
	
	mob:setMod(dsp.mod.UDMGPHYS,uDamagePhysical)
	
	target:setMod(dsp.mod.BP_DAMAGE,-95)
	target:setMod(dsp.mod.SHIELD_BASH,-20)
	target:setMod(dsp.mod.WEAPON_BASH,-6)
	target:setMod(dsp.mod.SPIKES_DMG,0)
end

--The crabs have an Endrain effect that goes off 50% of the time for 30 HP

function onAdditionalEffect(mob,target,damage)
    local chance = 50

    if (math.random(0,99) >= chance) then
        return 0,0,0
    else
        local power = 30
        
        power = power * applyResistanceAddEffect(mob,target,dsp.magic.ele.DARK,0)
        power = adjustForTarget(target,power,dsp.magic.ele.DARK)
        power = finalMagicNonSpellAdjustments(mob,target,dsp.magic.ele.DARK,power)

        if (power < 0) then
            power = 0
        else
            mob:addHP(power)
        end

        return dsp.subEffect.HP_DRAIN, dsp.msg.basic.ADD_EFFECT_HP_DRAIN, power
    end
end

function onMobDeath(mob, player, isKiller)
end;
