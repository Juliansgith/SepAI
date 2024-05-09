local BaseAIBrain = import('/lua/sim/Brain.lua').Brain

-- Custom AI modules
local BaseTemplates = import('/mods/SepAI/lua/AI/AIBaseTemplates/BaseTemplates.lua')
local Builders = import('/mods/SepAI/lua/AI/AIBuilders/SepAIEarlySetup.lua')  -- Corrected to match your comment
local PlatoonTemplates = import('/mods/SepAI/lua/AI/platoontemplates/sepaiplatoontemplates.lua')

-- Extending the base AI brain with custom behaviors
SepAIBrain = Class(BaseAIBrain) {

    -- Initialization function for AI
    OnCreate = function(self)
        BaseAIBrain.OnCreate(self)

        -- Initialize AI base templates and builders
        self.BaseTemplates = BaseTemplates
        self.Builders = Builders
        self.PlatoonTemplates = PlatoonTemplates

        -- Additional custom setup can go here
        self:InitCustomAI()
    end,

    -- Custom initialization for specific strategies or adjustments
    InitCustomAI = function(self)
        -- Set up economic parameters or initial strategies that influence early game builders
        self.EconomicStatus = {
            EnergyEfficiency = 1.0,
            MassEfficiency = 1.0,
        }

        -- You can set initial flags or state variables here
        self.InitialSetupDone = false  -- A flag to track if the initial setup phase is complete

        -- Example: setting up initial resource allocation strategies or prioritization
        self:SetResourceAllocation('EarlyGameFocus')
    end,

    -- Unified Decide what the AI should do next
    DecideWhatToDo = function(self)
        if not self.InitialSetupDone then
            -- Check if early game setup conditions are met
            if self:CheckEarlyGameSetupCompletion() then
                self.InitialSetupDone = true
                -- Adjust strategies or resource allocations based on early setup completion
                self:SetResourceAllocation('StandardGrowth')
            end
        else
            -- Continue with regular decision making
            self:EvaluateStrategicPosition()
            -- Custom logic for deciding next actions based on current game state
            -- This is where you can add checks for aggression levels, defense needs, etc.
        end
    end,

    -- Function to set resource allocation strategies
    SetResourceAllocation = function(self, mode)
        if mode == 'EarlyGameFocus' then
            -- Increase emphasis on energy and mass collection efficiency
            self:AdjustEconomicParameters({
                MassCollectionEfficiency = 1.2,  -- Hypothetical function to adjust mass collection efficiency
                EnergyCollectionEfficiency = 1.2
            })
        elseif mode == 'StandardGrowth' then
            -- Balance all resources towards a more rounded growth
            self:AdjustEconomicParameters({
                MassCollectionEfficiency = 1.0,
                EnergyCollectionEfficiency = 1.0
            })
        end
    end,

    -- Function to check if early game setup is completed
    CheckEarlyGameSetupCompletion = function(self)
        -- Example: check if certain number of resource units are built
        local massExtractors = self:GetUnitCount(categories.MASSEXTRACTION)
        local energyProduction = self:GetUnitCount(categories.ENERGYPRODUCTION)
        return massExtractors >= 8 and energyProduction >= 8
    end,
}

-- Ensure the AI is listed in the AI manager
function AddSepAI()
    local aitypes = import('/lua/ui/lobby/aitypes.lua').aitypes
    table.insert(aitypes, {'sepstandard', 'Standard SepAI'})
end

AddSepAI()
