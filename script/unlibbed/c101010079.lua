--PSYStream Tortise
function c101010667.initial_effect(c)
	--If you control at least 2 other "PSYStream" cards, except "PSYStream Tortise", other "PSYStream" monsters you control cannot be targeted by attacks or card effects.
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(LOCATION_MZONE,0)
	e4:SetCondition(function(e) return Duel.IsExistingMatchingCard(c101010667.afilter,e:GetHandlerPlayer(),LOCATION_ONFIELD,0,2,e:GetHandler()) end)
	e4:SetTarget(c101010667.atlimit)
	e4:SetValue(aux.imval1)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e5:SetValue(aux.tgval)
	c:RegisterEffect(e5)
	--When this card is Special Summoned: You can target 1 of your banished "PSYStream" monsters, except "PSYStream Tortise"; Special Summon it in face-up Defense Position.
	local e0=Effect.CreateEffect(c)
	e0:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e0:SetCode(EVENT_SPSUMMON_SUCCESS)
	e0:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e0:SetCountLimit(1,101010667)
	e0:SetTarget(c101010667.sptg)
	e0:SetOperation(c101010667.spop)
	c:RegisterEffect(e0)
	--If this card is banished: You can target 1 "PSYStream" monster you control; it cannot be destroyed by card effects this turn.
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_REMOVE)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e1:SetCondition(function(e,tp,eg,ep,ev,re,r,rp) local ef=e:GetHandler():GetReasonEffect() return ef and ef:GetHandler():IsSetCard(0x127) end)
	e1:SetTarget(c101010667.target)
	e1:SetOperation(c101010667.operation)
	c:RegisterEffect(e1)
	--This card can attack your opponent directly.
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_DIRECT_ATTACK)
	c:RegisterEffect(e2)
	--If this card attacks directly, any battle damage your opponent takes becomes 300 if the amount is more than than 600.
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EVENT_PRE_BATTLE_DAMAGE)
	e3:SetCondition(c101010667.rdcon)
	e3:SetOperation(c101010667.rdop)
	c:RegisterEffect(e3)
end
function c101010667.rdcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return ep~=tp and c==Duel.GetAttacker() and Duel.GetAttackTarget()==nil and ev>600
end
function c101010667.rdop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ChangeBattleDamage(ep,300)
end
function c101010667.afilter(c)
	return c:IsFaceup() and c:IsSetCard(0x127) and not c:IsCode(101010667)
end
function c101010667.atlimit(e,c)
	return c:IsFaceup() and c:IsSetCard(0x127) and c~=e:GetHandler()
end
function c101010667.con(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(101010667)>0 and (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2)
end
function c101010667.spfilter(c,e,tp)
	return c:IsSetCard(0x127) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and not c:IsCode(101010667)
end
function c101010667.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_REMOVED) and chkc:IsControler(tp) and c101010667.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c101010667.spfilter,tp,LOCATION_REMOVED,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c101010667.spfilter,tp,LOCATION_REMOVED,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c101010667.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP_DEFENCE)
	end
end
function c101010667.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x127)
end
function c101010667.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c101010667.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c101010667.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c101010667.filter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c101010667.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(1)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
		tc:RegisterEffect(e2)
	end
end