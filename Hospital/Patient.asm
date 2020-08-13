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
InputPatientName PROC C,
	maxSize:DWORD,											; maximum input for read
	patientName:PTR BYTE,									; point to the patientName address
	patientNameSize:DWORD									; get the patientName Size

	LOCAL inputLength:DWORD, characterFound:DWORD			; get the number of bytes returns from ReadString

	input:
		;mWrite <"                    -----------------------------------------------------------              ", 0dh,0ah>
		mWrite <"                                  Patient Name: ">
		
		mov edx, patientName								; point to patientName
		mov ecx, maxSize									; specify the max length the input receive
		call ReadString										; input patientName
		mov inputLength, eax								; get the number of character
		mov eax, patientNameSize							; get the limited patientName character receive
		dec eax
			
		;If Input is empty
		.IF (inputLength == 0)
			call Crlf
			mHospitalMenuError <"              No Input Detected! Input again               ", 0dh, 0ah>
			call Crlf
			jmp input
		.ENDIF

		;To check if the input length exceed
		.IF (inputLength > eax)
			call Crlf
			mHospitalMenuError <"           Maximum Length Detected! Input again            ", 0dh, 0ah>
			call Crlf
			jmp input
		.ENDIF

		;Only allow character
		mov ecx, inputLength
		mov esi, patientName
		mov characterFound, 0

		checkPatientName:
			;//Only allowed a-z, A-Z, Space
			.IF ((BYTE PTR [esi] < 041h || BYTE PTR [esi] > 05Ah) && (BYTE PTR [esi] < 061h || BYTE PTR [esi] > 07Ah) && (BYTE PTR [esi] != 020h))
				call Crlf
				mHospitalMenuError <"       Only allow character and space! Input again         ", 0dh, 0ah>
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
			mHospitalMenuError <"         Must at least 1 character! Input again            ", 0dh, 0ah>
			call Crlf
			jmp input
		.ENDIF

	ret
InputPatientName ENDP

InputPatientIC PROC C,
	maxSize:DWORD,										; maximum input for read
	patientIC:PTR BYTE,									; point to the patientIC address
	patientICsize:DWORD									; get the patientIC Size

	LOCAL inputLength:DWORD								; get the number of bytes returns from ReadString

	input:
		mWrite <"                      Patient IC (without '-'): ">
		
		mov edx, patientIC								; point to patientIC
		mov ecx, maxSize								; specify the max length the input receive
		call ReadString									; input patientIC
		mov inputLength, eax							; get the number of character
		mov eax, patientICsize							; get the limited patientIC character receive
		dec eax
			
		;If Input is empty
		.IF (inputLength == 0)
			call Crlf
			mHospitalMenuError <"              No Input Detected! Input again               ", 0dh, 0ah>
			call Crlf
			jmp input
		.ENDIF

		;To check if the input length exceed
		.IF (inputLength > eax)
			call Crlf
			mHospitalMenuError <"           Maximum Length Detected! Input again            ", 0dh, 0ah>
			call Crlf
			jmp input
		.ENDIF

		.IF (inputLength != eax)
			call Crlf
			mHospitalMenuError <"                 Invalid IC! Input again                   ", 0dh, 0ah>
			call Crlf
			jmp input
		.ENDIF

		;Only allow numbers
		mov ecx, inputLength
		mov esi, patientIC

		checkPatientIC:
			.IF ((BYTE PTR [esi] < 030h || BYTE PTR [esi] > 039h))
				call Crlf
				mHospitalMenuError <"              Only allow numbers! Input again              ", 0dh, 0ah>
				call Crlf
				jmp input
			.ENDIF

			inc esi
			loop checkPatientIC

	ret
InputPatientIC ENDP

InputPatientContact PROC C,
	maxSize:DWORD,											; maximum input for read
	patientContact:PTR BYTE,								; point to the patientContact address
	patientContactSize:DWORD								; get the patientContact Size

	LOCAL inputLength:DWORD 								; get the number of bytes returns from ReadString

	input:
		mWrite <"                Patient Contact (numbers only): ">
		
		mov edx, patientContact								; point to patientContact
		mov ecx, maxSize									; specify the max length the input receive
		call ReadString										; input patientContact
		mov inputLength, eax								; get the number of character
		mov eax, patientContactsize							; get the limited patientContact character receive
		dec eax
			
		;If Input is empty
		.IF (inputLength == 0)
			call Crlf
			mHospitalMenuError <"              No Input Detected! Input again               ", 0dh, 0ah>
			call Crlf
			jmp input
		.ENDIF

		;To check if the input length exceed
		.IF (inputLength > eax)
			call Crlf
			mHospitalMenuError <"           Maximum Length Detected! Input again            ", 0dh, 0ah>
			call Crlf
			jmp input
		.ENDIF

		.IF (inputLength < 9)
			call Crlf
			mHospitalMenuError <"              Invalid Contact! Input again                 ", 0dh, 0ah>
			call Crlf
			jmp input
		.ENDIF

		;Only allow numbers
		mov ecx, inputLength
		mov esi, patientContact

		checkPatientContact:
			.IF ((BYTE PTR [esi] < 030h || BYTE PTR [esi] > 039h))
				call Crlf
				mHospitalMenuError <"              Only allow numbers! Input again              ", 0dh, 0ah>
				call Crlf
				jmp input
			.ENDIF

			inc esi
			loop checkPatientContact

	ret
InputPatientContact ENDP
END