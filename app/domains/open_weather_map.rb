module OpenWeatherMap
  APPID = Rails.application.credentials.open_weather_map_api_key
  def self.city(name)
    id = Resolver.city_id(name)
    return nil unless id

    rsp = HTTP.get("https://api.openweathermap.org/data/2.5/weather?id=#{id}&appid=#{APPID}")
    City.parse(rsp.parse)
  end

  def self.cities(names)
    ids = names.map { |name| Resolver.city_id(name) }.compact
    return nil if ids.blank?

    rsp = HTTP.get("https://api.openweathermap.org/data/2.5/group?id=#{ids.join(',')}&appid=#{APPID}")
    rsp.parse['list'].map { |hsh| City.parse(hsh) }
  end
end
