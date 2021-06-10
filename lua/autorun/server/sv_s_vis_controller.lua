local cv_propmn,
cv_propmx,
cv_playermn,
cv_playermx,
cv_vehiclemn,
cv_vehiclemx,
cv_weaponmn,
cv_weaponmx,
cv_doormn,
cv_doormx,
cv_miscmn,
cv_miscmx,
cv_worldedit,
cv_performancemode,
cv_shadowdistance,
cv_dontreceiveshadows,
cv_disbleshadows,
cv_disbledepth

do
	local fl = FCVAR_ARCHIVE + FCVAR_NEVER_AS_STRING + FCVAR_NOTIFY + FCVAR_REPLICATED + FCVAR_DONTRECORD
	cv_worldedit = 			CreateConVar('svc_caneditlevel', '0', '', fl, 0, 1)
	cv_performancemode = 	CreateConVar('svc_performancemode', '0', '', fl, 0, 1)
	cv_dontreceiveshadows = CreateConVar('svc_disablereceiveshadows', '1', '', fl, 0, 1)
	cv_disbledepth = 		CreateConVar('svc_disbleshadowdepth', '0', '', fl, 0, 1)
	cv_disbleshadows = 		CreateConVar('svc_disableshadows', '0', '', fl, 0, 1)
	cv_shadowdistance = 	CreateConVar('svc_shadowdistance', '500', '', fl, 0, 3000)
	cv_propmn = 			CreateConVar('svc_propmin', '-1', '', fl, -1, 8000)
	cv_propmx = 			CreateConVar('svc_propmax', '2500', '', fl, 500, 8000)
	cv_playermn = 			CreateConVar('svc_playermin', '3000', '', fl, -1, 8000)
	cv_playermx = 			CreateConVar('svc_playermax', '3000', '', fl, 500, 8000)
	cv_npcmn = 				CreateConVar('svc_npcmin', '3000', '', fl, -1, 8000)
	cv_npcmx = 				CreateConVar('svc_npcmax', '3000', '', fl, 500, 8000)
	cv_vehiclemn = 			CreateConVar('svc_vehiclemin', '-1', '', fl, -1, 8000)
	cv_vehiclemx = 			CreateConVar('svc_vehiclemax', '2500', '', fl, 500, 8000)
	cv_weaponmn = 			CreateConVar('svc_weaponmin', '-1', '', fl, -1, 8000)
	cv_weaponmx = 			CreateConVar('svc_weaponmax', '500', '', fl, 500, 8000)
	cv_doormn = 			CreateConVar('svc_doormin', '-1', '', fl, -1, 8000)
	cv_doormx = 			CreateConVar('svc_doormax', '3000', '', fl, 500, 8000)
	cv_miscmn = 			CreateConVar('svc_miscmin', '-1', '', fl, -1, 8000)
	cv_miscmx = 			CreateConVar('svc_miscmax', '500', '', fl, 500, 8000)
end

do
	local _R = debug.getregistry()
	local SetKeyValue = _R.Entity.SetKeyValue
	local GetClass = _R.Entity.GetClass
	local CreatedByMap = _R.Entity.CreatedByMap

	local door_class = {
		prop_dynamic = true,
		prop_door_rotating = true,
		func_door_rotating = true,
		func_door = true
	}

	local prop_class = {
		prop_physics = true,
		prop_physics_multiplayer = true
	}

	local function SetupEntityVars(ent)
		if CreatedByMap(ent) and not cv_worldedit:GetBool() then return end

		ent:SetKeyValue('performancemode', cv_performancemode:GetString())
		ent:SetKeyValue('disableshadows', cv_disbleshadows:GetString())
		ent:SetKeyValue('shadowcastdist', cv_shadowdistance:GetString())
		ent:SetKeyValue('disablereceiveshadows', cv_dontreceiveshadows:GetString())
		ent:SetKeyValue('disableshadowdepth', cv_disbledepth:GetString())

		if ent:IsPlayer() then
			ent:SetKeyValue('fademindist', cv_playermn:GetString())
			ent:SetKeyValue('fademaxdist', cv_playermx:GetString())
			return
		end

		if ent:IsNPC() then
			ent:SetKeyValue('fademindist', cv_npcmn:GetString())
			ent:SetKeyValue('fademaxdist', cv_npcmx:GetString())
			return
		end

		if ent:IsWeapon() then
			ent:SetKeyValue('fademindist', cv_weaponmn:GetString())
			ent:SetKeyValue('fademaxdist', cv_weaponmx:GetString())
			return
		end

		if ent:IsVehicle() then
			ent:SetKeyValue('fademindist', cv_vehiclemn:GetString())
			ent:SetKeyValue('fademaxdist', cv_vehiclemx:GetString())
			return
		end

		local class = GetClass(ent)
		if prop_class[class] then
			ent:SetKeyValue('fademindist', cv_propmn:GetString())
			ent:SetKeyValue('fademaxdist', cv_propmx:GetString())
			return
		end

		if door_class[class] then
			ent:SetKeyValue('fademindist', cv_doormn:GetString())
			ent:SetKeyValue('fademaxdist', cv_doormx:GetString())
			return
		end

		ent:SetKeyValue('fademindist', cv_miscmn:GetString())
		ent:SetKeyValue('fademaxdist', cv_miscmx:GetString())
	end

	local function CVarChanged(name, old, new)
		local tb, i = ents.GetAll(), 0

		while true do
			i = i + 1
			local ent = tb[i]
			if not ent then break end
			SetupEntityVars(ent)
		end
	end

	hook.Add('OnEntityCreated', 'svc.OnEntityCreated', SetupEntityVars)
	cvars.AddChangeCallback('svc_caneditlevel', CVarChanged)
	cvars.AddChangeCallback('svc_performancemode', CVarChanged)
	cvars.AddChangeCallback('svc_disablereceiveshadows', CVarChanged)
	cvars.AddChangeCallback('svc_disbleshadowdepth', CVarChanged)
	cvars.AddChangeCallback('svc_disableshadows', CVarChanged)
	cvars.AddChangeCallback('svc_shadowdistance', CVarChanged)
	cvars.AddChangeCallback('svc_propmin', CVarChanged)
	cvars.AddChangeCallback('svc_propmax', CVarChanged)
	cvars.AddChangeCallback('svc_playermin', CVarChanged)
	cvars.AddChangeCallback('svc_playermax', CVarChanged)
	cvars.AddChangeCallback('svc_npcmin', CVarChanged)
	cvars.AddChangeCallback('svc_npcmax', CVarChanged)
	cvars.AddChangeCallback('svc_vehiclemin', CVarChanged)
	cvars.AddChangeCallback('svc_vehiclemax', CVarChanged)
	cvars.AddChangeCallback('svc_weaponmin', CVarChanged)
	cvars.AddChangeCallback('svc_weaponmax', CVarChanged)
	cvars.AddChangeCallback('svc_doormin', CVarChanged)
	cvars.AddChangeCallback('svc_doormax', CVarChanged)
	cvars.AddChangeCallback('svc_miscmin', CVarChanged)
	cvars.AddChangeCallback('svc_miscmax', CVarChanged)
end