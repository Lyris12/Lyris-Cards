--created by Lyris
--ソウル・リチャージ
local s,id,o=GetID()
function s.initial_effect(c)
	--You can only control 1 "Soul Recharge". Destroy this card if both of the following effects are activated in the same turn. ● Three times per turn, if an Xyz Monster you control activates its effect: Attach the top card of your Deck to that card as a material. ● Three times per turn, if an Xyz Monster your opponent controls activates its effect: Attach the top card of their Deck to that card as a material.
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	c:SetUniqueOnField(1,0,id,LOCATION_SZONE)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_CHAIN_SOLVED)
	e2:SetCountLimit(3)
	e2:SetLabel(0)
	e2:SetCondition(s.checkop)
	e2:SetTarget(s.attg)
	e2:SetOperation(s.atop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetLabel(1)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCode(EFFECT_SELF_DESTROY)
	e4:SetCondition(s.sdcon)
	c:RegisterEffect(e4)
end
function s.checkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=re:GetHandler()
	e:SetLabelObject(tc)
	return re:IsActiveType(TYPE_XYZ) and tc:IsLocation(LOCATION_ONFIELD) and tc:IsControler(e:GetLabel())
end
function s.attg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsRelateToEffect(e) end
	local p=rp
	if tp~=0 then p=1-p end
	Duel.Hint(HINT_OPSELECTED,0,aux.Stringid(id,p))
	local tc=Group.FromCards(re:GetHandler(),e:GetLabelObject())
	Duel.HintSelection(tc)
	Duel.SetTargetCard(tc)
	local ap=1<<p
	local ct=c:GetFlagEffectLabel(id)
	if not ct then
		c:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1,ap)
	else
		c:SetFlagEffectLabel(id,ap|ct)
	end
end
function s.atop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not tc or not tc:IsRelateToEffect(e) or not tc:IsType(TYPE_XYZ) then return end
	local p=e:GetLabel()
	local g=Duel.GetDecktopGroup(p,1)
	if #g==0 then return end
	Duel.DisableShuffleCheck()
	Duel.Overlay(tc,g)
end
function s.sdcon(e)
	local c=e:GetHandler()
	return c:GetFlagEffect(id)>0 and c:GetFlagEffectLabel(id)&0x3==0x3 and not c:IsStatus(STATUS_CHAINING)
end
