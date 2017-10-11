require 'rspec'

describe 'Verifico el comportamiento de las transacciones simples, rollback automatico & manual' do

  before :each do
    @persona = Persona.new
    @persona.edad = 20

  end

  it 'Verificamos el comportamiendo de una transaccion simple, deberia cambiar el estado del objeto persona, su edad' do

    @persona.queCumpla(@persona)
    expect(@persona.edad).to eq 21
    #print(transaccion.hash)
  end

  it 'Verificamos el rollback automatico, no deberia modificarse la edad porque hubo una excepción en el prog' do
    expect { @persona.queExploteAlCumplirAnios(@persona) }.to raise_error('Kabooom!')  ## la exception igual se propaga!
    expect(@persona.edad).to eq 20   # pero el pobre tipo volvió a tener 20
  end

  it 'Verificamos el rollback manual, debe ser capaz de volver a un estado anterior luego de una transacción exitosa' do
    transaccion = @persona.queCumpla(@persona)
    expect(@persona.edad).to eq 21
    transaccion.undo() # vuelve al estado anterior
    expect(@persona.edad).to eq 20
  end

  # realizar mas test de esta función
  it 'Verificamos el redo(), en cualquier momento queremos volver un estado "adelante" luego de una transacción exitosa' do
    transaccion = @persona.queCumpla(@persona)
    expect(@persona.edad).to eq 21
    transaccion.undo() # vuelve al estado anterior
    expect(@persona.edad).to eq 20
    transaccion.redo()
    expect(@persona.edad).to eq 21     # la re-hizo
  end

  # seguir testeando esto, hay casos que la lista es incorrecta, casos undo(), undo(), y hay estados repetidos
  it 'Verificamos el changes(), debe mostrar todos los cambios realizados durante la transacción' do
    transaccion = @persona.queCumpla(@persona)
    cambios = transaccion.changes()
    expect(cambios).to eq [[@persona.object_id, :@edad, 20, 21]]
    transaccion.undo()
    cambios = transaccion.changes()
    expect(cambios).to eq [[@persona.object_id, :@edad, 21, 20]]
    transaccion.redo()
    cambios = transaccion.changes()
    expect(cambios).to eq [[@persona.object_id, :@edad, 20, 21]]
    print(cambios)
  end

end