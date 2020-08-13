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
InputPatientDescription PROC C,
	maxSize:DWORD,												; maximum input for read
	patientDescription:PTR BYTE,								; point to the patientDescription address
	patientDescriptionSize:DWORD								; get the patientDescription Size

	LOCAL inputLength:DWORD, characterFound:DWORD				; get the number of bytes returns from ReadString
	
	input:
		mWrite <"                           Patient Description: ">
		
		mov edx, patientDescription								; point to patientDescription
		mov ecx, maxSize										; specify the max length the input receive
		call ReadString											; input patientDescription
		mov inputLength, eax									; get the number of character
		mov eax, patientDescriptionSize							; get the limited patientDescription character receive
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

		;//Not allowed space only
		mov ecx, inputLength
		mov esi, patientDescription
		mov characterFound, 0

		checkDescription:
			.IF (BYTE PTR [esi] != 020h)
				mov characterFound, 1
				jmp proceed
			.ENDIF

			inc esi
			loop checkDescription

		.IF (characterFound == 0)
			call Crlf
			mHospitalMenuError <"             Only Space Detected! Input again              ", 0dh, 0ah>
			call Crlf
			jmp input
		.ENDIF

		proceed:

	ret
InputPatientDescription ENDP

InputHospitalizedDay PROC C
	input:
		mWrite <"                   Hospitalized Period (Days) : ">
		
		call ReadInt
		.IF (OVERFLOW? || (eax < 1))
			call Crlf
			mHospitalMenuError <"                Invalid Input! Input again                 ", 0dh, 0ah>
			call Crlf
			jmp input
		.ENDIF

		.IF (eax > 36500)
			call Crlf
			mHospitalMenuError <"           Maximum Length Detected! Input again            ", 0dh, 0ah>
			call Crlf
			jmp input
		.ENDIF
	ret
InputHospitalizedDay ENDP

InputRoom PROC C

	input: 
		mWrite <"                                Room (1 - 20) : ">

		call ReadInt
		.IF (OVERFLOW? || (eax < 1) || (eax > 20))
			call Crlf
			mHospitalMenuError <"                Invalid Input! Input again                 ", 0dh, 0ah>
			call Crlf
			jmp input
		.ENDIF

	ret
InputRoom ENDP
END