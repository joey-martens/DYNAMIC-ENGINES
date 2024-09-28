-- Define fluid types
local fluidTypes = {
    diesel = "diesel",
    lubricant = "lubricant",
    air = "air"
}

-- Function to push a fixed amount of fluid from a tank to a peripheral
local function pushFluid(tankPeripheral, peripheralName, amount)
    if tankPeripheral and peripheral.isPresent(peripheralName) then
        local amountPushed = tankPeripheral.pushFluid(peripheralName, amount)
        return amountPushed
    else
        error("Failed to push fluid from tank to " .. peripheralName)
    end
end

-- Function to find all peripherals with a given prefix
local function findPeripherals(prefix)
    local foundPeripherals = {}
    for _, side in ipairs(peripheral.getNames()) do
        if side:find(prefix) then
            table.insert(foundPeripherals, side)
        end
    end
    return foundPeripherals
end

-- Function to find peripherals with specific fluid types in their tanks
local function findTanksWithFluid(fluid)
    local foundTanks = {}
    for _, side in ipairs(peripheral.getNames()) do
        if peripheral.hasType(side, "tank") then
            local tankPeripheral = peripheral.wrap(side)
            for _, tankInfo in ipairs(tankPeripheral.getTankInfo()) do
                if tankInfo.name == fluid then
                    foundTanks[fluid] = side
                end
            end
        end
    end
    return foundTanks
end

-- Function to monitor and push fluid to peripherals
local function monitorSystems()
    -- Identify relevant tank peripherals
    local dieselTanks = findTanksWithFluid(fluidTypes.diesel)
    local lubricantTanks = findTanksWithFluid(fluidTypes.lubricant)
    local airTanks = findTanksWithFluid(fluidTypes.air)

    while true do
        -- Find all expansion and engine peripherals
        local expansions = findPeripherals("expansion")
        local engines = findPeripherals("engine")

        -- Push fluids to peripherals
        for _, engine in ipairs(engines) do
            for _, tank in pairs(dieselTanks) do
                pushFluid(peripheral.wrap(tank), engine, 8000)
            end
        end

        for _, expansion in ipairs(expansions) do
            for _, tank in pairs(lubricantTanks) do
                pushFluid(peripheral.wrap(tank), expansion, 8000)
            end

            for _, tank in pairs(airTanks) do
                pushFluid(peripheral.wrap(tank), expansion, 8000)
            end
        end

        -- Delay before next check
        sleep(0.1)
    end
end

-- Start monitoring systems
monitorSystems()
