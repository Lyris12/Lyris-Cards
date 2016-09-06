--Rusted Dragon Zero
function c101020115.initial_effect(c)
	--Once per turn, you can also Xyz Summon "Rusted Dragon Zero" by using "Rusted Dragon Doom" you control as the Xyz Material. (Xyz Materials attached to that monster also become Xyz Materials on this card.)
	c:EnableReviveLimit()
	aux.AddXyzProcedure(c,c101020115.mfilter,6,3,c101020115.ovfilter,aux.Stringid(101020115,0),3,c101020115.xyzop)
	--This card gains 300 ATK for each Xyz Material attached to it.
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c101020115.atkval)
	c:RegisterEffect(e1)
	--Once per turn, during either player's turn: You can detach 1 Xyz Material from this card, then target 1 monster your opponent controls; this card gains ATK equal to half that target's ATK, until the end of this turn.
	local e2=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101020115,0))
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(TIMING_DAMAGE_STEP)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c101020115.atkcon)
	e2:SetCost(c101020115.atkcost)
	e2:SetTarget(c101020115.atktg)
	e2:SetOperation(c101020115.atkop)
	c:RegisterEffect(e2)
	--Once per turn, during either player's turn, if your opponent activates a Spell/Trap Card or effect: You can negate the activation or effect, and if you do, banish it.
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(1131)
	e3:SetCategory(CATEGORY_NEGATE+CATEGORY_REMOVE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetCountLimit(1)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c101020115.discon)
	e3:SetTarget(c101020115.distg)
	e3:SetOperation(c101020115.disop)
	c:RegisterEffect(e3)
end
function c101020115.mfilter(c)
	return c:IsRace(RACE_ZOMBIE) and c:IsAttribute(ATTRIBUTE_LIGHT)
end
function c101020115.ovfilter(c)
	return c:IsFaceup() and c:IsCode(101020114)
end
function c101020115.xyzop(e,tp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,101020115)==0 end
	Duel.RegisterFlagEffect(tp,101020115,RESET_PHASE+PHASE_END,0,1)
end
function c101020115.atkval(e,c)
	return c:GetOverlayCount()*300
end
function c101020115.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()~=PHASE_DAMAGE or not Duel.IsDamageCalculated()
end
function c101020115.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c101020115.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	--target 1 monster your opponent controls
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,Card.IsFaceup,tp,0,LOCATION_MZONE,1,1,nil)
end
function c101020115.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) and c:IsFaceup() and c:IsRelateToEffect(e) then
		local atk=tc:GetAttack()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(math.ceil(atk/2))
		e1:SetReset(RESET_EVENT+0x1ff0000+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
	end
end
function c101020115.discon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and re:IsActiveType(TYPE_SPELL+TYPE_TRAP) and Duel.IsChainNegatable(ev)
end
function c101020115.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsAbleToRemove() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,eg,1,0,0)
	end
end
function c101020115.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.Remove(eg,POS_FACEUP,REASON_EFFECT)
	end
end