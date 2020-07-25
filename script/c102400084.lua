--created by Lyris
--復剣主ダルク
local s,id,o=GetID()
function s.initial_effect(c)
	--If this card attacks a Defense Position monster, inflict piercing battle damage. Gains 100 ATK for each "Swordsmaster" monster in the GY. If this card is sent to the GY: Apply this effect, depending on the number of "Swordsmasterror Dharc" in your GY. ● 1: Send 1 "Swordsmaster" monster from your Deck to the GY, except "Swordsmasterror Dharc". You must have another "Swordsmaster" monster in your GY in order to resolve this effect. ● 2+: Target 1 "Swordsmaster" monster in your GY, except "Swordsmasterror Dharc"; return that target to your hand.
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_PIERCE)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(s.val)
	c:RegisterEffect(e1)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetCategory(CATEGORY_TOGRAVE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetTarget(s.target)
	e3:SetOperation(s.operation)
	c:RegisterEffect(e3)
end
function s.val(e,c)
	return Duel.GetMatchingGroupCount(s.rfilter,e:GetHandlerPlayer(),LOCATION_GRAVE,LOCATION_GRAVE,nil)*100
end
function s.rfilter(c)
	return c:IsSetCard(0xbb2) and c:IsType(TYPE_MONSTER)
end
function s.filter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xbb2) and c:IsAbleToGrave() and not c:IsCode(id)
end
function s.thfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xbb2) and c:IsAbleToHand() and not c:IsCode(id)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		if e:GetLabel()~=0 then
			return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and s.thfilter(chkc)
		else return false end
	end
	if chk==0 then return true end
	local ct=Duel.GetMatchingGroupCount(Card.IsCode,tp,LOCATION_GRAVE,0,nil,id)
	e:SetLabel(ct)
	if ct==1 then
		Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
		e:SetProperty(0)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		Duel.SetOperationInfo(0,CATEGORY_TODECK,Duel.SelectTarget(tp,s.thfilter,tp,LOCATION_GRAVE,0,1,1,nil),#g,0,0)
		e:SetProperty(EFFECT_FLAG_CARD_TARGET)
	end
end
function s.cfilter(c)
	return c:IsSetCard(0xbb2) and c:IsType(TYPE_MONSTER)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local ct=e:GetLabel()
	if ct==1 then
		if Duel.GetMatchingGroupCount(s.cfilter,tp,LOCATION_GRAVE,0,e:GetHandler())==0 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		Duel.SendtoGrave(Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_DECK,0,1,1,nil),REASON_EFFECT)
	else
		local tc=Duel.GetFirstTarget()
		if tc and tc:IsRelateToEffect(e) and s.thfilter(c) then
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
		end
	end
end
