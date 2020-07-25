--created by Lyris
--フォトンシック・タキオン
local s,id,o=GetID()
function s.initial_effect(c)
	--When your opponent activates a monster effect while a "Photon" or "Galaxy" card is on your field or GY: Reveal 1 Rank 8 "Galaxy-Eyes" Xyz Monster in your Extra Deck; Negate the activation, then Special Summon the revealed monster using that opponent's monster as the material. (This is treated as an Xyz Summon. Transfer its materials to the Summoned monster.) You can only activate 1 "Photonsic Tachyon" per turn. If all monsters you control are LIGHT and/or Dragon monsters (min. 1), you can activate this card from your hand.
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_SPECIAL_SUMMON)
	e1:SetCondition(s.condition)
	e1:SetCost(s.cost)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e2:SetCondition(s.hcon)
	c:RegisterEffect(e2)
end
function s.rfilter(c)
	return c:IsFaceupEx() and c:IsSetCard(0x55,0x7b)
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return re:IsActiveType(TYPE_MONSTER) and Duel.IsChainNegatable(ev) and rp==1-tp and Duel.IsExistingMatchingCard(s.rfilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,1,nil)
end
function s.cfilter(c,e,tp,mc)
	return c:IsFacedown() and c:IsRank(8) and c:IsSetCard(0x107b) and c:IsType(TYPE_XYZ)
		and Duel.GetLocationCountFromEx(tp,tp,mc,c)>0 and mc:IsCanBeXyzMaterial(c)
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false)
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local mc=re:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,mc) and aux.MustMaterialCheck(mc,1-tp,EFFECT_MUST_BE_XMATERIAL) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,s.cfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,mc)
	Duel.ConfirmCards(1-tp,g)
	e:SetLabelObject(g:GetFirst())
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:IsCostChecked() end
	Duel.SetTargetCard(e:GetLabelObject())
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function s.sfilter(c,e,tp,mc)
	return mc:IsCanBeXyzMaterial(c)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local mc=re:GetHandler()
	local sc=Duel.GetFirstTarget()
	if not (Duel.NegateActivation(ev) and mc:IsRelateToEffect(re) and not mc:IsImmuneToEffect(e) and sc
		and sc:IsRelateToEffect(e)) then return end
	Duel.BreakEffect()
	local mg=mc:GetOverlayGroup()
	if #mg>0 then Duel.Overlay(sc,mg) end
	sc:SetMaterial(Group.FromCards(mc))
	Duel.Overlay(sc,Group.FromCards(mc))
	Duel.SpecialSummon(sc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
	sc:CompleteProcedure()
end
function s.xfilter(c)
	return c:IsFacedown() or not (c:IsAttribute(ATTRIBUTE_LIGHT) or c:IsRace(RACE_DRAGON))
end
function s.hcon(e,tp,eg,ep,ev,re,r,rp)
	local tp=e:GetHandler():GetControler()
	return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)>0 and not Duel.IsExistingMatchingCard(s.xfilter,tp,LOCATION_MZONE,0,1,nil)
end
