require 'trie'
require 'log4r'

NUMBER_ENCODING = {
  2 => ['A', 'B', 'C'],
  3 => ['D', 'E', 'F'],
  4 => ['G', 'H', 'I'],
  5 => ['J', 'K', 'L'],
  6 => ['M', 'N', 'O'],
  7 => ['P', 'Q', 'R', 'S'],
  8 => ['T', 'U', 'V'],
  9 => ['W', 'X', 'Y', 'Z']
}

include Log4r

LOG = Logger.new 'PhoneNumbers'
FORMATTER = PatternFormatter.new(:pattern => "[%l] %d: %m") 
LOG.outputters = StdoutOutputter.new('console', :formatter => FORMATTER)

class WordDictionary

  def initialize()
    @trie = Trie.new
  end

  def load_from_file(filename)
    File.open(filename) do |f|
      f.each do |line|
        @trie.insert(line.chomp.downcase, true)
      end
    end
    self
  end

  def is_word(word)
    not @trie.find(word.downcase).empty?
  end

end

def solve(dictionary_file, phone_number)
  solutions = []
  LOG.info "Loading word dictionary from #{File.expand_path(dictionary_file)}"
  dict   = WordDictionary.new.load_from_file(dictionary_file)
  LOG.info "Searching for words combinations"
  digits = phone_number.scan(/\d/).map { |digit| digit.to_i }
  2.upto(digits.size - 3) do |i|
    slice_start = digits[0..i]
    slice_end   = digits[(i+1)..-1]

    strings_start = make_strings(slice_start)
    strings_end   = make_strings(slice_end)

    for s0 in strings_start
      for s1 in strings_end
        if dict.is_word(s0) and dict.is_word(s1)
          solutions << [s0, s1]
        end
      end
    end
  end
  solutions
end

def make_strings(digits)  
  arr = []
  digits.each do |digit|
    arr << NUMBER_ENCODING[digit]
  end
  arr = arr.inject { |product, a| cross(product, a) }
  arr.map { |e| e.join }
end

def cross(first_ary, second_ary)
  result = []
  first_ary.each do |i|
    second_ary.each do |j|
      result << [i,j].flatten
    end
  end
  result
end

if $0 == __FILE__
  if ARGV.size != 2
    LOG.error "Usage: phone_number.rb DICTIONARY_FILE PHONE_NUMBER"
  else
    solutions = solve(ARGV[0], ARGV[1])
    if solutions.empty?
      LOG.info "No match found"
    else
      solutions.map { |sol| LOG.info "#{sol[0]}-#{sol[1]}"}
      LOG.info "#{solutions.size} solutions found"
    end
  end
end


