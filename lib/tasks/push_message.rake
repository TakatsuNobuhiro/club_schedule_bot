namespace :push_message do
    desc "line ブロードキャスト機能で友達全員に明日の予定をプッシュする"
    task tomorrow_plans: :environment do 
        message = Message.new 
        message.broad_push
    end
end
