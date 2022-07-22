RSpec.describe OpenWeatherMap::City do
  it 'initializes values correctly' do
    var = described_class.new(id: 42, lat: 33, lon: 24, temp_k: 303.111, name: 'Zagreb')
    expect(var.id).to eq(42)
    expect(var.lat).to eq(33)
    expect(var.lon).to eq(24)
    expect(var.name).to eq('Zagreb')
  end

  it 'calculates temperature in celsius correctly' do
    var = described_class.new(id: 42, lat: 33, lon: 24, temp_k: 303.111, name: 'Zagreb')
    expect(var.temp).to eq(29.96)
  end

  it 'correctly compares objects when other has higher temperature' do
    # object has lower temp than other
    var1 = described_class.new(id: 42, lat: 33, lon: 24, temp_k: 300.111, name: 'Zagreb')
    var2 = described_class.new(id: 42, lat: 33, lon: 24, temp_k: 302.111, name: 'Zagreb')
    expect(var1 <=> var2).to eq(-1)
  end

  it 'correctly compares two cities with same temperature but different name' do
    var1 = described_class.new(id: 42, lat: 33, lon: 24, temp_k: 302.111, name: 'Berlin')
    var2 = described_class.new(id: 42, lat: 33, lon: 24, temp_k: 302.111, name: 'Zagreb')
    expect(var2 <=> var1).to eq(1)
  end

  it 'correctly compares two cities with same temperatures and names' do
    var1 = described_class.new(id: 40, lat: 33, lon: 24, temp_k: 302.111, name: 'Zagreb')
    var2 = described_class.new(id: 42, lat: 30, lon: 22, temp_k: 302.111, name: 'Zagreb')
    expect(var1 <=> var2).to eq(0)
  end

  it 'correctly compares two cities where other has higher temperature' do
    var1 = described_class.new(id: 42, lat: 33, lon: 24, temp_k: 300.111, name: 'Zagreb')
    var2 = described_class.new(id: 42, lat: 33, lon: 24, temp_k: 302.111, name: 'Zagreb')
    expect(var2 <=> var1).to eq(1)
  end

  it 'correctly compares cities wth same temperatures but others name comes first alphabetically' do
    var1 = described_class.new(id: 42, lat: 33, lon: 24, temp_k: 300.111, name: 'Berlin')
    var2 = described_class.new(id: 42, lat: 33, lon: 24, temp_k: 302.111, name: 'Zagreb')
    expect([var2, var1].sort).to eq([var1, var2])
  end

  it 'correctly parses hash given from site' do
    hash = { 'coord' =>
      { 'lat' => 145.77, 'lon' => -16.92 },
             'main' => { 'temp' => 300.15 }, 'id' => 1, 'name' => 'Zagreb' }
    var = described_class.parse(hash)
    expect(var.id).to eq(1)
    expect(var.lat).to eq(145.77)
    expect(var.lon).to eq(-16.92)
    expect(var.temp).to eq(27.0)
    expect(var.name).to eq('Zagreb')
  end
end
