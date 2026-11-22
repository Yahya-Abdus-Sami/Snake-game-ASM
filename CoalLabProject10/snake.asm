.686
INCLUDE Irvine32.inc

; External C wrapper procedures
Wrap_InitWindow        PROTO C, winWidth:SDWORD, winHeight:SDWORD, winTitle:PTR BYTE
Wrap_SetTargetFPS      PROTO C, fps:DWORD
Wrap_WindowShouldClose PROTO C
Wrap_CloseWindow       PROTO C
Wrap_BeginDrawing    PROTO C
Wrap_EndDrawing      PROTO C
Wrap_ClearBackground PROTO C, hexColor:DWORD
Wrap_DrawRectangle      PROTO C, x:SDWORD, y:SDWORD, w:SDWORD, h:SDWORD, hexColor:DWORD
Wrap_DrawRectangleLines PROTO C, x:SDWORD, y:SDWORD, w:SDWORD, h:SDWORD, hexColor:DWORD
Wrap_DrawText           PROTO C, text:PTR BYTE, x:SDWORD, y:SDWORD, fontSize:SDWORD, hexColor:DWORD
Wrap_UserPressedUp PROTO C
Wrap_UserPressedDown PROTO C
Wrap_UserPressedLeft PROTO C
Wrap_UserPressedRight PROTO C
Wrap_GetRandomValue PROTO C, minVal:SDWORD, maxVal:SDWORD 
Wrap_Srand           PROTO C
Wrap_LoadBackdrop PROTO C, path:PTR BYTE
Wrap_DrawBackdrop PROTO C, x:SDWORD, y:SDWORD, tint:DWORD
Wrap_UnloadBackdrop PROTO C 
Wrap_UserPressedS PROTO C
Wrap_drawscore PROTO C a:DWORD
.data

CELL EQU 20
COLS EQU 30
ROWS EQU 20
SWIDTH EQU 600
SHEIGHT EQU 400
MAX_LEN EQU 100
STARTLEN EQU 3
FRAMES_PER_MOVE EQU 8
SnakeBodyColor EQU 0309C55FFh
SnakeHeadColor EQU 02A573AFFh

snakeX SDWORD MAX_LEN DUP(?)
snakeY SDWORD MAX_LEN DUP(?)

prevX SDWORD MAX_LEN DUP(?)
prevY SDWORD MAX_LEN DUP(?)

snakeLen SDWORD ?
dirX     SDWORD ?
dirY     SDWORD ?
foodX    SDWORD ?
foodY    SDWORD ?
score    SDWORD ?
gameOver SDWORD ?
frames   SDWORD ?
started  SDWORD ?
turned   SDWORD ?


consoleMsg BYTE "Irvine32 + MASM + Raylib linked successfully!", 0
screenMsg  BYTE "I MASM + RAYLIB", 0
startScreenMsgStr BYTE "PRESS S to Start",0
gameOverMsg BYTE "GAME OVER", 0
exitMsg BYTE "CLOSE WINDOW TO EXIT", 0
backdroloc BYTE "backdrop.png",0
snakeGameTitle BYTE "SNAKE GAME",0
.code

; ---------------------------------
; OnSnake(x, y)
; Returns 1 if coordinate exists on the snake, else 0
; ---------------------------------
OnSnake PROC C x:SDWORD, y:SDWORD
    xor ecx, ecx              ; i = 0

CheckLoop:
    cmp ecx, snakeLen
    jge NotFound

    mov eax, snakeX[ecx*4]
    cmp eax, x
    jne NextCell

    mov eax, snakeY[ecx*4]
    cmp eax, y
    jne NextCell

    mov eax, 1                ; found
    ret

NextCell:
    inc ecx
    jmp CheckLoop

NotFound:
    xor eax, eax              ; not found
    ret
OnSnake ENDP

PlaceFood PROC C

GenerateFoodRetry:
        INVOKE Wrap_GetRandomValue, 0, COLS - 1
        mov foodX, eax
        INVOKE Wrap_GetRandomValue, 0, ROWS - 1
        mov foodY, eax
        INVOKE OnSnake, foodX, foodY
        cmp eax, 0
    jne GenerateFoodRetry
    ret

