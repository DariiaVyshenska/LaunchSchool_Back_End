require 'yaml'

LANGUAGE = 'en'
MESSAGES = YAML.load_file("mortgage_calculator_messages.yml")

def messages(message_key, lang='en')
  MESSAGES[lang][message_key]
end

def prompt(key)
  message = messages(key, LANGUAGE)
  puts ">> #{message}"
end

def num_prompt(f)
  puts ">>    #{format('%.2f', f)}"
end

def integer?(i)
  i.to_i.to_s == i
end

def float?(f)
  f.to_f.to_s == f
end

def number?(n)
  integer?(n) || float?(n)
end

def valid_apr?(n)
  number?(n) && n.to_f >= 0
end

def valid_month?(n)
  integer?(n) && n.to_i > 0
end

def valid_loan?(n)
  number?(n) && n.to_f > 0
end

def valid?(value, type)
  case type
  when 'apr' then valid_apr?(value)
  when 'month' then valid_month?(value)
  when 'loan' then valid_loan?(value)
  end
end

def get_num_from_user(input_message, type, error_message='error_general')
  user_input = ''
  loop do
    prompt input_message
    user_input = gets.chomp.strip
    if valid?(user_input, type)
      break user_input
    else
      prompt error_message
    end
  end
end

def mir_calc(apr)
  apr == 0 ? 0 : ((apr / 100) / 12)
end

def monthly_payment_calc(loan_amount, mir, duar_months)
  if mir == 0
    loan_amount / duar_months
  elsif mir > 0
    loan_amount * (mir / (1 - (1 + mir)**(-duar_months)))
  end
end

def another_round?
  loop do
    prompt 'another_round'
    user_answer = gets.chomp.strip.downcase
    case user_answer
    when 'y'
      break true
    when 'n'
      break false
    else
      prompt 'error_general'
      next
    end
  end
end

def get_input_from_user
  out_values = Hash.new(0)
  out_values[:loan_amount] = get_num_from_user('loan_message', 'loan').to_f
  out_values[:apr] = get_num_from_user('apr_message', 'apr').to_f
  out_values[:duar_months] = get_num_from_user('duar_message', 'month').to_f
  out_values
end

def calculations(user_input_hash)
  out_values = Hash.new(0)
  loan = user_input_hash[:loan_amount]
  duar = user_input_hash[:duar_months]
  mir = mir_calc(user_input_hash[:apr])
  out_values[:month_pay] = monthly_payment_calc(loan, mir, duar)
  out_values[:total_pay] = out_values[:month_pay] * duar
  out_values[:total_interest] = out_values[:total_pay] - loan
  out_values
end

def display_calculations(calcul_hash)
  prompt 'result_message'
  prompt 'output_month_pay'
  num_prompt calcul_hash[:month_pay]
  prompt 'output_total_pay'
  num_prompt calcul_hash[:total_pay]
  prompt 'output_interest'
  num_prompt calcul_hash[:total_interest]
end

prompt 'welcome'

# Main loop
loop do
  user_input = get_input_from_user
  calcul_values = calculations(user_input)
  display_calculations(calcul_values)

  break unless another_round?
end

prompt 'goodbye'
