local serverURL = "" // Insert your server URL here
local commands = {"add", "remove", "transfer", "quit", "help"}
local help = {["add"] = "Add money to account", ["remove"] = "Remove money from account", ["transfer"] = "Transfer money between accounts", ["quit"] = "Quits the program", ["help"] = "Brings up this help"}

function helpMoney()
  for i = 1, #commands do
    term.scroll(1)
    term.setCursorPos(1, max_y)
    term.write(commands[i] .. " - " .. help[commands[i]])
  end
  term.scroll(2)
end

function readError(event, incomeMessage, rightMessage)
  if event == "timer" then
    term.write("No connection")
  elseif event == "http_success" then
    message = incomeMessage.readLine()
    if message == "error" then
      term.scroll(1)
      term.setCursorPos(1, max_y)
      term.write("An error occured")
      term.scroll(2)
    elseif message == "pin" then
      term.scroll(1)
      term.setCursorPos(1, max_y)
      term.write("Wrong code")
      term.scroll(2)
    elseif message == "confirm" then
      term.scroll(1)
      term.setCursorPos(1, max_y)
      term.write(rightMessage)
      term.scroll(2)
    else
      term.scroll(1)
      term.setCursorPos(1, max_y)
      term.write("HTTP Error")
    end
  elseif event == "http_failure" then
    term.scroll(1)
    term.setCursorPos(1, max_y)
    term.write("HTTP Error")
    term.scroll(2)
  else
    term.scroll(1)
    term.setCursorPos(1, max_y)
    term.write("An error occured")
    term.scroll(2)
  end
end

function addMoney(account, amount, code)
  http.request(serverURL .. "/add.php" .. "?account=" .. account .. "&amount=" .. amount .. "&code=" .. code)
  timeout = os.startTimer(10)
  event, url, message = os.pullEvent()
  if amount >= 0 then
    readError(event, message, "Money added.")
  else
    readError(event, message, "Money removed.")
  end
end
function transferMoney(account1, account2, amount, pin)
  http.request(serverURL .. "/transfer.php" .. "?account1=" .. account1 .. "&account2=" .. account2 .. "&amount=" .. amount .. "&pin=" .. pin)
  timeout = os.startTimer(10)
  event, url, message = os.pullEvent()
  readError(event, message, "Money transferred.")
end

max_x, max_y = term.getSize()

function spaces(amount)
  for i = 1, amount do
    term.write(" ")
  end
end

function commandList()
  local notFitting = 0
  term.setCursorPos(1, max_y - (math.ceil(#commands / 3) + 1))
  print("*** Commands ***")
  notFitting = #commands % 3
  for i = 1, math.floor(#commands / 3) do
    for x = 1, 3 do
      if notFitting > 1 then
        term.setCursorPos(3 + 13 * (x - 1), max_y - (i + 1))
      else
        term.setCursorPos(3 + 13 * (x - 1), max_y - i)
      end
      term.write(x * i .. ": " .. commands[x * i])
    end
  end
  for i = 1, notFitting do
    term.setCursorPos(3 + 13 * (i - 1), max_y - 1)
    term.write(tostring((#commands - notFitting) + i) .. ": " .. commands[(#commands - notFitting) + i])
  end
  term.setCursorPos(1, max_y)
  term.write("What now> ")
  return io.read()
end

term.setBackgroundColor(colors.black)
term.setTextColor(colors.white)
term.clear()

while true do
  action = commandList()
  if action == "1" then
    term.scroll(1)
    term.setCursorPos(1, max_y)
    term.write("Insert card")
    term.scroll(1)
    term.setCursorPos(1, max_y)
    term.write("Press any key to exit")
    timeout = os.startTimer(10)
    event = os.pullEvent()
    if event == "timer" then
      term.scroll(1)
      term.setCursorPos(1, max_y)
      term.write("No card inserted")
    elseif event == "disk" then
      if not fs.exists("disk/card") then
        term.scroll(1)
        term.setCursorPos(1, max_y)
        term.write("Expired card")
      else
        file = fs.open("disk/card", "r")
        local account = file.readLine()
        file.close()  
        term.scroll(1)
        term.setCursorPos(1, max_y)
        term.write("Bank code: ")
        code = read("*")
        term.scroll(1)
        term.setCursorPos(1, max_y)
        term.write("Amount: $")
        local amount = io.read()
        addMoney(account, amount, code)
      end
    else
      term.scroll(1)
      term.setCursorPos(1, max_y)
      term.write("Cancelled")
      term.scroll(2)
    end
  elseif action == "2" then
    term.scroll(1)
    term.setCursorPos(1, max_y)
    term.write("Insert card")
    term.scroll(1)
    term.setCursorPos(1, max_y)
    term.write("Press any key to exit")
    event = os.pullEvent()
    if event == "disk" then
      if not fs.exists("disk/card") then
        term.scroll(1)
        term.setCursorPos(1, max_y)
        term.write("Expired card")
      else
        file = fs.open("disk/card", "r")
        local account = file.readLine()
        file.close()  
        term.scroll(1)
        term.setCursorPos(1, max_y)
        term.write("Bank code: ")
        code = read("*")
        term.scroll(1)
        term.setCursorPos(1, max_y)
        term.write("Amount: $")
        local amount = io.read()
        addMoney(account, -(amount), code)
      end
    else
      term.scroll(1)
      term.setCursorPos(1, max_y)
      term.write("Cancelled.")
      term.scroll(2)
    end
  elseif action == "3" then
    term.scroll(1)
    term.setCursorPos(1, max_y)
    term.write("Insert card 1")
    term.scroll(1)
    term.setCursorPos(1, max_y)
    term.write("Press any key to exit")
    event = os.pullEvent()
    if event == "disk" then
      if not fs.exists("disk/card") then
        term.scroll(1)
        term.setCursorPos(1, max_y)
        term.write("Expired card")
      else
        file = fs.open("disk/card", "r")
        account1 = file.readLine()
        file.close()
        file = fs.open("disk/pin", "r")
        pin = file.readLine()
        file.close()
        term.scroll(1)
        term.setCursorPos(1, max_y)
        term.write("Insert card 2")
        event = os.pullEvent("disk")
        if not fs.exists("disk/card") then
          term.scroll(1)
          term.setCursorPos(1, max_y)
          term.write("Expired card")
        else
          file = fs.open("disk/card", "r")
          account2 = file.readLine()
          file.close()
          term.scroll(1)
          term.setCursorPos(1, max_y)
          term.write("Amount: $")
          amount = io.read()
          transferMoney(account1, account2, amount, pin)
        end
      end
    else
      term.scroll(1)
      term.setCursorPos(1, max_y)
      term.write("Cancelled.")
      term.scroll(2)
    end
  elseif action == "4" then
    term.setBackgroundColor(colors.black)
    term.setTextColor(colors.white)
    term.clear()
    term.setCursorPos(1, 1)
    return
  elseif action == "5" then
    helpMoney()
  end
  term.scroll(3)
end