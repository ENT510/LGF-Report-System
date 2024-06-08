---@diagnostic disable: undefined-field
if not lib then error("Your resource requires the ox_lib resource. Refer to the documentation.") end
local Core = {}

local GetCore = promise.new()
local Path = lib.context
local CitWait = Citizen.Await


if GetResourceState("LegacyFramework") ~= "missing" then
    GetCore:resolve({ "LegacyFramework", "ReturnFramework" })
elseif GetResourceState("es_extended") ~= "missing" then
    GetCore:resolve({ "es_extended", "getSharedObject" })
elseif GetResourceState("qb-core") ~= "missing" then
    GetCore:resolve({ "qb-core", "GetCoreObject" })
else
    GetCore:reject("Could not find a framework!")
end

local Name, Object = table.unpack(CitWait(GetCore))
local Core <const> = Object and exports[Name][Object]()



if Path == 'client' then
    function Core:GetName()
        if Name == 'LegacyFramework' then
            local firstName = LocalPlayer.state.playerData[1].firstName
            local lastName = LocalPlayer.state.playerData[1].lastName
            return string.format("%s %s", firstName, lastName)
        elseif Name == 'es_extended' then
            local firstName = ESX.GetPlayerData().firstName
            local lastName = ESX.GetPlayerData().lastName
            return string.format("%s %s", firstName, lastName)
        elseif Name == 'qb-core' then
            local Player = exports['qb-core']:GetPlayerData()
            return ("%s %s"):format(Player.charinfo.firstname, Player.charinfo.lastname)
        end
    end
end

if Path == 'server' then
    function Core:GetPlayerIdentifier(src)
        if Name == 'LegacyFramework' then
            return Core.SvPlayerFunctions.GetPlayerData(src)[1].charName
        elseif Name == 'es_extended' then
            return ESX.GetIdentifier(src)
        elseif Name == 'qb-core' then
            return exports["qb-core"]:GetPlayer(src).PlayerData.license
        end
    end

    function Core:GetPlayerName(src)
        if Name == 'LegacyFramework' then
            local PlayerData = Core.SvPlayerFunctions.GetPlayerData(src)[1]
            return string.format("%s %s", PlayerData.firstName, PlayerData.lastName)
        elseif Name == 'es_extended' then
            local xPlayer = ESX.GetPlayerFromId(src)
            return string.format("%s %s", xPlayer.get("firstName"), xPlayer.get("lastName"))
        elseif Name == 'qb-core' then
            local QbPlayer = exports["qb-core"]:GetPlayer(src).PlayerData
            return string.format("%s %s", QbPlayer.charinfo.firstname, QbPlayer.charinfo.lastname)
        end
    end

    function Core:GetPlayerGroup(src)
        if Name == 'LegacyFramework' then
            return Core.SvPlayerFunctions.GetPlayerData(src)[1].playerGroup
        elseif Name == 'es_extended' then
            return ESX.GetPlayerFromId(src).getGroup()
        elseif Name == 'qb-core' then
            local hasAdminPerms = exports["qb-core"]:GetPermission(src).admin
            if hasAdminPerms == true then
                return 'admin'
            end
        end
    end
end

return Core
