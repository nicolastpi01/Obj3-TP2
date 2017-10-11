
class Transactor
  attr_accessor :hash_antiguos, :persona, :hash_nuevos

  def initialize(hash, p)
    @persona = p
    @hash_antiguos = hash
  end

  def self.perform(p)
    hash = self.update_hash(p)
    # self.update_methods(p, p_instance_var, hash)
    transactor_obj = self.new(hash, p)
    begin
      yield(p)
      nuevos = self.update_hash(p)
      transactor_obj.hash_nuevos = nuevos
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
    list = Array.new()
    p_instance_var.each { |a| if (self.hash_nuevos[a] != self.hash_antiguos[a])
                                if (self.hash_antiguos[a] == self.persona.instance_variable_get(a))
                                  list.push([self.persona.object_id, a, self.hash_nuevos[a], self.persona.instance_variable_get(a)])
                                else
                                  if (self.hash_nuevos[a] == self.persona.instance_variable_get(a))
                                    list.push([self.persona.object_id, a, self.hash_antiguos[a], self.persona.instance_variable_get(a)])
                                  end
                                end
                              end
    }
        return list

  end


  #def changes()
  #  puts "\nHistorial del objeto " + self.object_id.to_s
  #  puts self.hash_antiguos
  #  puts self.hash_nuevos
  #end










  #def self.update_methods(p, list, hash)
  #  p_instance_var = p.instance_variables
  #  i = 0
  #  num = p_instance_var.length
  #  while i < num do
  #    original = p_instance_var[i]
  #    nuevo = original[1..original.length - 1]
  #    p.define_singleton_method(nuevo) do |arg|
  #      super(arg)
  #    end
  #    i+=1
  #  end
  #end

end


