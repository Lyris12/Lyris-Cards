--created & coded by Lyris
--剣主導き
function c101010223.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetCountLimit(1,101010223+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c101010223.condition)
	e1:SetOperation(c101010223.activate)
	c:RegisterEffect(e1)
end
function c101010223.condition(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	local at=Duel.GetAttackTarget()
	return at and ((a:IsControler(tp) and (a:IsSetCard(0xbb2) or a:IsSetCard(0xbb3)))
		or (at:IsControler(tp) and at:IsFaceup() and (at:IsSetCard(0xbb2) or at:IsSetCard(0xbb3))))
end
function c101010223.activate(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	local at=Duel.GetAttackTarget()
	if a:IsControler(1-tp) then a,at=at,a end
	if not a:IsRelateToBattle() or a:IsFacedown() or not at:IsRelateToBattle() or at:IsFacedown() then return end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	e1:SetValue(at:GetDefense())
	a:RegisterEffect(e1)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SET_BASE_ATTACK)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	e1:SetCondition(function(e) return Duel.GetTurnPlayer()==e:GetHandlerPlayer() end)
	e1:SetValue(a:GetBaseAttack()/2)
	a:RegisterEffect(e1)
end
