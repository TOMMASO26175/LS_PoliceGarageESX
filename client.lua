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

mainMenu = nil
_menuPool = NativeUI.CreatePool()
Count = 1
CarsTable = {}
Init = false
Myindex = 0
StoredTable = {}
NotStoredTable = {}

function PoolExtra()
    _menuPool:MouseControlsEnabled(false)
    _menuPool:MouseEdgeEnabled(false)
    _menuPool:ControlDisablingEnabled(false)
end

RegisterNetEvent("lspolicegarage:client:initquerymenu")
AddEventHandler("lspolicegarage:client:initquerymenu",function(carname,plate,stored,numrows)
    print(stored)
    local amount = 1
    if stored == true then
        StoredTable[amount] = InitialCarMenu(mainMenu,carname,stored,plate)
    elseif stored == false then
        NotStoredTable[amount] = NotStoredCar(mainMenu,carname,stored,plate)
        --InitialCarMenu(mainMenu,carname,stored,plate)
    end
    if amount < numrows then
        amount = amount + 1
    end
end)

RegisterNetEvent("lspolicegarage:client:setuplocaltable")
AddEventHandler("lspolicegarage:client:setuplocaltable", function(carname,plate,stored,numrows)

    CurrentRows = numrows
    --Citizen.Trace("numero di righe "..numrows)
    --Citizen.Trace("\n iniziale "..Count)

    table.insert( CarsTable,Count,{name = carname,carplate = plate,isstored = stored})
    if Count < numrows then
        Count = Count + 1
    end
    --Citizen.Trace("\n finale"..Count)
end)

RegisterNetEvent("lspolicegarage:client:getcarslocaltable")
AddEventHandler('lspolicegarage:client:getcarslocaltable', function()
    for i=1,CurrentRows do
       Localcar(mainMenu,CarsTable[i].name,CarsTable[i].carplate,CarsTable[i].isstored)
    end
end)

RegisterNetEvent('lspolicegarage:client:onitemselect')
AddEventHandler('lspolicegarage:client:onitemselect', function()
    mainMenu.OnItemSelect = function(menu,item,index)
    for k,v in pairs(StoredTable) do
        --print(k,v)
        if index == v then
            print("sone dentro")
        end
    end
    for k,v in pairs(NotStoredTable) do
        --print(k,v)
        if index == v then
            print("non sono dentro")
        end
    end
    end
end)

function DynamicMenu()
    mainMenu = NativeUI.CreateMenu("VEICOLI POLIZIA", "~b~Preleva i veicoli della polizia",nil,nil,Menuthing,Menuthing)
    _menuPool:Add(mainMenu)
    PoolExtra()

    local job = "police"

    if Init == false then
        TriggerServerEvent('lspolicegarage:server:initcars', job)
        TriggerEvent('lspolicegarage:client:onitemselect')
        Init = true
    else
        TriggerEvent('lspolicegarage:client:getcarslocaltable')
        --TriggerServerEvent('lspolicegarage:server:getcars', job)
    end
    _menuPool:RefreshIndex()
    mainMenu:Visible(not mainMenu:Visible())
end

function Localcar(menu,carname,stored,plate)
    carname = NativeUI.CreateItem(carname, "Preleva questo veicolo")
    menu:AddItem(carname)
    _menuPool:RefreshIndex()
    menu.OnItemSelect = function(menu, item, index)
    local realitem = menu:GetItemAt(index) --now you can pass at this function multiple carname and make every of it doing something different
        if item == realitem then
            Citizen.Trace("ciaooo")
        end
    end
end











function InitialCarMenu(menu,carname,stored,plate)
        carname = NativeUI.CreateItem(carname, "Preleva questo veicolo Query")
        menu:AddItem(carname)
        Myindex = Myindex + 1
        _menuPool:RefreshIndex()
        return Myindex
end

-- menu.OnItemSelect = function(menu, item, index)
--     local realitem = menu:GetItemAt(index)
--     --print(index)
--     --print("di qua")
--     --print(realitem)
--     --print(item)
--     if item == carname then
--         Citizen.Trace("dentro")
--     end
-- end

function NotStoredCar(menu,carname,stored,plate)
    carname = NativeUI.CreateItem(carname, "Questo Veicolo è fuori")
    carname:RightLabel("Fuori",{ R = 255, G = 0, B = 0, A = 100 })
    menu:AddItem(carname)
    Myindex = Myindex + 1
    _menuPool:RefreshIndex()
    return Myindex
end

-- menu.OnItemSelect = function(menu, item, index)
--     print(index)
--     local realitem = menu:GetItemAt(index)
--     print(realitem)
--     print(item)
--     if item == carname then
--         --exports['mythic_notify'].DoHudText('error', 'Questo Veicolo è Fuori dal garage')
--         print("dentrolitem")
--     end
-- end



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
                DynamicMenu()
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
