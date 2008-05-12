require 'net/http'
require 'xmlsimple'

module Yahoo
  
  # a finder of upcoming events in a location
  class UpcomingFinder
    
    # constructor
    def initialize(lat, long, rad)
      @lat = lat
      @long = long
      @radius = rad
    end
    
    # get the list of events/locations nearby
    def get_locations
      data = parse_url
      locations = Array.new
      
      data["event"].each do |item|
        location = Hash.new
        location["name"] = "#{item['name']}: #{item['start_date']} (#{item['start_time']}) - #{item['end_date']} (#{item['end_time']})"
        location["lat"] = item["latitude"]
        location["long"] = item["longitude"]
        
        locations.push(location)
      end
      
      return locations
    end
    
    private
    
    # build a Yahoo!Upcoming url
    def build_url
      url = "http://upcoming.yahooapis.com/services/rest/?"
      url += "api_key=1c6636bdf7"
      url += "&method=event.search"
      url += "&location=#{@lat},#{@long}"
      url += "&radius=#{@radius/1.609}" # distance in miles, not km!
      url += "&sort=start-date-asc"
            
      return url
    end
    
    # download and parse the XML file in the URL
    def parse_url
      url = URI.encode(build_url)
      
      begin
        xml_data = Net::HTTP.get_response(URI.parse(url)).body
      rescue
        raise "Couldn't connect to upcoming.yahooapis.com"
      end
      
      data = XmlSimple.xml_in(xml_data)
      
      return data
    end
    
  end
end