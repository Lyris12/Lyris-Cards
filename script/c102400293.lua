--created by Lyris
--半物質のピクシ(アナザー宙)
local s,id,o=GetID()
function s.initial_effect(c)
	--2 "Antemattr" monsters If this card is Spatial Summoned: You can Special Summon 1 of your banished "Antemattr" monsters, except "Antemattr Pixie". You can only use this effect of "Antemattr Pixie" once per turn.
	c:EnableReviveLimit()
	aux.AddOrigSpatialType(c)
	aux.AddSpatialProc(c,nil,aux.FilterBoolFunction(Card.IsSetCard,0xf87),2,2)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,id)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetCondition(function() return c:IsSummonType(SUMMON_TYPE_SPATIAL) end)
	e1:SetTarget(s.tg)
	e1:SetOperation(s.op)
	c:RegisterEffect(e1)
end
s.spt_other_space=102400289
function s.filter(c,e,tp)
	return c:IsFaceup() and c:IsSetCard(0xf87) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and not c:IsCode(id)
end
function s.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_REMOVED,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,tp,LOCATION_REMOVED)
end
function s.op(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	Duel.SpecialSummon(Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_REMOVED,0,1,1,nil,e,tp),0,tp,tp,false,false,POS_FACEUP)
end
