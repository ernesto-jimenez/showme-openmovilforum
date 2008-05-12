require 'oos4ruby'
require 'google'
require 'open_movilforum'

module Process
  class Ocio
    def self.run(user, msg)
      search, place = msg.split(':')
      lat, long = Google::Geocoding.geocode(place)

      oos = Oos4ruby::Oos.new
      oos.auth_app('c56caa96b4a7da37b5683dca5c8b0983', '08b3c00ad800f510c74867e081b69a50')

      locations = oos.search(:lat => lat, :lon => long, :q => search, :radius => '1')
      locations = locations.collect do |place|
        {:lat => place.latitude, :long => place.longitude, :name => "#{place.name}. #{place.user_address}"}
      end
      
      map_url = Google::GMapsStatic.build_url(:markers => {:green => [lat, long], :characters => locations})
      msg_text= ""
      Google::GMapsStatic.each_with_character(locations) do |char, value|
        msg_text << "#{char.upcase}: #{value[:name]}\n"
      end

      if (user =~ /^\d+$/)
        OpenMovilforum::MMS::Sender::Movistar.send(user, search, map_url, msg_text)
      else
        OpenMovilforum::MMS::Sender::Gmail.send(user, search, map_url, msg_text)
      end
     
    end

    private :initialize
  end
end