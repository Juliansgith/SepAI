local MyCustomConditions = import('/mods/SepAI/lua/conditions/customconditions.lua').CustomConditions

EconomicBuilders = {
    BuilderGroups = {
        {
            BuilderName = 'T1 Economy Initial Setup',
            BuildersType = 'EngineerBuilder',
            Builders = {
                Builder {
                    BuilderName = 'Build T1 Power Generators',
                    PlatoonTemplate = 'T1EngineerBuilder',
                    Priority = 950,
                    BuilderConditions = {
                        { MyCustomConditions, 'NeedMoreEnergy', { 0.8 } }
                    },
                    BuilderType = 'Any',
                    BuilderData = {
                        Construction = {
                            BuildStructures = {
                                'T1EnergyProduction',
                            }
                        }
                    }
                },
                Builder {
                    BuilderName = 'Build Hydrocarbon Power Plants',
                    PlatoonTemplate = 'T1EngineerBuilder',
                    Priority = 1000,
                    BuilderConditions = {
                        { MyCustomConditions, 'CanBuildOnHydrocarbon', {} }
                    },
                    BuilderType = 'Any',
                    BuilderData = {
                        Construction = {
                            NearMarkerType = 'Hydrocarbon',
                            BuildStructures = {
                                'HydrocarbonPowerPlant',
                            }
                        }
                    }
                },
                Builder {
                    BuilderName = 'Initial T1 Mass Extractors',
                    PlatoonTemplate = 'T1EngineerBuilder',
                    Priority = 950,
                    BuilderConditions = {
                        { MyCustomConditions, 'NeedMoreMass', { 0.8 } }
                    },
                    BuilderType = 'Any',
                    BuilderData = {
                        Construction = {
                            BuildStructures = {
                                'T1Resource',
                            }
                        }
                    }
                },
            }
        },
        {
            BuilderName = 'Higher Tech Energy Production',
            BuildersType = 'EngineerBuilder',
            Builders = {
                Builder {
                    BuilderName = 'Build T2 Power Generators',
                    PlatoonTemplate = 'T2EngineerBuilder',
                    Priority = 900,
                    BuilderConditions = {
                        { MyCustomConditions, 'NeedMoreEnergy', { 0.7 } },
                        { MyCustomConditions, 'Tech2EngineerExists', {} }
                    },
                    BuilderType = 'Any',
                    BuilderData = {
                        Construction = {
                            BuildStructures = {
                                'T2EnergyProduction',
                            }
                        }
                    }
                },
                Builder {
                    BuilderName = 'Upgrade T1 to T2 Mass Extractors',
                    PlatoonTemplate = 'T2EngineerBuilder',
                    Priority = 850,
                    BuilderConditions = {
                        { MyCustomConditions, 'ShouldUpgradeResourceProduction', { 'TECH2' } }
                    },
                    BuilderType = 'Any',
                    BuilderData = {
                        Upgrade = {
                            UpgradeStructure = 'T1Resource',
                        }
                    }
                },
            }
        },
        {
            BuilderName = 'T3 Economy Expansion',
            BuildersType = 'EngineerBuilder',
            Builders = {
                Builder {
                    BuilderName = 'Build T3 Power Generators',
                    PlatoonTemplate = 'T3EngineerBuilder',
                    Priority = 800,
                    BuilderConditions = {
                        { MyCustomConditions, 'NeedMoreEnergy', { 0.6 } },
                        { MyCustomConditions, 'Tech3EngineerExists', {} }
                    },
                    BuilderType = 'Any',
                    BuilderData = {
                        Construction = {
                            BuildStructures = {
                                'T3EnergyProduction',
                            }
                        }
                    }
                },
                Builder {
                    BuilderName = 'Upgrade T2 to T3 Mass Extractors',
                    PlatoonTemplate = 'T3EngineerBuilder',
                    Priority = 750,
                    BuilderConditions = {
                        { MyCustomConditions, 'ShouldUpgradeResourceProduction', { 'TECH3' } }
                    },
                    BuilderType = 'Any',
                    BuilderData = {
                        Upgrade = {
                            UpgradeStructure = 'T2Resource',
                        }
                    }
                },
            }
        }
    }
}
