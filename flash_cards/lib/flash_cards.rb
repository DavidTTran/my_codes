require 'pry'

class CardGenerator
  attr_reader :filename

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
  attr_reader :card_question, :card_answer

  def initialize(card_question, card_answer)
    @card_question = card_question
    @card_answer = card_answer
  end
end

class Deck
  attr_reader :deck_cards

  def initialize(deck_cards)
    @deck_cards = deck_cards
  end

  def count
    @deck_cards.length
  end
end

class Turn
  attr_reader :turn_guess, :card

  def initialize(turn_guess, card)
    @turn_guess = turn_guess
    @card = card
  end

  def correct?
    if @card.card_answer == @turn_guess
      puts "Correct!"
      true
    else
      puts "Incorrect. The correct answer was: #{@card.card_answer}"
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
  end

  def current_card
    @deck.deck_cards.first
  end

  def percent_correct
    ((@number_correct.to_f / @turns.size) * 100).round(2)
  end

  def take_turn(turn_guess)
    turn = Turn.new(turn_guess, current_card)
    @number_correct += 1 unless turn.correct? != true
    @turns << turn
    @deck.deck_cards.shift()
    turn
  end

  def start
    card_counter = 1
    total_number_of_cards = @deck.count
    puts "Welcome! You're playing with #{total_number_of_cards} cards."

    while @turns.count != total_number_of_cards
      puts "-" * 50
      puts "This is card number #{card_counter} out of #{total_number_of_cards}."
      puts "Question: #{current_card.card_question}"
      turn_guess = gets.chomp.downcase
      take_turn(turn_guess)
      card_counter += 1
    end
    puts ("-" * 20) + "Game over!" + ("-" * 20)
    puts "You had #{@number_correct} correct guesses out of #{total_number_of_cards} for a total score of #{percent_correct}%."
  end
end

cards = CardGenerator.new(@filename)
file_cards = cards.file_cards

deck = Deck.new(file_cards)
round = Round.new(deck)

round.start
