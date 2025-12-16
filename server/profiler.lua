Citizen.CreateThread(function()
    while true do
        Citizen.Wait(10000)
        -- Using collectgarbage for total Lua memory monitoring since GetResourceCPUUsage/GetResourceMemoryUsage don't exist in FiveM/RedM
        local mem = collectgarbage("count") / 1024 / 1024 -- Convert KB to MB
        print(string.format("[PROFILER] Police System - Total Lua Memory: %.2f MB", mem))
    end
end)