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

def valid_number?(n)
  number?(n) && n.to_f > 0
end

def get_num_from_user(input_message_request, error_message='error_general')
  user_input = ''
  loop do
    prompt input_message_request
    user_input = gets.chomp.strip
    if valid_number?(user_input)
      break user_input
    else
      prompt error_message
    end
  end
end

def monthly_payment_calc(loan_amount, mir, duar_months)
  loan_amount * (mir / (1 - (1 + mir)**(-duar_months)))
end

prompt 'welcome'

# Main loop
loop do
  # Get input from user
  loan_amount = get_num_from_user('loan_amount_message').to_f
  apr = get_num_from_user('apr_message').to_f
  duar_years = get_num_from_user('duar_years_message').to_f

  # Calculations
  mir = (apr / 100) / 12
  duar_total_months = duar_years * 12
  month_pay = monthly_payment_calc(loan_amount, mir, duar_total_months)
  total_pay = month_pay * duar_total_months
  total_interest = total_pay - loan_amount

  # Output for the user
  prompt 'result_message'
  prompt 'output_month_pay'
  num_prompt month_pay
  prompt 'output_total_pay'
  num_prompt total_pay
  prompt 'output_interest'
  num_prompt total_interest

  # Asking if another round should be performed
  prompt 'another_round'
  answer = gets.chomp.strip
  break unless answer.downcase == 'y'
end

prompt 'goodbye'
