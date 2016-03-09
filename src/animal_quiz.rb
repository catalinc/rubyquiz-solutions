class Question

  attr_accessor :text, :answers, :animal

  def initialize(text, animal, answers)
    @text = text
    @animal = animal
    @answers = answers
  end

  def ask
    puts @text
    @answers[gets.chomp]
  end

end

class AnimalQuiz
  def initialize
    @start_question = Question.new("Think of an animal...\nIs an elephant ?", 
                                   "elephant", 
                                   { "y" => :success, "n" => :fail })
    @playing = true
  end
  
  def start
    answer        = @start_question
    last_question = @start_question
    while @playing
      last_question = answer
      answer        = answer.ask
      case answer 
      when :success
        puts "I win, I'm pretty smart !"
        puts "Play again ?"
        if gets.chomp == "n"
          @playing = false
        else
          answer = @start_question
        end
      when :fail
        puts "I lose..."
        
        puts "Help me improve myself... What is the animal you are thinking of ?"
        animal = gets.chomp
        
        puts "Give me a question to distinguish between <#{animal}> and <#{last_question.animal}>"
        text = gets.chomp
        
        puts "Your answer for <#{animal}> to <#{text}> ? (y or n)"
        success_answer = gets.chomp
        answers = Hash.new { |h, k| h[k] = :fail }
        answers[success_answer] = Question.new("Is a #{animal} ?", 
                                               animal, 
                                               { "y" => :success, "n" => :fail })
        
        question = Question.new(text, animal, answers)
        last_question.answers["n"] = question
        puts "Play again ?"
        if gets.chomp! == "n"
          @playing = false
        else
          answer = @start_question
        end
      end
    end
    puts "Bye, have a nice day !"
  end

end

if $0 == __FILE__
  AnimalQuiz.new.start
end
