class Message 
    def organize_from_calendar
        club_calendar = Calendar.new
        response = club_calendar.fetch_events
        if response.items.empty?
            result = '予定無し'
        else
            event =response.items.first
            start_time = event.start.date_time.in_time_zone('Tokyo').strftime("%H:%M")
            end_time = event.end.date_time.in_time_zone('Tokyo').strftime("%H:%M")
            location = event.location
            title = event.summary
            #要件は満たせるけど可読性が微妙
            #locationがnilではない場合は○○での「で」を追加
            location += "で" if location
            result = "明日は#{start_time}から#{end_time}まで#{location}#{title}があります。\n欠席or遅刻者は背番号＋（スペース）遅刻or欠席+（スペース）理由の形式でご回答ください。\n(例)21番 欠席 授業があるため"
        end
    end

    def broad_push
        require 'net/http'
        require 'uri'
        require 'json' 

        token = ENV["LINE_CHANNEL_TOKEN"]
        # post先のurl
        uri = URI.parse('https://api.line.me/v2/bot/message/broadcast')
        http = Net::HTTP.new(uri.host,uri.port)
        http.use_ssl = true

        # Header
        headers = {
            'Authorization'=>"Bearer #{token}",
            'Content-Type' =>'application/json',
            'Accept'=>'application/json'
        }
        send_message = self.organize_from_calendar
        # Body
        params = {"messages" => [{"type" => "text", "text" => send_message}]}

        response = http.post(uri.path, params.to_json, headers)
    end
end