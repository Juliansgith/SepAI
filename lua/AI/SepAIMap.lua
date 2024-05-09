local NavUtils = import('/lua/sim/navutils.lua')

-- Global flag to ensure map setup runs only once
local bMapSetupRun = false

-- Variables to store enemy base locations for the AI brain
local enemyBaseLocation = 'SepAIEnemyBase' -- Using a descriptive key for the brain's table

function SetupMap(aiBrain)
    if not bMapSetupRun then
        bMapSetupRun = true
        -- Generate navigation mesh if it hasn't been generated
        if not NavUtils.IsGenerated() then
            NavUtils.Generate()
        end
    end
    -- Run initial setup functions
    DetermineEnemyBase(aiBrain)
end

function DetermineEnemyBase(aiBrain)
    local nearestEnemyBaseDistance = 10000
    local nearestEnemyBase
    local ourBaseX, ourBaseZ = aiBrain:GetArmyStartPos()
    local ourIndex = aiBrain:GetArmyIndex()
    
    for _, enemyBrain in ipairs(ArmyBrains) do
        if IsEnemy(ourIndex, enemyBrain:GetArmyIndex()) and not ArmyIsCivilian(enemyBrain:GetArmyIndex()) then
            local enemyBaseX, enemyBaseZ = enemyBrain:GetArmyStartPos()
            local distance = VDist2(ourBaseX, ourBaseZ, enemyBaseX, enemyBaseZ)
            
            if distance < nearestEnemyBaseDistance then
                nearestEnemyBaseDistance = distance
                nearestEnemyBase = {enemyBaseX, GetSurfaceHeight(enemyBaseX, enemyBaseZ), enemyBaseZ}
            end
        end
    end
    
    -- Store the closest enemy base location in the AI brain for further use
    aiBrain[enemyBaseLocation] = nearestEnemyBase
end

