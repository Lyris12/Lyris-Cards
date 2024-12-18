--created by Nadège
--エンジェルO8
local s,id,o=GetID()
function s.initial_effect(c)
	--You can Tribute Summon this card by Tributing 1 "Angel O7". This Tribute Summoned card gains these effects. ● Monsters cannot activate their effects. Negate the attacks of Level 7 or lower monsters.
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_HAND)
	e1:SetCode(EFFECT_SUMMON_PROC)
	e1:SetCondition(s.hspcon)
	e1:SetOperation(s.hspop)
	e1:SetValue(SUMMON_TYPE_ADVANCE)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetOperation(s.regop)
	c:RegisterEffect(e2)
end
function s.hspfilter(c,ft,tp)
	return c:IsCode(56784842) and (ft>0 or (c:IsControler(tp) and c:GetSequence()<5)) and (c:IsControler(tp) or c:IsFaceup())
end
function s.hspcon(e,c,minc)
	if c==nil then return true end
	local tp=c:GetControler()
	return c:IsLevelAbove(7) and minc<=1 and Duel.CheckTribute(c,1,1,Duel.GetMatchingGroup(s.hspfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil,Duel.GetLocationCount(tp,LOCATION_MZONE),tp))
end
function s.hspop(e,tp,eg,ep,ev,re,r,rp,c)
	local sg=Duel.SelectTribute(tp,c,1,1,Duel.GetMatchingGroup(s.hspfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil,Duel.GetLocationCount(tp,LOCATION_MZONE),tp))
	c:SetMaterial(sg)
	Duel.Release(sg,REASON_SUMMON+REASON_MATERIAL)
end
function s.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsSummonType(SUMMON_TYPE_ADVANCE) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_CANNOT_ACTIVATE)
		e1:SetRange(LOCATION_MZONE)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetTargetRange(1,1)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetTarget(aux.TargetBoolFunction(Effect.IsActiveType,TYPE_MONSTER))
		c:RegisterEffect(e1)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e3:SetCode(EVENT_ATTACK_ANNOUNCE)
		e3:SetRange(LOCATION_MZONE)
		e3:SetCondition(function() return Duel.GetAttacker():IsLevelBelow(7) end)
		e3:SetOperation(function() Duel.Hint(HINT_CARD,0,id) Duel.NegateAttack() end)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e3)
	end
end
