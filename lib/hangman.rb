# required libraries
require "json"

# initialize variables
$text_file = "5desk.txt"
$save_file = "save_file.json"
total_chances = 6
chance_number = 0
guess = []
display_chances = "HANGEDMAN"
display_word = ""

def load_save_file()
  print "Would you like to reload a saved game? (y/n): "
  answer = gets().chomp.downcase
  if answer == "y"
    file = File.open($save_file, "r") do |file|
      save_data = JSON.load(file)
      secret_word = save_data["secret_word"]
      chances = save_data["chances"]
      guesses = save_data["guesses"]
      puts "Loading saved game"
      sleep(2)
      return secret_word, chances, guesses
    end
  else
    secret_word = get_random_word($text_file).downcase.split("")
    return secret_word
  end
end

def make_save_file(secret_word, chances, guesses)
  save_hash = {
    "secret_word" => secret_word,
    "chances" => chances,
    "guesses" => guesses,
  }
  File.open($save_file, "w") do |file|
    file.write(save_hash.to_json)
  end
end

def get_random_word(text_file)
  min_word_length = 5
  max_word_length = 12
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
begin
  load = load_save_file()

  if load.length == 3
    secret_word, chance_number, guess = load[0], load[1], load[2]
  else
    secret_word = load
  end

  while chance_number < display_chances.length()
    system("clear") || system("cls")

    puts "HANG MAN GAME!!\n\(control-C to exit\)\n\n"

    if secret_word - guess == []
      puts "\nYOU WIN!\n"
      puts "\nThe word was #{secret_word.join()}\n"
      break
    end

    if chance_number >= display_chances.length - 1
      print "\n" + display_chances[0..chance_number] + "\n"
      puts "Letters guessed, #{guess}"
      puts "\nYOU LOSE!\n"
      puts "\nThe word was '#{secret_word.join()}'"
      break
    elsif chance_number == 0
    else
      print "\n" + display_chances[0..chance_number - 1] + "\n"
      puts "Letters guessed, #{guess}"
    end

    display_word = secret_word.join().gsub(/[#{secret_word - guess}]/, "_")
    puts "Your word is: #{display_word}"

    print "\nEnter a letter: "
    my_guess = gets.chomp().downcase
    guess.push(my_guess)

    chance_number += 1 if !secret_word.join().include?(my_guess)
  end
rescue Interrupt => e
  system("clear") || system("cls")
  puts "Would you like to save your progress? (y/n): "
  save_choice = gets.chomp.downcase
  if save_choice == "y"
    puts "Writing save file..."
    make_save_file(secret_word, chance_number, guess)
    abort("Done! Have a great day")
  end
  abort("Exiting program")
end
