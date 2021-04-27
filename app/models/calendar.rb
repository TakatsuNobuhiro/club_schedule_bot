require "google/apis/calendar_v3"
require "googleauth"
require "googleauth/stores/file_token_store"
require "date"
require "fileutils"
class Calendar 
  OOB_URI = ENV["OOB_URI"].freeze
  APPLICATION_NAME = ENV["APPLICATION_NAME"].freeze
  
  # The file token.yaml stores the user's access and refresh tokens, and is
  # created automatically when the authorization flow completes for the first
  # time.
  TOKEN_PATH = "token.yaml".freeze
  SCOPE = Google::Apis::CalendarV3::AUTH_CALENDAR_READONLY
  
  ##
  # Ensure valid credentials, either by restoring from the saved credentials
  # files or intitiating an OAuth2 authorization. If authorization is required,
  # the user's default browser will be launched to approve the request.
  #
  # @return [Google::Auth::UserRefreshCredentials] OAuth2 credentials


  def authorize
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
  
      client_id = Google::Auth::ClientId.from_hash secret_hash
      
      token_store = Google::Auth::Stores::FileTokenStore.new file: TOKEN_PATH
      authorizer = Google::Auth::UserAuthorizer.new client_id, SCOPE, token_store
      


      user_id = ENV["MAIL"]
      
      credentials = authorizer.get_credentials user_id
      
      if credentials.nil?
          url = authorizer.get_authorization_url base_url: OOB_URI
          puts "Open the following URL in the browser and enter the " \
              "resulting code after authorization:\n" + url
          code = ENV["CODE"]
          
          credentials = authorizer.get_and_store_credentials_from_code(
          user_id: user_id, code: code, base_url: OOB_URI
          )
          
          
          
      end
      credentials
  end
  # Initialize the API
  def initialize
      @service = Google::Apis::CalendarV3::CalendarService.new
      @service.client_options.application_name = APPLICATION_NAME
      @service.authorization = authorize
  end

  def fetchEvents
      
      # Fetch the next 10 events for the user
      calendar_id = ENV["CALENDAR_ID"]
      binding.pry
      now = DateTime.now + 1
      response = @service.list_events(calendar_id,
                                  max_results:   5,
                                  single_events: true,
                                  order_by:      "startTime",
                                  time_min:      DateTime.new(now.year,now.month,now.day,0,0,0),
                                  time_max:      DateTime.now + 1 )

      puts "No upcoming events found" if response.items.empty?
      puts response.items.first
      # response.items.each do |event|
      #     start = event.start.date || event.start.date_time
      #     puts "- #{event.summary} (#{start})"
      # end
      
      
      start_time = response.items.first.start.date_time.strftime("%H:%M")
      end_time = response.items.first.end.date_time.strftime("%H:%M")
      location = response.items.first.location
      title = response.items.first.summary
      result = "明日は#{start_time}から#{end_time}まで#{location}で#{title}があります。"
      
      
      return result
  end
end