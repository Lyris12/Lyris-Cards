--created by Lyris
--サイコ波動拳
local s,id,o=GetID()
function s.initial_effect(c)
	--3 LIGHT "uken" monsters with different names There can only be 1 "Psychic Hadouken" in the Monster Zone. Any card banished is placed on the bottom of the Deck instead, while your Deck has an even number of cards. You can place 1 LIGHT/Spell/Trap "uken" card from your hand or field on the bottom of the Main Deck, then target 1 card your opponent controls; send 1 card its owner controls to the GY. You can only use this of "Psychic Hadouken" once per turn.
	c:EnableReviveLimit()
	aux.AddOrigSpatialType(c)
	aux.AddSpatialProc(c,aux.drccheck,aux.TRUE,2,99)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_RANGE+EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_REMOVE_REDIRECT)
	e1:SetTargetRange(0xfe,0xfe)
	e1:SetCondition(s.condition)
	e1:SetValue(LOCATION_DECKBOT)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetCost(s.cost)
	e2:SetTarget(s.target)
	e2:SetOperation(s.operation)
	c:RegisterEffect(e2)
end
s.spt_other_space=102400028
function s.condition(e)
	return Duel.GetFieldGroupCount(e:GetHandlerPlayer(),LOCATION_DECK,0)%2<1
end
function s.cfilter(c)
	return c:IsFaceupEx() and c:IsSetCard(0x1d10) and c:IsAbleToDeckAsCost()
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,s.cfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil)
	Duel.HintSelection(g)
	Duel.SendtoDeck(g,nil,SEQ_DECKBOTTOM,REASON_COST)
end
function s.filter(c)
	return Duel.IsExistingMatchingCard(Card.IsAbleToGrave,c:GetOwner(),LOCATION_ONFIELD,0,1,nil)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) and s.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(s.filter,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local tc=Duel.SelectTarget(tp,s.filter,tp,0,LOCATION_ONFIELD,1,1,nil):GetFirst()
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tc:GetOwner(),LOCATION_ONFIELD)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToGrave,tc:GetOwner(),LOCATION_ONFIELD,0,1,1,nil)
	Duel.HintSelection(g)
	Duel.SendtoGrave(g,REASON_EFFECT)
end
