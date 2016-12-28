--created & coded by Lyris
--サイバー・スペース・ソーラー・ドラゴン
function c101010037.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddFusionProcCodeFun(c,101010037,aux.FilterBoolFunction(Card.IsSetCard,0x4093),2,true,true)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EFFECT_ADD_ATTRIBUTE)
	e1:SetValue(ATTRIBUTE_LIGHT)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetCode(EFFECT_SPSUMMON_CONDITION)
	e2:SetValue(c101010037.splimit)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_PIERCE)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_DAMAGE)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e4:SetCode(EVENT_BATTLE_DAMAGE)
	e4:SetCondition(c101010037.dmgcon)
	e4:SetTarget(c101010037.dmgtg)
	e4:SetOperation(c101010037.dmgop)
	c:RegisterEffect(e4)
end
function c101010037.splimit(e,se,sp,st)
	return st==SUMMON_TYPE_FUSION+0x800
end
function c101010037.dmgcon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp
end
function c101010037.dmgtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsSetCard,tp,LOCATION_REMOVED,0,1,nil,0x4093) end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,0)
end
function c101010037.dmgop(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local d=Duel.GetMatchingGroupCount(Card.IsSetCard,tp,LOCATION_REMOVED,0,nil,0x4093)*300
	Duel.Damage(p,d,REASON_EFFECT)
end
