Citizen.CreateThread(function()
    while true do
        Citizen.Wait(10000)
        -- Using collectgarbage for memory monitoring since GetResourceCPUUsage/GetResourceMemoryUsage don't exist in FiveM/RedM
        local mem = collectgarbage("count") / 1024 -- Convert KB to MB
        print(string.format("[PROFILER] Police System: Mem %.2f MB", mem))
    end
end)