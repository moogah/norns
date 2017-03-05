--[[
   helpers.lua
   utilities and helper functions
--]]

-- define a function with arbitrary name and parameter list
-- target: any valid lvalue expression to hold the function
-- args: table of strings
-- body: function body
function defineFunction(target, args, body)
   local str = target .. " = function ( "
   for k,v in pairs(args) do
	  str = str .. v .. ","
   end
   str = string.sub(str, 0, -2) -- strip trailing ','
   str = str .. " ) \n " .. body .. " \n end "
   local func = assert(loadstring(str))
   func()
end


-- given an engine command string and format string,
-- define a function in the engine command table
function defineEngineCommand(idx, name, fmt)
   local args = {};
--   local target = "engine." .. string.gsub(name, '/', '_')
   local target = "engine." .. name
   local body = 'send_command(' .. idx .. ','
   for i=1,#fmt do
	  args[i] = "arg"..i
	  body = body .. args[i] .. ','
   end
   body = string.sub(body, 0, -2) -- bodyip trailing ','
   body = body .. ' )'

   defineFunction(target, args, body)
end

-- add engine commands. this is our default handler for command reports
function addEngineCommands(commands, count)
   engine = {} -- clear existing commands
   engine.commands = commands
   for i=1,count do
	  print(i .. ": " .. commands[i][1] .. " (" .. commands[i][2] .. ")")
	  defineEngineCommand(i, commands[i][1], commands[i][2])
   end
end
