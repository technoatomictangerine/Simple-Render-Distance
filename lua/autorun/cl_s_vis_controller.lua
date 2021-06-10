if SERVER then AddCSLuaFile() return end
local ExportSetting do
	local ExportFrame

	function ExportSetting()
		local w, h = 400, 320
		if IsValid(ExportFrame) then ExportFrame:Remove() end
		local frame = vgui.Create('DFrame')
		frame:SetTitle('#svc_export')
		frame:SetSizable(false)
		frame:MakePopup()
		frame:SetSize(w, h)
		frame:Center()

		local pnl = vgui.Create('RichText', frame)
		local cvars = {
			'svc_caneditlevel', 'svc_performancemode', 'svc_disablereceiveshadows', 'svc_disbleshadowdepth',
			'svc_disableshadows', 'svc_shadowdistance', 'svc_propmin', 'svc_playermin', 'svc_playermax',
			'svc_npcmin', 'svc_npcmax', 'svc_vehiclemin', 'svc_vehiclemax', 'svc_weaponmin', 'svc_weaponmax',
			'svc_doormin', 'svc_doormax', 'svc_miscmin', 'svc_miscmax'
		}
		
		do
			local form = '%s "%s"'
			pnl:SetFontInternal('DebugFixedSmall')

			for k, name in next, cvars do
				local str = form:format(name, GetConVarString(name))
				cvars[k] = str
				pnl:AppendText(str)
				pnl:AppendText'\n'
			end
		end

		local str_values = table.concat(cvars, '\n')

		local btn2 = vgui.Create('DButton', frame)
		btn2:SetText('#svc_export_clipboard')
		btn2.DoClick = function() SetClipboardText(str_values) end

		local btn1 = vgui.Create('DButton', frame)
		btn1:SetText('#svc_export_file')
		btn1:SetTooltip('#svc_export_file_help')
		btn1.DoClick = function()
			file.Write('svc_export.txt', str_values)
		end

		pnl:SetPos(8, 32)
		pnl:SetSize(w - 16, h - 32 - 64)

		local x, y = w * .5, h - 64 + 8
		btn1:SetPos(x - 140, y)
		btn1:SetSize(140 - 4, 64 - 16)

		btn2:SetPos(x + 4, y)
		btn2:SetSize(140 - 4, 64 - 16)
		frame:RequestFocus()
		frame:InvalidateLayout()

		ExportFrame = frame
	end
end

