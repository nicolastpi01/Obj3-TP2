
class Transactor
  attr_accessor :hash_antiguos, :persona, :hash_nuevos, :cambios

  def initialize(hash, p)
    @persona = p
    @hash_antiguos = hash
    @cambios = Array.new()
  end

  def self.perform(p)
    hash = self.update_hash(p)
    transactor_obj = self.new(hash, p)
    begin
      yield(p)
      nuevos = self.update_hash(p)
      transactor_obj.hash_nuevos = nuevos
      transactor_obj.changes()
      return transactor_obj

    rescue

      transactor_obj.undo()
      yield(p.class.new) # tira la excep con cualquier persona

    end
  end


  def self.update_hash(p)
    p_instance_var = p.instance_variables
    hash = Hash.new()
    p_instance_var.each { |a| method_name = a[1..a.length-1]
      hash[a] = p.method(method_name).call
    }
      return hash
  end


  def undo()
    self.state_update(self.hash_antiguos)
  end

  def redo()
    self.state_update(self.hash_nuevos)
  end

  def state_update(hash)
    hash.each do |key, value|
      self.persona.instance_variable_set(key, value)
    end
  end

  def changes()
    p_instance_var = self.persona.instance_variables
    p_instance_var.each { |a| if (self.hash_nuevos[a] != self.hash_antiguos[a] and self.cambios.length < 2)
                                if (self.hash_antiguos[a] == self.persona.instance_variable_get(a))
                                  self.cambios.push([self.persona.object_id, a, self.hash_nuevos[a], self.persona.instance_variable_get(a)])
                                else
                                  if (self.hash_nuevos[a] == self.persona.instance_variable_get(a) and self.cambios.length < 1)
                                    self.cambios.push([self.persona.object_id, a, self.hash_antiguos[a], self.persona.instance_variable_get(a)])
                                  end
                                end
                              end
    }
        return self.cambios
  end


end


