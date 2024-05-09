-- Platoon for Tanks, Engineers, and Mobile AA
PlatoonTemplate {
    Name = 'SepAI_TankPlatoon',
    Plan = 'AttackForceAI',
    GlobalSquads = {
        { categories.MOBILE * categories.LAND * categories.DIRECTFIRE, 4, 10, 'Attack', 'none' }
    },
}

PlatoonTemplate {
    Name = 'SepAI_EngineerPlatoon',
    Plan = 'EngineerBuildAI',
    GlobalSquads = {
        { categories.ENGINEER * categories.MOBILE, 1, 1, 'Support', 'none' }
    },
}

PlatoonTemplate {
    Name = 'SepAI_MobileAAPlatoon',
    Plan = 'GuardBaseAI',
    GlobalSquads = {
        { categories.MOBILE * categories.LAND * categories.ANTIAIR, 1, 3, 'Support', 'none' }
    },
}
