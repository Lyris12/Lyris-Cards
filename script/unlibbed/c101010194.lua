--Blitzkrieg Element - PSYph
function c101010089.initial_effect(c)
	--self-destruct
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_ATTACK_ANNOUNCE)
	e2:SetCondition(c101010089.descon)
	e2:SetOperation(c101010089.desop)
	c:RegisterEffect(e2)
	--def down
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetCode(EFFECT_UPDATE_DEFENCE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(function(e) local ph=Duel.GetCurrentPhase() return ph==PHASE_DAMAGE or ph==PHASE_DAMAGE_CAL end)
	e3:SetValue(function(e,tp,eg,ep,ev,re,r,rp) return -Duel.GetFieldGroupCount(c:GetControler(),0,LOCATION_MZONE)*600 end)
	c:RegisterEffect(e3)
	--damage break
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetRange(LOCATION_HAND)
	e4:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e4:SetCondition(c101010089.dtg)
	e4:SetOperation(c101010089.dop)
	c:RegisterEffect(e4)
end
function c101010089.descon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return Duel.GetTurnPlayer()~=tp and c:IsFaceup() and Duel.GetAttackTarget()==c
end
function c101010089.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.Destroy(c,REASON_EFFECT)
	end
end
function c101010089.dtg(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local p=c:GetControler()
	return Duel.GetTurnPlayer()~=p and Duel.GetBattleDamage(p)>0 and c:IsDestructable()
end
function c101010089.dfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x167) and c:IsDestructable()
end
function c101010089.dop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PRE_BATTLE_DAMAGE)
	e1:SetOperation(c101010089.damop)
	e1:SetReset(RESET_PHASE+PHASE_DAMAGE)
	Duel.RegisterEffect(e1,tp)
end
function c101010089.damop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=Duel.GetAttacker()
	if Duel.Destroy(c,REASON_EFFECT)~=0 then
		local p=c:GetPreviousControler()
		Duel.ChangeBattleDamage(p,0)
		local g=Duel.SelectMatchingCard(tp,c101010089.dfilter,tp,LOCATION_HAND,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.Destroy(g,REASON_EFFECT)
			Duel.Destroy(bc,REASON_EFFECT)
		end
	end
end