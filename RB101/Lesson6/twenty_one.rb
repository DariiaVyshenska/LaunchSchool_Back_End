require 'yaml'

MESSAGES = YAML.load_file('./msgs_twenty_one.yml')
WIN_THRESHOLD = 21

JQK_WORTH = 10
ACE_SINGLE_WORTH = 11
ACE_MULT = 1
DEALER_THRESHOLD = 17
MSG_CENTERED_LEN = 55
NUM_OF_WINS = 2
DEALER_NAME = 'Dealer'
PLAYER_NAME = 'Player'

def initiate_deck
  ((2..10).to_a + ['Jack', 'Queen', 'King', 'Ace']) * 4
end

def shuffle_deck!(deck)
  deck.shuffle!
end

def initiate_hands
  { DEALER_NAME => [], PLAYER_NAME => [] }
end

def hit_one_card!(player, hands, deck)
  hands[player] << deck.pop
end

def deal_all_participants!(deck, hands)
  hands.each_key do |player|
    hit_one_card!(player, hands, deck)
  end
end

# rubocop:disable Style/CaseLikeIf
def eval_card(card)
  if card.is_a? Integer
    card
  elsif card == 'Ace'
    ACE_SINGLE_WORTH
  else
    JQK_WORTH
  end
end
# rubocop:enable Style/CaseLikeIf

def calc_score_all_ace_eleven(hand)
  hand.reduce(0) { |score, card| score + eval_card(card) }
end

def how_many_aces(hand)
  hand.count('Ace')
end

def score_ace_recount(score, ace_num)
  ace_num.times do
    score -= (ACE_SINGLE_WORTH - ACE_MULT)
    return score if score <= WIN_THRESHOLD
  end
  score
end

def calculate_score(hand)
  score = calc_score_all_ace_eleven(hand)
  return score if score <= WIN_THRESHOLD

  ace_num = how_many_aces(hand)
  score_ace_recount(score, ace_num)
end

def recalculate_scores!(score, hands)
  hands.each { |player, hand| score[player] = calculate_score(hand) }
end

def stay_or_hit?
  answer = ''
  loop do
    prompt MESSAGES['hit_or_stay']
    answer = gets.chomp
    break if ['h', 's'].include?(answer)

    prompt MESSAGES['invalid_entry_errmsg']
  end
  answer
end

def wanna_stay?
  what_to_do = stay_or_hit?
  what_to_do.eql?('s') ? true : false
end

def bust?(score, player)
  score[player] > WIN_THRESHOLD
end

def player_turn(deck, hands, score, round)
  loop do
    display_move_header(hands, score, round)

    prompt MESSAGES['player_moves']
    break if wanna_stay?

    hit_one_card!(PLAYER_NAME, hands, deck)
    recalculate_scores!(score, hands)

    if bust?(score, PLAYER_NAME)
      display_busted(PLAYER_NAME, score, hands, round)
      break
    end
  end
end

def dealer_turn(score, hands, deck, round)
  while score[DEALER_NAME] < DEALER_THRESHOLD
    hit_one_card!(DEALER_NAME, hands, deck)
    recalculate_scores!(score, hands)
  end

  if bust?(score, DEALER_NAME)
    display_busted(DEALER_NAME, score, hands, round)
  end
end

def winner?(score)
  not_busted = score.select { |_, pl_score| pl_score <= WIN_THRESHOLD }
  max_score = not_busted.values.max
  max_scored = not_busted.select { |_, pl_score| max_score == pl_score }

  return max_scored.keys[0] if max_scored.size == 1
end

def game_winner?(game_score)
  game_score.key(NUM_OF_WINS) if game_score.values.max == NUM_OF_WINS
end

def play_one_round(game_score, round)
  hands = initiate_hands
  deck = initiate_deck
  score = Hash.new(0)

  shuffle_deck!(deck)

  2.times { deal_all_participants!(deck, hands) }
  recalculate_scores!(score, hands)

  player_turn(deck, hands, score, round)
  dealer_turn(score, hands, deck, round) unless bust?(score, PLAYER_NAME)

  winner = winner?(score)
  game_score[winner] += 1 if winner
  display_round_results(hands, score, winner, round)
  nil
