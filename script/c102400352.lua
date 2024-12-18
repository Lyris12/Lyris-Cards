--created by Lyris
--機氷竜エターンドラ
local s,id,o=GetID()
function s.initial_effect(c)
	--2 Level 4 "Icybr" monsters When your opponent activates a card or effect (Quick Effect): You can detach 1 "Icybr" material from this card; you can only Special Summon a monster(s) of each Type up to twice until the end of the next turn, also, each player draws 1 card, also, that effect becomes "Reveal 1 random card in your opponent's hand, and it will remain revealed until the end of the next turn". You can only use this effect of "Icybr Eterndra" once per turn.
	c:EnableReviveLimit()
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0xd76),4,2)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,id)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetCondition(function(e,tp,eg,ep,ev,re,r,rp) return rp~=tp end)
	e1:SetCost(s.cost)
	e1:SetTarget(s.tg)
	e1:SetOperation(s.op)
	c:RegisterEffect(e1)
	if not s.global_check then
		s.global_check=true
		s[0]={}
		s[1]={}
		local race=1
		while race<RACE_ALL do
			s[0][race]=0
			s[1][race]=0
			race=race<<1
		end
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SPSUMMON_SUCCESS)
		ge1:SetOperation(s.rchk)
		Duel.RegisterEffect(ge1,0)
	end
end
function s.cfilter(c,tp,rc)
	return c:IsSummonPlayer(tp) and c:IsRace(rc)
end
function s.rchk(e,tp,eg)
	for p=0,1 do if Duel.GetFlagEffect(p,id)>0 then
		local rc=1
		while rc<RACE_ALL do
			if eg:IsExists(s.cfilter,1,nil,p,rc) then s[p][rc]=s[p][rc]+1 end
			rc=rc<<1
		end
	end end
end
function s.lim(e,c,sump,sumtype,sumpos,targetp)
	if sumpos and bit.band(sumpos,POS_FACEDOWN)>0 then return false end
	local tp=sump
	if targetp then tp=targetp end
	return s[tp][c:GetRace()] and s[tp][c:GetRace()]>1
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g=c:GetOverlayGroup():Filter(Card.IsSetCard,nil,0xd76)
	if chk==0 then return c:CheckRemoveOverlayCard(tp,1,REASON_COST) and #g>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVEXYZ)
	Duel.SendtoGrave(g:Select(tp,1,1,nil),REASON_COST)
	Duel.RaiseSingleEvent(c,EVENT_DETACH_MATERIAL,e,0,0,0,0)
end
function s.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) and Duel.IsPlayerCanDraw(1-tp,1) end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,PLAYER_ALL,1)
end
function s.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetFlagEffect(tp,id)==0 then
		local rc=1
		while rc<RACE_ALL do s[tp][rc]=0 rc=rc<<1 end
		Duel.RegisterFlagEffect(tp,id,RESET_PHASE+PHASE_END,0,2)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_LIMIT_SPECIAL_SUMMON_POSITION)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetTargetRange(1,0)
		e1:SetTarget(s.lim)
		e1:SetReset(RESET_PHASE+PHASE_END+RESET_SELF_TURN)
		Duel.RegisterEffect(e1,tp)
	end
	Duel.Draw(tp,1,REASON_EFFECT)
	Duel.Draw(1-tp,1,REASON_EFFECT)
	local g=Group.CreateGroup()
	Duel.ChangeTargetCard(ev,g)
	Duel.ChangeChainOperation(ev,s.repop)
end
function s.repop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(aux.NOT(Card.IsPublic),tp,0,LOCATION_HAND,nil)
	if #g==0 then return end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetDescription(66)
	e1:SetCode(EFFECT_PUBLIC)
	e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,2)
	g:RandomSelect(1-tp,1):GetFirst():RegisterEffect(e1)
end
