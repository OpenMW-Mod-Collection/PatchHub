local I = require("openmw.interfaces")
local types = require("openmw.types")
local util = require("openmw.util")

local srcCell = "Esm3ExteriorCell:-5:-5"
local destCell = "rethan manor"

I.Activation.addHandlerForType(
    types.Door,
    function(obj, actor)
        if obj.cell.id ~= srcCell
            or not obj.type.isTeleport(obj)
            or obj.type.destCell(obj).id ~= destCell
            or obj.type.isLocked(obj)
            or obj.type.getTrapSpell(obj)
            or not types.Player.objectIsInstance(actor)
        then
            return true
        end

        ---@type GameObject
        local doorBack
        for _, door in ipairs(obj.type.destCell(obj):getAll(types.Door)) do
            if door.type.destCell(door).id == srcCell then
                doorBack = door
                break
            end
        end

        actor:teleport(
            obj.type.destCell(obj),
            doorBack.position + util.vector3(-150, 0, 0),
            {
                onGround = true,
            }
        )
        return false
    end
)
