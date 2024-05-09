local UCBC = import('/lua/editor/UnitCountBuildConditions.lua')
local EBC = import('/lua/editor/EconomyBuildConditions.lua')
local Platoons = import('/mods/SepAI/lua/AI/platoontemplates/sepaiplatoontemplates.lua')

-- Builders for the ACU: Building initial base structures then switching to offensive or retreat behaviors
BuilderGroup {
    BuilderGroupName = 'SepAI_AcuBuilders',  -- Group for ACU related building and defensive behaviors
    BuildersType = 'EngineerBuilder',
    
    -- Initial build order for ACU
    Builder {
        BuilderName = 'SepAI_ACU_Initial_Build',
        PlatoonTemplate = 'CommanderBuilder',  -- Use a template that involves the ACU in building
        Priority = 1000,
        BuilderConditions = {
            -- Conditions to check if the initial buildings do not exist yet
            { UCBC, 'HaveLessThanUnitsWithCategory', { 1, categories.FACTORY * categories.LAND }},
            { UCBC, 'HaveLessThanUnitsWithCategory', { 4, categories.MASSEXTRACTION }},
            { UCBC, 'HaveLessThanUnitsWithCategory', { 4, categories.ENERGYPRODUCTION * categories.TECH1 }},
        },
        BuilderType = 'Any',
        BuilderData = {
            Construction = {
                BuildStructures = {
                    'T1LandFactory',
                    'T1Resource',  -- Mass Extractors
                    'T1Resource',
                    'T1Resource',
                    'T1Resource',
                    'T1EnergyProduction',  -- Energy Generators
                    'T1EnergyProduction',
                    'T1EnergyProduction',
                    'T1EnergyProduction',
                }
            }
        }
    },

    -- Defensive and ongoing construction tasks for ACU
    Builder {
        BuilderName = 'SepAI_ACU_Defensive',
        PlatoonTemplate = 'CommanderBuilder',  -- Use a template that involves the ACU but in a non-combat role
        Priority = 900,
        BuilderConditions = {
            -- Ensure that ACU stays defended by maintaining a certain number of defensive units or structures around
            { UCBC, 'GreaterThanUnitAroundACUCount', { 5, 40, categories.DEFENSE }},
            -- Check if ACU health is not full to avoid risky situations
            { UCBC, 'CommanderHealth', { 0.8 } },
        },
        BuilderType = 'Any',
        BuilderData = {
            Construction = {
                BuildClose = true,  -- Build structures close to ACU's location to maintain defense
                BuildStructures = {
                    'T2ShieldDefense',
                    'T2Artillery',
                    'T2StrategicMissile',
                    'T2AADefense',
                }
            }
        }
    },
    LOG('SepAI: ACU builder setup complete')
}

-- Builders for factories to produce specific units
BuilderGroup {
    BuilderGroupName = 'SepAI_FactoryBuilders', -- Group for all factory production
    BuildersType = 'FactoryBuilder',
    Builder {
        BuilderName = 'SepAI_Tank_Production_Basic',
        PlatoonTemplate = 'SepAI_TankPlatoon',  -- Assuming this is a defined PlatoonTemplate
        Priority = 800,
        BuilderConditions = {
            { UCBC, 'HaveLessThanUnitsWithCategory', { 25, categories.LAND * categories.MOBILE * categories.DIRECTFIRE * categories.TECH1 }},
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 8, categories.MASSEXTRACTION }},  -- Minimum Mass Extractors
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 8, categories.ENERGYPRODUCTION * categories.TECH1 }},  -- Minimum Energy Production
        },
        BuilderType = 'Land',
    },
    Builder {
        BuilderName = 'SepAI_Tank_Production_Increased',
        PlatoonTemplate = 'SepAI_TankPlatoon',
        Priority = 900,
        BuilderConditions = {
            { UCBC, 'HaveLessThanUnitsWithCategory', { 40, categories.LAND * categories.MOBILE * categories.DIRECTFIRE * categories.TECH1 }},
            { UCBC, 'EnemyHasMoreUnitsThanYou', { nil, categories.LAND * categories.MOBILE * categories.DIRECTFIRE * categories.TECH1, 30 }},
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 8, categories.MASSEXTRACTION }},  -- Ensure economic stability before increasing production
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 8, categories.ENERGYPRODUCTION * categories.TECH1 }},
        },
        BuilderType = 'Land',
    },
    Builder {
        BuilderName = 'SepAI_Tank_Attack',
        PlatoonTemplate = 'SepAI_TankAttackForce',  -- This should be a defined PlatoonTemplate that involves attack plans
        Priority = 1000,
        BuilderConditions = {
            { UCBC, 'UnitsGreaterAtLocation', { 'LocationType', 0.9, categories.LAND * categories.MOBILE * categories.DIRECTFIRE * categories.TECH1 }},
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 8, categories.MASSEXTRACTION }},
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 8, categories.ENERGYPRODUCTION * categories.TECH1 }},
        },
        BuilderType = 'Any',
    },
    LOG('SepAI: Factory builders setup complete')
}

-- Builders for engineers to handle economy and base expansion
BuilderGroup {
    BuilderGroupName = 'SepAI_EngineerEconomyBuilders', -- Group for all economic expansion by engineers
    BuildersType = 'EngineerBuilder',

    -- Engineer production for early game economy setup
    Builder {
        BuilderName = 'SepAI_Early_Game_Engineer_Production',
        PlatoonTemplate = 'T1EngineerBuilder',  -- Make sure this platoon template is properly defined
        Priority = 950,
        BuilderConditions = {
            -- Ensure we don't overproduce engineers
            { UCBC, 'HaveLessThanUnitsWithCategory', { 10, categories.ENGINEER * categories.TECH1 }},
        },
        BuilderType = 'Any',
    },

    -- Builder for deploying engineers to build Mass Extractors
    Builder {
        BuilderName = 'SepAI_Mass_Extractor_Construction',
        PlatoonTemplate = 'T1EngineerBuilder',
        Priority = 900,
        BuilderConditions = {
            -- Check for safe locations to build Mass Extractors
            { UCBC, 'CanBuildOnMassLessThanDistance', { 'LocationType', 1000, -500, 0, 0, 'AntiSurface', 1 }},  -- Parameters might need adjustment based on the map and threat assessment functions
        },
        BuilderType = 'Any',
        BuilderData = {
            Construction = {
                DesiresAssist = true,
                BuildClose = false,
                BuildStructures = {
                    'T1Resource',
                }
            }
        }
    },

    -- Dynamic energy production based on demand
    Builder {
        BuilderName = 'SepAI_Energy_Production_On_Demand',
        PlatoonTemplate = 'T1EngineerBuilder',
        Priority = 850,
        BuilderConditions = {
            -- Start building energy if our stored energy is low relative to income
            { EBC, 'LessThanEconEfficiencyOverTime', { 1.1, 0.9 }},  -- Checks if the energy efficiency is below 90%
        },
        BuilderType = 'Any',
        BuilderData = {
            Construction = {
                DesiresAssist = false,
                BuildClose = true,
                BuildStructures = {
                    'T1EnergyProduction',
                }
            }
        }
    },
    LOG('SepAI: Engineer economy builders setup complete')
}

