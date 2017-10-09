class Persona
  attr_accessor :nombre, :edad

  def initialize()
    @nombre = 'pedro'
    @edad = 0
  end

  def cumplirAnios
    self.edad = self.edad + 1 # noten que usamos el setter
  end

  def queCumpla(p)
    Transactor.perform(p) { |p|
      p.cumplirAnios()
    }
  end

  def queExploteAlCumplirAnios(p)
    Transactor.perform(p) { |p|
      p.cumplirAnios()
      raise 'Kabooom!'    ## forzamos a que explote luego de cumplir !
    }
  end

end
