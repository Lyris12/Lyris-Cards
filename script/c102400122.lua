--created by Lyris
--機光襲雷竜－ニューン
local s,id,o=GetID()
function s.initial_effect(c)
	--1 "Blitzkrieg" monster + 1 LIGHT Dragon monster Once per turn (Quick Effect): You can destroy this card, and if you do, Special Summon 1 Level 5 or lower "Blitzkrieg" monster from your hand or GY. Unaffected by card effects that target it and cannot be targeted for attacks, while you control a Level 5 or lower "Blitzkrieg" monster. Once per turn, if another "Blitzkrieg" Monster Card(s) is destroyed: You can banish cards from your hand and/or GY face-down equal to the number of cards destroyed; destroy the top card of your Deck, and if you do, draw 1 card unless the destroyed card was a "Blitzkrieg" monster.
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,aux.FilterBoolFunction(Card.IsSetCard,0x7c4),aux.AND(aux.FilterBoolFunction(Card.IsAttribute,ATTRIBUTE_LIGHT),aux.FilterBoolFunction(Card.IsRace,RACE_DRAGON)),true)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_DESTROYED)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetCondition(function(e,tp,eg,ep,ev,re,r,rp) return eg:IsExists(s.cfilter,1,nil,tp) end)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_DRAW)
	e1:SetCost(s.cost)
	e1:SetTarget(s.tg)
	e1:SetOperation(s.op)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(s.tgcon)
	e2:SetValue(s.etarget)
	c:RegisterEffect(e2)
	local e5=e2:Clone()
	e5:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
	e5:SetValue(aux.imval1)
	c:RegisterEffect(e5)
	local e0=Effect.CreateEffect(c)
	e0:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
	e0:SetType(EFFECT_TYPE_QUICK_O)
	e0:SetRange(LOCATION_MZONE)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetCountLimit(1)
	e0:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_BATTLE_START)
	e0:SetTarget(s.destg)
	e0:SetOperation(s.desop)
	c:RegisterEffect(e0)
end
function s.desfilter(c,e,tp)
	return c:IsLevelBelow(5) and c:IsSetCard(0x7c4) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetMZoneCount(tp,c)>0
		and Duel.IsExistingMatchingCard(s.desfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.Destroy(c,REASON_EFFECT)~=0 then
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		Duel.SpecialSummon(Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.desfilter),tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp),0,tp,tp,false,false,POS_FACEUP)
	end
end
function s.tgfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x7c4) and c:IsLevelBelow(5)
end
function s.tgcon(e)
	return Duel.IsExistingMatchingCard(s.tgfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end
function s.etarget(e,re)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	return g and g:IsContains(e:GetHandler())
end
function s.cfilter(c,tp)
	return c:IsPreviousLocation(LOCATION_MZONE) and (c:IsPreviousPosition(POS_FACEUP) or c:GetPreviousControler()==tp) and c:IsPreviousSetCard(0x7c4)
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(aux.AND(s.cfilter,aux.FilterBoolFunction(Card.IsAbleToRemoveAsCost)),eg:FilterCount(s.cfilter,nil,tp),nil,tp) end
	Duel.Remove(eg:Filter(aux.AND(s.cfilter,aux.FilterBoolFunction(Card.IsAbleToRemoveAsCost)),nil,tp),POS_FACEUP,REASON_COST)
end
function s.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>0 end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,Duel.GetDecktopGroup(tp,1),1,0,0)
end
function s.op(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetDecktopGroup(tp,1)
	local tc=g:GetFirst()
	Duel.DisableShuffleCheck()
	if Duel.Destroy(g,REASON_EFFECT)~=0 then
		if not (tc:IsType(TYPE_MONSTER) and tc:IsSetCard(0x7c4)) then Duel.Draw(tp,1,REASON_EFFECT) end
	else Duel.ConfirmDecktop(tp,1) end
end
