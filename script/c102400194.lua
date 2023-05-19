--created by Lyris
--Cyber Dragon Weiss
local s,id,o=GetID()
function s.initial_effect(c)
	--1 "Cyber Dragon" monster You can only Special Summon "Cyber Dragon Weiss(s)" once per turn. If this card is Link Summoned: Take 1 Machine monster in your possession, and either add it from your Deck to your hand or Special Summon it from your GY, then in either case, Tribute this card. If this card is Special Summoned: It either loses 500 ATK or cannot attack.
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
