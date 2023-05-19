--created by Lyris
--Chimeratech Cyber Dragon
local s,id,o=GetID()
function s.initial_effect(c)
	--1 "Cyber Dragon" monster + 1+ monsters with 2100 or more ATK Cannot be used as Fusion Material. Must first be Special Summoned (from your Extra Deck) by Tributing the above cards from either field. Gains ATK equal to the combined original ATK of all non-"Cyber Dragon" materials used for its Special Summon. This card becomes LIGHT-Attribute while banished or in the GY.
	local tp=c:GetControler()
	local ef=Effect.CreateEffect(c)
	ef:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	ef:SetCode(EVENT_PHASE_START+PHASE_DRAW)
	ef:SetCountLimit(1,5001+EFFECT_COUNT_CODE_DUEL)
	ef:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	ef:SetOperation(function()
		local tk=Duel.CreateToken(tp,5000)
		Duel.SendtoDeck(tk,nil,SEQ_DECKBOTTOM,REASON_RULE)
		c5000.ops(ef,tp)
	end)
	Duel.RegisterEffect(ef,tp)
end
