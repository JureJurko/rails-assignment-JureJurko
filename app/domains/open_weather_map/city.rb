module OpenWeatherMap
  class City
    def initialize(id:, lat:, lon:, temp_k:, name:)
      @id = id
      @lat = lat
      @lon = lon
      @temp_k = temp_k
      @name = name
    end

    attr_reader :id, :lat, :lon, :name

    def temp
      (@temp_k - 273.15).round(2)
    end

    def <=>(other)
      return temp <=> other.temp unless other.temp == temp

      name <=> other.name
    end

    def self.parse(hash)
      City.new(
        id: hash['id'],
        lat: hash['coord']['lat'],
        lon: hash['coord']['lon'],
        temp_k: hash['main']['temp'],
        name: hash['name']
      )
    end

    def nearby(count = 5)
      hash = HTTP.get("https://api.openweathermap.org/data/2.5/find?lat=#{@lat}&lon=#{@lon}&cnt=#{count}&appid=#{APPID}")
      hash['list'].map { |e| OpenWeatherMap::City.parse(e) }
    end

    def coldest_nearby(list)
      list.min
    end
  end
end
