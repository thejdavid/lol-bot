require 'httparty'
require 'json'

class LolSummoner
 include HTTParty
 default_timeout(1) #timeout after 1 second

 attr_reader :api_key, :playername, :domain
 attr_accessor :region
 def initialize(region,playername,apikey)
   @region = region_server(region)
   @playername = name_with_space(playername)
   @api_key = apikey
 end

 def name_with_space(name)
   name.gsub(" ", "%20")
 end
 def name_without_space(name)
   name.gsub("%20","")
 end

 def region_server(region)
   case region
   when "euw"
     @domain = "https://euw.api.pvp.net/api/lol/euw"
   when "na"
     @domain = "https://na.api.pvp.net/api/lol/na"
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
   "v1.4/summoner/by-name"
 end

 def summoner_id
   handle_timeouts do
     url = "#{domain}/#{ base_path }/#{playername}?api_key=#{api_key}"
     response = HTTParty.get(url)
     case response.code
       when 200
        puts "All good!"
        reponse = JSON.parse(response.body)
        response[name_without_space(playername).downcase]["id"]
       when 404..600
         puts "ERROR #{response.code}"
     end
   end
 end
end

test = LolSummoner.new("euw","gnik aivinA","8c1b3183-da08-4dfc-aaa3-7171bb1af336")
puts test.summoner_id