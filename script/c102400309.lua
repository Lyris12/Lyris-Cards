--created by Lyris
--パワー・ナップ
local s,id,o=GetID()
function s.initial_effect(c)
	--During your turn: Change all your monsters to face-down Defense Position, also, change all your monsters to face-up Defense Position (but negate their effects) after this Chain resolves.
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCategory(CATEGORY_POSITION)
	e1:SetCondition(s.con)
	e1:SetTarget(s.tg)
	e1:SetOperation(s.act)
	c:RegisterEffect(e1)
end
function s.con(e,tp)
	return Duel.GetTurnPlayer()==tp
end
function s.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsCanTurnSet,tp,LOCATION_MZONE,0,1,nil) end
	local g=Duel.GetMatchingGroup(Card.IsCanChangePosition,tp,LOCATION_MZONE,0,nil)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,#g,0,0)
end
function s.act(e,tp)
	local g=Duel.GetMatchingGroup(Card.IsCanChangePosition,tp,LOCATION_MZONE,0,nil)
	Duel.ChangePosition(g:Filter(Card.IsCanTurnSet,nil),POS_FACEDOWN_DEFENSE)
	g:KeepAlive()
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAIN_END)
	e1:SetLabelObject(g)
	e1:SetOperation(s.flip)
	e1:SetReset(RESET_CHAIN)
	Duel.RegisterEffect(e1,tp)
end
function s.flip(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,id)
	local g=e:GetLabelObject()
	Duel.ChangePosition(g,POS_FACEUP_DEFENSE)
	g:DeleteGroup()
end
