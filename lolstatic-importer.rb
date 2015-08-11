require 'httparty'
response = HTTParty.get("https://global.api.pvp.net/api/lol/static-data/euw/v1.2/champion?dataById=true&api_key=API API API API API KEY
")
#response["data"][champion_id]["name"]
response["data"].each{|hero| Hero.create(id:hero[0],name:hero[1]["name"]) }
