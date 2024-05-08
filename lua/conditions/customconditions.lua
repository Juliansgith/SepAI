MyCustomConditions = {
    ShouldBuildMoreProduction = function(aiBrain)
        local energyRatio = aiBrain:GetEconomyStoredRatio('ENERGY')
        local massRatio = aiBrain:GetEconomyStoredRatio('MASS')
        local energyIncome = aiBrain:GetEconomyIncome('ENERGY')
        local massIncome = aiBrain:GetEconomyIncome('MASS')
        local energyRequest = aiBrain:GetEconomyRequested('ENERGY')
        local massRequest = aiBrain:GetEconomyRequested('MASS')

        local energyThreshold = energyIncome > energyRequest and energyRatio > 0.3 or energyRatio > 0.8
        local massThreshold = massIncome > massRequest and massRatio > 0.3 or massRatio > 0.8

        return energyThreshold and massThreshold
    end,

    ShouldUseReserves = function(aiBrain)
        local energyStored = aiBrain:GetEconomyStored('ENERGY')
        local massStored = aiBrain:GetEconomyStored('MASS')
        local highReserveThreshold = 5000 

        return energyStored > highReserveThreshold and massStored > highReserveThreshold
    end,
}
