--created by Lyris
--襲雷渦動
local s,id,o=GetID()
function s.initial_effect(c)
	--When your opponent's card or effect is activated: Negate the effect, and if you do, destroy both that card and 1 "Blitzkrieg" card you control.
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_CHAINING)
	e2:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e2:SetCondition(s.discon)
	e2:SetTarget(s.distg)
	e2:SetOperation(s.disop)
	c:RegisterEffect(e2)
end
function s.discon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsChainDisablable(ev) and rp~=tp
end
function s.dfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x7c4) and c:IsDestructable()
end
function s.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.dfilter,tp,LOCATION_ONFIELD,0,1,aux.ExceptThisCard(e)) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,Duel.GetMatchingGroup(s.dfilter,tp,LOCATION_ONFIELD,0,aux.ExceptThisCard(e)),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
end
function s.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,s.dfilter,tp,LOCATION_ONFIELD,0,1,1,aux.ExceptThisCard(e))
	Duel.HintSelection(g)
	if Duel.Destroy(g,REASON_EFFECT)==0 then return end
	Duel.NegateEffect(ev)
end
