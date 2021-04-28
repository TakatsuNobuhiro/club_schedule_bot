require "google/apis/calendar_v3"
require "googleauth"
require "googleauth/stores/file_token_store"
require "date"
require "fileutils"
class Calendar 
  
  
  
  # The file token.yaml stores the user's access and refresh tokens, and is
  # created automatically when the authorization flow completes for the first
  # time.
  
  
  
  ##
  # Ensure valid credentials, either by restoring from the saved credentials
  # files or intitiating an OAuth2 authorization. If authorization is required,
  # the user's default browser will be launched to approve the request.
  #
  # @return [Google::Auth::UserRefreshCredentials] OAuth2 credentials


  def authorize
    # 環境変数の定義
    uri = ENV["OOB_URI"].freeze
    user_id = ENV["MAIL"]

      secret_hash = {
        "web" => {
          "client_id"     => ENV["CLIENT_ID"],
          "project_id" => ENV["PROJECT_ID"],
          "auth_uri" => ENV["AUTH_URI"],
          "token_uri" => ENV["TOKEN_URI"],
          "auth_provider_x509_cert_url" => ENV["PROVIDER_URI"],
          "client_secret" => ENV["CLIENT_SECRET"],
          "redirect_uris" => [ENV["REDIRECT_URIS"]],
          "javascript_origins" => [ENV["JAVASCRIPT_ORIGINS"]]
        }
      }
      # herokuの環境的に環境変数から読み込んだほうが良い
      client_id = Google::Auth::ClientId.from_hash secret_hash   
      token_store = Google::Auth::Stores::FileTokenStore.new file: "token.yaml".freeze
      authorizer = Google::Auth::UserAuthorizer.new client_id, Google::Apis::CalendarV3::AUTH_CALENDAR_READONLY, token_store
      
      credentials = authorizer.get_credentials user_id
      
      if !credentials
          url = authorizer.get_authorization_url base_url: uri
          puts "Open the following URL in the browser and enter the " \
              "resulting code after authorization:\n" + url
          code = ENV["CODE"]
          
          credentials = authorizer.get_and_store_credentials_from_code(
          user_id: user_id, code: code, base_url: uri
          )
          
          
          
      end
      credentials
  end
  # Initialize the API
  def initialize
      @service = Google::Apis::CalendarV3::CalendarService.new
      @service.client_options.application_name = ENV["APPLICATION_NAME"].freeze
      @service.authorization = authorize
  end

  def fetch_events
      
      # Fetch the next 10 events for the user
      calendar_id = ENV["CALENDAR_ID"]
    
      now = DateTime.now + 1
      response = @service.list_events(calendar_id,
                                  max_results:   5,
                                  single_events: true,
                                  order_by:      "startTime",
                                  time_min:      DateTime.new(now.year,now.month,now.day,0,0,0),
                                  time_max:      DateTime.new(now.year,now.month,now.day,23,59,59) )

      
      if response.items.empty?
        result = '予定無し'
      else
        
        event =response.items.first
        start_time = event.start.date_time.in_time_zone('Tokyo').strftime("%H:%M")
        end_time = event.end.date_time.in_time_zone('Tokyo').strftime("%H:%M")
        location = event.location
        title = event.summary
        result = "明日は#{start_time}から#{end_time}まで#{location}で#{title}があります。\n欠席or遅刻者は背番号＋（スペース）遅刻or欠席+（スペース）理由の形式でご回答ください。\n(例)21番 欠席 授業があるため"

      end
      
      
      return result
  end
end