INCLUDE Irvine32.inc
INCLUDE macros.inc
INCLUDE proto.inc
INCLUDE extraMacros.inc

.386
.model flat, STDCALL
.stack 4096
ExitProcess PROTO, dwExitCode:DWORD
.data
; declare variables here

.code
LoginUsername PROC C, 
	maxSize:DWORD,
	loginStaffUsername:PTR BYTE,
	usernameSize:DWORD

	LOCAL inputLength:DWORD
		
	input:
		mWrite <"                                  Username : ">

		mov edx, loginStaffUsername							; point to currentStaffUserame
		mov ecx, maxSize									; specify the max length the input receive
		call ReadString										; input currentStaffName
		mov inputLength, eax								; get the number of character
		mov eax, usernameSize								; get the limited staffName character receive
		dec eax

		;If Input is empty
		.IF (inputLength == 0)
			call Crlf
			;Call The Login Error from extraMacros.inc
			mMainMenuError <"              No Input Detected! Input again              ", 0dh, 0ah>
			call Crlf
			jmp input
		.ENDIF

		;To check if the input length exceed
		.IF (inputLength > eax)
			call Crlf
			;Call The Login Error from extraMacros.inc
			mMainMenuError <"          Maximum Length Detected! Input again            ", 0dh, 0ah>
			call Crlf
			jmp input
		.ENDIF

		;Only allow character and number
		mov ecx, inputLength
		mov esi, loginStaffUsername

		checkStaffUsername:
			.IF ((BYTE PTR [esi] < 030h || BYTE PTR [esi] > 039h) && (BYTE PTR [esi] < 041h || BYTE PTR [esi] > 05Ah) && (BYTE PTR [esi] < 061h || BYTE PTR [esi] > 07Ah))
				call Crlf
				;Call The Login Error from extraMacros.inc
				mMainMenuError <"       Only allow character and number! Input again       ", 0dh, 0ah>
				call Crlf
				jmp input
			.ENDIF
			inc esi
			loop checkStaffUsername
	ret
LoginUsername ENDP

LoginPassword PROC C,
	loginStaffPassword:PTR BYTE, 
	passwordSize:DWORD

	input:
		mWrite <"                                  Password : ">
		mov esi, loginStaffPassword									; to assign character to the address
		mov ebx, 0													; to calculate the length of character
		mov edx, 00h												; to assign null to character

	notEnoughChar:

		.REPEAT
			call ReadChar

			;If backspace Key is pressed, and esi is still above 0
			.IF (al == 8 && ebx > 0)
				dec	esi									; decrement staffPassword address
				dec ebx									; decrement length
				mov [esi], edx							; set the character to null
				INVOKE backspace						; remove last output character (call from C++)
			;// If Input is not special KEY
			.ELSEIF (al >= 020h && al <= 07Eh)
				mov [esi], al							; assign character to password address
				mWrite <"*">							; output '*'
				inc esi									; increment staffPassword address
				inc ebx									; increment length
			.ENDIF

		
		;// If input is Enter KEY
		.UNTIL (al == 13)

		;// If Password Exceed String Length
			.IF (ebx >= passwordSize)
				call Crlf
				call Crlf
				;Call The Login Error from extraMacros.inc
				mMainMenuError <"           Maximum Length Detected! Input again           ", 0dh, 0ah>
				call Crlf

				mov ecx, ebx							; assign total number of length to ecx
				mov esi, loginStaffPassword				; assign esi to offset 0 of staffPassword

				;//loop through character to reset string
				clearPasswordArray:
					mov [esi], edx						; assign null to character
					inc esi								; increment staffPassword address
					loop clearPasswordArray				; loop until ecx become zero

				jmp input								; and then jump back to input password
			.ENDIF

		;// If the Password is empty, jmp back to password input
		.IF (ebx == 0)
			call Crlf
			call Crlf
			;Call The Login Error from extraMacros.inc
			mMainMenuError <"              No Input Detected! Input again              ", 0dh, 0ah>
			call Crlf
			jmp input										; and then jump back to input password
		.ENDIF

		mov eax, ebx										; return the password size				
	ret
LoginPassword ENDP
END