local function SDCSettings(root)
	root:ClearControls()
	root:ControlHelp('#svc_notsingleplayer'):DockMargin(16, 8, 16, 16)

	local pnl = vgui.Create('ControlPanel')
	pnl:SetName('#svc_main')
	pnl:InvalidateLayout(true)
	pnl:AddControl('CheckBox', {Label = '#svc_caneditlevel', Command = 'svc_caneditlevel'})
	pnl:AddControl('CheckBox', {Label = '#svc_performancemode', Command = 'svc_performancemode'})

	local btn = pnl:Button('#svc_export')
	btn.DoClick = ExportSetting

	root:AddPanel(pnl)

	pnl = vgui.Create('ControlPanel')
	pnl:SetName('#svc_shadows')
	pnl:AddControl('CheckBox', {Label = '#svc_disablereceiveshadows', Command = 'svc_disablereceiveshadows'})
	pnl:AddControl('CheckBox', {Label = '#svc_disbleshadowdepth', Command = 'svc_disbleshadowdepth'})
	pnl:AddControl('CheckBox', {Label = '#svc_disableshadows', Command = 'svc_disableshadows'})
	pnl:AddControl('Slider', {Label = '#svc_shadowdistance', Type = 'Integer', Command = 'svc_shadowdistance', Min = 0, Max = 3000})
	pnl:InvalidateLayout(true)
	root:AddPanel(pnl)

	pnl = vgui.Create('ControlPanel')
	pnl:SetName('#svc_props')
	pnl:AddControl('Slider', {Label = '#svc_rendermin', Type = 'Integer', Command = 'svc_propmin', Min = -1, Max = 8000})
	pnl:AddControl('Slider', {Label = '#svc_rendermax', Type = 'Integer', Command = 'svc_propmax', Min = 500, Max = 8000})
	pnl:InvalidateLayout(true)
	root:AddPanel(pnl)

	pnl = vgui.Create('ControlPanel')
	pnl:SetName('#svc_players')
	pnl:AddControl('Slider', {Label = '#svc_rendermin', Type = 'Integer', Command = 'svc_playermin', Min = -1, Max = 8000})
	pnl:AddControl('Slider', {Label = '#svc_rendermax', Type = 'Integer', Command = 'svc_playermax', Min = 500, Max = 8000})
	pnl:InvalidateLayout(true)
	root:AddPanel(pnl)

	pnl = vgui.Create('ControlPanel')
	pnl:SetName('#svc_npcs')
	pnl:AddControl('Slider', {Label = '#svc_rendermin', Type = 'Integer', Command = 'svc_npcmin', Min = -1, Max = 8000})
	pnl:AddControl('Slider', {Label = '#svc_rendermax', Type = 'Integer', Command = 'svc_npcmax', Min = 500, Max = 8000})
	pnl:InvalidateLayout(true)
	root:AddPanel(pnl)

	pnl = vgui.Create('ControlPanel')
	pnl:SetName('#svc_vehicles')
	pnl:InvalidateLayout(true)
	pnl:AddControl('Slider', {Label = '#svc_rendermin', Type = 'Integer', Command = 'svc_vehiclemin', Min = -1, Max = 8000})
	pnl:AddControl('Slider', {Label = '#svc_rendermax', Type = 'Integer', Command = 'svc_vehiclemax', Min = 500, Max = 8000})
	pnl:InvalidateLayout(true)
	root:AddPanel(pnl)

	pnl = vgui.Create('ControlPanel')
	pnl:SetName('#svc_weapons')
	pnl:AddControl('Slider', {Label = '#svc_rendermin', Type = 'Integer', Command = 'svc_weaponmin', Min = -1, Max = 8000})
	pnl:AddControl('Slider', {Label = '#svc_rendermax', Type = 'Integer', Command = 'svc_weaponmax', Min = 500, Max = 8000})
	pnl:InvalidateLayout(true)
	root:AddPanel(pnl)

	pnl = vgui.Create('ControlPanel')
	pnl:SetName('#svc_doors')
	pnl:AddControl('Slider', {Label = '#svc_rendermin', Type = 'Integer', Command = 'svc_doormin', Min = -1, Max = 8000})
	pnl:AddControl('Slider', {Label = '#svc_rendermax', Type = 'Integer', Command = 'svc_doormax', Min = 500, Max = 8000})
	pnl:InvalidateLayout(true)
	root:AddPanel(pnl)

	pnl = vgui.Create('ControlPanel')
	pnl:SetName('#svc_misc')
	pnl:AddControl('Slider', {Label = '#svc_rendermin', Type = 'Integer', Command = 'svc_miscmin', Min = -1, Max = 8000})
	pnl:AddControl('Slider', {Label = '#svc_rendermax', Type = 'Integer', Command = 'svc_miscmax', Min = 500, Max = 8000})
	pnl:InvalidateLayout(true)
	root:AddPanel(pnl)
end

hook.Add('PopulateToolMenu', 'svc.PopulateToolMenu', function()
	spawnmenu.AddToolMenuOption('Utilities', 'Admin', 'RenderSettings', '#svc_settings', '', '', SDCSettings)
end)

hook.Add('AddToolMenuCategories', 'svc.AddToolMenuCategories', function()
	spawnmenu.AddToolCategory('Utilities', 'Admin', '#spawnmenu.utilities.admin')
end)

