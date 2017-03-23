# encoding: utf-8

require 'telegram/bot'
require 'ghee'
require 'time'
require 'pp'

require_relative 'module'

TOKEN = "298625375:AAG51PT_LTCGbsZdiAqdFIJcPRbtPyNZ1xw"
gh = Ghee.basic_auth("???", "???")

$updatetime = Hash.new
$updatetime = Unicorn::get_time(gh)

Telegram::Bot::Client.run(TOKEN) do |bot|
    receive_thread = Thread.new do
        bot.listen do |message|
            begin
                case message.text
                when '/start'
                    Unicorn::store_chatid(message.chat.id)
                    bot.api.send_message(chat_id: message.chat.id, text: "Hello,welcome to use @ujnblogbot.")
                when '/stop'
                    # todo
                    bot.api.send_message(chat_id: message.chat.id, text: "See you next time.")
                end
            rescue
                next
            end
        end
    end

    send_thread = Thread.new do
        while true
            sleep 120
            begin
                str = Unicorn::check($updatetime, gh)
                if (str.size != 0)
                    Unicorn::user_list.each do |user|
                        bot.api.send_message(chat_id: user.to_i, text: "#{str}")
                    end
                    $updatetime = Unicorn::get_time(gh)
                end
            rescue
                next
            end
        end
    end

    begin
        receive_thread.join
    rescue
        retry
    end

    begin
        send_thread.join
    rescue
        retry
    end
end
