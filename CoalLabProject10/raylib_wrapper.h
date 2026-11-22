#pragma once
#ifndef RAYLIB_WRAPPER_H
#define RAYLIB_WRAPPER_H

void Wrap_InitWindow(int width, int height, const char* title);
void Wrap_SetTargetFPS(int fps);
int  Wrap_WindowShouldClose(void);
void Wrap_CloseWindow(void);

void Wrap_BeginDrawing(void);
void Wrap_EndDrawing(void);
void Wrap_ClearBackground(unsigned int hexColor);
void Wrap_DrawRectangle(int x, int y, int w, int h, unsigned int hexColor);
void Wrap_DrawRectangleLines(int x, int y, int w, int h, unsigned int hexColor);
void Wrap_DrawText(const char* text, int x, int y, int fontSize, unsigned int hexColor);
int Wrap_GetRandomValue(int min, int max);
void Wrap_Srand(void);
int Wrap_UserPressedUp(void);
int Wrap_UserPressedDown(void);
int Wrap_UserPressedLeft(void);
int Wrap_UserPressedRight(void);
void Wrap_LoadBackdrop(const char* path);
void Wrap_DrawBackdrop(int x, int y, unsigned int tint);
void Wrap_UnloadBackdrop(void);
void Wrap_drawscore(int a);
#endif