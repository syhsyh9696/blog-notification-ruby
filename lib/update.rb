# encoding:utf-8

class Updatetime
    def initialize(username, userpassword)
        @gh = Ghee.basic_auth(username, userpassword)
        @updatetime = Unicorn::get_time(@gh)
    end

    def check
        newupdatetime, str = Hash.new, String.new

        newupdatetime = Unicorn::get_time(@gh)
        return str if newupdatetime == @updatetime

        @updatetime.each do |key, value|
            str << "#{key} update Blogs at #{key}.github.io" if newupdatetime[key] > value
        end

        @updatetime = newupdatetime
        return str if str.size != 0
    end
end
