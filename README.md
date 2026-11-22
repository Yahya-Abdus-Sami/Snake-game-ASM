Snake Game

A simple Snake game developed as part of my COAL (Computer Organization and Assembly Language) lab project. The game is built using C, x86 Assembly (MASM), and raylib for graphics.

About the Game

This is a classic Snake game where you control a snake, move around the playing area, and eat food to increase your score.

Eat food to increase your score.
Use the arrow keys to control the snake's direction.
Avoid colliding with yourself.
The game ends when the snake hits itself.
Controls
Key	Action
S	Start the game
↑ ↓ ← →	Move the snake
Close Window	Exit the game
How to Run
Open CoalLabProject10.sln in Visual Studio.
Make sure MASM and raylib are properly installed and configured on your system.
Build the project in Visual Studio.
Run the application.
Project Structure
text
Snake-Game/
│
├── main.c
├── CoalLabProject10/
│   ├── snake.asm
│   ├── raylib_wrapper.c
│   └── raylib_wrapper.h
│
├── backdrop.png
└── CoalLabProject10.sln

File Descriptions
File	Description
main.c	Entry point of the application. Starts the game.
snake.asm	Contains most of the game's logic, implemented in x86 Assembly (MASM).
raylib_wrapper.c	Provides wrapper functions to connect the Assembly code with raylib.
raylib_wrapper.h	Header file containing wrapper function declarations.
backdrop.png	Background image used in the game.
CoalLabProject10.sln	Visual Studio solution file.
Technologies Used
C – Application entry point and raylib integration.
x86 Assembly (MASM) – Core game logic.
raylib – Graphics and window management.
Visual Studio – Development environment.

Developed as a COAL Lab Project.
