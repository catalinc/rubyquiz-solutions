#!/usr/bin/env ruby

class Array
  def choice
    return self[rand(self.size)]
  end
end

def load_families(filename)
  families = Hash.new { |h, k| h[k] = [] }
  File.open(filename) do |file|
    file.each_line do |line|
      next if line =~ /^\s*$/
      first_name, last_name, email = line.split
      families[last_name] << { :first=> first_name, :last => last_name, :email => email }
    end
  end
  families
end

def assign_santas(families)
  santas = []
  families.each_pair do |family_name, persons|
    persons.each do |person|
      # pick a random person from other families
      random_family = (families.keys - [family_name]).choice
      random_person = families[random_family].choice
      santas << [random_person, person]
    end
  end
  santas
end

def pp_person(h)
  "#{h[:last]}, #{h[:first]} #{h[:email]}"
end

if $0 == __FILE__
  if ARGV.size == 1
    santas = assign_santas(load_families(ARGV[0]))
    santas.each do |ary|
      puts "Santa for #{pp_person(ary[1])} is #{pp_person(ary[0])}"
    end
  else
    puts "usage: ./secret_santas.rb INPUT_FILE"
  end
end
