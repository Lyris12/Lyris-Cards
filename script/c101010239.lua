--created & coded by Lyris
--Lyris, the Universal Material
function c101010239.initial_effect(c)
	--race
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetRange(0xff)
	e1:SetCode(EFFECT_CHANGE_RACE)
	e1:SetValue(0xffffff)
	c:RegisterEffect(e1)
	--attribute
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CHANGE_ATTRIBUTE)
	e2:SetValue(0x7f)
	c:RegisterEffect(e2)
	--give omniproperties
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_BE_MATERIAL)
	e3:SetOperation(c101010239.matop)
	c:RegisterEffect(e3)
	--multi-tribute
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_DOUBLE_TRIBUTE)
	e4:SetValue(1)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EFFECT_TRIPLE_TRIBUTE)
	c:RegisterEffect(e5)
	--ritual level
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetCode(EFFECT_RITUAL_LEVEL)
	e6:SetValue(c101010239.rlevel)
	c:RegisterEffect(e6)
	--fusion substitute
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE)
	e7:SetCode(EFFECT_FUSION_SUBSTITUTE)
	e7:SetCondition(c101010239.subcon)
	c:RegisterEffect(e7)
	--nontuner
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_NONTUNER)
	c:RegisterEffect(e1)
end
function c101010239.matop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=c:GetReasonCard()
	--race
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetRange(0xff)
	e1:SetCode(EFFECT_CHANGE_RACE)
	e1:SetValue(0xffffff)
	rc:RegisterEffect(e1)
	--attribute
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CHANGE_ATTRIBUTE)
	e2:SetValue(0x7f)
	rc:RegisterEffect(e2)
end
function c101010239.rlevel(e,c)
	local lv=e:GetHandler():GetLevel()
	local clv=c:GetLevel()
	return lv*65536+clv
end
function c101010239.subcon(e)
	return e:GetHandler():IsLocation(LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE)
end
