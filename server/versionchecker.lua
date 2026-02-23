--[[
    ██╗     ██╗  ██╗██████╗        ██████╗ ██████╗ ██████╗ ███████╗
    ██║     ╚██╗██╔╝██╔══██╗      ██╔════╝██╔═══██╗██╔══██╗██╔════╝
    ██║      ╚███╔╝ ██████╔╝█████╗██║     ██║   ██║██████╔╝█████╗
    ██║      ██╔██╗ ██╔══██╗╚════╝██║     ██║   ██║██╔══██╗██╔══╝
    ███████╗██╔╝ ██╗██║  ██║      ╚██████╗╚██████╔╝██║  ██║███████╗
    ╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝       ╚═════╝ ╚═════╝ ╚═╝  ╚═╝╚══════╝

    🐺 LXR Core - Police System

    ═══════════════════════════════════════════════════════════════════════════════
    SERVER SCRIPT - VERSION CHECKER
    ═══════════════════════════════════════════════════════════════════════════════

    Checks the running version of lxr-police against the canonical version
    published on GitHub. Warns server owners when an update is available.

    Also enforces the required resource name to prevent theft/reselling under
    a different name.

    Developer:   iBoss21 / The Lux Empire
    Website:     https://www.wolves.land
    Discord:     https://discord.gg/CrKcWdfd3A
    GitHub:      https://github.com/iBoss21

    © 2026 iBoss21 / The Lux Empire | wolves.land | All Rights Reserved
]]

-- ═══════════════════════════════════════════════════════════════════════════════
-- 🐺 RESOURCE NAME PROTECTION
-- ═══════════════════════════════════════════════════════════════════════════════

local REQUIRED_RESOURCE_NAME <const> = 'lxr-police'
local GITHUB_VERSION_URL     <const> = 'https://raw.githubusercontent.com/iboss21/LXRCore-Police-System/main/version.txt'
local GITHUB_REPO_URL        <const> = 'https://github.com/iboss21/LXRCore-Police-System'

local resourceName = GetCurrentResourceName()

if resourceName ~= REQUIRED_RESOURCE_NAME then
    local msg = string.format([[

    ═══════════════════════════════════════════════════════════════════════════════
    ❌ CRITICAL ERROR: RESOURCE NAME MISMATCH ❌
    ═══════════════════════════════════════════════════════════════════════════════

        Expected resource name : %s
        Detected resource name : %s

        This resource MUST be named "%s".
        Rename your resource folder to "%s" and restart.

        🐺 wolves.land — The Land of Wolves | iBoss21 / The Lux Empire
        Unauthorized redistribution or renaming is strictly prohibited.

    ═══════════════════════════════════════════════════════════════════════════════

    ]], REQUIRED_RESOURCE_NAME, resourceName, REQUIRED_RESOURCE_NAME, REQUIRED_RESOURCE_NAME)

    -- Print a loud, coloured warning and stop execution
    print('^1' .. msg .. '^7')
    error(('[lxr-police] Resource name mismatch — expected "%s", got "%s". Halting.'):format(
        REQUIRED_RESOURCE_NAME, resourceName), 2)
end

-- ═══════════════════════════════════════════════════════════════════════════════
-- 🐺 VERSION CHECKER
-- ═══════════════════════════════════════════════════════════════════════════════

local function printLog(level, message)
    -- level: 'success' | 'warning' | 'error'
    local color = ({ success = '^2', warning = '^3', error = '^1' })[level] or '^7'
    print(('[lxr-police]%s %s^7'):format(color, message))
end

-- Semantic version comparison: returns true if `latest` is newer than `current`
local function isOutdated(current, latest)
    local function parse(v)
        local a, b, c = v:match('(%d+)%.(%d+)%.(%d+)')
        return { tonumber(a) or 0, tonumber(b) or 0, tonumber(c) or 0 }
    end
    local c, l = parse(current), parse(latest)
    for i = 1, 3 do
        if l[i] > c[i] then return true
        elseif l[i] < c[i] then return false
        end
    end
    return false
end

local function CheckVersion()
    local currentVersion = GetResourceMetadata(resourceName, 'version')
    if not currentVersion or currentVersion == '' then
        printLog('error', 'Unable to read version from fxmanifest.lua — skipping version check.')
        return
    end

    PerformHttpRequest(GITHUB_VERSION_URL, function(statusCode, remoteRaw, _headers)
        if statusCode ~= 200 or not remoteRaw or remoteRaw == '' then
            printLog('warning', ('Version check failed (HTTP %s). Check your internet connection.'):format(statusCode))
            return
        end

        local remoteVersion = remoteRaw:gsub('%s+$', '') -- trim trailing whitespace / newlines

        if currentVersion == remoteVersion then
            printLog('success', ('Running latest version %s ✓'):format(currentVersion))
            return
        end

        if isOutdated(currentVersion, remoteVersion) then
            printLog('error', '════════════════════════════════════════════════════════')
            printLog('error', ('  UPDATE AVAILABLE!  Current: %s  →  Latest: %s'):format(currentVersion, remoteVersion))
            printLog('error', ('  Download: %s'):format(GITHUB_REPO_URL))
            printLog('error', '  🐺 wolves.land — iBoss21 / The Lux Empire')
            printLog('error', '════════════════════════════════════════════════════════')
        else
            printLog('warning', ('Dev build detected — local %s is ahead of remote %s.'):format(currentVersion, remoteVersion))
        end
    end, 'GET')
end

-- ═══════════════════════════════════════════════════════════════════════════════
-- Run on resource start
-- ═══════════════════════════════════════════════════════════════════════════════

CreateThread(function()
    Wait(2000) -- small delay so other resource messages don't swamp the output
    CheckVersion()
end)
