function widget:GetInfo()
    return {
        name      = "Passive builders v1",
        desc      = "All builders + factories (except commander) are set to Passive mode",
        author    = "[teh]decay",
        date      = "11 jan 2015",
        license   = "The BSD License",
        layer     = 0,
        version   = 1,
        enabled   = true  -- loaded by default
    }
end

-- project page on github: https://github.com/SpringWidgets/passive-builders

-- Changelog:
-- v2

local CMD_PASSIVE       = 34571
local spGetMyTeamID     = Spring.GetMyTeamID
local spGetTeamUnits    = Spring.GetTeamUnits
local spGetUnitDefID    = Spring.GetUnitDefID
local spGiveOrderToUnit = Spring.GiveOrderToUnit

local function isBuilder(unitDefID)
    return unitDefID and unitDefID.isBuilder and not unitDefID.canManualFire
end

local function passivateBuilder(unitID)
    spGiveOrderToUnit(unitID, CMD_PASSIVE, {1}, {})
end


function widget:Initialize()
    local myUnits = spGetTeamUnits(spGetMyTeamID())
    for _,unitID in ipairs(myUnits) do
        local unitDefID = spGetUnitDefID(unitID)
        if (isBuilder(UnitDefs[unitDefID])) then
            passivateBuilder(unitID)
        end
    end
end

function widget:UnitCreated(unitID, unitDefID, unitTeam)
    if (unitTeam ~= spGetMyTeamID()) then
        return
    end

    if (isBuilder(UnitDefs[unitDefID])) then
        passivateBuilder(unitID)
    end
end


function widget:UnitGiven(unitID, unitDefID, unitTeam)
    widget:UnitCreated(unitID, unitDefID, unitTeam)
end

function widget:UnitTaken(unitID, unitDefID, unitTeam, newTeam)
    widget:UnitCreated(unitID, unitDefID, unitTeam)
end

function widget:UnitFinished(unitID, unitDefID, unitTeam)
    widget:UnitCreated(unitID, unitDefID, unitTeam)
end