end

def play_one_game
  game_score = Hash.new(0)
  round = 1

  loop do
    play_one_round(game_score, round)

    round += 1
    break if game_winner?(game_score)
  end

  game_winner = game_winner?(game_score)
  display_game_results(game_winner)
end

def play_again?
  answer = ''
  loop do
    prompt MESSAGES['play_again_msg']
    answer = gets.chomp.downcase
    break if ['y', 'n'].include?(answer)

    prompt MESSAGES['invalid_entry_errmsg']
  end
  answer.start_with?('y') ? true : false
end

def joinor(arr, join_char = ', ', connector = 'and')
  return "#{arr[0]} #{connector} #{arr[1]}" if arr.size == 2

  "#{arr[0, (arr.size - 1)].join(join_char)} #{connector} #{arr[-1]}"
end

def pause_for_user
  prompt MESSAGES['hit_to_continue']
  gets
end

def prompt(msg)
  puts "=> #{msg}"
end

def display_busted(player, score, hands, round)
  system 'clear'
  display_move_header_fullinfo(hands, score, round)
  display_center_msg(MESSAGES['short_sep'])
  display_center_msg("#{player} #{MESSAGES['busted']}")
  display_center_msg(MESSAGES['short_sep'])
  pause_for_user
end

def display_center_msg(msg)
  puts msg.center(MSG_CENTERED_LEN)
end

def display_welcome
  display_center_msg(MESSAGES['short_sep'])
  display_center_msg(MESSAGES['welcome'])
  puts
  display_center_msg(MESSAGES['winning_threshold'])
  display_center_msg(WIN_THRESHOLD.to_s)
  puts
  display_center_msg(MESSAGES['num_of_wins'])
  display_center_msg(NUM_OF_WINS.to_s)
  display_center_msg(MESSAGES['short_sep'])
end

def display_start_info
  system 'clear'
  display_welcome
  pause_for_user
end

def display_cards_dealer_hidden(hands)
  puts MESSAGES['cards_info']
  puts "#{DEALER_NAME}: #{hands[DEALER_NAME][0]} and #{MESSAGES['hide_card']}."
  puts "#{PLAYER_NAME}: #{joinor(hands[PLAYER_NAME])}"
end

def display_player_score(score)
  puts MESSAGES['score_info']
  puts "#{PLAYER_NAME}: #{score[PLAYER_NAME]}"
end

def display_round(round)
  puts "#{MESSAGES['round_info']} #{round}"
end

def display_move_header(hands, score, round)
  system 'clear'

  display_round(round)
  puts ''
  display_cards_dealer_hidden(hands)
  puts ''
  display_player_score(score)
  puts ''
end

def display_all_cards(hands)
  puts MESSAGES['cards_info']
  hands.keys.each do |participant|
    puts "#{participant}: #{joinor(hands[participant])}"
  end
end

def display_all_score(score)
  puts MESSAGES['score_info']
  score.keys.each do |participant|
    puts "#{participant}: #{score[participant]}"
  end
end

def display_move_header_fullinfo(hands, score, round)
  display_round(round)
  puts ''
  display_all_cards(hands)
  puts ''
  display_all_score(score)
  puts ''
end

def round_winner_msg(winner)
  if winner
    "#{winner.upcase} #{MESSAGES['is_winner']}"
  else
    MESSAGES['tie']
  end
end

def display_round_results(hands, score, winner, round)
  system 'clear'

  display_move_header_fullinfo(hands, score, round)
  display_center_msg(MESSAGES['short_sep'])
  display_center_msg(MESSAGES['end_round_message'])
  puts ''
  display_center_msg(round_winner_msg(winner))
  display_center_msg(MESSAGES['short_sep'])
  pause_for_user
end

def display_game_results(game_winner)
  system 'clear'

  display_center_msg(MESSAGES['short_sep'])
  display_center_msg(MESSAGES['game_results'])
  puts
  display_center_msg("#{game_winner} #{MESSAGES['is_winner']}")
  display_center_msg(MESSAGES['short_sep'])
end

######################### Main #########################################
display_start_info
loop do
  play_one_game
  break unless play_again?
end
