--created by Lyris
--スターリ・アイズ・スぺーシュル・ドラゴン(アナザー宙)
local s,id,o=GetID()
function s.initial_effect(c)
	--2 monsters, except Tokens During your Main Phase 1: You can target 1 monster in the GY; gain LP equal to its ATK, then banish it. You can only use this effect of "Starry-Eyes Spatial Dragon" once per turn.
	c:EnableReviveLimit()
	aux.AddOrigSpatialType(c)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_CHANGE_CODE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetValue(102400036)
	c:RegisterEffect(e0)
	aux.AddSpatialProc(c,nil,aux.FilterBoolFunction(aux.NOT(Card.IsType),TYPE_TOKEN),2,2)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,id)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCategory(CATEGORY_RECOVER+CATEGORY_REMOVE)
	e1:SetCondition(function() return Duel.GetCurrentPhase()==PHASE_MAIN1 end)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
end
s.spt_other_space=102400036
function s.filter(c)
	return c:IsType(TYPE_MONSTER) and aux.nzatk(c) and c:IsAbleToRemove()
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and s.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(s.filter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil,TYPE_MONSTER) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local tc=Duel.SelectTarget(tp,aux.AND(Card.IsFaceup,Card.IsType),tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil,TYPE_MONSTER):GetFirst()
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,tc:GetAttack())
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,tc,1,0,0)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.Recover(tp,tc:GetAttack(),REASON_EFFECT)>0 then
		Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
	end
end
