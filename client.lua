ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end
	PlayerData = ESX.GetPlayerData()
end)

MenuImage = "https://i.imgur.com/kgzvDwQ.png"
local RuntimeTXD = CreateRuntimeTxd('Custom_Menu_Head')
local Object = CreateDui(MenuImage, 512, 128)
_G.Object = Object
local TextureThing = GetDuiHandle(Object)
local Texture = CreateRuntimeTextureFromDuiHandle(RuntimeTXD, 'Custom_Menu_Head', TextureThing)
Menuthing = "Custom_Menu_Head"


_menuPool = NativeUI.CreatePool()
mainMenu = NativeUI.CreateMenu("VEICOLI POLIZIA", "~b~Preleva i veicoli della polizia",nil,nil,Menuthing,Menuthing)
_menuPool:Add(mainMenu)
_menuPool:MouseControlsEnabled(false)
_menuPool:MouseEdgeEnabled(false)
_menuPool:ControlDisablingEnabled(false)


-- local cars = { "Aventador","Peugeut"}
-- function CarSpawn(menu)
--     local newitem = NativeUI.CreateListItem("Ritira Veicolo", cars, 1)
--     menu:AddItem(newitem)
--     menu.OnListChange = function (sender, item, index)
--         if item == newitem then
--             ESX.ShowNotification("ciao")
--         end
--     end

-- end
-- function Test(menu)
--     --  local Description = "Sample description that takes more than one line. Moreso, it takes way more than two lines since it's so long. Wow, check out this length!"
--     --  local Item = NativeUI.CreateColouredItem("Coloured item", Description, Colours.BlueLight, Colours.BlueDark)
--     --  menu:AddItem(Item)
--     -- menu.OnItemSelect = function(menu, item)
--     --    if item == Item then
--     --     -- Perform your actions here.
--     --     end
--     --  end
--     local ciao = "hekllo"
-- end

function CarSpawn(menu)
    local Veicoli = NativeUI.CreateItem("Veicolo", "Preleva questo veicolo")
    menu:AddItem(Veicoli)
    menu.OnItemSelect = function(menu, item)
       if item == Veicoli then
        Citizen.Trace("hello clochard")
        local job = "police"
        TriggerServerEvent('lspolicegarage:getcars', job)
       end
    end
end

function CarSpawnNew(menu,carname)
    carname = NativeUI.CreateItem(carname, "Preleva questo veicolo")
    menu:AddItem(carname)
    menu.OnItemSelect = function(menu, item)
       if item == carname then
        Citizen.Trace("ciaooo")
       end
    end
end

RegisterNetEvent("lspolicegarage:carmenu")
AddEventHandler("lspolicegarage:carmenu", function(carname,plate,stored)
    CarSpawnNew(mainMenu,carname)
end)

CarSpawn(mainMenu)
--Test(mainMenu)
_menuPool:RefreshIndex()

local blip   = {
    garage = {x = 437.67,  y = -1017.9, z = 28.77},
    {x = 453.63,  y = -1017.6, z = 28.45},
    {x = 532.216,  y = -456.131, z = 34.037}
}

Citizen.CreateThread(function()
    while true do
        local coords = GetEntityCoords(GetPlayerPed(-1))
        Citizen.Wait(0)
        if GetDistanceBetweenCoords(coords,blip.garage.x,blip.garage.y,blip.garage.z) < 2.5 then
            _menuPool:ProcessMenus()
            if IsControlJustPressed(0, 38) then
                mainMenu:Visible(not mainMenu:Visible())
            end
        end
    end
end)








--JUST MARKERS AND BLIPS
--NEED TO ADD BLIPS

Citizen.CreateThread(function()
    blips()
end)

function blips()
    while true do
        Citizen.Wait(1)
        if GetDistanceBetweenCoords( blip.garage.x,blip.garage.y,blip.garage.z, GetEntityCoords(GetPlayerPed(-1))) < 10.0 then
            DrawText3D(blip.garage, "~g~[E]~w~ Preleva Veicolo")
        end
    end
end

local background = {
    color = { r = 35, g = 35, b = 35, alpha = 130 },
}
local color = { r = 220, g = 220, b = 220, alpha = 255 }
local font = 0
function DrawText3D(coords, text)
    local x,y,z = coords.x, coords.y, coords.z
    local onScreen,_x,_y = World3dToScreen2d(x,y,z)
    local px,py,pz = table.unpack(GetGameplayCamCoord())
    local dist = GetDistanceBetweenCoords(px,py,pz, x,y,z, 1)

    local scale = ((1/dist)*2)*(1/GetGameplayCamFov())*100

    if onScreen then

        -- Formalize the text
        SetTextColour(color.r, color.g, color.b, color.alpha)
        SetTextScale(scale, 0.25*scale)
        SetTextFont(font)
        SetTextProportional(1)
        SetTextCentre(true)

        -- Calculate width and height
        BeginTextCommandWidth("STRING")
        AddTextComponentString(text)
        local height = GetTextScaleHeight(0.45*scale, font)
        local width = EndTextCommandGetWidth(font)

        -- Diplay the text
        SetTextEntry("STRING")
        AddTextComponentString(text)
        EndTextCommandDisplayText(_x, _y)

        DrawRect(_x, _y+scale/95, width, height, background.color.r, background.color.g, background.color.b , background.color.alpha)
    end
end



-- pool = NativeUI.CreatePool()
-- pool:RefreshIndex()
-- newMenu = nil
-- local tableThatChangesOften = {"Value1","Value2"}
-- local tableThatChangesOftenIndex = 1
-- local tableThatChangesOftenSelection = tableThatChangesOften[tableThatChangesOftenIndex]

-- function AddDynamicList(menu) 
-- 	local newitem = NativeUI.CreateListItem("Dynamic", tableThatChangesOften, tableThatChangesOftenIndex)
-- 	menu:AddItem(newitem)
-- 	menu.OnListChange = function(sender, item, index)
-- 		if item == newitem then
-- 			tableThatChangesOftenIndex = index
-- 			tableThatChangesOftenSelection = item:IndexToItem(index)
-- 		end
-- 	end
-- end

-- function openDynamicMenu()
-- 	newMenu = NativeUI.CreateMenu("Yay", "~b~Dynamic List")
-- 	pool:Add(newMenu )
-- 	AddDynamicList(newMenu )
-- 	pool:RefreshIndex()
-- 	newMenu:Visible(true)
-- end

-- Citizen.CreateThread(function()
--     while true do
--         Citizen.Wait(0)
--         pool:ProcessMenus()
--         if IsControlJustPressed(1, 38) then
--             openDynamicMenu()
--         end
--     end
-- end)
