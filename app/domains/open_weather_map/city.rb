module OpenWeatherMap
  class City
    def initilaize(id:, lat:, lon:, temp_k:, name:)
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
      return other.temp <=> temp unless other.temp == temp

      other.name <=> name
    end

    def parse(hash)
      lat = hash['coord']['lat']
      lon = hash['coord']['lon']
      temp_k = hash['main']['temp']
      name = hash['name']
      id = hash['id']
      City.new(id: id, lat: lat, lon: lon, temp_k: temp_k, name: name)
    end

    def nearby(count = 5)
      hash = HTTP.get("https://api.openweathermap.org/data/2.5/find?lat=#{@lat}&lon=#{@lon}&cnt=#{count}&appid=#{APPID}")
      hash['list'].map { |e| parse(e) }
    end

    def coldest_nearby(list)
      list.min
    end
  end
end
