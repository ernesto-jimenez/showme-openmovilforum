require 'net/http'
require 'json'

module GeoNames
  # a finder of places nearby in Wikipedia
  class WikiFinder
    def initialize(lat, long, rad)
      @lat = lat
      @long = long
      @radius = rad
    end
    
    # get the list of locations nearby
    def get_locations
      data = parse_url["geonames"]
      locations = Array.new
      
      data.each do |loc|
        location = Hash.new
        location["name"] = loc["title"]
        location["lat"] = loc["lat"]
        location["long"] = loc["lng"]
        
        locations.push(location)
      end
        
      return locations
    end
    
    private
    
    # build a GeoNames' URL
    def build_url
      url = "http://ws.geonames.org/findNearbyWikipediaJSON?"
      url += "lat=#{@lat}"
      url += "&lng=#{@long}"
      url += "&radius=#{@radius}"
      url += "&lang=en"
      return url
    end
    
    # download and parse the JSON file in the URL
    def parse_url
      url = build_url
      resp = Net::HTTP.get_response(URI.parse(url))
      data = resp.body

      # convert downloaded data to a ruby structure
      result = JSON.parse(data)
      
      # if the hash has 'Error' as a key, we raise an error
      if result.has_key? 'Error'
         raise "web service error"
      end
      
      return result
    end
  end
  
end

# finder = GeoNames::WikiFinder.new(38.345278, -0.483056, 10)