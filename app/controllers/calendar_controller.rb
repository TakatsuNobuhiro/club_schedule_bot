require "google/apis/calendar_v3"
require "googleauth"
require "googleauth/stores/file_token_store"
require "date"
require "fileutils"
class CalendarController < ApplicationController
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

    def index 
    end 

    def callback
        #urlのcodeをsessionに格納

        session[:code] = params[:code]
        #念の為値をターミナルに吐き出す
        logger.debug(session[:code])
        calendar = Google::Apis::CalendarV3::CalendarService.new
        calendar.client_options.application_name = APPLICATION_NAME
        # カレンダーモデルからauthorizeを呼び出す
        club_calendar = Calendar.new
        
        calendar.authorization = club_calendar.authorize
    
        redirect_to action: :index
    end


end