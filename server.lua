ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)


RegisterNetEvent('lspolicegarage:server:updatecars')
AddEventHandler('lspolicegarage:server:updatecars', function(society)

end)


RegisterNetEvent('lspolicegarage:server:initcars')
AddEventHandler('lspolicegarage:server:initcars', function(society)
    local ped = source
    print(society)
    MySQL.Async.fetchAll("SELECT * FROM police_car WHERE society = @society", {
        ['@society'] = society
    },
    function(cars)
        local rows = 0
        for k, v in ipairs(cars) do
            rows = rows + 1
        end
        for i=1,rows do --n rows lspolicegarage:client:initquerymenu
            TriggerClientEvent("lspolicegarage:client:setuplocaltable", ped, cars[i].carname,cars[i].plate,cars[i].stored,rows)
            TriggerClientEvent("lspolicegarage:client:initquerymenu", ped, cars[i].carname,cars[i].plate,cars[i].stored,rows)
        end
    end)
end)