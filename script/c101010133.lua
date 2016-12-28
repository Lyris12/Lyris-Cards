--created & coded by Lyris
--DNAトランズミューテーション
function c101010133.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c101010133.target)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_REMOVED,LOCATION_REMOVED)
	e2:SetCode(EFFECT_CHANGE_RACE)
	e2:SetValue(c101010133.value)
	c:RegisterEffect(e2)
	e1:SetLabelObject(e2)
end
function c101010133.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,563)
	local rc=Duel.AnnounceRace(tp,1,0xffffff)
	e:GetLabelObject():SetLabel(rc)
	e:GetHandler():SetHint(CHINT_RACE,rc)
end
function c101010133.value(e,c)
	return e:GetLabel()
end
