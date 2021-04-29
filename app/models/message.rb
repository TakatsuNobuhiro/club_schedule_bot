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
end