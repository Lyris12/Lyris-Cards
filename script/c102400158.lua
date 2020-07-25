--created by Lyris
--竜の実ピタヤ
local s,id,o=GetID()
function s.initial_effect(c)
	--If a card(s) on the field is destroyed by your opponent, even during the Damage Step: You can Special Summon this card from your hand, then, if possible, make the player who controls the fewest cards destroy cards on their opponent's field until each player controls the same number of cards. You can only use this effect of "Pitaya the Fruit Dragon" once per turn.
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_DESTROYED)
	e1:SetRange(LOCATION_HAND)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DESTROY)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.spcon)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
end
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and eg:IsExists(Card.IsPreviousLocation,1,nil,LOCATION_ONFIELD)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
	local g1,g2=Duel.GetFieldGroup(0,LOCATION_ONFIELD,0),Duel.GetFieldGroup(0,0,LOCATION_ONFIELD)
	local diff=#g1-#g2
	if diff~=0 then
		local g=diff>0 and g1 or g2
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,math.abs(diff),0,0)
	end
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)<1 then return end
	local g1,g2=Duel.GetFieldGroup(0,LOCATION_ONFIELD,0),Duel.GetFieldGroup(0,0,LOCATION_ONFIELD)
	if #g1==#g2 then return end
	local p,g,ct=#g1>#g2 and (0,g1,#g1-#g2) or (1,g2,#g2-#g1)
	Duel.Hint(HINT_SELECTMSG,p,HINTMSG_REMOVE)
	local sg=g:Select(p,ct,ct,nil)
	Duel.SendtoGrave(sg,REASON_DESTROY+REASON_RULE)
end
