if not lib then error("LGF Report requires ox_lib. Refer to the documentation.") end

local Shared = {}
local Core = nil
local GetCore = promise.new()
local Path = lib.context
local CitWait = Citizen.Await

if GetResourceState("LegacyFramework") ~= "missing" then
    Core = "LegacyFramework"
    GetCore:resolve({ "LegacyFramework", "ReturnFramework" })
elseif GetResourceState("es_extended") ~= "missing" then
    Core = "es_extended"
    GetCore:resolve({ "es_extended", "getSharedObject" })
elseif GetResourceState("qb-core") ~= "missing" then
    Core = "qbx_core"
    GetCore:resolve({ "qb-core", "GetCoreObject" })
else
    GetCore:reject("Could not find a framework!")
    return
end

local Object = table.unpack(CitWait(GetCore))

if Path == 'client' then
    function Shared:GetName()
        if Core == 'LegacyFramework' then
            local firstName = LocalPlayer.state.playerData[1].firstName
            local lastName = LocalPlayer.state.playerData[1].lastName
            return string.format("%s %s", firstName, lastName)
        elseif Core == 'es_extended' then
            local firstName = Object.GetPlayerData().firstName
            local lastName = Object.GetPlayerData().lastName
            return string.format("%s %s", firstName, lastName)
        elseif Core == 'qbx_core' then
            local Player = exports.qbx_core:GetPlayerData()
            return ("%s %s"):format(Player.charinfo.firstname, Player.charinfo.lastname)
        end
    end
end

if Path == 'server' then
    function Shared:GetPlayerIdentifier(src)
        if Core == 'LegacyFramework' then
            return Object.SvPlayerFunctions.GetPlayerData(src)[1].charName
        elseif Core == 'es_extended' then
            return Object.GetIdentifier(src)
        elseif Core == 'qbx_core' then
            local PlayerData = exports.qbx_core:GetPlayer(src).PlayerData
            return PlayerData.license
        end
    end

    function Shared:GetPlayerName(src)
        if Core == 'LegacyFramework' then
            local PlayerData = Object.SvPlayerFunctions.GetPlayerData(src)[1]
            return string.format("%s %s", PlayerData.firstName, PlayerData.lastName)
        elseif Core == 'es_extended' then
            local xPlayer = Object.GetPlayerFromId(src)
            return string.format("%s %s", xPlayer.get("firstName"), xPlayer.get("lastName"))
        elseif Core == 'qbx_core' then
            local QbPlayer = exports.qbx_core:GetPlayer(src).PlayerData
            return string.format("%s %s", QbPlayer.charinfo.firstname, QbPlayer.charinfo.lastname)
        end
    end

    function Shared:GetPlayerGroup(src)
        if Core == 'LegacyFramework' then
            return Object.SvPlayerFunctions.GetPlayerData(src)[1].playerGroup
        elseif Core == 'es_extended' then
            return Object.GetPlayerFromId(src).getGroup()
        elseif Core == 'qbx_core' then
            if IsPlayerAceAllowed(src, 'admin') then
                return 'admin'
            end
        end
    end
end

return Shared
