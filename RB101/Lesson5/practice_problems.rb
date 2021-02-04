# Problem#1
arr = ['10', '11', '9', '7', '8']
arr.sort { |a,b | b.to_i <=> a.to_i }
arr.sort_by { |i| i.to_i}.reverse

# Problem#2
books = [
  {title: 'One Hundred Years of Solitude', author: 'Gabriel Garcia Marquez', published: '1967'},
  {title: 'The Great Gatsby', author: 'F. Scott Fitzgerald', published: '1925'},
  {title: 'War and Peace', author: 'Leo Tolstoy', published: '1869'},
  {title: 'Ulysses', author: 'James Joyce', published: '1922'}
]

books.sort_by { |i| i[:published]}

# Problem#3
arr1 = ['a', 'b', ['c', ['d', 'e', 'f', 'g']]]
arr1[2][1][3]

arr2 = [{first: ['a', 'b', 'c'], second: ['d', 'e', 'f']}, {third: ['g', 'h', 'i']}]
arr2[1][:third][0]

arr3 = [['abc'], ['def'], {third: ['ghi']}]
arr3[2][:third][0][0]

hsh1 = {'a' => ['d', 'e'], 'b' => ['f', 'g'], 'c' => ['h', 'i']}
hsh1['b'][1]

hsh2 = {first: {'d' => 3}, second: {'e' => 2, 'f' => 1}, third: {'g' => 0}}
hsh2[:third].keys[0]

# Problem#4
arr1 = [1, [2, 3], 4]
arr1[1][1] += 1
# arr1[1][1] = 4
# p (arr1.map! do |a|
#   if a == 3
#     a + 1
#   else
#     if a.is_a? Array
#       a.map do |b|
#         if b == 3
#           b + 1
#         else
#           b
#         end
#       end
#     else
#       a
#     end
#   end
# end)

arr2 = [{a: 1}, {b: 2, c: [7, 6, 5], d: 4}, 3]
arr2[2] += 1

hsh1 = {first: [1, 2, [3]]}
hsh1[:first][2][0] += 1

hsh2 = {['a'] => {a: ['1', :two, 3], b: 4}, 'b' => 5}
hsh2[['a']][:a][2] += 1

# Problem#5
munsters = {
  "Herman" => { "age" => 32, "gender" => "male" },
  "Lily" => { "age" => 30, "gender" => "female" },
  "Grandpa" => { "age" => 402, "gender" => "male" },
  "Eddie" => { "age" => 10, "gender" => "male" },
  "Marilyn" => { "age" => 23, "gender" => "female"}
}
munsters.select { |_, v| v["gender"] == "male" }.values.map { |i| i["age"] }.sum
# tmp = munsters.map do |_, v|
#   if v["gender"] == "male"
#     v["age"]
#   else
#     0
#   end
# end
# p tmp.sum

# Problem#6
munsters = {
  "Herman" => { "age" => 32, "gender" => "male" },
  "Lily" => { "age" => 30, "gender" => "female" },
  "Grandpa" => { "age" => 402, "gender" => "male" },
  "Eddie" => { "age" => 10, "gender" => "male" },
  "Marilyn" => { "age" => 23, "gender" => "female"}
}

# munsters.each do |k, v|
#   puts "#{k} is a #{v["age"]}-year-old (#{v["gender"]})"
# end

# Problem#7
# a == 2
# b == [3, 8]

# Problem#8
hsh = {first: ['the', 'quick'], second: ['brown', 'fox'], third: ['jumped'], fourth: ['over', 'the', 'lazy', 'dog']}

# hsh.values.each { |v| v.each {|arr_el| arr_el.each_char { |ch| p ch if 'aeiou'.include?(ch) } } }

# Problem#9
arr = [['b', 'c', 'a'], [2, 1, 3], ['blue', 'black', 'green']]
arr.map { |subarr| subarr.sort { |a, b| b <=> a } }

# Problem#10
arr = [{a: 1}, {b: 2, c: 3}, {d: 4, e: 5, f: 6}]
new_arr = arr.map do |hsh|
  hsh.map { |k, v| [k, v + 1] }.to_h
end

# Problem#11
arr = [[2], [3, 5, 7], [9], [11, 13, 15]]
arr.map { |el| el.select { |num| num % 3 == 0} }

# Problem#12
arr = [[:a, 1], ['b', 'two'], ['sea', {c: 3}], [{a: 1, b: 2, c: 3, d: 4}, 'D']]
new_hsh = {}
arr.each { |pair| new_hsh[pair[0]] = pair[1] }

# Problem#13
arr = [[1, 6, 7], [1, 4, 9], [1, 8, 3]]
arr.sort_by { |el| el.select { |subel| subel.odd? } }

# Problem#14
hsh = {
  'grape' => {type: 'fruit', colors: ['red', 'green'], size: 'small'},
  'carrot' => {type: 'vegetable', colors: ['orange'], size: 'medium'},
  'apple' => {type: 'fruit', colors: ['red', 'green'], size: 'medium'},
  'apricot' => {type: 'fruit', colors: ['orange'], size: 'medium'},
  'marrow' => {type: 'vegetable', colors: ['green'], size: 'large'},
}
(hsh.map do |_, v|
  if v[:type] == 'fruit'
    v[:colors].map(&:capitalize)
  elsif v[:type] == 'vegetable'
    v[:size].upcase
  end
end)

# Problem#15
#arr.select { |i| i.values.flatten.all?(&:even?) }

# Problem#16
def uuid_gen
  uuid = [8, 4, 4, 4, 12].each_with_object([]) do |i, obj|
    obj << Random.new.rand((16**(i - 1))..(16**i)).to_s(16)
  end
  uuid.join('-')
end
