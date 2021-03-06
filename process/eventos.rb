require 'google'
require 'open_movilforum'
require 'yahoo'

module Process
  class Eventos
      def self.run(user, msg)
        lat, long = Google::Geocoding.geocode(msg)
        finder = Yahoo::UpcomingFinder.new(lat, long, 10)
        locations = finder.get_locations
        
        map_url = Google::GMapsStatic.build_url(:markers => {:green => [lat, long], :characters => locations})
        msg_text= ""
        Google::GMapsStatic.each_with_character(locations) do |char, value|
          msg_text << "#{char.upcase}: #{value['name']}\n"
        end

        OpenMovilforum::MMS::Sender::Base.send(user, search, map_url, msg_text)
      end
      
      private :initialize
  end
end