do
	local cc = GetConVarString('gmod_language')
	local add = language.Add
	if cc == 'ru' then
		add('svc_export', 'Экспортировать настройки')
		add('svc_export_clipboard', 'В буффер')
		add('svc_export_file', 'В файл')
		add('svc_export_file_help', 'Экспортирует настройки в ".../garrysmod/data/svc_export.txt"')

		add('svc_settings', 'Настройки рендера')
		add('svc_caneditlevel', 'Редактировать объекты карты')
		add('svc_performancemode', 'Отключить осколки объектов')
		add('svc_notsingleplayer', 'Эти параметры можно изменить только в одиночной игре')

		add('svc_disablereceiveshadows', 'Отключить тени на объектах')
		add('svc_disbleshadowdepth', 'Отключить тени объектов от фонарика')
		add('svc_disableshadows', 'Отключить тени объектов на карте')
		add('svc_shadowdistance', 'Дистанция теней')

		add('svc_shadows', 'Рендер теней')
		add('svc_props', 'Рендер объектов')
		add('svc_players', 'Рендер игроков')
		add('svc_npcs', 'Рендер NPC')
		add('svc_vehicles', 'Рендер автомобилей')
		add('svc_weapons', 'Рендер оружия')
		add('svc_doors', 'Рендер дверей')
		add('svc_misc', 'Рендер прочих объектов')
		add('svc_main', 'Основные настройки')

		add('svc_rendermin', 'Дистанция угасания')
		add('svc_rendermax', 'Дистанция отрисовки')
	else
		add('svc_export', 'Export settings')
		add('svc_export_clipboard', 'Clipboard')
		add('svc_export_file', 'File')
		add('svc_export_file_help', 'Exports your settings to ".../garrysmod/data/svc_export.txt"')

		add('svc_settings', 'Render settings')
		add('svc_caneditlevel', 'Allow edit map entities')
		add('svc_performancemode', 'Disable gibs')
		add('svc_notsingleplayer', 'All of these parameters can be changed only in singleplayer')

		add('svc_disablereceiveshadows', 'Disable entities receiving shadows')
		add('svc_disbleshadowdepth', 'Disable flashlight shadows')
		add('svc_disableshadows', 'Disable shadows on map surface')
		add('svc_shadowdistance', 'Shadows distance')

		add('svc_shadows', 'Shadows render')
		add('svc_props', 'Entities render')
		add('svc_players', 'Players render')
		add('svc_npcs', 'NPCs render')
		add('svc_vehicles', 'Vehicles render')
		add('svc_weapons', 'Weapons render')
		add('svc_doors', 'Doors render')
		add('svc_misc', 'Miscellaneous render')
		add('svc_main', 'Main settings')

		add('svc_rendermin', 'Fade distance')
		add('svc_rendermax', 'Render distance')
	end
end

do
	local fl = FCVAR_NEVER_AS_STRING + FCVAR_NOTIFY + FCVAR_REPLICATED + FCVAR_DONTRECORD
	CreateConVar('svc_caneditlevel', '0', '', fl, 0, 1)
	CreateConVar('svc_performancemode', '0', '', fl, 0, 1)
	CreateConVar('svc_disablereceiveshadows', '1', '', fl, 0, 1)
	CreateConVar('svc_disbleshadowdepth', '0', '', fl, 0, 1)
	CreateConVar('svc_disableshadows', '0', '', fl, 0, 1)
	CreateConVar('svc_shadowdistance', '500', '', fl, 0, 3000)
	CreateConVar('svc_propmin', '-1', '', fl, -1, 8000)
	CreateConVar('svc_propmax', '2500', '', fl, 500, 8000)
	CreateConVar('svc_playermin', '3000', '', fl, -1, 8000)
	CreateConVar('svc_playermax', '3000', '', fl, 500, 8000)
	CreateConVar('svc_npcmin', '3000', '', fl, -1, 8000)
	CreateConVar('svc_npcmax', '3000', '', fl, 500, 8000)
	CreateConVar('svc_vehiclemin', '-1', '', fl, -1, 8000)
	CreateConVar('svc_vehiclemax', '2500', '', fl, 500, 8000)
	CreateConVar('svc_weaponmin', '-1', '', fl, -1, 8000)
	CreateConVar('svc_weaponmax', '500', '', fl, 500, 8000)
	CreateConVar('svc_doormin', '-1', '', fl, -1, 8000)
	CreateConVar('svc_doormax', '3000', '', fl, 500, 8000)
	CreateConVar('svc_miscmin', '-1', '', fl, -1, 8000)
	CreateConVar('svc_miscmax', '500', '', fl, 500, 8000)
end