--created by Lyris
--半物質の放射
local s,id,o=GetID()
function s.initial_effect(c)
	--Banish 1 "Antemattr" card from your field, then target 1 of your banished "Antemattr" monsters with a different name; Special Summon it, then for the rest of this turn, all your opponent's effects in that column are negated. You can only activate 1 "Antemattr Radiation" per turn.
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DISABLE)
	e1:SetCost(function() e1:SetLabel(100) return true end)
	e1:SetTarget(s.tg)
	e1:SetOperation(s.op)
	c:RegisterEffect(e1)
end
function s.cfilter(c,e,tp)
	return c:IsFaceup() and c:IsSetCard(0xf87) and c:IsAbleToRemoveAsCost() and Duel.IsExistingTarget(s.filter,tp,LOCATION_REMOVED,0,1,nil,e,tp,c:GetCode())
end
function s.filter(c,e,tp,code)
	return c:IsFaceup() and c:IsSetCard(0xf87) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and not (code and c:IsCode(code))
end
function s.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_REMOVED) and chkc:IsControler(tp) and s.filter(chkc,e,tp,e:GetLabel()) end
	local l=e:GetLabel()==100
	if chk==0 then e:SetLabel(0) return l and Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_ONFIELD,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local tc=Duel.SelectMatchingCard(tp,s.cfilter,tp,LOCATION_ONFIELD,0,1,1,nil,e,tp):GetFirst()
	Duel.Remove(tc,POS_FACEUP,REASON_COST)
	local code=tc:GetCode()
	e:SetLabel(code)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,Duel.SelectTarget(tp,s.filter,tp,LOCATION_REMOVED,0,1,1,nil,e,tp,code),1,0,0)
end
function s.op(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)>0 then
		local e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_FIELD)
		e4:SetCode(EFFECT_DISABLE)
		e4:SetTargetRange(0,LOCATION_ONFIELD)
		e4:SetTarget(s.distg)
		e4:SetLabel(tc:GetSequence())
		e4:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e4,tp)
		local e5=Effect.CreateEffect(c)
		e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e5:SetCode(EVENT_CHAIN_SOLVING)
		e5:SetOperation(s.disop)
		e5:SetReset(RESET_PHASE+PHASE_END)
		e5:SetLabel(tc:GetSequence())
		Duel.RegisterEffect(e5,tp)
		local e6=Effect.CreateEffect(c)
		e6:SetType(EFFECT_TYPE_FIELD)
		e6:SetCode(EFFECT_DISABLE_TRAPMONSTER)
		e6:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
		e6:SetTarget(s.distg)
		e6:SetReset(RESET_PHASE+PHASE_END)
		e6:SetLabel(tc:GetSequence())
		Duel.RegisterEffect(e6,tp)
		Duel.Hint(HINT_ZONE,tp,0x101<<tc:GetSequence())
	end
end
function s.distg(e,c)
	return aux.GetColumn(c,e:GetHandlerPlayer())==e:GetLabel()
end
function s.disop(e,tp,eg,ep,ev,re,r,rp)
	local loc,seq=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION,CHAININFO_TRIGGERING_SEQUENCE)
	if loc&LOCATION_ONFIELD~=0 and seq<=4 and rp==1-tp and seq==4-e:GetLabel() then Duel.NegateEffect(ev) end
end
