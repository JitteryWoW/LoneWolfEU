-- Function to handle Lua errors
local function MyLuaErrorHandler(msg)
    -- Check if the error message matches the one we want to handle
    if string.find(msg, "Unknown link type") then
        -- Display a recommendation message to the user
        print("Error: To click URLs, please install a chat addon such as Prat or WIM.")
        return true  -- Indicate that the error has been handled
    end

    -- If the error message doesn't match, return false to indicate it hasn't been handled
    return false
end

-- Register the error handler
seterrorhandler(MyLuaErrorHandler)
