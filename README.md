# Asteroid Attack Game
assembly 8086 game (for dosbox)
MADE BY ASHER EPSTEIN 
Welcome to Asteroid Attack! This assembly program is a simple game where the player controls a spaceship to dodge asteroids falling from the top of the screen.



![](https://github.com/asher-epstein-42/AsteroidAttack/blob/main/asteroid.gif)

## Prerequisites

Before running the program, make sure you have the following installed:

- [DOSBox](https://www.dosbox.com/): DOS emulator that allows you to run old DOS games and applications on modern operating systems.

## Running the Program

Follow these steps to run the Asteroid Attack game using DOSBox:

1. **Download the Files**: Ensure you have the "AsteroidAttack.ASM" file downloaded onto your computer.

2. **Launch DOSBox**: Open DOSBox on your system. You can usually find DOSBox in your list of installed applications or by searching for it.

3. **Mount the Directory**: In DOSBox, you need to mount the directory containing the "AsteroidAttack.ASM" file. Suppose your file is located in a folder named `asteroid_attack`. You can mount it using the following command:

```
mount c path/to/asteroid_attack
```
Replace `path/to/asteroid_attack` with the actual path to your directory.

4. **Navigate to the Directory**: Change the current directory to the one where your "AsteroidAttack.ASM" file is located. If you mounted the directory as drive `C:`, you can navigate to it using the following command:

```
C:
cd asteroid_attack
```
Replace `asteroid_attack` with the name of your directory.

5. **Assemble and Run the Program**: Once you're in the directory containing the "AsteroidAttack.ASM" file, you can assemble and run the program using the following commands:
```
nasm AsteroidAttack.ASM -o AsteroidAttack.COM
AsteroidAttack.COM
```
6. **Playing the Game**: Follow the on-screen instructions to play the game. Use the keyboard to control the spaceship and dodge the falling asteroids.

   - Move the spaceship left by pressing `z` or `Z`.
   - Move the spaceship right by pressing `x` or `X`.
   - If one of the asteroids hits the spaceship, the game is over.

## Exiting the Program

To exit the program and return to DOSBox, you can typically press `Alt + Enter` to toggle fullscreen mode. Then, you can close DOSBox by typing `exit` and pressing `Enter`.

If you encounter any issues or have questions, feel free to refer to the documentation provided with DOSBox or seek assistance from online forums and communities dedicated to DOSBox and assembly programming.

Enjoy playing the Asteroid Attack game!


THERE IS AN ASTEROID ATTACK! TRY TO DODGE THEM TO SURVIVE!



![](https://github.com/asher-epstein-42/AsteroidAttack/blob/main/asteroid.gif)
