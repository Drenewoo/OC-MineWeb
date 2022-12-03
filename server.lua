local event = require("event")
local component = require("component")
local file = require("filesystem")
local m = component.modem
local filesystem = require("filesystem")

m.open(1)
m.open(2)
while true do
print("waiting for request...")
local _, _, from, port, _, message = event.pull("modem_message")
while true do
if message == "req" then m.broadcast(port, "allow") break end
end
if port == 1 then
_, _, from, port, _, message = event.pull("modem_message")
print ("From " .. from .. " port " .. port .. " : " .. tostring(message))

local path = "/mnt/831/" .. message
local pathnum = "/mnt/831/" .. message .. ".num"
print(path)
if filesystem.exists(path) then if filesystem.exists(pathnum) then
local file = io.open("/mnt/831/" .. message .. ".num" , r)
file:seek("set", 0)
m.broadcast(port, file:read(1000))
print("broadcasted site size: ")
print(file:read(1000))
os.sleep(1)
file:close()
file = io.open("/mnt/831/" .. message,r)
file:seek("set", 0)
m.broadcast(port, file:read(99999))
print("Broadcasted site: ")
print(message)
os.sleep(2) 
else
print("file not found, skipping request..")
m.broadcast(port, "site not found, quitting client")
os.sleep(3)
end
else
print("file not found, skipping request..")
m.broadcast(port, "site not found, quitting client")
end
else
print("Recieving file")
local _, _, from, port, _, message = event.pull("modem_message")
local file
file = io.open("/mnt/831/" .. message .. ".num", "w")
file:write("1")
file:close()
if filesystem.exists("/mnt/831/" .. message) then m.broadcast(2, "fe")
else
file = io.open("/mnt/831/" .. message, "w")
m.broadcast(2, "end")
_, _, from, port, _, message = event.pull("modem_message")

file:write(message)
m.broadcast(2, "end")
print("File recieved and saved")
print("/mnt/831/" .. message)
file:close()
end
end
end