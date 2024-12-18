--created by Lyris
--サイバー・ドラゴン・ウェブスクレープ
local s,id,o=GetID()
function s.initial_effect(c)
	--"Cyber Dragon" + 1 Machine or "Cyber Dragon" monster Must first be Fusion Summoned. Gains ATK equal to the highest ATK on the field (except this card), while its original name is "Cyber Dragon Web-Scrape". Once per turn (Quick Effect): You can target 1 "Cyber Dragon" monster, or 1 monster that mentions "Cyber Dragon", in your GY or that is banished; Special Summon it. There can only be 1 "Cyber Dragon Web-Scrape" on the field. You can banish this card from your GY; this turn, while you control "Cyber Dragon", your opponent cannot activate cards or effects in response to your cards or effects that include an effect that Special Summons a Fusion Monster.
	c:EnableReviveLimit()
	aux.AddFusionProcCodeFun(c,70095154,s.mfilter,1,true,true)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SINGLE_RANGE)
	e1:SetValue(aux.fuslimit)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE,EFFECT_FLAG2_WICKED)
	e2:SetCondition(s.acon)
	e2:SetValue(s.aval)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,id)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetTarget(s.sptg)
	e3:SetOperation(s.spop)
	c:RegisterEffect(e3)
	c:SetUniqueOnField(1,1,id)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetCost(aux.bfgcost)
	e4:SetOperation(s.nrop)
	c:RegisterEffect(e4)
end
function s.mfilter(c)
	return c:IsRace(RACE_MACHINE) or c:IsFusionSetCard(0x1093)
end
function s.acon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsOriginalCodeRule(id)
end
function s.aval(e,c)
	local g=Duel.GetMatchingGroup(Card.IsFaceup,0,LOCATION_MZONE,LOCATION_MZONE,nil)
	local tg,val=g:GetMaxGroup(Card.GetAttack)
	return #g>0 and val or 0
end
function s.filter(c,e,tp)
	return c:IsFaceupEx() and (c:IsSetCard(0x1093) or aux.IsCodeListed(c,70095154)) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED) and chkc:IsControler(tp)
		and s.filter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(s.filter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,Duel.SelectTarget(tp,s.filter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,e,tp),1,0,0)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP) end
end
function s.nrop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAINING)
	e1:SetOperation(s.chainop)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function s.cfilter(c)
	return c:IsFaceup() and c:IsCode(70095154)
end
function s.chainop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_ONFIELD,0,1,nil)
		and re:IsHasCategory(CATEGORY_FUSION_SUMMON) and ep==tp then Duel.SetChainLimit(s.chainlm) end
end
function s.chainlm(e,rp,tp)
	return tp==rp
end
