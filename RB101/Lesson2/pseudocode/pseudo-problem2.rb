START

SET input_array = array of strings
SET output_var = ''
SET iterator = 1

WHILE iterator <= length of input_array
  SET output_var = output_var + input_array at space "iterator"
  iterator = iterator + 1

RETURN output_var

END