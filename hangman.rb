
words=[]

File.open("5desk",'r') do |file|
    file.each_line do |line|
        words.push(line)
    end
end

secret_word="asdf"
guesses_remaining=6
incorrect_letters=""
correct_letters=""
guess=""
win=false

while secret_word.length<5 || secret_word.length>12 do
    secret_word=words.sample.downcase # set a random word to secret word
    secret_word=secret_word[0..-3] # Im trimming the word because word ends with /n
end

(1..secret_word.length).each {|c| correct_letters << "_"}

    while guesses_remaining>0    do
        guess=gets.chomp.downcase[0]
        if secret_word.include?(guess)
        secret_word.each_char.with_index {|c,i|
            if c==guess
                correct_letters[i]=guess
            end
        }
        else
            incorrect_letters << guess << " "
            guesses_remaining-=1
        end
            
     
        if correct_letters.split.join('')==secret_word
            win=true 
            guesses_remaining=0
        else
            correct_letters.each_char {|e| print e<<" "}
            puts "\nIncorrect letters: #{incorrect_letters}"
            puts "Remaining guesses: #{guesses_remaining}"
         end
        
    end

    

    puts win==true ?  "Congratulations !!!\n You found the secret word: #{secret_word}" : "Sorry you lost...The secret word was: #{secret_word}"