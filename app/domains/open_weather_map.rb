module OpenWeatherMap
  APPID = Rails.application.credentials.open_weather_map_api_key
  def self.city(name)
    id = Resolver.city_id(name)
    hash = HTTP.get("https://api.openweathermap.org/data/2.5/weather?id=#{id}&appid=#{APPID}")
    City.parse(hash)
  end

  def self.cities(names)
    ids = names.map { |name| Resolver.city_id(name) }
    hash = HTTP.get("https://api.openweathermap.org/data/2.5/group?id=#{ids.join(',')}&appid=#{APPID}")
    hash['list'].map { |hsh| City.parse(hsh) }
  end
end