PlaceFood ENDP

resetGame PROC uses eax ebx ecx edx
    mov ecx,STARTLEN
    mov snakeLen,STARTLEN
    
    InitSnakeBodyLoop:
        mov eax,STARTLEN
        sub eax,ecx
        mov ebx,COLS
        mov edx,ROWS
        shr ebx,1
        shr edx,1
        sub ebx,eax
        mov SnakeX[eax*4],ebx
        mov SnakeY[eax*4],edx
    loop InitSnakeBodyLoop
    
    mov DirX,1
    mov DirY,0
    mov gameOver,0
    mov frames,0
    mov turned,0
    mov Score,0

    call placefood

    ret
resetGame endp

    
ReadInput PROC USES eax

    cmp turned, 1
    jne InputSideChecks
    jmp endInput

InputSideChecks:
    cmp dirY, 0
    jne CheckHorizontal

    call Wrap_UserPressedUp
    test eax, eax
    jz ReadInput_CheckDown

    mov dirX, 0
    mov dirY, -1
    mov turned, 1
    jmp endInput

    ReadInput_CheckDown:
    call Wrap_UserPressedDown
    test eax, eax
    jz endInput

    mov dirX, 0
    mov dirY, 1
    mov turned, 1
    jmp endInput

    CheckHorizontal:
    cmp dirX, 0
    jne endInput

    call Wrap_UserPressedLeft
    test eax, eax
    jz testright

    mov DirX, -1
    mov dirY, 0
    mov turned, 1
    jmp endInput

    testright:
    call Wrap_UserPressedRight
    test eax, eax
    jz endInput

    mov DirX, 1
    mov dirY, 0
    mov turned, 1

    endInput:
    ret

ReadInput ENDP

StepSnake PROC uses eax ebx ecx edx
    LOCAL nextX:SDWORD
    LOCAL nextY:SDWORD
    LOCAL tailX:SDWORD
    LOCAL tailY:SDWORD

    mov eax,snakeX[0]
    add eax,dirX
    mov ebx,snakeY[0]
    add ebx,dirY
    mov nextX,eax
    mov nextY,ebx

    cmp nextx,0
    jl gameoverlbl
    cmp nexty,0
    jl gameoverlbl
    cmp nextx,COLS
    jge gameoverlbl
    cmp nexty,ROWS
    jge gameoverlbl

    jmp gameNotOver
    gameoverlbl:
        mov gameOver,1
        ret
    gameNotOver:

    mov ecx,snakelen
    sub ecx,2
    mov edx,1
    
    cmp ecx,0
    jle collisionDone

    checkCollisionLoop:
        push ecx
        mov ecx,nextX
        cmp snakeX[edx*4],ecx
        pop ecx

        jne next

        push ecx
        mov ecx,nexty
        cmp snakeY[edx*4],ecx
        pop ecx
        jne next

        mov gameover,1
        ret

        next:
        inc edx
    loop checkCollisionLoop
    collisionDone:

    mov eax,snakelen
    dec eax

    mov ebx,snakeX[eax*4]
    mov tailX,ebx

    mov ebx,snakeY[eax*4]
    mov tailY,ebx
    

    mov ecx,snakelen
    sub ecx,1

    snakeMoveLoop:
        mov eax,snakeX[ecx*4-4]
        mov ebx,snakeY[ecx*4-4]

        mov snakeX[ecx*4],eax
        mov snakeY[ecx*4],ebx
    loop snakeMoveLoop

    mov eax,NextX
    mov ebx,NextY

    mov snakeX[0],eax
    mov snakeY[0],ebx

    push ecx
    mov ecx,nextX
    cmp foodX,ecx
    pop ecx

    jne notate
    push ecx
    mov ecx,nextY
    cmp foodY,ecx
    pop ecx
    jne notate
    cmp snakelen,MAX_LEN
    jge spawnFood
    inc score

    mov eax,tailX
    mov ebx,tailY

    push ecx
    mov ecx,snakelen
    mov snakeX[ecx*4],eax
    mov snakeY[ecx*4],ebx
    pop ecx

    inc snakelen
    spawnFood:
    call placefood
    notate:

    ret
