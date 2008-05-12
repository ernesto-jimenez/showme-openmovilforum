require 'geonames/wiki_finder'
require 'google'
require 'open_movilforum'

module Process
  class Turismo
    def self.run(user, msg)
      lat, long = Google::Geocoding.geocode(msg)
      finder = GeoNames::WikiFinder.new(lat, long, 10)
      locations = finder.get_locations

      map_url = Google::GMapsStatic.build_url(:markers => {:green => [lat, long], :characters => locations})
      msg_text= ""
      Google::GMapsStatic.each_with_character(locations) do |char, value|
        msg_text << "#{char.upcase}: #{value['name']}\n"
      end

      if (user =~ /^\d+$/)Å
        OpenMovilforum::MMS::Sender::Movistar.send(user, search, map_url, msg_text)
      else
        OpenMovilforum::MMS::Sender::Gmail.send(user, search, map_url, msg_text)
      end    end

    private :initialize
  end
end