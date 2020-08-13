mMainMenuError MACRO message:REQ
	LOCAL string
	.data
	string BYTE message, 0
	.code
	push edx
	mWrite <"                     ">

	mov eax, white + (red * 16)
	call SetTextColor

	mov edx, OFFSET string
	call WriteString

	mov eax, white + (black * 16)
	call SetTextColor
	pop edx
ENDM

mMainMenuSuccessful MACRO message:REQ
	LOCAL string
	.data
	string BYTE message, 0
	.code
	push edx
	mWrite <"                     ">

	mov eax, white + (green * 16)
	call SetTextColor

	mov edx, OFFSET string
	call WriteString

	mov eax, white + (black * 16)
	call SetTextColor
	pop edx
ENDM

mHospitalMenuError MACRO message:REQ
	LOCAL string
	.data
	string BYTE message, 0
	.code
	push edx
	mWrite <"                    ">

	mov eax, white + (red * 16)
	call SetTextColor

	mov edx, OFFSET string
	call WriteString

	mov eax, white + (black * 16)
	call SetTextColor
	pop edx
ENDM

mHospitalMenuSuccessful MACRO message:REQ
	LOCAL string
	.data
	string BYTE message, 0
	.code
	push edx
	mWrite <"                    ">

	mov eax, white + (green * 16)
	call SetTextColor

	mov edx, OFFSET string
	call WriteString

	mov eax, white + (black * 16)
	call SetTextColor
	pop edx
ENDM