-- Function to find peripherals matching a pattern
function findPeripherals(pattern)
    local peripherals = {}
    for _, name in ipairs(peripheral.getNames()) do
        if string.match(name, pattern) then
            table.insert(peripherals, peripheral.wrap(name))
        end
    end
    return peripherals
end

-- Function to push fluid from a tank to a destination
function pushFluid(tank, destination, amount)
    local pushed = tank.pushFluid(destination, amount)
    if pushed == 0 then
        print("Failed to push fluid from " .. tank.getName() .. " to " .. destination.getName())
    else
        print("Pushed " .. pushed .. " units of fluid from " .. tank.getName() .. " to " .. destination.getName())
    end
end

-- Main function to manage fluid transfer
function manageFluids()
    local dieselEngines = findPeripherals("tfmg:diesel_engine_.*")
    local dieselExpansions = findPeripherals("tfmg:diesel_engine_expansion_.*")
    
    -- Debugging output to verify found peripherals
    print("Found " .. #dieselEngines .. " diesel engines")
    print("Found " .. #dieselExpansions .. " diesel engine expansions")
    
    local tank1 = peripheral.wrap("fluidTank_2")
    local tank2 = peripheral.wrap("fluidTank_0")
    local tank3 = peripheral.wrap("fluidTank_1")
    while true do
    -- Push fluid from tank1 to diesel engines
    for _, engine in ipairs(dieselEngines) do
    local name = peripheral.getName(engine)
        tank1.pushFluid(name, 8000) -- Adjust the amount as needed
    end
    
    -- Push fluid from tank2 and tank3 to diesel engine expansions
    for _, expansion in ipairs(dieselExpansions) do
    local expansion1 = peripheral.getName(expansion)
        tank2.pushFluid(expansion1, 8000) -- Adjust the amount as needed
        tank3.pushFluid(expansion1, 500) -- Adjust the amount as needed
    end
    end
end
while true do
manageFluids()
sleep(0.1)
end
-- Run the fluid management function
