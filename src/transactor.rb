
class Transactor
  attr_accessor :hash, :persona

  def initialize(hash, p)
    @persona = p
    @hash = hash
  end

  def self.perform(p)
    p_instance_var = p.instance_variables
    hash = self.update_hash(p, p_instance_var)
    #self.update_methods(p, p_instance_var, hash)
    transactor_obj = self.new(hash, p)
    begin
      yield(p)
      #transactor_obj.redo()
      return transactor_obj

    rescue

      transactor_obj.undo()
      yield(p.class.new) # tira la excep con cualquier persona

    end
  end


  def self.update_hash(p, list)
    hash = Hash.new()
    list.each { |a| method_name = a[1..a.length-1]
      hash[a] = p.method(method_name).call
    }
      return hash
  end


  def undo()
    hash = self.hash
    hash.each do |key, value|
      persona.instance_variable_set(key, value)

    end
  end

  def redo()
    # Muy similar a undo

  end










  def self.update_methods(p, list, hash)
    p_instance_var = p.instance_variables
    i = 0
    num = p_instance_var.length
    while i < num do
      original = p_instance_var[i]
      nuevo = original[1..original.length - 1]
      p.define_singleton_method(nuevo) do |arg|
        super(arg)
      end
      i+=1
    end
  end

end