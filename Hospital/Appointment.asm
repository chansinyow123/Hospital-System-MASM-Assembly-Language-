INCLUDE Irvine32.inc
INCLUDE macros.inc
INCLUDE proto.inc

.386
.model flat, STDCALL
.stack 4096
.data

.code
InputYear PROC C, 
	currentYear:DWORD

	input:
		mWrite <"                 Appointment Year (">
		mov eax, currentYear
		call WriteDec
		mWrite <"-">
		add eax, 5
		call WriteDec
		mov ebx, eax					; move the added 5 year to ebx, for future use
		mWrite <"): ">

		call ReadInt
		.IF OVERFLOW? || (eax < currentYear) || (eax > ebx)
			call Crlf
			mWrite  <"Must within ">
			mov eax, currentYear
			call WriteDec
			mWrite <"-">
			add eax, 5
			call WriteDec
			mWrite <" Year!", 0dh, 0ah>
			call Crlf
			jmp input
		.ENDIF
	ret
InputYear ENDP

InputMonth PROC C

	input:
		mWrite <"                      Appointment Month (1-12): ">
		call ReadInt
		.IF OVERFLOW? || (eax < 1) || (eax > 12)
			call Crlf
			mWrite  <"Must within 1-12 Month!", 0dh, 0ah>
			call Crlf
			jmp input
		.ENDIF
	ret
InputMonth ENDP

InputDay PROC C, 
	yearInput:DWORD,
	monthInput:DWORD

	LOCAL remainder:DWORD, maxDay:DWORD, leap:DWORD


	; To calculate is the input year a leap year
	.IF (monthInput == 2)
		xor edx, edx
		mov eax, yearInput
		mov leap, 4
		div leap
		mov remainder, edx

		.IF (remainder == 0)							; if leap year, then max day is 29
			mov maxDay, 29
		.ELSE											; else, max day is 28
			mov maxDay, 28
		.ENDIF
	; To check if the month has 31 max day
	.ELSEIF (monthInput == 1 || monthInput == 3 || monthInput == 5 || monthInput == 7 || monthInput == 8 || monthInput == 10 || monthInput == 12)
		mov maxDay, 31
	.ELSE												; else, max day is 30
		mov maxDay, 30
	.ENDIF

	input:
		mWrite <"                        Appointment Day (1-">
		mov eax, maxDay
		call WriteDec
		mWrite <"): ">
		call ReadInt
		.IF OVERFLOW? || (eax < 1) || (eax > maxDay)
			call Crlf
			mWrite  <"Must within 1-">
			mov eax, maxDay
			call WriteDec
			mWrite <" Day!", 0dh, 0ah>
			call Crlf
			jmp input
		.ENDIF
	ret
InputDay ENDP

InputHour PROC C

	input:
		mWrite <"                       Appointment Hour (0-23): ">

		call ReadInt
		.IF OVERFLOW? || (eax < 0) || (eax > 23)
			call Crlf
			mWrite  <"Must within 0-23 Hour!">
			call Crlf
			jmp input
		.ENDIF

	ret
InputHour ENDP

InputMinute PROC C

	input:
		mWrite <"                     Appointment Minute (0-59): ">

		call ReadInt
		.IF OVERFLOW? || (eax < 0) || (eax > 59)
			call Crlf
			mWrite  <"Must within 0-59 Minute!">
			call Crlf
			jmp input
		.ENDIF
	ret
InputMinute ENDP



InputDoctor PROC C,
	maxSize:DWORD,											; maximum input for read
	doctorName:PTR BYTE,									; point to the doctorName address
	doctorNameSize:DWORD									; get the doctorName Size

	LOCAL inputLength:DWORD, characterFound:DWORD			; get the number of bytes returns from ReadString

	input:
		mWrite <"                                   Doctor Name: ">
		
		mov edx, doctorName									; point to doctorName
		mov ecx, maxSize									; specify the max length the input receive
		call ReadString										; input doctorName
		mov inputLength, eax								; get the number of character
		mov eax, doctorNameSize								; get the limited doctorName character receive
		dec eax
			
		;If Input is empty
		.IF (inputLength == 0)
			call Crlf
			mWrite  <"No Input Detected! Input again", 0dh, 0ah>
			call Crlf
			jmp input
		.ENDIF

		;To check if the input length exceed
		.IF (inputLength > eax)
			call Crlf
			mWrite  <"Maximum Length Detected! Input again", 0dh, 0ah>
			call Crlf
			jmp input
		.ENDIF

		;Only allow character
		mov ecx, inputLength
		mov esi, doctorName
		mov characterFound, 0

		checkPatientName:
			;//Only allowed a-z, A-Z, Space
			.IF ((BYTE PTR [esi] < 041h || BYTE PTR [esi] > 05Ah) && (BYTE PTR [esi] < 061h || BYTE PTR [esi] > 07Ah) && (BYTE PTR [esi] != 020h))
				call Crlf
				mWrite  <"Only allow character and space! Input again", 0dh, 0ah>
				call Crlf
				jmp input
			.ENDIF

			;//This is to check if every character has at least one character, not all space, eg: _a__
			.IF ((characterFound == 0) && (BYTE PTR [esi] != 020h))
				mov characterFound, 1
			.ENDIF

			inc esi
			loop checkPatientName

		;//If no characterFound, input again
		.IF (characterFound == 0)
			call Crlf
			mWrite  <"Must at least 1 character! Input again", 0dh, 0ah>
			call Crlf
			jmp input
		.ENDIF

	ret
InputDoctor ENDP
END