module OpenWeatherMap
  module Resolver
    def self.city_id(name)
      cities = File.read(File.expand_path('city_ids.json', __dir__))
      var = JSON.parse(cities).find { |c| c['name'] == name }
      var.nil? ? nil : var['id']
    end
  end
end
