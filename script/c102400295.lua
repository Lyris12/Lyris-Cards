--created by Lyris
--半物質の腐敗
local s,id,o=GetID()
function s.initial_effect(c)
	--Target up to 5 of your banished "Antemattr" monsters; return them to the GY, then if you targeted 3 or more monsters, you can add 1 "Antemattr" monster from your Deck to your hand, also, banish 1 "Antemattr" monster from your Extra Deck after that, plus an additional "Antemattr" monster if you targeted 5 monsters.
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_REMOVE)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
function s.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xf87) and c:IsType(TYPE_MONSTER)
end
function s.rfilter(c)
	return c:IsSetCard(0xf87) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemove()
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_REMOVED) and chkc:IsControler(tp) and s.cfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(s.cfilter,tp,LOCATION_REMOVED,0,1,nil)
		and Duel.IsExistingMatchingCard(s.rfilter,tp,LOCATION_EXTRA,0,1,nil) end
	local mx=5
	if not Duel.IsExistingMatchingCard(s.rfilter,tp,LOCATION_EXTRA,0,2,nil) then mx=4 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectTarget(tp,s.cfilter,tp,LOCATION_REMOVED,0,1,mx,nil)
	e:SetLabel(#g)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,#g,0,0)
end
function s.filter(c)
	return c:IsSetCard(0xf87) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetTargetsRelateToChain()
	if #g==0 or Duel.SendtoGrave(g,REASON_EFFECT+REASON_RETURN)<1 then return end
	local ct=e:GetLabel()
	local mg=Duel.GetMatchingGroup(s.filter,tp,LOCATION_DECK,0,nil)
	if ct>3 and #mg>0 and Duel.SelectEffectYesNo(tp,e:GetHandler()) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=mg:Select(tp,1,1,nil)
		Duel.BreakEffect()
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
	local rt=1
	if ct==5 then rt=rt+1 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local rg=Duel.SelectMatchingCard(tp,s.rfilter,tp,LOCATION_EXTRA,0,rt,rt,nil)
	if #rg>0 then
		Duel.BreakEffect()
		Duel.Remove(rg,POS_FACEUP,REASON_EFFECT)
	end
end