StepSnake ENDP

DrawStartScreen PROC c
    INVOKE Wrap_BeginDrawing
    INVOKE Wrap_ClearBackground, 000000FFh
    INVOKE  Wrap_DrawText, OFFSET startScreenMsgStr, 210,190,20,0FFFFFFFFh
    INVOKE Wrap_EndDrawing
    ret
DrawStartScreen ENDP

DrawFrame PROC USES eax ebx ecx edx

    INVOKE Wrap_BeginDrawing
    INVOKE Wrap_ClearBackground, 000000FFh
    INVOKE Wrap_DrawBackdrop, 0, 0, 0FFFFFFFFh
    INVOKE Wrap_DrawRectangleLines, 0, 0, SWIDTH, SHEIGHT, 404040FFh

    mov eax, foodX
    imul eax, CELL
    add eax, 4
    mov ebx, eax

    mov eax, foodY
    imul eax, CELL
    add eax, 4

    INVOKE Wrap_DrawRectangle, ebx, eax, CELL-8, CELL-8, 0FF0000FFh

    mov edx, 0
    mov ecx, snakeLen
    cmp ecx, 0
    jle CheckGameOver

DrawSnakeLoop:
    mov eax, snakeX[edx*4]
    imul eax, CELL
    add eax, 2
    mov ebx, eax

    mov eax, snakeY[edx*4]
    imul eax, CELL
    add eax, 2

    cmp edx, 0
    jne DrawBody

    push ecx
    push edx
    INVOKE Wrap_DrawRectangle, ebx, eax, CELL-4, CELL-4, 02A573AFFh
    pop edx
    pop ecx
    jmp NextSnake

DrawBody:
    push ecx
    push edx
    INVOKE Wrap_DrawRectangle, ebx, eax, CELL-4, CELL-4, 0309C55FFh
    pop edx
    pop ecx

NextSnake:
    inc edx
    loop DrawSnakeLoop

CheckGameOver:
    cmp gameOver, 1
    jne EndFrame

    INVOKE Wrap_DrawRectangle, 0, 0, SWIDTH, SHEIGHT, 000000BEh
    INVOKE Wrap_DrawText, OFFSET gameOverMsg, 200, 160, 40, 0FF0000FFh
    INVOKE Wrap_DrawText, OFFSET exitMsg, 200, 220, 20, 0808080FFh 
    INVOKE Wrap_drawscore, score

     
      
       
EndFrame:
    INVOKE Wrap_EndDrawing
    ret
DrawFrame ENDP

GAMELOOP PROC C
    INVOKE Wrap_InitWindow, 600, 400, OFFSET snakeGameTitle
    INVOKE Wrap_LoadBackdrop, OFFSET backdroloc
    INVOKE Wrap_SetTargetFPS, 60
    INVOKE Wrap_Srand
    mov started, 0

    MainLoop:
    call Wrap_WindowShouldClose
    test eax, eax
    jnz ExitLoop

    cmp started, 0
    jne GameActive

    call Wrap_UserPressedS
    test eax, eax
    jz ShowStart
    call resetGame
    mov started, 1
    jmp GameActive

    ShowStart:
    call DrawStartScreen
    jmp MainLoop

    GameActive:
    cmp gameOver, 0
    jne DrawOnly

    call ReadInput
    inc frames
    mov eax, frames
    cmp eax, FRAMES_PER_MOVE
    jl DrawOnly
    call StepSnake
    mov frames, 0
    mov turned, 0

    DrawOnly:
    call DrawFrame
    jmp MainLoop

    ExitLoop:
    INVOKE Wrap_UnloadBackdrop
    INVOKE Wrap_CloseWindow
    ret
GAMELOOP ENDP

Asm_UpdateAndDraw PROC C
    INVOKE Wrap_BeginDrawing
    INVOKE Wrap_ClearBackground, 0181818FFh
    INVOKE Wrap_DrawRectangle, 250, 150, 100, 100, 0309C55FFh
    INVOKE Wrap_DrawText, OFFSET screenMsg, 165, 100, 20, 0FFFFFFFFh
    INVOKE Wrap_EndDrawing
    ret
Asm_UpdateAndDraw ENDP

END