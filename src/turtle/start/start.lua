local skyrtle = require("libraries.skyrtle")
local sha = require("libraries.sha256")
local chacha = require("libraries.chacha20")

-- Right now the turtle should be bare, so the wired modem it finds should give it direct access to the network.
local modem = peripheral.find("modem",function(_,v)return(not v.isWireless())end)
-- Send ready ping, await setup
modem.open(2) -- Channel 2 is where data download is
local id = os.getComputerID()
modem.transmit(1,2,"FIRSTJOIN "..id) -- Channel 1 on wired network is for join/leave messages
-- FIRSTJOIN will be the turtle requesting the network encryption key, and letting Skynet know that a new turtle has arrived.

-- Receive and write the key to file
local _,msg
repeat
  _,_,_,_,msg = os.pullEvent("modem_message")
until msg.id == id

if msg.type == "UNAUTHORIZED" then
  error("TURTLE ALREADY IN NETWORK, UNAUTHORIZED TO JOIN AGAIN.")
end

local key = msg.key
local f = fs.open(".skynet/key","w")
f.write(key)
f.close()

