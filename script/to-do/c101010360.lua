--Time Dragon Trystin
function c101010360.initial_effect(c)
--fusion summon
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c101010360.splimit)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(c101010360.spscon)
	e2:SetOperation(c101010360.spsop)
	e2:SetValue(SUMMON_TYPE_FUSION)
	c:RegisterEffect(e2)
	--actlimit
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e0:SetCode(EVENT_ATTACK_ANNOUNCE)
	e0:SetOperation(c101010360.operation)
	c:RegisterEffect(e0)
	--token
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_BATTLE_DESTROYING)
	e4:SetCondition(aux.bdocon)
	e4:SetTarget(c101010360.sptg)
	e4:SetOperation(c101010360.spop)
	c:RegisterEffect(e4)
	--handes
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_REMOVE+CATEGORY_HANDES)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EVENT_BATTLE_DESTROYED)
	e3:SetCondition(c101010360.condition)
	e3:SetTarget(c101010360.rmtg)
	e3:SetOperation(c101010360.rmop)
	c:RegisterEffect(e3)
end
function c101010360.splimit(e,se,sp,st)
	return not e:GetHandler():IsLocation(LOCATION_EXTRA)
end
function c101010360.ffilter(c)
	return c:IsSetCard(0x4db) and c:IsAbleToDeckAsCost()
end
function c101010360.spscon(e,c)
	if c==nil then return true end
	local mg=Duel.GetMatchingGroup(c101010360.ffilter,tp,LOCATION_MZONE,0,nil)
	return mg:CheckWithSumEqual(Card.GetLevel,c:GetOriginalLevel(),1,99,nil)
end
function c101010360.spsop(e,tp,eg,ep,ev,re,r,rp,c)
	local mg=Duel.GetMatchingGroup(Card.IsAbleToDeckOrExtraAsCost,tp,LOCATION_MZONE,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local mat=mg:SelectWithSumEqual(tp,Card.GetLevel,c:GetOriginalLevel(),1,99,nil)
	local cg=mat:Filter(Card.IsFacedown,nil)
	if cg:GetCount()>0 then
		Duel.ConfirmCards(1-tp,cg)
	end
	c:SetMaterial(mat)
	Duel.SendtoDeck(mat,nil,2,REASON_COST)
end
function c101010360.operation(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetTargetRange(0,1)
	e1:SetValue(c101010360.aclimit)
	e1:SetReset(RESET_PHASE+PHASE_DAMAGE)
	Duel.RegisterEffect(e1,tp)
end
function c101010360.aclimit(e,re,tp)
	return re:IsHasType(EFFECT_TYPE_ACTIVATE)
end
function c101010360.condition(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	local rc=tc:GetReasonCard()
	return eg:GetCount()==1 and rc:IsControler(tp) and rc:GetOriginalCode()==101010360
		and tc:IsReason(REASON_BATTLE)-- and tc:IsType(TYPE_MONSTER)
end
function c101010360.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0 end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,0,LOCATION_HAND)
end
function c101010360.rmop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_HAND,nil)
	if g:GetCount()==1 then
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	elseif g:GetCount()>0 then
		local tc=g:RandomSelect(tp,1)
		Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
	end
end
function c101010360.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c101010360.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local c=e:GetHandler()
	if Duel.IsPlayerCanSpecialSummonMonster(tp,101010360,0x4db,0x4011,c:GetAttack(),c:GetDefense(),c:GetLevel(),RACE_MACHINE,ATTRIBUTE_LIGHT) then
		local token=Duel.CreateToken(tp,101010360)
		Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_BASE_ATTACK)
		e1:SetValue(c:GetAttack())
		e1:SetReset(RESET_EVENT+0x1fe0000)
		token:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_SET_BASE_DEFENSE)
		e2:SetValue(c:GetDefense())
		token:RegisterEffect(e2)
		local e3=e1:Clone()
		e3:SetCode(EFFECT_CHANGE_LEVEL)
		e3:SetValue(c:GetLevel())
		token:RegisterEffect(e3)
		Duel.SpecialSummonComplete()
	end
end