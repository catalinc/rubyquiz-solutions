require 'rubygems'

module TextTwist

  class WordBlender

    def initialize(word_lenght=5, words_file="words.lst")
      @word_lenght = word_lenght
      @allowed_words = read_words_file words_file
    end

    def round
      @current_letters = next_random_letters
      found = 0
      puts "Given letters: " + @current_letters
      while true
        word = gets.strip.upcase
        if !valid_letters? word
          puts "Invalid letters"
          next
        end
        if !valid_word? word
          puts "Invalid word"
          next
        end
        found += 1
        puts "#{word} is valid word [#{found} words found so far]"
        break if found == 6 or word.size == @word_lenght
      end
    end

    def valid_letters?(user_input)
      user_input.split("").each do |letter|
        return false unless @current_letters.include? letter
      end
      return true
    end

    def valid_word?(user_input)
      return @allowed_words[user_input.upcase] == :present
    end

    private

    def next_random_letters
      chars = ('A'..'Z').to_a
      letters =""
      @word_lenght.times do 
        letters << chars[rand(chars.size-1)]
      end
      letters
    end
    
    def read_words_file(words_file)
      # following format is assumed for words_file
      # word0
      # word1
      # ... you got the picture I'm sure
      upcase_words = { }
      File.open(words_file) do |file|
        file.each_line do |line|          
          upcase_words[line.upcase.strip] = :present if line.size <=@word_lenght
        end
      end
      upcase_words
    end

  end

end


if $0 == __FILE__
  wb = TextTwist::WordBlender.new(6,"hacker.lst")
  wb.round
end
