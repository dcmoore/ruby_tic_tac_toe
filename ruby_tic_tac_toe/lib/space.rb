require 'constants'

class Space
  attr_reader :row, :col
  attr_accessor :val

  def initialize(*args)
    args = validate_args(args)
    case args.size
    when 2
      init_default_val(*args)
    when 3
      init_set_val(*args)
    else
      return "Error"
    end
  end


  def init_default_val(*args)
    @row = args[0]
    @col = args[1]
    @val = 0
  end


  def init_set_val(*args)
    @row = args[0]
    @col = args[1]
    @val = args[2]
  end


  def validate_args(args)
    #TODO

    return args
  end
end
