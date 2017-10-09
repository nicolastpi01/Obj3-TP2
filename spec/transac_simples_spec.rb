require 'rspec'

describe 'My behaviour' do

  before :each do
    @persona = Persona.new
    @persona.edad = 22

  end

  it 'should do something' do

    @persona.queCumpla(@persona)
    expect(@persona.edad).to eq 22
  end

end