--U.A.プレイングマネージャー
--U.A. Playing Manager
--Scripted by Sock#3222
function c101102019.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101102019,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,101102019)
	e1:SetCondition(c101102019.spcon)
	e1:SetTarget(c101102019.sptg)
	e1:SetOperation(c101102019.spop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	--destroy/disable
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,101102019+100)
	e3:SetTarget(c101102019.target)
	e3:SetOperation(c101102019.operation)
	c:RegisterEffect(e3)
end
function c101102019.cfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0xb2) and c:GetSummonPlayer()==tp
end
function c101102019.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c101102019.cfilter,1,nil,tp)
end
function c101102019.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c101102019.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c101102019.negfilter(c)
	return c:IsFaceup() and not c:IsDisabled() and not c:IsSetCard(0xb2)
end
function c101102019.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() end
	local b1=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	local b2=Duel.GetMatchingGroup(c101102019.negfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if chk==0 then return #b1>0 or #b2>0 end
	local off=1
	local ops={}
	local opval={}
	if #b1>0 then
		ops[off]=aux.Stringid(101102019,1)
		opval[off]=0
		off=off+1
	end
	if #b2>0 then
		ops[off]=aux.Stringid(101102019,2)
		opval[off]=1
		off=off+1
	end
	local op=Duel.SelectOption(tp,table.unpack(ops))+1
	local sel=opval[op]
	e:SetLabel(sel)
	if sel==0 then
		e:SetCategory(CATEGORY_DESTROY)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local g=Duel.SelectTarget(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	else
		e:SetCategory(CATEGORY_DISABLE)
	end
end
function c101102019.operation(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabel()==0 then
		local tc=Duel.GetFirstTarget()
		if tc:IsRelateToEffect(e) then
			Duel.Destroy(tc,REASON_EFFECT)
		end
	else
		local c=e:GetHandler()
		local b2=Duel.GetMatchingGroup(c101102019.negfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
		local nc=b2:GetFirst()
		while nc do
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			nc:RegisterEffect(e1)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_DISABLE_EFFECT)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			nc:RegisterEffect(e2)
			if nc:IsType(TYPE_TRAPMONSTER) then
				local e3=Effect.CreateEffect(c)
				e3:SetType(EFFECT_TYPE_SINGLE)
				e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
				e3:SetReset(RESET_EVENT+RESETS_STANDARD)
				nc:RegisterEffect(e3)
			end
			nc=b2:GetNext()
		end
	end
end
