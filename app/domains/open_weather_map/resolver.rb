module OpenWeatherMap
  module Resolver
    def self.city_id(name)
      var = OpenWeatherMap::Resolver.cities.find { |c| c['name'] == name }
      var.nil? ? nil : var['id']
    end

    def self.cities
      @cities ||= JSON.parse(File.read(File.expand_path('city_ids.json', __dir__)))
    end
  end
end
