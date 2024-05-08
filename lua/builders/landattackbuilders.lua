local BuildingUtils = import('/mods/SepAI/lua/conditions/buildingutils.lua')
local UnitUtils = import('/mods/SepAI/lua/conditions/unitutils.lua')
local PlatoonTemplates = import('/mods/SepAI/lua/platoontemplates.lua').PlatoonTemplates

LandAttackBuilders = {
    BuilderGroups = {
        {
            BuilderName = 'T1 Land Unit Production',
            BuildersType = 'FactoryBuilder',
            Builders = {
                Builder {
                    BuilderName = 'T1 Tanks',
                    PlatoonTemplate = 'T1LandDFTank',
                    Priority = 900,
                    BuilderConditions = {
                        { BuildingUtils, 'LessThanFactoryCount', { 'LAND', 2 } },
                        { UnitUtils, 'UnitCapCheckLess', { .75 } }
                    },
                    BuilderType = 'Land'
                },
                Builder {
                    BuilderName = 'T1 Mobile Artillery',
                    PlatoonTemplate = 'T1LandArtillery',
                    Priority = 850,
                    BuilderConditions = {
                        { BuildingUtils, 'LessThanFactoryCount', { 'LAND', 2 } },
                        { UnitUtils, 'UnitCapCheckLess', { .75 } }
                    },
                    BuilderType = 'Land'
                },
            }
        },
        {
            BuilderName = 'Basic Land Attack',
            BuildersType = 'PlatoonFormBuilder',
            Builders = {
                Builder {
                    BuilderName = 'T1 Tank Attack',
                    PlatoonTemplate = 'AttackForceT1',
                    Priority = 800,
                    BuilderConditions = {
                        { UnitUtils, 'EnemyThreatGreaterThanValueAtBase', { 'LocationType', 15 } }
                    },
                    InstanceCount = 2,
                    BuilderType = 'Any',
                    BuilderData = {
                        SearchRadius = 600,
                        GetTargetsFromBase = true,
                        AggressiveMove = true,
                        AttackEnemyStrength = 100000,
                        MoveToCategories = {
                            'LAND',
                            'STRUCTURE',
                        },
                        StayTogether = true,
                        PrioritizedCategories = { 
                            'ANTIAIR',
                            'DIRECTFIRE',
                            'ARTILLERY',
                            'ENGINEER',
                            'MASSEXTRACTION',
                        },
                    }
                },
            }
        }
    }
}
