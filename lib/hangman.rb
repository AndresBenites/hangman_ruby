# required libraries
require "json"

# initialize variables
save_file = "save_file.txt"
text_file = "5desk.txt"
total_chances = 6
chance_number = 0
guess = []
display_chances = "HANGEDMAN"
display_word = ""

def get_random_word(text_file)
  min_word_length = 4
  max_word_length = 7
  words_array = []
  return_word = ""
  if !File.exists?(text_file)
    return "File does not exist."
  end
  text_file = File.open(text_file)

  words_array = text_file.readlines()
  loop do
    return_word = words_array[rand(words_array.length)].gsub(/\R+/, "")
    break if return_word.length >= min_word_length &&
             return_word.length <= max_word_length
  end
  return return_word
end

# begin logic
secret_word = get_random_word(text_file).downcase.split("")

# p secret_word.join()

while chance_number < display_chances.length()
#   system("clear") || system("cls")
  puts "HANG MAN GAME!!\n"
  if secret_word - guess == []
    puts "\nYOU WIN!\n"
    puts "\nThe word was #{secret_word.join()}\n"
    break
  end
  display_word = secret_word.join().gsub(/[#{secret_word - guess}]/, "_")
  puts display_word
  print "\nEnter a letter: "
  my_guess = gets.chomp().downcase
  guess.push(my_guess)
  if chance_number >= display_chances.length - 1
    print "\n" + display_chances[0..chance_number] + "\n"
    puts "Letters guessed, #{guess}"
    puts "\nYOU LOSE!\n"
    puts "\nThe word was '#{secret_word.join()}'"
    break
  else
    print "\n" + display_chances[0..chance_number] + "\n"
    puts "Letters guessed, #{guess}"
  end
  chance_number += 1 if !secret_word.join().include?(my_guess)
end
