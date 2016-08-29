--EE・ナヌーク
function c101010004.initial_effect(c)
--spsummon
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(101010004,0))
	e0:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e0:SetType(EFFECT_TYPE_IGNITION)
	e0:SetRange(LOCATION_GRAVE)
	e0:SetCountLimit(1,101010004)
	e0:SetCost(c101010004.spcost)
	e0:SetTarget(c101010004.sptg)
	e0:SetOperation(c101010004.spop)
	c:RegisterEffect(e0)
	--disact
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,101010004)
	e1:SetCondition(c101010004.dtcon)
	e1:SetTarget(c101010004.tg)
	e1:SetOperation(c101010004.op)
	c:RegisterEffect(e1)
end
function c101010004.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Group.CreateGroup()
	if chk==0 then
		for i=0,4 do
			local tc=Duel.GetFieldCard(tp,LOCATION_MZONE,i)
			if tc and tc:IsFaceup() and tc:IsAttribute(ATTRIBUTE_EARTH) and tc:IsType(TYPE_XYZ) then
				g:Merge(tc:GetOverlayGroup())
			end
		end
		return g:GetCount()>0
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVEXYZ)
	local sg=g:Select(tp,1,1,nil)
	Duel.SendtoGrave(sg,REASON_EFFECT)
end
function c101010004.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c101010004.spop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP)
	end
end
function c101010004.dtcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsReason(REASON_COST) and re:IsHasType(0x7e0) and re:IsActiveType(TYPE_MONSTER)
		and c:IsPreviousLocation(LOCATION_OVERLAY) and re:GetHandler():IsSetCard(0xeeb)
end
function c101010004.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsOnField() and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	e:SetLabelObject(Duel.SelectTarget(tp,Card.IsFaceup,tp,0,LOCATION_ONFIELD,1,1,nil))
end
function c101010004.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local typ=e:GetLabelObject():GetFirst():GetType()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetTargetRange(0,1)
	e1:SetLabel(typ)
	e1:SetValue(c101010004.aclimit)
	e1:SetReset(RESET_PHASE+PHASE_END+RESET_SELF_TURN,1)
	Duel.RegisterEffect(e1,tp)
end
function c101010004.aclimit(e,re,tp)
	if re:GetHandler():IsImmuneToEffect(e) then return false end
	local val=bit.band(re:GetActiveType(),0x7)
	return val==bit.band(e:GetLabel(),0x7)
end
