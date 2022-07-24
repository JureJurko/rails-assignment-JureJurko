module OpenWeatherMap
  APPID = Rails.application.credentials.open_weather_map_api_key
  BASE_URL = 'https://api.openweathermap.org/data/2.5'
  def self.city(name)
    id = Resolver.city_id(name)
    return nil unless id

    rsp = HTTP.get("#{BASE_URL}/weather?id=#{id}&appid=#{APPID}")
    City.parse(rsp.parse)
  end

  def self.cities(names)
    ids = names.map { |name| Resolver.city_id(name) }.compact
    return nil if ids.blank?

    rsp = HTTP.get("#{BASE_URL}/group?id=#{ids.join(',')}&appid=#{APPID}")
    rsp.parse['list'].map { |hsh| City.parse(hsh) }
  end
end
