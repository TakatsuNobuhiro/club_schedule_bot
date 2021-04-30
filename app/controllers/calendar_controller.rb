require "google/apis/calendar_v3"
require "googleauth"
require "googleauth/stores/file_token_store"
require "date"
require "fileutils"
class CalendarController < ApplicationController

    def index 
    end 

    def callback
        #urlのcodeをsessionに格納
        session[:code] = params[:code]

        #念の為値をターミナルに吐き出す
        logger.debug(session[:code])
        calendar = Google::Apis::CalendarV3::CalendarService.new
        calendar.client_options.application_name = ENV["APPLICATION_NAME"]

        # カレンダーモデルからauthorizeを呼び出す
        club_calendar = Calendar.new 
        calendar.authorization = club_calendar.authorize
    
        redirect_to action: :index
    end


end