#!/usr/bin/env ruby

require 'pp'

class Term
  OP = [:+, :-, :/, :*]

  def initialize(op, left=nil, right=nil)
    @op = op
    @left = left
    @right = right
  end

  def value
    @left.send(@op, @right)
  end

  def to_s
    "#{@left} #{@op.to_s} #{@right}"
  end
end

def combinations(a)
  combs = []
  a.each_with_index do |el1, index1|
    a.each_with_index do |el2, index2|
      if index1 != index2
        combs << [el1, el2]
      end
    end
  end
  combs
end

def term_combinations(a)
  term_combs = []
  combs = combinations(a)
  combs.each do |arr|
    Term::OP.each do |op|
      term = Term.new(op, arr[0], arr[1])
      value = term.value
      if value > 0.0 and (value - value.to_i).zero?
        term_combs << term
      end
    end
  end
  term_combs
end

def solve(target, source)
  sol = []
  best_value = 0
  sorted_term_combs = term_combinations(source).sort_by { |term| term.value }
  sorted_term_combs.reverse.each do |term|
    if best_value + term.value <= target
      best_value += term.value
      sol << term
      break if best_value == target
    end
  end
  [best_value, sol]
end

def print_solution(best_value, sol)
  puts "Value: #{best_value} with expression: "
  puts (sol.map { |term| "(#{term})"}).join(" + ")
end

if $0 == __FILE__
  if ARGV.length < 2
    puts "usage: ./countdown.rb TARGET SOURCE_NUMBERS"
  else
    target = ARGV.shift.to_f
    source = ARGV.map { |el| el.to_f }
    print_solution(*solve(target, source))
  end
end


