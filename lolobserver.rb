require 'httparty'
require 'json'

class LolObserver
 include HTTParty
 default_timeout(1) #timeout after 1 second

 attr_reader :api_key, :playerid, :domain
 attr_accessor :region
 def initialize(region,playerid,apikey)
   @region = region_server(region)
   @playerid = playerid
   @api_key = apikey
 end

 def region_server(region)
   case region
   when "euw"
     @domain = "https://euw.api.pvp.net"
     self.region = "EUW1"
   when "na"
     @domain = "https://na.api.pvp.net"
     self.region = "NA1"
   end
 end

 def handle_timeouts
   begin
     yield
   #Timeout::Error, is raised if a chunk of the response cannot be read within the read_timeout.
   #Timeout::Error, is raised if a connection cannot be created within the open_timeout.
   rescue Net::OpenTimeout, Net::ReadTimeout
     #todo
   end
 end

 def base_path
   "/observer-mode/rest/consumer/getSpectatorGameInfo"
 end

 def current_game_info
   handle_timeouts do
     url = "#{domain}/#{ base_path }/#{region}/#{playerid}?api_key=#{api_key}"
     response = HTTParty.get(url)
     case response.code
       when 200
        puts "All good!"
        JSON.parse(response.body)
       when 404..600
         puts "ERROR #{response.code}"
     end
   end
 end

 def current_hero_id
 	current_game_info["participants"].select{|k,v| k.has_value?(playerid) }[0]["championId"]
 end
end

 test = LolObserver.new("euw",50416878,"replace-by-api-key")