--created by Lyris
--ハーピィズペットエレガントドラゴン
local s,id,o=GetID()
function s.initial_effect(c)
	--"Harpie's Pet Baby Dragon" w/ 1+ "Harpie Lady" If this card is Evolve Summoned: Special Summon up to 2 "Harpie Lady" from your Deck or GY with different original names. You cannot Special Summon monsters the turn you activate this effect, except WIND monsters. You can only use this effect of "Harpie's Pet Elegant Dragon" once per turn. Your WIND monsters gain 300 ATK.
	c:EnableReviveLimit()
	aux.AddOrigEvolveType(c)
	aux.AddEvolveProc(c,6924874,function(tp,ec,tc) return Duel.IsExistingMatchingCard(aux.AND(Card.IsFaceup,Card.IsCode),tp,LOCATION_MZONE,0,1,tc,76812113) end)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e0:SetCode(EVENT_SPSUMMON_SUCCESS)
	e0:SetCountLimit(1,id)
	e0:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e0:SetCondition(function() return c:IsSummonType(SUMMON_TYPE_EVOLVE) end)
	e0:SetCost(s.cost)
	e0:SetTarget(s.target)
	e0:SetOperation(s.operation)
	c:RegisterEffect(e0)
	Duel.AddCustomActivityCounter(id,ACTIVITY_SPSUMMON,aux.FilterBoolFunction(Card.IsAttribute,ATTRIBUTE_WIND))
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsAttribute,ATTRIBUTE_WIND))
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetValue(300)
	c:RegisterEffect(e1)
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(id,tp,ACTIVITY_SPSUMMON)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetTargetRange(1,0)
	e1:SetTarget(aux.TargetBoolFunction(aux.NOT(Card.IsAttribute),ATTRIBUTE_WIND))
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function s.filter(c,e,tp)
	return c:IsCode(76812113) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.doncheck(g)
	return g:GetClassCount(Card.GetOriginalCode)==#g
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<=0 then return end
	local g=Duel.GetMatchingGroup(s.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,nil,e,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	Duel.SpecialSummon(g:SelectSubGroup(tp,s.doncheck,false,1,math.min(ft,2)),0,tp,tp,false,false,POS_FACEUP)
end
