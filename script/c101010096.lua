--created & coded by Lyris
--Clear Protector
function c101010096.initial_effect(c)
	--This card's owner is unaffected by the effects of "Clear World".
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(1,0)
	e1:SetCode(97811903)
	e1:SetCondition(c101010096.tpcon)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetTargetRange(0,1)
	e2:SetCondition(c101010096.ntpcon)
	c:RegisterEffect(e2)
	--If this card is Summoned: Its owner declares 1 Attribute.
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	e3:SetTarget(c101010096.target)
	e3:SetOperation(c101010096.operation)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e4)
	local e5=e3:Clone()
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e5)
	--Your opponent cannot attack with monsters of the declared Attribute.
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetCode(EFFECT_CANNOT_ATTACK)
	e6:SetRange(LOCATION_MZONE)
	e6:SetTargetRange(0,LOCATION_MZONE)
	e6:SetCondition(c101010096.tpcon)
	e6:SetTarget(c101010096.block)
	c:RegisterEffect(e6)
	--While controlled by its owner's opponent: Cannot be used as a Material for a Summon. This face-up card cannot be Tributed.
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE)
	e7:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e7:SetRange(LOCATION_MZONE)
	e7:SetCode(EFFECT_UNRELEASABLE_SUM)
	e7:SetValue(1)
	e7:SetCondition(c101010096.ntpcon)
	c:RegisterEffect(e7)
	local e8=e7:Clone()
	e8:SetCode(EFFECT_UNRELEASABLE_NONSUM)
	c:RegisterEffect(e8)
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_SINGLE)
	e9:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e9:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
	e9:SetValue(1)
	e9:SetCondition(c101010096.ntpcon)
	c:RegisterEffect(e9)
	local ea=e9:Clone()
	ea:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
	c:RegisterEffect(ea)
	local eb=e9:Clone()
	eb:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	c:RegisterEffect(eb)
	--You cannot Special Summon monsters from the hand or Deck with the declared Attribute.
	local ec=Effect.CreateEffect(c)
	ec:SetType(EFFECT_TYPE_FIELD)
	ec:SetRange(LOCATION_MZONE)
	ec:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	ec:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	ec:SetTargetRange(1,0)
	ec:SetValue(c101010096.sumlimit)
	ec:SetCondition(c101010096.ntpcon)
	c:RegisterEffect(ec)
end
c101010096[0]=0
c101010096[1]=0
function c101010096.tpcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsLocation(LOCATION_MZONE) and c:IsControler(c:GetOwner())
end
function c101010096.ntpcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsLocation(LOCATION_MZONE) and c:IsControler(1-c:GetOwner())
end
function c101010096.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	c101010096[0]=0
	c101010096[1]=0
	Duel.Hint(HINT_SELECTMSG,tp,562)
	local rc=Duel.AnnounceAttribute(tp,1,0xffff)
	e:SetLabel(rc)
end
function c101010096.operation(e,tp,eg,ep,ev,re,r,rp)
	local at=e:GetLabel()
	c:SetHint(CHINT_ATTRIBUTE,at)
	c101010096[0],c101010096[1]=at,at
end
function c101010096.block(e,c)
	return c:IsAttribute(c101010096[e:GetHandlerPlayer()])
end
function c101010096.sumlimit(e,c,sump,sumtype,sumpos,targetp,se)
	return c:IsAttribute(c101010096[e:GetHandlerPlayer()]) and c:IsLocation(LOCATION_DECK+LOCATION_HAND)
end
