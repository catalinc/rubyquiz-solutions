class PriorityQueue
  def initialize
    @list = []
  end
  
  def add(priority, item)
    # Add @list.length so that sort is always using Fixnum comparisons,
    # which should be fast, rather than whatever is comparison on `item'
    @list << [priority, @list.length, item]
    @list.sort!
    self
  end

  def <<(pritem)
    add(*pritem)
  end
  def next
    @list.shift[2]
  end

  def empty?
    @list.empty?
  end
end

class Astar
  def do_solution(puzzle)
    @terrain = []
    puzzle.each { |rowstr|

      orig_puzzle += rowstr
      orig_puzzle += "\n"

      row = []
      rowstr.scan(/[.X@~*^]/) { |tile|
        case tile
        when /[.X@]/ row << 1
        when /[*]/ row << 2
        when /\^/ row << 3
        when /~/ row << nil
        end
      }

      # goal coord
      gind = rowstr.index('X')
      if gind
        @start = [@terrain.length, gind] # (row, col)
      end

      # start coord
      xind = rowstr.index('@')
      if xind
        @goal = [@terrain.length, xind]
      end

      @terrain << row
    }

    if do_find_path
      orig_puzzle_arr = orig_puzzle.split(/\n/)
      @path.each { |row,col| orig_puzzle_arr[row][col] = "#"}
      return orig_puzzle_arr.join("\n")
    else
      return nil
    end
  end

    # http://en.wikipedia.org/wiki/A-star_search_algorithm#Algorithm_description  
  def do_find_path
    closed = { } # already visited
    queue = PriorityQueue.new
    queue << [1, [@start,[],1]] # (f(spot) = cost_so_far(spot) + estimate(spot) -> A* -> f(x), (spot, path, cost)) 
    while !queue.empty?
      spot, path_so_far, cost_so_far = queue.next
      next if closed[spot] # to avoid already visited paths
      newpath = [path_so_far,spot]
      
      # goal reached?
      if spot == @goal
        @path = []
        newpath.flatten.each_slice(2) { |i,j| @path << [i,j] }
        return @path
      end
      
      closed[spot] = 1 # mark this tile as visited

      successors(spot).each {|newspot|
        next if closed[newspot]
        tcost = @terrain[newspot[0]][newspot[1]]
        newcost = cost_so_far + tcost # A* -> g(x)
        queue << [newcost + estimate(newspot), [newspot,newpath,newcost]]
      }

    end
    return nil
  end
  
  # A* -> h(x) 
  def estimate(spot)
    [(spot[0] - @goal[0]).abs, (spot[1] - @goal[1]).abs].max
  end

  def successors(spot)
    retval = []
    vertadds = [0,1]
    horizadds = [0,1]
    if (spot[0] > 0) then vertadds << -1; end
    if (spot[1] > 0) then horizadds << -1; end
    vertadds.each{|v| horizadds.each{|h|
        if (v != 0 or h != 0) then
          ns = [spot[0]+v,spot[1]+h]
          if (@terrain[ns[0]] and @terrain[ns[0]][ns[1]]) then
            retval << ns
          end
        end
      }}
    retval
  end

end

if __FILE__ == $0
  puts Astar.new.do_quiz_solution(ARGF)
end
