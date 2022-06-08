
function SWEP:SetGestureTime( time )
	self:SetNWGestureTime( time )
	self.f_NextGesture = time
end

function SWEP:GetGestureTime()
	return math.max( (self.f_NextGesture or 0),self:GetNWGestureTime() )
end

function SWEP:PlayAnimation( anim, start )
	if not start then
		start = 0
	end

	local ply = self:GetOwner()

	if not IsValid( ply ) then return end

	ply.s_vcd_anim = anim

	if SERVER then
		net.Start( "lscs_animations" )
			net.WriteEntity( ply )
			net.WriteString( anim )
			net.WriteString( tostring(start) )
		net.Broadcast()
	end

	ply:AddVCDSequenceToGestureSlot( GESTURE_SLOT_ATTACK_AND_RELOAD, ply:LookupSequence( anim ), start, true )
end

function SWEP:StopAnimation()
	local ply = self:GetOwner()

	if not IsValid( ply ) then return end

	ply.s_vcd_anim = nil

	self:SetGestureTime( CurTime() )
end