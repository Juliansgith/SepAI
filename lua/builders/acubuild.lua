local MyCustomConditions = import('/mods/SepAI/lua/conditions/customconditions.lua').CustomConditions

ACUBuilders = {
    BuilderGroups = {
        {
            BuilderName = 'ACU Initial Construction',
            BuildersType = 'EngineerBuilder',
            Builders = {
                Builder {
                    BuilderName = 'ACU Initial Base Setup',
                    PlatoonTemplate = 'CommanderBuilder',
                    Priority = 1000,
                    BuilderConditions = {
                        { MyCustomConditions, 'LessThanGameTimeSeconds', { 300 } } 
                    },
                    BuilderType = 'Any',
                    BuilderData = {
                        Construction = {
                            BuildStructures = {
                                'T1EnergyProduction',
                                'T1Resource',
                                'T1LandFactory',
                            }
                        }
                    }
                },
                Builder {
                    BuilderName = 'ACU T1 Defense Structures',
                    PlatoonTemplate = 'CommanderBuilder',
                    Priority = 900,
                    BuilderConditions = {
                        { MyCustomConditions, 'GreaterThanGameTimeSeconds', { 300 } }, 
                        { MyCustomConditions, 'NeedDefense', { 'BasePerimeter' } }
                    },
                    BuilderType = 'Any',
                    BuilderData = {
                        Construction = {
                            BuildStructures = {
                                'T1AADefense',
                                'T1GroundDefense',
                                'T1ShieldDefense',
                            }
                        }
                    }
                },
            }
        },
    }
}
