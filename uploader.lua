local component = require("component")
local event = require("event")
local filesystem = require("filesystem")
local file = require("filesystem")
local io = require("io")

local m = component.modem

print("Type full path of file ex.: /home/file.txt, /mnt/123/file.lua")
local path = io.read("*l")
if path == "exit" then os.exit() end
print("Type site/ or file/ + full name od file ex.: site/website.mw, file/file.lua")
local name = io.read("*l")
if name == "exit" then os.exit() end
m.open(2)
os.execute("clear")
print("Waiting for respond from server")
m.broadcast(2, "req")
local _, _, from, port, _, message = event.pull("modem_message")
if message == "allow" then
print("Server responded")
local file
file = io.open(path, "r")
m.broadcast(2, name)
while true do
_, _, from, port, _, message = event.pull("modem_message")
if message == "end" then break end
if message == "fe" then print("MineWeb localisation already exists") os.sleep(3) os.exit() end
end
print("broadcasted file part 1")
m.broadcast(2, file:read(99999))
while true do
_, _, from, port, _, message = event.pull("modem_message")
if message == "end" then break end
end
print("Broadcasted file part 2")
m.close(2)
end