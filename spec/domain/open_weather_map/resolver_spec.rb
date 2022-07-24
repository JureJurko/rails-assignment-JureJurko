RSpec.describe OpenWeatherMap::Resolver do
  it 'returns id of existing city name' do
    expect(described_class.city_id('Taglag')).to eq(3245)
  end

  it 'returns nil when given wrong city name' do
    expect(described_class.city_id('abc')).to eq(nil)
  end
end
