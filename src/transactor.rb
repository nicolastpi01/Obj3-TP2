class Transactor

  def self.perform(p)
    #clone = p.clone
    #p.nombre = 'Nicolas'
    begin
      yield(p)

    rescue

      #p = clone # clone es el problema, se esta modificando segun p
      p.edad = p.edad - 1
      yield(p.class.new)

    end

  end
end