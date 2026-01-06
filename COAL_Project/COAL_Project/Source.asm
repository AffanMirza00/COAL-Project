INCLUDE Irvine32.inc

.data
; Constants
CORRECT_PIN DWORD 1234           ; The correct PIN
balance DWORD 5000              ; Initial balance

; Messages
welcomeMsg BYTE "=== Welcome to ATM Machine ===",0
pinPrompt BYTE "Enter your 4-digit PIN: ",0
successMsg BYTE "Login successful!",0
errorMsg BYTE "Invalid PIN! Please try again.",0
lockedMsg BYTE "Too many attempts! Account locked.",0

; Menu
menuMsg BYTE "========== ATM MENU ==========",0
option1 BYTE "1. Check Balance",0
option2 BYTE "2. Deposit Money",0
option3 BYTE "3. Withdraw Money",0
option4 BYTE "4. Exit",0
choicePrompt BYTE "Enter your choice (1-4): ",0

; Balance messages
balanceMsg BYTE "Your current balance is: $",0
newBalanceMsg BYTE "Your new balance is: $",0

; Deposit messages
depositPrompt BYTE "Enter amount to deposit: $",0
invalidDepositMsg BYTE "Invalid amount! Must be positive.",0
depositSuccess BYTE "Deposit successful!",0

; Withdrawal messages
withdrawPrompt BYTE "Enter amount to withdraw: $",0
invalidWithdrawMsg BYTE "Invalid amount! Must be positive.",0
insufficientMsg BYTE "Insufficient balance!",0
withdrawSuccess BYTE "Withdrawal successful!",0

; Other messages
thankYouMsg BYTE "Thank you for using our ATM. Goodbye!",0
pressKeyMsg BYTE "Press any key to continue...",0
line BYTE "-----------------------------------",0

; Variables
attempts DWORD 0
maxAttempts DWORD 3
userInput DWORD 0
userChoice DWORD 0
amount DWORD 0

.code
main PROC
    ; Display welcome message
    mov edx, OFFSET welcomeMsg
    call WriteString
    call Crlf
    call Crlf

login:
    ; Check if too many attempts
    mov eax, attempts
    cmp eax, maxAttempts
    je account_locked
    
    ; Ask for PIN
    mov edx, OFFSET pinPrompt
    call WriteString
    call ReadInt
    mov userInput, eax
    
    ; Validate PIN
    mov eax, userInput
    cmp eax, CORRECT_PIN
    je pin_correct
    
    ; Incorrect PIN
    inc attempts
    mov edx, OFFSET errorMsg
    call WriteString
    call Crlf
    
    ; Show attempts left
    mov eax, maxAttempts
    sub eax, attempts
    call WriteDec
    mov al, ' '
    call WriteChar
    mov al, 'a'
    call WriteChar
    mov al, 't'
    call WriteChar
    mov al, 't'
    call WriteChar
    mov al, 'e'
    call WriteChar
    mov al, 'm'
    call WriteChar
    mov al, 'p'
    call WriteChar
    mov al, 't'
    call WriteChar
    mov al, '('
    call WriteChar
    mov al, 's'
    call WriteChar
    mov al, ')'
    call WriteChar
    mov al, ' '
    call WriteChar
    mov al, 'l'
    call WriteChar
    mov al, 'e'
    call WriteChar
    mov al, 'f'
    call WriteChar
    mov al, 't'
    call WriteChar
    call Crlf
    call Crlf
    
    jmp login
    
account_locked:
    mov edx, OFFSET lockedMsg
    call WriteString
    call Crlf
    jmp exit_program
    
pin_correct:
    mov edx, OFFSET successMsg
    call WriteString
    call Crlf
    call Crlf
    
    ; Reset attempts counter
    mov attempts, 0
    
menu_loop:
    ; Display menu
    mov edx, OFFSET line
    call WriteString
    call Crlf
    
    mov edx, OFFSET menuMsg
    call WriteString
    call Crlf
    
    mov edx, OFFSET option1
    call WriteString
    call Crlf
    
    mov edx, OFFSET option2
    call WriteString
    call Crlf
    
    mov edx, OFFSET option3
    call WriteString
    call Crlf
    
    mov edx, OFFSET option4
    call WriteString
    call Crlf
    
    mov edx, OFFSET line
    call WriteString
    call Crlf
    
    ; Get user choice
    mov edx, OFFSET choicePrompt
    call WriteString
    call ReadInt
    mov userChoice, eax
    call Crlf
    
    ; Process choice
    cmp eax, 1
    je check_balance
    
    cmp eax, 2
    je deposit_money
    
    cmp eax, 3
    je withdraw_money
    
    cmp eax, 4
    je exit_program
    
    ; Invalid choice - show menu again
    jmp menu_loop
    
check_balance:
    ; Display balance
    mov edx, OFFSET balanceMsg
    call WriteString
    mov eax, balance
    call WriteDec
    mov al, '.'
    call WriteChar
    mov al, '0'
    call WriteChar
    mov al, '0'
    call WriteChar
    call Crlf
    jmp continue_loop
    
deposit_money:
    ; Ask for deposit amount
    mov edx, OFFSET depositPrompt
    call WriteString
    call ReadInt
    mov amount, eax
    
    ; Validate amount
    cmp eax, 0
    jle invalid_deposit
    
    ; Add to balance
    add balance, eax
    
    ; Display success message
    mov edx, OFFSET depositSuccess
    call WriteString
    call Crlf
    
    mov edx, OFFSET newBalanceMsg
    call WriteString
    mov eax, balance
    call WriteDec
    mov al, '.'
    call WriteChar
    mov al, '0'
    call WriteChar
    mov al, '0'
    call WriteChar
    call Crlf
    jmp continue_loop
    
invalid_deposit:
    mov edx, OFFSET invalidDepositMsg
    call WriteString
    call Crlf
    jmp continue_loop
    
withdraw_money:
    ; Ask for withdrawal amount
    mov edx, OFFSET withdrawPrompt
    call WriteString
    call ReadInt
    mov amount, eax
    
    ; Validate amount
    cmp eax, 0
    jle invalid_withdraw
    
    ; Check if enough balance
    cmp eax, balance
    jg insufficient_funds
    
    ; Subtract from balance
    sub balance, eax
    
    ; Display success message
    mov edx, OFFSET withdrawSuccess
    call WriteString
    call Crlf
    
    mov edx, OFFSET newBalanceMsg
    call WriteString
    mov eax, balance
    call WriteDec
    mov al, '.'
    call WriteChar
    mov al, '0'
    call WriteChar
    mov al, '0'
    call WriteChar
    call Crlf
    jmp continue_loop
    
invalid_withdraw:
    mov edx, OFFSET invalidWithdrawMsg
    call WriteString
    call Crlf
    jmp continue_loop
    
insufficient_funds:
    mov edx, OFFSET insufficientMsg
    call WriteString
    call Crlf
    jmp continue_loop
    
continue_loop:
    ; Wait for user to continue
    call Crlf
    mov edx, OFFSET pressKeyMsg
    call WriteString
    call ReadChar
    call Crlf
    jmp menu_loop
    
exit_program:
    ; Display thank you message
    call Crlf
    mov edx, OFFSET thankYouMsg
    call WriteString
    call Crlf
    call Crlf
    
    exit
main ENDP
END main