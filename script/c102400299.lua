--created by Lyris
--半物質のヴォイド
local s,id,o=GetID()
function s.initial_effect(c)
	--While your opponent controls more monsters than you do, you can use 1 of those monsters as Space Material, as if you controlled it. You can only Special Summon from the Extra Deck once during the turn you use this effect. You can banish 1 card from your hand; add 1 "Antemattr" card with a different name from your Deck to your hand, except "Antemattr Void". You can only use this effect of "Antemattr Void" once per turn.
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	aux.EnableExtraDeckSummonCountLimit()
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(id)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(0,LOCATION_MZONE)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_EXTRA_SPACE_MATERIAL)
	e3:SetOperation(s.xmop(c))
	e3:SetValue(s.xmval)
	c:RegisterEffect(e3)
	Duel.AddCustomActivityCounter(id,ACTIVITY_SPSUMMON,aux.FilterBoolFunction(aux.NOT(Card.IsSummonLocation),LOCATION_EXTRA))
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_FZONE)
	e4:SetCountLimit(1,id)
	e4:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e4:SetCost(s.cost)
	e4:SetTarget(s.target)
	e4:SetOperation(s.operation)
	c:RegisterEffect(e4)
end
function s.xmop(c)
	return  function(tc,tp)
				Duel.SendtoGrave(tc,REASON_MATERIAL+REASON_SPATIAL)
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_FIELD)
				e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
				e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
				e1:SetTargetRange(1,0)
				e1:SetTarget(s.splimit)
				e1:SetReset(RESET_PHASE+PHASE_END)
				Duel.RegisterEffect(e1,tp)
				local e2=Effect.CreateEffect(c)
				e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
				e2:SetCode(EVENT_SPSUMMON_SUCCESS)
				e2:SetOperation(s.checkop)
				e2:SetReset(RESET_PHASE+PHASE_END)
				Duel.RegisterEffect(e2,tp)
				local e3=Effect.CreateEffect(c)
				e3:SetType(EFFECT_TYPE_FIELD)
				e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
				e3:SetCode(92345028)
				e3:SetTargetRange(1,0)
				e3:SetReset(RESET_PHASE+PHASE_END)
				Duel.RegisterEffect(e3,tp)
			end
end
function s.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return c:IsLocation(LOCATION_EXTRA) and aux.ExtraDeckSummonCountLimit[sump]<=0
end
function s.cfilter(c,tp)
	return c:IsSummonPlayer(tp) and c:IsPreviousLocation(LOCATION_EXTRA)
end
function s.checkop(e,tp,eg,ep,ev,re,r,rp)
	if eg:IsExists(s.cfilter,1,nil,tp) then
		aux.ExtraDeckSummonCountLimit[tp]=aux.ExtraDeckSummonCountLimit[tp]-1
	end
	if eg:IsExists(s.cfilter,1,nil,1-tp) then
		aux.ExtraDeckSummonCountLimit[1-tp]=aux.ExtraDeckSummonCountLimit[1-tp]-1
	end
end
function s.xmval(e,c,g)
	local tp=e:GetHandlerPlayer()
	return Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)>Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)
		and Duel.GetCustomActivityCount(id,tp,ACTIVITY_SPSUMMON)==0 and not g:IsExists(Card.IsHasEffect,1,c,id)
end
function s.rfilter(c,tp)
	return c:IsAbleToRemoveAsCost() and Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_DECK,0,1,nil,c:GetCode())
end
function s.filter(c,...)
	return c:IsSetCard(0xf87) and not c:IsCode(id,...) and c:IsAbleToHand()
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(0)
	if chk==0 then return Duel.IsExistingMatchingCard(s.rfilter,tp,LOCATION_HAND,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local tc=Duel.SelectMatchingCard(tp,s.rfilter,tp,LOCATION_HAND,0,1,1,nil,tp)
	e:SetLabel(tc:GetCode())
	Duel.Remove(tc,POS_FACEUP,REASON_COST)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:IsCostChecked() or Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_DECK,0,1,nil,0) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_DECK,0,1,1,nil,e:GetLabel())
	Duel.SendtoHand(g,nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,g)
end
