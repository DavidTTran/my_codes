require 'pry'
require 'colorize'

class CardGenerator
  def initialize(filename)
    @filename = "./lib/cards.txt"
  end

  def file_cards
    lines = []
    deck = []
    File.readlines(@filename).each do |line|
      lines << line.chomp.split('|')
    end
    until lines.size == 0
      deck << Card.new(lines.first[0], lines.first[1])
      lines.shift
    end
    deck
  end
end

class Card
  attr_reader :question, :answer

  def initialize(question, answer)
    @question = question
    @answer = answer
  end
end

class Deck
  attr_reader :cards

  def initialize(cards)
    @cards = cards
  end

  def count
    @cards.length
  end
end

class Turn
  attr_reader :guess, :card

  def initialize(guess, card)
    @guess = guess
    @card = card
  end

  def correct?
    if @card.answer == @guess
      puts "Correct!\n".green
      true
    else
      puts "Incorrect. The correct answer was: #{@card.answer}\n".red
      false
    end
  end
end

class Round
  attr_reader :deck, :turns

  def initialize(deck)
    @deck = deck
    @turns = []
    @number_correct = 0
    @total_number_of_cards = 0
    @incorrect_questions = []
  end

  def current_card
    @deck.cards.first
  end

  def percent_correct
    ((@number_correct.to_f / @turns.size) * 100).round(2)
  end

  def take_turn(guess)
    turn = Turn.new(guess, current_card)
    if turn.correct? == true
      @number_correct += 1
    else
      @incorrect_questions << turn
    end
    @turns << turn
    @deck.cards.shift()
    turn
  end

  def start
    @deck.cards.shuffle!
    card_counter = 1
    total_number_of_cards = @deck.count

    puts "\nWelcome! You're playing with #{total_number_of_cards} cards.".yellow

    while @turns.count != total_number_of_cards
      puts "-" * 50
      puts "\nThis is card number #{card_counter} out of #{total_number_of_cards}."
      puts "Question: #{current_card.question}".yellow
      guess = gets.chomp.downcase
      take_turn(guess)
      card_counter += 1
    end
    puts (("-" * 20) + "Game over!" + ("-" * 20)).red
    puts "You had #{@number_correct} correct guesses out of #{total_number_of_cards} for a total score of #{percent_correct}%.".yellow
    puts "\nThe questions you got wrong were.." unless @incorrect_questions.size == 0
    until @incorrect_questions.size == 0
      puts "-" * 50
      puts "#{@incorrect_questions.first.card.question}" + " #{@incorrect_questions.first.card.answer}".red
      @incorrect_questions.shift()
    end
    puts ""
  end
end

cards = CardGenerator.new(@filename)
file_cards = cards.file_cards

deck = Deck.new(file_cards)
round = Round.new(deck)

round.start
