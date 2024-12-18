--created by LionHeartKIng
--襲雷ラッシュ
local s,id,o=GetID()
function s.initial_effect(c)
	--Destroy as many cards in your Pendulum Zones as possible, also, destroy up to 3 face-up "Blitzkrieg" Pendulum Monsters with different names in your Extra Deck, then if you destroyed exactly 3 "Blitzkrieg" monsters with this effect, draw 2 cards. You can only activate 1 "Blitzkrieg Rush" per turn.
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
end
function s.filter(c)
	return c:IsSetCard(0x7c4) and c:IsType(TYPE_PENDULUM) and c:IsFaceup()
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(s.filter,tp,LOCATION_EXTRA,0,nil)+Duel.GetFieldGroup(tp,LOCATION_PZONE,0)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2)
		and g:Filter(Card.IsSetCard,nil,0x7c4):GetClassCount(Card.GetCode)>=3 end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,3,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsSetCard,tp,LOCATION_PZONE,0,nil,0x7c4)
	local mg=Duel.GetMatchingGroup(s.filter,tp,LOCATION_EXTRA,0,nil)
	for tc in aux.Next(g) do mg:Remove(Card.IsCode,nil,tc:GetCode()) end
	local ct=3-g:GetClassCount(Card.GetCode)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local tg=mg:SelectSubGroup(tp,aux.dncheck,false,ct,ct)
	Duel.Destroy(tg+Duel.GetFieldGroup(tp,LOCATION_PZONE,0),REASON_EFFECT)
	local dt=Duel.GetOperatedGroup():FilterCount(function(c,dg) return dg:IsContains(c) end,nil,g+tg)
	if dt>=3 then
		Duel.BreakEffect()
		Duel.Draw(tp,2,REASON_EFFECT)
	end
end
