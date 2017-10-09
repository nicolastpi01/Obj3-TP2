require 'rspec'

describe 'My behaviour' do

  before :each do
    @persona = Persona.new
    @persona.edad = 20
    @persona.nombre = 'Raul'

  end

  it 'should do something' do

    @persona.queCumpla(@persona)
    expect(@persona.edad).to eq 21
  end

  it 'should do something FFFFFFF' do
    expect { @persona.queExploteAlCumplirAnios(@persona) }.to raise_error('Kabooom!')   ## la exception igual se propaga !
    expect(@persona.edad).to eq 20      # pero el pobre tipo volvió a tener 20
    expect(@persona.nombre).to eq 'Raul'
  end

end