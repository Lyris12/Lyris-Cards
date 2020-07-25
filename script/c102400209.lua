--created by Lyris
--ローマ・キー・III
local s,id,o=GetID()
function s.initial_effect(c)
	--1+ monsters with a Level, including a "Roman Keys" monster Must first be Fusion Summoned with a "Roman Keys" card effect. If this card is Fusion Summoned: Inflict 1000 damage to your opponent. You can only use this effect of "Roman Keys - III" once per turn. During the turn this card is Summoned, its ATK is doubled, also it will inflict piercing battle damage.
	c:EnableReviveLimit()
	aux.AddFusionProcFunFunRep(c,aux.FilterBoolFunction(Card.IsSetCard,0xeeb),aux.FilterBoolFunction(Card.IsLevelAbove,1),0,63,false)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetValue(aux.FALSE)
	c:RegisterEffect(e1)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	e5:SetCountLimit(1,id)
	e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e5:SetCategory(CATEGORY_DAMAGE)
	e5:SetCondition(function(e) return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION) end)
	e5:SetTarget(s.target)
	e5:SetOperation(s.costop)
	c:RegisterEffect(e5)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetOperation(s.atkup)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(1000)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,1000)
end
function s.costop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
end
function s.atkup(e,tp,eg,ep,ev,re,r,rp)
	local e0=Effect.CreateEffect(e:GetHandler())
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_PIERCE)
	e0:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	e:GetHandler():RegisterEffect(e0)
	local e1=e0:Clone()
	e1:SetCode(EFFECT_SET_ATTACK)
	e1:SetValue(e:GetHandler():GetAttack()*2)
	e:GetHandler():RegisterEffect(e1)
end
