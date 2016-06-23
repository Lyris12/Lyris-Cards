--ガーディアン・ライリス
function c101010276.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	--sum limit
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetCondition(c101010276.sumlimit)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_FLIP_SUMMON)
	c:RegisterEffect(e2)
	--Once per turn: You can target 1 monster you control; destroy that target, and if you do, Special Summon it. Any monster Special Summoned by this effect cannot be targeted by card effects.
	local e9=Effect.CreateEffect(c)
	e9:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e9:SetType(EFFECT_TYPE_IGNITION)
	e9:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e9:SetCountLimit(1)
	e9:SetRange(LOCATION_MZONE)
	e9:SetTarget(c101010276.destg)
	e9:SetOperation(c101010276.desop)
	c:RegisterEffect(e9)
end
--You can target 1 monster you control;
function c101010276.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and chkc:IsDestructable() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsDestructable,tp,LOCATION_MZONE,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,Card.IsDestructable,tp,LOCATION_MZONE,0,1,1,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c101010276.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	--destroy that target,
	if tc:IsControler(tp) and tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT) then
		--and if you do, Special Summon it.
		if Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP) then
			--Any monster Special Summoned by this effect cannot be targeted by card effects.
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetValue(1)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			tc:RegisterEffect(e1)
		end
	end
end
function c101010276.cfilter(c)
	return c:IsFaceup() and c:IsCode(101010277)
end
function c101010276.sumlimit(e)
	return not Duel.IsExistingMatchingCard(c101010276.cfilter,e:GetHandlerPlayer(),LOCATION_ONFIELD,0,1,nil)
end