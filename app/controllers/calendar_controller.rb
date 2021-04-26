require "google/apis/calendar_v3"
require "googleauth"
require "googleauth/stores/file_token_store"
require "date"
require "fileutils"
class CalendarController < ApplicationController
    OOB_URI = "https://d91221407360.ngrok.io/oauth2callback".freeze
    APPLICATION_NAME = "calendar".freeze
    CREDENTIALS_PATH = "client_secret.json".freeze
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

    def index 
    end 

    def authorize
        client_id = Google::Auth::ClientId.from_file CREDENTIALS_PATH
        
        token_store = Google::Auth::Stores::FileTokenStore.new file: TOKEN_PATH
        authorizer = Google::Auth::UserAuthorizer.new client_id, SCOPE, token_store
        
        user_id = "tokyotech2015@gmail.com"
        credentials = authorizer.get_credentials user_id
        
        if credentials.nil?
            url = authorizer.get_authorization_url base_url: OOB_URI
            puts "Open the following URL in the browser and enter the " \
                "resulting code after authorization:\n" + url
            code = '4/0AY0e-g5VeEb1ULGc976JkNilLM1f-AvWN4sJ5nHVzYbhe1Q30MvEI2fP02nPK9L6q05uqA'
            
            credentials = authorizer.get_and_store_credentials_from_code(
            user_id: user_id, code: code, base_url: OOB_URI
            )
            
            
            
        end
        credentials
    end
    def callback
        session[:code] = params[:code]
        logger.debug(session[:code])
        calendar = Google::Apis::CalendarV3::CalendarService.new
        calendar.client_options.application_name = APPLICATION_NAME
        
        calendar.authorization = authorize
        fetchEvents(calendar)
        redirect_to action: :index
    end
    # Initialize the API
    def initialize
        service = Google::Apis::CalendarV3::CalendarService.new
        service.client_options.application_name = APPLICATION_NAME
        service.authorization = authorize
    end
    
    def fetchEvents(service)
        # Fetch the next 10 events for the user
        calendar_id = "4relcv3achthpmqe5lb88944bs@group.calendar.google.com"
        response = service.list_events(calendar_id,
                                    max_results:   10,
                                    single_events: true,
                                    order_by:      "startTime",
                                    time_min:      DateTime.now.rfc3339)
        puts "Upcoming events:"
        puts "No upcoming events found" if response.items.empty?
        response.items.each do |event|
            start = event.start.date || event.start.date_time
            puts "- #{event.summary} (#{start})"
        end
    end
end