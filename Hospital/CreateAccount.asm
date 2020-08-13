INCLUDE Irvine32.inc
INCLUDE macros.inc
INCLUDE proto.inc
INCLUDE extraMacros.inc

.386
.model flat,stdcall
.stack 4096
ExitProcess PROTO, dwExitCode:DWORD
.data
; declare variables here

.code

InputStaffName PROC C, 
	maxSize:DWORD,											; maximum input for read
	staffName:PTR BYTE,										; point to the staffName address
	staffNameSize:DWORD										; get the staffName Size
	
	LOCAL inputLength:DWORD, characterFound:DWORD			; get the number of bytes returns from ReadString

	input:
		mWrite <"                                 Staff Name: ">
		
		mov edx, staffName					; point to staffName
		mov ecx, maxSize					; specify the max length the input receive
		call ReadString						; input staffName
		mov inputLength, eax				; get the number of character
		mov eax, staffNameSize				; get the limited staffName character receive
		dec eax
			
		;If Input is empty
		.IF (inputLength == 0)
			call Crlf
			mMainMenuError <"              No Input Detected! Input again              ", 0dh, 0ah>
			call Crlf
			jmp input
		.ENDIF

		;To check if the input length exceed
		.IF (inputLength > eax)
			call Crlf
			mMainMenuError <"           Maximum Length Detected! Input again           ", 0dh, 0ah>
			call Crlf
			jmp input
		.ENDIF

		;Only allow character
		mov ecx, inputLength
		mov esi, staffName
		mov characterFound, 0

		checkStaffName:
			;//Only allowed a-z, A-Z, Space
			.IF ((BYTE PTR [esi] < 041h || BYTE PTR [esi] > 05Ah) && (BYTE PTR [esi] < 061h || BYTE PTR [esi] > 07Ah) && (BYTE PTR [esi] != 020h))
				call Crlf
				mMainMenuError <"       Only allow character and number! Input again       ", 0dh, 0ah>
				call Crlf
				jmp input
			.ENDIF

			;//This is to check if every character has at least one character, not all space, eg: _a__
			.IF ((characterFound == 0) && (BYTE PTR [esi] != 020h))
				mov characterFound, 1
			.ENDIF

			inc esi
			loop checkStaffName

		;//If no characterFound, input again
		.IF (characterFound == 0)
			call Crlf
			mMainMenuError <"          Must at least 1 character! Input again          ", 0dh, 0ah>
			call Crlf
			jmp input
		.ENDIF

	ret
InputStaffName ENDP

InputStaffUsername PROC C, 
	maxSize:DWORD,									; maximum input for read
	staffUsername:PTR BYTE,							; point to the staffUsername address
	staffUsernameSize:DWORD							; get the staffUsername Size
	
	LOCAL inputLength:DWORD							; To get the number of bytes returns from ReadString

	input:
		mWrite <"                                   Username: ">
		
		mov edx, staffUsername						; point to staffName
		mov ecx, maxSize							; specify the max length the input receive
		call ReadString								; input staffName
		mov inputLength, eax						; get the number of character
		mov eax, staffUsernameSize					; get the limited staffName character receive
		dec eax

		;If Input is empty
		.IF (inputLength == 0)
			call Crlf
			mMainMenuError <"              No Input Detected! Input again              ", 0dh, 0ah>
			call Crlf
			jmp input
		.ENDIF

		;To check if the input length is less than 3
		.IF (inputLength < 3)
			call Crlf
			mMainMenuError <"            Username must at least 3 character            ", 0dh, 0ah>
			call Crlf
			jmp input
		.ENDIF
		
		;To check if the input length exceed
		.IF (inputLength > eax)
			call Crlf
			mMainMenuError <"           Maximum Length Detected! Input again           ", 0dh, 0ah>
			call Crlf
			jmp input
		.ENDIF
		
		;Only allow character and number
		mov ecx, inputLength
		mov esi, staffUsername

		checkStaffUsername:
			.IF ((BYTE PTR [esi] < 030h || BYTE PTR [esi] > 039h) && (BYTE PTR [esi] < 041h || BYTE PTR [esi] > 05Ah) && (BYTE PTR [esi] < 061h || BYTE PTR [esi] > 07Ah))
				call Crlf
				mMainMenuError <"       Only allow character and number! Input again       ", 0dh, 0ah>
				call Crlf
				jmp input
			.ENDIF
			inc esi
			loop checkStaffUsername

		;Check if username already existed
		INVOKE readUsername, staffUsername
		.IF (eax == 1)
			call Crlf
			mMainMenuError <"              Username Existed! Input again               ", 0dh, 0ah>
			call Crlf
			jmp input
		.ENDIF

	ret
InputStaffUsername ENDP

InputStaffPassword PROC C, 
	staffPassword:PTR BYTE,						; point to the staffPassword address
	staffPasswordSize:DWORD						; get the staffPassword size

	input:
		mWrite <"                                   Password: ">
		mov esi, staffPassword					; to assign character to the address
		mov ebx, 0								; to calculate the length of character
		mov edx, 00h							; to assign null to character

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

			;// If Password Exceed String Length
			.IF (ebx == staffPasswordSize)
				call Crlf
				call Crlf
				mMainMenuError <"           Maximum Length Detected! Input again           ", 0dh, 0ah>
				call Crlf

				mov ecx, ebx							; assign total number of length to ecx
				mov esi, staffPassword					; assign esi to offset 0 of staffPassword

				;//loop through character to reset string
				clearPasswordArray:
					mov [esi], edx						; assign null to character
					inc esi								; increment staffPassword address
					loop clearPasswordArray				; loop until ecx become zero

				jmp input								; and then jump back to input password
			.ENDIF
		;// If input is Enter KEY
		.UNTIL (al == 13)

		;// If the Password is empty, jmp back to password input
		.IF (ebx == 0)
			call Crlf
			call Crlf
			mMainMenuError <"              No Input Detected! Input again              ", 0dh, 0ah>
			call Crlf
			jmp input										; and then jump back to input password
		;//If Password is below 8 character
		.ELSEIF (ebx < 8)
			call Crlf
			call Crlf
			mMainMenuError <"            Password must at least 8 character!           ", 0dh, 0ah>
			call Crlf

			;//rewrite the existing password user has typed
			mWrite <"                                   Password: ">
			mov ecx, ebx

			writeAsterisk:
				mWrite <"*">
				loop writeAsterisk


			jmp notEnoughChar								; and then jump back to input password
		.ENDIF
		
		mov eax, ebx										; return the password size
	ret
InputStaffPassword ENDP

encryptPassword PROC C, 
	staffPassword:PTR BYTE,
	encryptKey:DWORD,
	passwordSize:DWORD

	mov edi, staffPassword
	mov ecx, passwordSize
	mov ebx, encryptKey

	encryptByte:
		xor [edi], ebx 
		inc edi
		loop encryptByte

	ret
encryptPassword ENDP
END