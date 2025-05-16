--Constellar Vylon
local s,id=GetID()
function s.initial_effect(c)
	--Add Pseudo-PendulumProc
	Pendulum.PseudoAddProc({handler=c,lscale=1,rscale=1})
	--splimit
	local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetRange(LOCATION_PZONE)
		e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
		e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
		e2:SetTargetRange(1,0)
		e2:SetTarget(s.splimit)
	c:RegisterEffect(e2)	
	-- --return to hand
	-- local e3=Effect.CreateEffect(c)
		-- e3:SetDescription(aux.Stringid(id,1))
		-- e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
		-- e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
		-- e3:SetCode(EVENT_TO_GRAVE)
		-- e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
		-- e3:SetCountLimit(1,{id,0})
		-- e3:SetCondition(s.thcon)
		-- e3:SetTarget(s.thtg)
		-- e3:SetOperation(s.thop)
	-- c:RegisterEffect(e3)	
	-- --add tuner
	-- local e4=Effect.CreateEffect(c)
		-- e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
		-- e4:SetCode(EVENT_BE_MATERIAL)
		-- e4:SetCondition(s.tncon)
		-- e4:SetOperation(s.tnop)
	-- c:RegisterEffect(e4)
	--Attach
	local e5=Effect.CreateEffect(c)
		e5:SetDescription(aux.Stringid(id,1))
		e5:SetProperty(EFFECT_FLAG_CARD_TARGET)
		e5:SetType(EFFECT_TYPE_IGNITION)
		e5:SetRange(LOCATION_GRAVE)
		e5:SetCountLimit(1,{id,1})
		e5:SetTarget(s.AttTg)
		e5:SetOperation(s.AttOp)
	c:RegisterEffect(e5)	
end

s.listed_series={SET_CONSTELLAR}
-- {Pendulum Summon Restriction: Constellar}
function s.splimit(e,c,sump,sumtype,sumpos,targetp)
	if c:IsSetCard(SET_CONSTELLAR) then return false end
	return bit.band(sumtype,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end

function s.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_DESTROY)
end
function s.tgfilter(c)
	return c:IsSetCard(SET_CONSTELLAR) 
		and not c:IsCode(id) 
		and c:IsAbleToGrave()
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then 
		return Duel.IsExistingMatchingCard(s.tgfilter,tp,LOCATION_DECK,0,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local g=Duel.SelectMatchingCard(tp,s.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
    if g:GetCount()>0 and Duel.SendtoGrave(g,REASON_EFFECT)~=0 then
		if c.IsLocation(c,LOCATION_GRAVE) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			Duel.SendtoHand(c,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,c)
		end
    end
end
function s.tncon(e,tp,eg,ep,ev,re,r,rp)
	return r==REASON_SYNCHRO
end
function s.tnop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=c:GetReasonCard()
	local r1=Effect.CreateEffect(c)
		r1:SetType(EFFECT_TYPE_SINGLE)
		r1:SetCode(EFFECT_ADD_TYPE)
		r1:SetValue(TYPE_TUNER)
		r1:SetReset(RESET_EVENT+0x1fe0000)
	rc:RegisterEffect(r1)
end
function s.descon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc:GetFlagEffectLabel(id)~=e:GetLabel() then
		e:Reset()
		return false
	else 
		return true 
	end
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Destroy(e:GetLabelObject(),REASON_EFFECT)
end
-- {Graveyard Effect: Attach}
function s.AttFilter(c)
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and c:IsSetCard(SET_CONSTELLAR) 
end
function s.AttTg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and s.AttFilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(s.AttFilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,s.AttFilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function s.AttOp(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) and tc:IsFaceup() and not tc:IsImmuneToEffect(e) and c:IsRelateToEffect(e) then
		Duel.Overlay(tc,Group.FromCards(c))
	end
end