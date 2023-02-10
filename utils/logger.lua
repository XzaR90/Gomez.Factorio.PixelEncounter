local Logger = {}

function Logger.log_information(message)
    local timestamp = ("%02d: "):format(game.tick / 60)
    message = timestamp .. message;
    game.write_file("pe-log.txt", message .. '\n', true)
    log(message)
    print(message)
end

return Logger