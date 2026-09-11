local core = require("openmw.core")
local self = require("openmw.self")
local types = require("openmw.types")

local isSoundPlaying = core.sound.isSoundPlaying
local stopSound3d = core.sound.stopSound3d
local playSoundFile3d = core.sound.playSoundFile3d
local random = math.random
local weaponStance = types.Actor.STANCE.Weapon
local weaponSlot = types.Actor.EQUIPMENT_SLOT.CarriedRight
local getStance = types.Actor.getStance
local getEquipment = types.Actor.getEquipment

local swishPath = "Sound\\Fx\\Item\\CSOSwing\\Swing%d.wav"
local hitPath = "Sound\\Fx\\Item\\CSOHit\\Hit%d.wav"

local function buildFiles(path, count)
    local t = {}
    for i = 1, count do
        t[i] = string.format(path, i)
    end
    return t
end

local swishFiles = buildFiles(swishPath, 26)
local hitFiles = buildFiles(hitPath, 102)
local nSwishFiles = #swishFiles
local nHitFiles = #hitFiles

local checks = {
    { "Weapon Swish",     swishFiles, nSwishFiles },
    { "SwishM",           swishFiles, nSwishFiles },
    { "SwishL",           swishFiles, nSwishFiles },
    { "SwishS",           swishFiles, nSwishFiles },
    { "Light Armor Hit",  hitFiles,   nHitFiles },
    { "Medium Armor Hit", hitFiles,   nHitFiles },
    { "Heavy Armor Hit",  hitFiles,   nHitFiles },
}
local nChecks = #checks

local function onUpdate()
    if getStance(self) ~= weaponStance or not getEquipment(self, weaponSlot) then
        return
    end

    for i = 1, nChecks do
        local c = checks[i]
        local name = c[1]
        if isSoundPlaying(name, self) then
            stopSound3d(name, self)
            local files, n = c[2], c[3]
            playSoundFile3d(files[random(1, n)], self)
            return
        end
    end
end

return {
    engineHandlers = {
        onUpdate = onUpdate,
    },
}
