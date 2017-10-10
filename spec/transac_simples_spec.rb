require 'rspec'

describe 'My behaviour' do

  before :each do
    @persona = Persona.new
    @persona.edad = 20

  end

  it 'should do something' do

    @persona.queCumpla(@persona)
    expect(@persona.edad).to eq 21
    #print(transaccion.hash)
  end

  it 'should do something FFFFFFF' do
    expect { @persona.queExploteAlCumplirAnios(@persona) }.to raise_error('Kabooom!')  ## la exception igual se propaga!
    expect(@persona.edad).to eq 20   # pero el pobre tipo volvió a tener 20
  end

  it 'should do something GGGGGGGGG' do
    transaccion = @persona.queCumpla(@persona)
    expect(@persona.edad).to eq 21
    transaccion.undo() # vuelve al estado anterior
    expect(@persona.edad).to eq 20
  end

  it 'should do something HHHHHHHHH' do
    transaccion = @persona.queCumpla(@persona)
    expect(@persona.edad).to eq 21
    transaccion.undo() # vuelve al estado anterior
    expect(@persona.edad).to eq 20
    transaccion.redo()
    expect(@persona.edad).to eq 21     # la re-hizo
  end

end