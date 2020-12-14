require 'yaml'

MOVES_INFO_HASH = {
  'r' => {full_name: 'rock', wins_over: %w(l sc)},
  'p' => {full_name: 'paper', wins_over: %w(r sp)},
  'sc' => {full_name: 'scissors', wins_over: %w(p l)},
  'sp' => {full_name: 'Spock', wins_over: %w(sc r)},
  'l' => {full_name: 'lizard', wins_over: %w(sp p)}
}

LANGUAGE = 'en'
MESSAGES = YAML.load_file("bonus_rps.yml")

#==============================METHODS SECTION==================================
def clear
  system('clear') || system('cls')
end

def messages(message_key, lang='en')
  MESSAGES[lang][message_key]
end

def prompt(key, value='')
  message = messages(key, LANGUAGE)
  puts "=> #{message}" + value
end

def get_user_choice
  choice = ''
  loop do
    prompt('ask_to_choose')
    choice = gets.chomp

    break choice if MOVES_INFO_HASH.keys.include?(choice)
    
    prompt('not_valid_error')
    prompt('instruction')
  end
end

def win?(first, second)
  MOVES_INFO_HASH[first][:wins_over].include?(second)
end

def who_won_battle?(user_choice, computer_choice)
  if win?(user_choice, computer_choice)
    'user'
  elsif win?(computer_choice, user_choice)
    'computer'
  else
    'tie'
  end
end

def who_won_round?(score_hash)
  if score_hash['you'] > score_hash['computer']
    'you'
  elsif score_hash['you'] < score_hash['computer']
    'computer'
  else
    'tie'
  end
end

def update_score(score_hash, battle_winner)
  case battle_winner
  when 'user' then score_hash['you'] += 1
  when 'computer' then score_hash['computer'] += 1
  when 'tie' then nil
  end
end

def display_choices(user_choice, computer_choice, battle_number)
  clear
  prompt('battle_number', battle_number.to_s)
  prompt('user_choice', MOVES_INFO_HASH[user_choice][:full_name])
  prompt('comp_choice', MOVES_INFO_HASH[computer_choice][:full_name])
end

def display_score(round_score)
  prompt('small_break')
  prompt('score')
  prompt('player1', round_score['you'].to_s)
  prompt('player2', round_score['computer'].to_s)
  prompt('small_break')
end

def display_battle_results(battle_winner)
  prompt(battle_winner)
end

def display_round_results(score_hash)
  round_winner = who_won_round?(score_hash)
  round_message =
    case round_winner
    when 'you'      then 'round_user_won'
    when 'computer' then 'round_comp_won'
    else                 'general_error'
    end
  prompt('star_break')
  prompt(round_message)
  prompt('star_break')
end

def play_again?
  loop do
    prompt 'play_again'
    user_answer = gets.chomp.strip.downcase
    case user_answer
    when 'y' then break true
    when 'n' then break false
    else
      prompt 'not_valid_error'
      next
    end
  end
end

def play_round
  round_score = Hash.new(0)
  battle = 0
  loop do
    prompt('instruction')
    user_choice = get_user_choice
    computer_choice = MOVES_INFO_HASH.keys.sample
    winner = who_won_battle?(user_choice, computer_choice)
    update_score(round_score, winner)
    battle += 1

    display_choices(user_choice, computer_choice, battle)
    display_battle_results(winner)
    display_score(round_score)
    break if round_score.any? { |_, value| value == 5 }
  end
  display_round_results(round_score)
end
#============================END METHODS SECTION================================

clear
prompt 'welcome'
loop do
  play_round
  break unless play_again?
  clear
end
prompt('goodbye')
