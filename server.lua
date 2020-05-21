ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)


RegisterNetEvent('lspolicegarage:getcars')
AddEventHandler('lspolicegarage:getcars', function(society)
    local ped = source
    print(society)
    MySQL.Async.fetchAll("SELECT * FROM police_car WHERE society = @society", {
        ['@society'] = society
    },
    function(cars)
        local rows
        for k, v in pairs(cars) do
            rows = k
        end
        print(cars[1].carname)
        TriggerClientEvent("lspolicegarage:carmenu", ped, cars[1].carname,cars[1].plate,cars[1].stored,rows)
    end)
end)