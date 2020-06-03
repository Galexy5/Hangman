
     require 'json'
    
    class Hangman

     def initialize
        puts "1)New Game \n 2)Load Game"
        choice=gets.chomp.to_i
        choice==2 ? load_game : new_game
     end

        def new_game

            words=[]

            File.open("5desk",'r') do |file|
                file.each_line do |line|
                    words.push(line)
                end
            end

            @secret_word=""
            @guesses_remaining=6
            @incorrect_letters=""
            @correct_letters=""
            @guess=""
            @win=false

            while @secret_word.length<5 || @secret_word.length>12 do
                @secret_word=words.sample.downcase # set a random word to secret word
                @secret_word=@secret_word[0..-2] # Im trimming the word because word ends with /n
            end

            (1..@secret_word.length).each {|c| @correct_letters << "_"}
            puts "Let's start playing !!"
            play_game(true)
        end


        def play_again?
            print "\nDo you want to play a new game ?  y/n: "
            answer=gets.chomp.downcase
            answer=='y' ? new_game : exit(true)
        end

        def play_game(first_time)

        while @guesses_remaining>0    do
            if !first_time
            print "\nSave game ? y/n : "
            save=gets.chomp.downcase
            save_game(@secret_word,@correct_letters,@incorrect_letters,@guesses_remaining)  if save=='y'
            end

            print "\n Enter your guess letter: "
            guess=gets.chomp.downcase[0]
            if @secret_word.include?(guess)
            @secret_word.each_char.with_index {|c,i|
                if c==guess
                    @correct_letters[i]=guess
                end
            }
            else
                @incorrect_letters << guess << " "
                @guesses_remaining-=1
            end
                
        
            if @correct_letters.split.join('')==@secret_word
                @win=true 
                @guesses_remaining=0
            else
                display    
            end
            
            first_time=false

        end

        if @win==true 
           puts "Congratulations !!!\n You found the secret word: #{@secret_word}" 
           play_again? 
        else
            puts "Sorry you lost...The secret word was: #{@secret_word}"
            play_again? 
        end
        end


        def save_game (sw,cl,il,gr) #sw=secret_word, cl=correct_letters, il=incorrect_letters, gr=guesses_remaining
            filename = "load.json"
            print "Type a name to save your game: "
            name=gets.chomp.to_s.downcase

            if File.file?(filename)   # Check if there is already a game saved with the same name
                json_lines=File.readlines(filename)
                json_lines.each{|l| 
                    l=JSON.parse(l)
                    while l["name"]==name do
                        print "\nThere is another game with the same name\nType a different name: "
                        name=gets.chomp.to_s.downcase
                    end
                }
            end

            line={ name: name, sw: sw, cl: cl, il: il, gr: gr }
            File.open(filename,'a') do |file|
            file.puts line.to_json
            end
            print "\nYour game is saved" 
            play_again?
        end

        def load_game
            begin
            lines=File.readlines "load.json"
            puts "Type one of the following games to load:"
            lines.each{|line|
            line=JSON.parse(line)   # convert every line which is a string to hash
            puts line["name"]
            }
            name=gets.chomp.downcase
            lines.each{|line|
                    line=JSON.parse(line)
                    if line["name"]==name
                        @secret_word=line["sw"]
                        @correct_letters=line["cl"]
                        @incorrect_letters=line["il"]
                        @guesses_remaining=line["gr"]
                        puts "\nGame is loaded !!!\n"
                        display
                        play_game(true)
                    end
                }
            rescue 
              puts  "There is no game to load"    
            end
            
            
        end

        def display
            @correct_letters.each_char {|e| print e<<" "}
            puts "\nIncorrect letters: #{@incorrect_letters}"
            puts "Remaining guesses: #{@guesses_remaining}"
        end
    

    end

    game=Hangman.new
   
   










