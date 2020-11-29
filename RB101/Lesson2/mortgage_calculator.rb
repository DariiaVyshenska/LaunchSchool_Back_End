LANGUAGE = 'en'
require 'yaml'

def messages(message_key, lang='en')
  MESSAGES[lang][message_key]
end

def prompt(key)
  message = messages(key, LANGUAGE)
  puts ">> #{message}"
end

def num_prompt(f)
  puts ">>    #{f.round(2)}"
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

def monthly_payment_calc(loan_amount, mir, duar_months)
  loan_amount * (mir / (1 - (1 + mir)**(-duar_months)))
end

MESSAGES = YAML.load_file("mortgage_calculator_messages.yml")

prompt 'welcome'
loop do # main loop
  loan_amount = ''
  loop do
    prompt 'loan_amount_message'
    loan_amount = gets.chomp
    if number?(loan_amount)
      break loan_amount = loan_amount.to_f
    else
      prompt 'error_general'
    end
  end

  apr = ''
  loop do
    prompt 'apr_message'
    apr = gets.chomp
    if number?(apr)
      break apr = apr.to_f
    else
      prompt 'error_apr'
    end
  end

  duar_years = ''
  loop do
    prompt 'duar_years_message'
    duar_years = gets.chomp
    if number?(duar_years)
      break duar_years = duar_years.to_f
    else
      prompt 'error_general'
    end
  end

  duar_months = ''
  loop do
    prompt 'duar_months_message'
    duar_months = gets.chomp
    if number?(duar_months)
      break duar_months = duar_months.to_f
    else
      prompt 'error_general'
    end
  end

  # calculations
  mir = (apr / 100) / 12
  duar_total_months = (duar_years * 12) + duar_months
  month_pay = monthly_payment_calc(loan_amount, mir, duar_total_months)
  total_pay = month_pay * duar_total_months
  total_interest = total_pay - loan_amount

  # output for the user
  prompt 'result_message'
  prompt 'output_month_pay'
  num_prompt month_pay
  prompt 'output_total_pay'
  num_prompt total_pay
  prompt 'output_interest'
  num_prompt total_interest

  prompt 'another_round'
  answer = gets.chomp
  break unless answer.downcase.start_with?('y')
end

prompt 'goodbye'
