require 'constants'

class Space
  attr_reader :row, :col

  def initialize(r, c)
    @row = r
    @col = c
  end
end
