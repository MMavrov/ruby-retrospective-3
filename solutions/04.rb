module Asm

  def self.asm(&block)
  	instructions = Instructions.new
  	instructions.instance_eval &block
  	# p instructions.registers
    p instructions.operations_queue
  	p instructions.next_instruction
  end

  class ArithmeticInstructions
  	attr_reader :ax, :bx, :cx, :dx
  	attr_reader :registers, :operations_queue

  	def initialize
  	  @operations_queue = []
  	  @registers = {
  	  	ax: 	0,
  	  	bx: 	0,
  	  	cx: 	0,
  	  	dx: 	0,
  	  }
  	  @ax, @bx = :ax, :bx
  	  @cx, @dx = :cx, :dx
  	end

    def mov(register, value)
      if value.is_a? Fixnum
        @registers[register.to_sym] = value
      else
      	@registers[register.to_sym] = @registers[value.to_sym]
      end
      @operations_queue << ['mov', [register.to_sym, value]]
    end

    def inc(register, value)
      if value.is_a? Fixnum
        @registers[register.to_sym] += value
      else
      	@registers[register.to_sym] += @registers[value.to_sym]
      end
      @operations_queue << ['inc', [register.to_sym, value]]
    end

    def dec(register, value)
      if value.is_a? Fixnum
        @registers[register.to_sym] -= value
      else
      	@registers[register.to_sym] -= @registers[value.to_sym]
      end
      @operations_queue << ['dec', [register.to_sym, value]]
    end

    def cmp(register, value)
      if value.is_a? Fixnum
        @last_cmp_result = @registers[register.to_sym] <=> value
      else
      	@last_cmp_result = @registers[register.to_sym] <=> @registers[value.to_sym]
      end
      @operations_queue << ['cmp', [register.to_sym, value]]
    end
  end

  class Instructions < ArithmeticInstructions
    attr_reader :next_instruction

  	def initialize
  	  super()
  	end

    def label(value)
      @operations_queue << ['label', value]
    end

    def jmp(where)
      @operations_queue << ['jmp', where]
      if where.is_a? Fixnum
        @next_instruction = get_queue_index_if_number(where)
      else
        @next_instruction = get_queue_index_if_label(where)
      end
    end

    def get_queue_index_if_number(where)
      if where < @operations_queue.index { |operation, value| operation == 'label' }
        return where
      end
      @operations_queue.each_with_index do |operation, index|
        p where
        if where == 0
          return index + 1
        elsif operation[0] != 'label'
          where -= 1
        end
      end
    end

    def get_queue_index_if_label(where)
      @operations_queue.index { |operation, value| value == where } + 1
    end

    def method_missing(method_name)
      method_name
    end

  end
end


Asm.asm do
  mov bx, 40  #0
  mov ax, 20  #1
  label booty
  inc bx, ax  #2
  cmp ax, bx  #3
  label ass
  dec ax, 1   #4
  jmp 3
end