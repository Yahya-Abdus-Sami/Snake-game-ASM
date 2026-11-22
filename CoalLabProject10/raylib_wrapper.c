#include "raylib.h"
#include "raylib_wrapper.h"
#include <time.h>

static Texture2D backdrop;

void Wrap_InitWindow(int width, int height, const char* title) {
    InitWindow(width, height, title);
}

void Wrap_SetTargetFPS(int fps) {
    SetTargetFPS(fps);
}

int Wrap_WindowShouldClose(void) {
    return WindowShouldClose() ? 1 : 0;
}

void Wrap_CloseWindow(void) {
    CloseWindow();
}

void Wrap_BeginDrawing(void) {
    BeginDrawing();
}

void Wrap_EndDrawing(void) {
    EndDrawing();
}

void Wrap_ClearBackground(unsigned int hexColor) {
    ClearBackground(GetColor(hexColor));
}

void Wrap_DrawRectangle(int x, int y, int w, int h, unsigned int hexColor) {
    DrawRectangle(x, y, w, h, GetColor(hexColor));
}

void Wrap_DrawRectangleLines(int x, int y, int w, int h, unsigned int hexColor) {
    DrawRectangleLines(x, y, w, h, GetColor(hexColor));
}

void Wrap_DrawText(const char* text, int x, int y, int fontSize, unsigned int hexColor) {
    DrawText(text, x, y, fontSize, GetColor(hexColor));
}

int Wrap_GetRandomValue(int min, int max)
{
    return GetRandomValue(min, max);
}

void Wrap_Srand(void)
{
    SetRandomSeed((unsigned int)time(NULL));
}

int Wrap_UserPressedUp(void) {
    return IsKeyPressed(KEY_UP);
}

int Wrap_UserPressedDown(void) {
    return IsKeyPressed(KEY_DOWN);
}

int Wrap_UserPressedLeft(void) {
    return IsKeyPressed(KEY_LEFT);
}

int Wrap_UserPressedRight(void) {
    return IsKeyPressed(KEY_RIGHT);
}

int Wrap_UserPressedS(void) {
    return IsKeyPressed(KEY_S);
}

void Wrap_LoadBackdrop(const char* path) {
    const char* paths[] = {
        path,
        "backdrop.png",
        "../backdrop.png",
        "../../backdrop.png",
        "../../../backdrop.png"
    };
    int count = sizeof(paths) / sizeof(paths[0]);

    backdrop.id = 0;
    for (int i = 0; i < count; i++) {
        if (paths[i] == 0) continue;
        backdrop = LoadTexture(paths[i]);
        if (IsTextureValid(backdrop)) {
            return;
        }
        if (backdrop.id != 0) {
            UnloadTexture(backdrop);
            backdrop.id = 0;
        }
    }
}

void Wrap_DrawBackdrop(int x, int y, unsigned int tint) {
    if (IsTextureValid(backdrop)) DrawTexture(backdrop, x, y, GetColor(tint));
}

void Wrap_UnloadBackdrop(void) {
    UnloadTexture(backdrop);
}

void Wrap_drawscore(int a) {
    DrawText(TextFormat("score= %d", a), 20, 20, 15, WHITE);
}


