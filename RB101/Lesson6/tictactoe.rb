require 'yaml'

INITIAL_MARKER = ' '
PLAYER_MARKER = 'X'
COMPUTER_MARKER = 'O'
ROUND_WINS = 2
WINNING_LINES = [
  [1, 2, 3], [4, 5, 6], [7, 8, 9],
  [1, 4, 7], [2, 5, 8], [3, 6, 9],
  [1, 5, 9], [3, 5, 7]
]
WHO_GOES_FIRST = 'choose'
BOARD_CENTER = 5
CENTERED_LEN = 45
MESSAGES = YAML.load_file('./msgs-ttt.yml')

def prompt(msg)
  puts "=> #{msg}"
end

def joinor(arr, join_char = ', ', connector = 'or')
  return arr[0].to_s if arr.size == 1

  arr[-1] = "#{connector} #{arr[-1]}"
  return arr.join(' ') if arr.size == 2

  arr.join(join_char)
end

def display_centered_msg(msg, msg_length)
  puts msg.center(msg_length)
end

def display_game_start
  system 'clear'

  display_centered_msg(MESSAGES['welcome'], CENTERED_LEN)
  display_centered_msg(MESSAGES['rounds_req_to_win'], CENTERED_LEN)
  display_centered_msg(ROUND_WINS.to_s, CENTERED_LEN)
  display_centered_msg(MESSAGES['minor_separator_line'], CENTERED_LEN)
  display_centered_msg(MESSAGES['press_enter'], CENTERED_LEN)
  gets
end

# rubocop:disable Metrics/AbcSize, Metrics/MethodLength
def display_board(brd, round, score)
  prompt "ROUND #{round}."
  prompt "SCORE Player #{score['player']}:#{score['computer']} Computer"
  prompt "You're #{PLAYER_MARKER}. Computer is #{COMPUTER_MARKER}."
  puts ""
  puts "     |     |"
  puts "  #{brd[1]}  |  #{brd[2]}  |  #{brd[3]}"
  puts "     |     |"
  puts "-----+-----+-----"
  puts "     |     |"
  puts "  #{brd[4]}  |  #{brd[5]}  |  #{brd[6]}"
  puts "     |     |"
  puts "-----+-----+-----"
  puts "     |     |"
  puts "  #{brd[7]}  |  #{brd[8]}  |  #{brd[9]}"
  puts "     |     |"
  puts ""
end
# rubocop:enable Metrics/AbcSize, Metrics/MethodLength

def display_round_result(brd, round, score, winner)
  system 'clear'
  display_board(brd, round, score)
  prompt !!winner ? "#{winner} #{MESSAGES['won']}" : MESSAGES['tie_msg']
  prompt MESSAGES['press_enter']
  gets
end

def display_game_results(score, winner)
  system 'clear'

  display_centered_msg(MESSAGES['score'], CENTERED_LEN)
  display_centered_msg(MESSAGES['player_vs_comp'], CENTERED_LEN)
  display_centered_msg("#{score['player']}:#{score['computer']}", CENTERED_LEN)
  display_centered_msg(MESSAGES['minor_separator_line'], CENTERED_LEN)
  display_centered_msg("#{winner.upcase} #{MESSAGES['won']}", CENTERED_LEN)
end

def intialize_board
  new_board = {}
  (1..9).each { |num| new_board[num] = INITIAL_MARKER }
  new_board
end

def user_assign_player
  system 'clear'
  user_answer = ''
  loop do
    prompt MESSAGES['who_goes_first_msg']
    user_answer = gets.chomp.downcase
    break if ['p', 'c'].include?(user_answer)

    system 'clear'
    prompt MESSAGES['not_valid_msg']
  end

  user_answer.start_with?('p') ? 'player' : 'computer'
end

def assign_player(who_goes_first)
  case who_goes_first
  when 'choose' then user_assign_player
  else who_goes_first
  end
end

def alternate_player(curr_player)
  case curr_player
  when 'player' then 'computer'
  when 'computer' then 'player'
  end
end

def empty_squares(brd)
  brd.keys.select { |num| brd[num] == INITIAL_MARKER }
end

def board_full?(brd)
  empty_squares(brd).empty?
end

def someone_won?(brd)
  !!detect_winner(brd)
end

def detect_winner(brd)
  WINNING_LINES.each do |line|
    if brd.values_at(*line).count(PLAYER_MARKER) == 3
      return 'PLAYER'
    elsif brd.values_at(*line).count(COMPUTER_MARKER) == 3
      return 'COMPUTER'
    end
  end
  nil
end

def critical_line?(brd, line, marker)
  !!(brd.values_at(*line).count(marker) == 2 &&
    brd.values_at(*line).count(INITIAL_MARKER) == 1)
end

def detect_critical_idx(brd, marker)
  danger_location = []
  WINNING_LINES.each do |line|
    if critical_line?(brd, line, marker)
      danger_location << line[brd.values_at(*line).index(INITIAL_MARKER)]
    end
  end
  danger_location.sample
end

def valid_i?(num)
  !!(num.to_i.to_s == num)
end

def valid_square_choice?(square, brd)
  !!(valid_i?(square) && empty_squares(brd).include?(square.to_i))
end

def player_places_piece!(brd)
  square = ''
  loop do
    prompt "Choose a square (#{joinor(empty_squares(brd))}):"
    square = gets.chomp
    break if valid_square_choice?(square, brd)

    prompt MESSAGES['not_valid_msg']
  end

  brd[square.to_i] = PLAYER_MARKER
end

def computer_places_piece!(brd)
  square = if !!detect_critical_idx(brd, COMPUTER_MARKER)
             detect_critical_idx(brd, COMPUTER_MARKER)
           elsif !!detect_critical_idx(brd, PLAYER_MARKER)
             detect_critical_idx(brd, PLAYER_MARKER)
           elsif empty_squares(brd).include?(BOARD_CENTER)
             BOARD_CENTER
           else empty_squares(brd).sample
           end
  brd[square] = COMPUTER_MARKER
end

def place_piece!(brd, curr_player)
  case curr_player
  when 'player' then player_places_piece!(brd)
  when 'computer' then computer_places_piece!(brd)
  end
end

def update_score!(score, winner)
  score[winner.downcase] += 1 if winner
end

def detect_game_winner(score)
  score.key(ROUND_WINS)
end

def play_one_round(score, round, current_player)
  board = intialize_board

  loop do
    system 'clear'
    display_board(board, round, score)
    place_piece!(board, current_player)
    current_player = alternate_player(current_player)
    break if someone_won?(board) || board_full?(board)
  end

  winner = detect_winner(board)
  update_score!(score, winner)
  display_round_result(board, round, score, winner)
end

def play_again?
  answer = ''
  loop do
    puts
    prompt MESSAGES['play_again_msg']
    answer = gets.chomp.downcase
    break if ['y', 'n'].include?(answer)

    prompt MESSAGES['not_valid_msg']
  end
  answer.start_with?('y') ? true : false
end

################################ Main loop #####################################
display_game_start
loop do
  round = 1
  score = { 'player' => 0, 'computer' => 0 }
  current_player = assign_player(WHO_GOES_FIRST)
  while score.values.max < ROUND_WINS
    play_one_round(score, round, current_player)
    round += 1
  end
  game_winner = detect_game_winner(score)
  display_game_results(score, game_winner)
  break unless play_again?
end

prompt MESSAGES['bye_msg']
