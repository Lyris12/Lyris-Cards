--Astral Dragon of Stellar Vine
function c101010425.initial_effect(c)
	--special summon (Do Not Remove)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(c101010425.spcon)
	e1:SetOperation(c101010425.spop)
	e1:SetValue(SUMMON_TYPE_XYZ+7150)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SINGLE_RANGE)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCode(EFFECT_SPSUMMON_CONDITION)
	e2:SetValue(function(e,se,ep,st) return bit.band(st,SUMMON_TYPE_XYZ+7150)==SUMMON_TYPE_XYZ+7150 end)
	c:RegisterEffect(e2)
	--cannot Grave (Do Not Remove)
	local ge1=Effect.CreateEffect(c)
	ge1:SetType(EFFECT_TYPE_FIELD)
	ge1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_RANGE)
	ge1:SetCode(EFFECT_TO_GRAVE_REDIRECT)
	ge1:SetTargetRange(LOCATION_ONFIELD+LOCATION_OVERLAY,0)
	ge1:SetTarget(function(e,c) return c==e:GetHandler() end)
	ge1:SetValue(LOCATION_REMOVED)
	Duel.RegisterEffect(ge1,0)
end
function c101010425.sfilter1(c,x,g)
	local lv=c:GetLevel()
	local rk=c:GetRank()
	return g:IsExists(c101010425.sfilter2,1,c,x,lv,rk)
end
function c101010425.sfilter2(c,x,lv,rk)
	return c:GetLevel()+lv==x or c:GetLevel()+rk==x
end
function c101010425.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<-1 then return end
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemoveAsCost,tp,LOCATION_MZONE,0,nil)
	return g:IsExists(c101010425.sfilter1,1,nil,10,g)
end
function c101010425.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local mg=Group.CreateGroup()
	local x=10
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemoveAsCost,tp,LOCATION_MZONE,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local tc1=g:FilterSelect(tp,c101010425.sfilter1,1,1,nil,x,g):GetFirst()
	mg:AddCard(tc1)
	local tc2=g:FilterSelect(tp,c101010425.sfilter2,1,1,tc1,x,tc1:GetLevel(),tc1:GetRank())
	mg:AddCard(tc2)
	c:SetMaterial(mg)
	local fg=mg:Filter(Card.IsFacedown,nil)
	if fg:GetCount()>0 then Duel.ConfirmCards(1-tp,fg) end
	Duel.Remove(mg,POS_FACEUP,REASON_MATERIAL+7150)
end
