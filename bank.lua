function addMoney(account, amount, code)
  http.request("http://localhost/centraldator/add.php" .. "?account=" .. account .. "&amount=" .. amount .. "&code=" .. code)
  timeout = os.startTimer(10)
  event, url, message = os.pullEvent()
  if event == "timer" then
    term.write("No connection")
  elseif event == "http_success" then
    message = message.readAll()
    if message == "error" then
      term.scroll(1)
      term.setCursorPos(1, max_y)
      term.write("An error occured")
    elseif message == "pin" then
      term.scroll(1)
      term.setCursorPos(1, max_y)
      term.write("Wrong code")
    elseif message == "confirm" then
      term.scroll(1)
      term.setCursorPos(1, max_y)
      if amount > 0 then
        term.write("Money added.")
      else
        term.write("Money removed.")
      end
    else
      term.scroll(1)
      term.setCursorPos(1, max_y)
      term.write("HTTP Error")
    end
  elseif event == "http_failure" then
    term.scroll(1)
    term.setCursorPos(1, max_y)
    term.write("HTTP Error")
  else
    term.scroll(1)
    term.setCursorPos(1, max_y)
    term.write("An error occured")
  end
  term.scroll(2)
end

local commands = {"add", "remove", "transfer", "quit", "help"}

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
    timeout = os.startTimer(10)
    event = os.pullEvent()
    if event == "timer" then
      term.scroll(1)
      term.setCursorPos(1, max_y)
      term.write("No card inserted")
    else
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
    end
  elseif action == "2" then
    term.scroll(1)
    term.setCursorPos(1, max_y)
    term.write("Insert card")
    timeout = os.startTimer(10)
    event = os.pullEvent()
    if event == "timer" then
      term.scroll(1)
      term.setCursorPos(1, max_y)
      term.write("No card inserted")
    else
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
    end
  elseif action == "3" then
    transferMoney()
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