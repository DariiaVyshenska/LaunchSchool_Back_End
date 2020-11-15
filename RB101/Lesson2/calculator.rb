def prompt(message)
  Kernel.puts("=> #{message}")
end

def valid_number?(num)
  # Calculator bonus assignment 1 - another way of validating integers
  num.to_i.to_s == num
end

# # Calculator bonus assignment 2 - verify if number is either float or integer
# def number?(num)
#   num.to_f.to_s == num || num.to_i.to_s == num
# end

def operation_to_message(opr)
  # Calculator bonus assignment 3
  answer =
    case opr
    when '1'
      'Adding'
    when '2'
      'Substracting'
    when '3'
      'Multiplying'
    when '4'
      'Dividing'
    end
  # Kernel.puts("can do some other thing here")
  answer
end

prompt("Welcome to Calculator! Enter your name: ")
name = ''
loop do
  name = Kernel.gets().chomp()

  if name.empty?()
    prompt("Make sure to use a valid name.")
  else
    break
  end
end

prompt("Hello, #{name}!")

loop do # main loop
  number1 = ''
  loop do
    prompt("What's the first number?")
    number1 = Kernel.gets().chomp()

    if valid_number?(number1)
      break
    else
      prompt("Hmm... That doesn't look like a valid number")
    end
  end

  number2 = ''
  loop do
    prompt("What's the second number?")
    number2 = Kernel.gets().chomp()

    if valid_number?(number2)
      break
    else
      prompt("Hmm... That doesn't look like a valid number")
    end
  end

  operator_prompt = <<-MSG
    What operation would you like to perform?
    1) add
    2) substract
    3) multiply
    4) divide
  MSG

  prompt(operator_prompt)
  operator = ''
  loop do
    operator = Kernel.gets().chomp()

    if %w(1 2 3 4).include? operator
      break
    else
      prompt("Must chose 1, 2, 3 or 4")
    end
  end

  prompt("#{operation_to_message(operator)} the two numbers...")

  result =
    case operator
    when '1'
      number1.to_i() + number2.to_i()
    when '2'
      number1.to_i() - number2.to_i()
    when '3'
      number1.to_i() * number2.to_i()
    when '4'
      number1.to_f() / number2.to_f()
    end

  prompt("The result is #{result}")
  prompt("Do you want to perform another calculation? Y to calculate again")
  answer = Kernel.gets().chomp()
  break unless answer.downcase().start_with?('y')
end

prompt("Thank you for using the calculator! Good bye!")
