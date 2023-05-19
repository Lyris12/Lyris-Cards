--created by Lyris, art at https://www.1e.com/wp-content/uploads/2017/03/tachyon-pop-culture-energy.png
--フォトンシック・タキオン
local s,id,o=GetID()
function s.initial_effect(c)
	--When your opponent activates a monster effect: Discard 1 card, then reveal 1 Rank 8 Dragon Xyz Monster in your Extra Deck; Negate the activation, then, you can Special Summon the revealed monster using that opponent's monster as the material. (This is treated as an Xyz Summon. Transfer its materials to the Summoned monster.) You can only activate 1 "Photonsic Tachyon" per turn. If you control no monsters, or all monsters you control are LIGHT and/or Dragon monsters, you can activate this card from your hand.
	local tp=c:GetControler()
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e0:SetCode(EVENT_PHASE_START+PHASE_DRAW)
	e0:SetCountLimit(1,5001+EFFECT_COUNT_CODE_DUEL)
	e0:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e0:SetOperation(function()
		local tk=Duel.CreateToken(tp,5000)
		Duel.SendtoDeck(tk,nil,SEQ_DECKTOP,REASON_RULE)
	end)
	Duel.RegisterEffect(e0,tp)
end
