
# Snake Game

A simple Snake game developed as part of my **COAL (Computer Organization and Assembly Language) Lab Project**. The game is built using **C, x86 Assembly (MASM), and raylib** for graphics.

## About the Game

This is a classic Snake game where you control a snake, move around the playing area, and eat food to increase your score.

### Features
- Eat food to increase your score.
- Use the arrow keys to control the snake's direction.
- Avoid colliding with yourself.
- The game ends when the snake collides with itself.

## Controls

| Key | Action |
|:---:|---|
| `S` | Start the game |
| `↑` | Move Up |
| `↓` | Move Down |
| `←` | Move Left |
| `→` | Move Right |
| Close Window | Exit the game |

## How to Run

1. Open `CoalLabProject10.sln` in Visual Studio.
2. Make sure MASM and raylib are properly installed and configured on your system.
3. Build the project in Visual Studio.
4. Run the application.

## Project Structure

```text
Snake-Game/
│
├── main.c
│
├── CoalLabProject10/
│   ├── snake.asm
│   ├── raylib_wrapper.c
│   └── raylib_wrapper.h
│
├── backdrop.png
│
└── CoalLabProject10.sln
```

## File Descriptions

| File | Description |
|---|---|
| `main.c` | Entry point of the application. Starts the game. |
| `snake.asm` | Contains most of the game's logic, implemented in x86 Assembly (MASM). |
| `raylib_wrapper.c` | Provides wrapper functions to connect the Assembly code with raylib. |
| `raylib_wrapper.h` | Header file containing wrapper function declarations. |
| `backdrop.png` | Background image used in the game. |
| `CoalLabProject10.sln` | Visual Studio solution file. |

## Technologies Used

- **C** – Application entry point and raylib integration.
- **x86 Assembly (MASM)** – Core game logic.
- **raylib** – Graphics and window management.
- **Visual Studio** – Development environment.

## Project Information

Developed as a COAL (Computer Organization and Assembly Language) Lab Project.
