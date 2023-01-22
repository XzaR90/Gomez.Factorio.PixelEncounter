local Logger = {}

function Logger.log_information(message)
    game.write_file("pe-log.txt", message .. '\n', true)
    print(message)
end

return Logger