-- Sets project path to default lua path
-- Required for libs
package.path = ";.\\?.lua;C:\\Program Files (x86)\\Lua\\5.1\\lua\\?.lua;C:\\Program Files (x86)\\Lua\\5.1\\lua\\?\\init.lua;C:\\Program Files (x86)\\Lua\\5.1\\?.lua;C:\\Program Files (x86)\\Lua\\5.1\\?\\init.lua;C:\\Program Files (x86)\\Lua\\5.1\\lua\\?.luac"

local socket = require("socket");
local http = require("socket.http");

-- Memory offset for start of party pokemon nickname
local nicknameOffset = 8;

-- Length of the nickname (bytes)
local nicknameLength = 10;

-- Memory register addresses for party pokemon
local party1 = 0x02024284;
local party2 = 0x020242E8;
local party3 = 0x0202434C;
local party4 = 0x020243B0;
local party5 = 0x02024414;
local party6 = 0x02024478;

-- Sets specified party pokemon's nickname
function setPokemonName(register, name)
  -- Signed byte for start of capital alphabet
  local alphaStart = -70;

  -- Uppercase alphabet for letter offset
  local alpha = " ABCDEFGHIJKLMNOPQRSTUVWXYZ";

  name = string.upper(name);

  vba.print("setting name: " .. name);

  -- temporary address of current party pokemon's current nickname letter
  local addr = register + nicknameOffset;

  -- check if name is withing 10 bytes
  if string.len(name) <= nicknameLength then

    -- For each letter in the nickname (including empty chars)
    for i = 1, 10, 1 do
      -- Gets the current letter of the nickname
      local letter = string.sub(name, i, i);

      -- Gets byte offset of current letter
      local index = string.find(alpha, letter);

      -- If space or unrecognized char
      if index == 1 then
        -- Writes space to character memory address
        memory.writebyte(addr, alphaStart - 27);
      else
        -- Writes capital letter to character memory address
        memory.writebyte(addr, alphaStart + index - 1);
      end

      -- Inc temp address for next character
      addr = addr + 1;
    end
  end
end

-- just go
while true do
  -- get request from twitch server
  -- TODO change address when hosted on heroku
  local body, code, headers, status = http.request("http://localhost:3000");

  -- Sets party pokemon name to http response body
  setPokemonName(party2, body);

  gui.transparency(1);
  gui.text(5, 5, body, "black", "white")
  vba.frameadvance();
end
