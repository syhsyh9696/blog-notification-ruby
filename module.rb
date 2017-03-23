# encoding: utf-8

module Unicorn
    version = "1.3"

    def get_time(authentication)
        updatetime = Hash.new
        File.open("allblog.ini", "r") do |io|
            while line = io.gets
                line.chomp!
                updatetime[line] = Time.parse(pushed_at(line, authentication).to_s.gsub!(/T/, " ").gsub!(/Z/, ""))
            end
        end
        return updatetime
    end

    def pushed_at(user, authentication)
        return authentication.repos(user, "#{user}.github.io").to_h['pushed_at']
    end

    def check(updatetime, authentication)
        newupdatetime = Hash.new
        str = String.new

        newupdatetime = get_time(authentication)
        return str if(updatetime == newupdatetime)

        updatetime.each do |key, value|
            if newupdatetime[key] > value
                str << "#{key} update Blogs #{key}.github.io"
            end
        end

        return str if str.size != 0
    end

    def user_list
        user = Array.new
        File.open("chat_id.ini", "r") do |io|
            while line = io.gets
                line.chomp!
                user << line
            end
        end
        return user
    end

    def store_chatid(chat_id)
        chat_id = chat_id.to_s
        flagbit = true
        user_list.each do |user|
            next if user != chat_id
            flagbit = false if user == chat_id
        end

        if (flagbit)
            io_temp = File.open("chat_id.ini", "a")
            io_temp << chat_id << "\n"
            io_temp.close
        end
    end

    module_function :get_time
    module_function :pushed_at
    module_function :check
    module_function :user_list
    module_function :store_chatid
end
