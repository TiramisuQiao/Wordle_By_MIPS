# Wordle_By_MIPS
# Author: Junqiao Wang
# Mail : 2022141520188@stu.scu.edu.cn
Currently, the program implements the following features:
1.Anomaly Detection：
-If the player chooses the wrong number for the opening, they will be asked to re-enter it
-If the player enters fewer than 5 characters, a new entry will be requested
-If a player enters a word with non-lowercase letters, such as capital letters and other characters, they are asked to re-enter it
2.Debug Mode:
-To help developers understand the performance of the program more quickly, there is a developer mode within the program
-0 is Normal Mode and 1 is Debug Mode
-Debug Mode will show the correct string the player will guess
3.Method of implementation of the entire program
-Load in Random puzzles:
The program is generated as a random number, which is then multiplied by 5 to obtain the position of the first letter of the randomized word, from which the correct word is then stored in RAM using a register, which will be loaded into the $s# register during the game.
-Wordle Judgment Method
Ⅰ.Judge the abnormal input.
Ⅱ.Determine how many plays a player has left
Ⅲ.The first loop determines if it's completely correct,If you're absolutely right, you win outright.
Ⅳ.The second loop judges each input individually, first determining if it is of exactly the right type, and if not then determining if it is inside the character
4.Here's an FYI on the multiple rounds of wordle game. That is, all the five words in the array is reachable.
====================================
Welcome to Wordle, let's play a game
====================================
What do you want to do?
 (1) Play
 (2) Quit
1
Make your guess:smart
 s   m  (a)  r   t  
Make your guess:alige
Yay :)
The word is indeed:alige

====================================
Welcome to Wordle, let's play a game
====================================
What do you want to do?
 (1) Play
 (2) Quit
1
Make your guess:pixel
 p  (i)  x  (e) (l) 
Make your guess:alige
Yay :)
The word is indeed:alige

====================================
Welcome to Wordle, let's play a game
====================================
What do you want to do?
 (1) Play
 (2) Quit
1
Make your guess:smart
[s]  m   a   r   t  
Make your guess:spell
Yay :)
The word is indeed:spell

====================================
Welcome to Wordle, let's play a game
====================================
What do you want to do?
 (1) Play
 (2) Quit
1
Make your guess:pixel
 p   i   x  (e) (l) 
Make your guess:alige
 a  (l)  i   g  (e) 
Make your guess:spell
 s   p  (e) [l] (l) 
Make your guess:hello
Yay :)
The word is indeed:hello

====================================
Welcome to Wordle, let's play a game
====================================
What do you want to do?
 (1) Play
 (2) Quit
1
Make your guess:pixel
 p   i   x  (e) (l) 
Make your guess:hello
Yay :)
The word is indeed:hello

====================================
Welcome to Wordle, let's play a game
====================================
What do you want to do?
 (1) Play
 (2) Quit
1
Make your guess:smart
Yay :)
The word is indeed:smart

====================================
Welcome to Wordle, let's play a game
====================================
What do you want to do?
 (1) Play
 (2) Quit
1
Make your guess:alige
 a  (l) (i)  g  (e) 
Make your guess:pixel
Yay :)
The word is indeed:pixel

====================================
Welcome to Wordle, let's play a game
====================================
What do you want to do?
 (1) Play
 (2) Quit
2

-- program is finished running --
