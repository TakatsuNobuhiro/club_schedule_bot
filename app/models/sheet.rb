class Sheet 
    def initialize
        @service = Google::Apis::SheetsV4::SheetsService.new
        @service.client_options.application_name = ENV["APPLICATION_NAME"]
        calendar = Calendar.new
        @service.authorization = calendar.authorize
    end

    def fetch_cell
        spreadsheet_id = ENV["SPREADSHEET_ID"]
        range = "B"
        response = @service.get_spreadsheet_values spreadsheet_id, range
        puts "No data found." if response.values.empty?
        response.values.each do |row|
            # Print columns A and E, which correspond to indices 0 and 4.
            puts "#{row[0]}, #{row[4]}"
        end
    end
end
