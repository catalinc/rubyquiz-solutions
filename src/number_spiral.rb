require 'rubygems'
require 'cooloptions'

class NumberSpiral

  def initialize(square_size)
    @square_size = square_size
  end
  
  def draw_square
    1.upto @square_size do |y|
      1.upto @square_size do |x|
        print "#{base(y,x)**2 + delta(y,x)}\t"
      end
      puts
    end
  end

  private


  def base(x,y)
    @square_size - 2*[[x,y].min, [@square_size-x,@square_size-y].min].min
  end

  def delta(x,y)
    d = [x,y].min
    d = @square_size - [x,y].max if x + y > @square_size 
    return -1 * (x + y - 2*d) if y > x 
    x + y - 2*d
  end

end


if $0 == __FILE__

  options = CoolOptions.parse!("[options] NumberSpiral") do |o|
    o.desc 'Number spiral square (see: http://www.rubyquiz.com/quiz109.html)'
    o.on "square SIZE", "Square size (min 1)", 8
  end

  NumberSpiral.new(options.square).draw_square
  
end
