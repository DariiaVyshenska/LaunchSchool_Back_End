ROUND_SIZE = 5
VALID_CHOICES = %w(r p sc sp l)
WIN_RULES_HASH = {
  'r' => %w(l sc),
  'p' => %w(r sp),
  'sc' => %w(p l),
  'sp' => %w(sc r),
  'l' => %(sp p)
}
INTRO_MSG = <<-MSG
  Enter one:
    r for rock
    p for paper
    l for lizard
    sc for scissors
    sp for spock
MSG

def prompt(message)
  Kernel.puts "=> #{message}"
end

def win?(first, second)
  WIN_RULES_HASH[first].include?(second)
end

def display_results(player, computer)
  if win?(player, computer)
    prompt("You won!")
  elsif win?(computer, player)
    prompt("Computer won!")
  else
    prompt("It's a tie!")
  end
end

def who_won?(score_hash)
  if score_hash['you'] > score_hash['computer']
    'you'
  elsif score_hash['you'] < score_hash['computer']
    'computer'
  else
    'tie'
  end
end

def display_round_results(score_hash)
  winner = who_won?(score_hash)
  round_message =
    case winner
    when 'you'
      "You won this round!"
    when 'computer'
      "Computer won this round!"
    when 'tie'
      "It's a tie for this round!"
    else
      "Error: something went wrong!"
    end
  prompt(round_message)
end

def update_score(score_hash, player, computer)
  if win?(player, computer)
    score_hash['you'] += 1
  elsif win?(computer, player)
    score_hash['computer'] += 1
  else
    score_hash['tie'] += 1
  end
  nil
end

loop do
  round_score = Hash.new(0)
  ROUND_SIZE.times do
    choice = ''
    loop do
      prompt(INTRO_MSG)
      choice = Kernel.gets().chomp()

      if VALID_CHOICES.include?(choice)
        break
      else
        prompt("That's not a valid choice.")
      end
    end

    computer_choice = VALID_CHOICES.sample

    prompt("You chose: #{choice}; Computer chose: #{computer_choice}")
    display_results(choice, computer_choice)
    update_score(round_score, choice, computer_choice)
  end

  display_round_results(round_score)
  prompt("Do you want to play again?")
  answer = Kernel.gets().chomp()
  break unless answer.downcase().start_with?('y')
end

prompt("Thank you for playing! Good bye!")
