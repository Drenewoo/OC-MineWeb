local component = require("component")
local event = require("event")
local filesystem = require("filesystem")
local file = require("filesystem")
local io = require("io")
local gpu = component.gpu
local m = component.modem
local w,h = gpu.getResolution()

gpu.setForeground(0xFFFFFF)
gpu.setBackground(0x0000FF)
gpu.fill(1,1,w,h," ")
while true do
print("MINEWEB BROWSER CLIENT v1.0")
print("----------------------------")
print("Type help to get help | Type dl to access download utility | Type minesite link to go to that minesite | Or type exit")
print("|")
print("V")
local s = tostring(io.read("*l"))
s = string.lower(s)
if s == "exit" then gpu.setForeground(0xFFFFFF) gpu.setBackground(0x000000) gpu.fill(1,1,w,h, " ") os.exit() end
if s == "help" then print("w/s - up/down; exit - exit;") break  end
if s == "dl" then
gpu.setBackground(0xFF0000)
gpu.setForeground(0x000000)
gpu.fill(1,1,w,h," ")
print("Write file name ex.: file.txt")
s = tostring(io.read("*l"))
print("Connecting to server.." )
print("Sending download request..")
m.open(1)
while true do
print("Waiting for respond")
m.broadcast(1,"req")
local _, _, from, port, _, message = event.pull("modem_message")
if message == "allow" then break end
end

m.broadcast(1, "file/" .. s)
print("Request sent!")
print("Downloading file to /home/")
local _, _, from, port, _, message = event.pull("modem_message")
print("File downloaded! Decompressing...")
_, _, from, port, _, message = event.pull("modem_message")

local file
file = io.open("/home/" .. s,"w")
file:seek("set",0)
file:write(message)
print(" ")
print("Complete! File is in /home/ directory")
print("Press enter to exit program")
m.close(1)
io.read("*l")
gpu.setBackground(0x000000)
gpu.setForeground(0xFFFFFF)
gpu.fill(1,1,w,h," ")
os.sleep(2)
os.exit()
end
os.execute("clear")
gpu.setBackground(0x00FF00)
gpu.fill(1,1,w,h," ")
print("Connecting to minesite: " .. string.upper(s))
print("Sending request...")
m.open(1)
while true do
print("waiting for respond...")
os.sleep(1)
m.broadcast(1, "req")
local _, _, from, port, _, message = event.pull("modem_message")
if message == "allow" then break end 
end
m.broadcast(1,"site/" .. s)
print("Request sent!")
print("Downloading minesite...")
local _, _, from, port, _, message = event.pull("modem_message")
local ml = message
print("Minesite part 1 downloaded!")
if message == "site not found, quitting client" then os.sleep(3) os.exit()
end
_, _, from, port, _, message = event.pull("modem_message")
if message == "site not found, quitting client" then os.sleep(3) os.exit()
end
print("Minesite part 2 downloaded!")
print("Decompressing and linking minesite...")
m.close(1)
os.sleep(2)
print("Press enter to continue...")
io.read("*l")
gpu.setForeground(0xFFFFFF)
gpu.setBackground(0x000000)
gpu.fill(1,1,w,h," ")
local file
file = io.open("/tmp/site.txt", "w")
file:seek("set",0)
file:write(message)
file:close()
file = io.open("/tmp/site.txt", "r")
file:seek("set",0)
local p = 10
os.execute("clear")
local count = 1
for line in file:lines() do
  if count <= p then print(line) end
count = count + 1
end
file:close()
while true do
local w = io.read("*l")
if w == "exit" then
file:close()
filesystem.remove("/tmp/site.txt")
os.execute("clear")
os.exit()
end
if w == "q" then p = 10 os.execute("clear") end
if w == "w" then 
p = p - 3
os.execute("clear")
file = io.open("/tmp/site.txt", r)
file:seek("set")
local count = 1
for line in file:lines() do
  if count < p then print(line) end
count = count + 1
end
file:close()
end
if w == "s" then 
p = p + 3
os.execute("clear")
file = io.open("/tmp/site.txt", r)
file:seek("set")
local count = 1
for line in file:lines() do
  if count < p then print(line) end
count = count + 1
end
file:close()
end
end
end