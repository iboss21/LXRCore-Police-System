Citizen.CreateThread(function()
    while true do
        Citizen.Wait(10000)
        -- CPU monitoring removed: GetResourceCPUUsage doesn't exist in FiveM/RedM
        -- Memory monitoring replaced: GetResourceMemoryUsage replaced with collectgarbage
        local mem = collectgarbage("count") / 1024 -- collectgarbage returns memory in KB, divide by 1024 to convert to MB
        print(string.format("[PROFILER] Police System - Total Lua Memory: %.2f MB", mem))
    end
end)