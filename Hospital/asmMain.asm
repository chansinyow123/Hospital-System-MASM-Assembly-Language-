INCLUDE Irvine32.inc
INCLUDE macros.inc
INCLUDE proto.inc
INCLUDE extraMacros.inc

.386
.model flat,stdcall
.stack 4096
ExitProcess PROTO, dwExitCode:DWORD

MAX_SIZE_INPUT = 2000		; for call ReadString, in order to have validation
ENCRYPT_KEY = 239			; Encrypt Key (XOR)

.data
sysTime SYSTEMTIME <>

;//CREATE ACCOUNT
staffName BYTE 31 DUP(?)
staffUsername BYTE 51 DUP(?)
staffPassword BYTE 51 DUP(?)

;//LOGIN
loginStaffName BYTE 31 DUP(?)
loginStaffUsername BYTE 51 DUP(?)
loginStaffPassword BYTE 51 DUP(?)
accountExist DWORD ?

;//BOTH LOGIN / CREATE ACCOUNT
passwordSize DWORD ?

;//Add Hospitalize / Add Appointment
patientName BYTE 31 DUP(?)
patientIC BYTE 13 DUP(?)
patientContact BYTE 12 DUP(?)

;Add Hospitalize
patientDescription BYTE 50 DUP(?)
hospitalDay DWORD ?
room DWORD ?

;Hospitalized Receipt
pricePerDay REAL4 100.0
tax REAL4 0.06
price REAL4 ?
taxPrice REAL4 ?
totalPrice REAL4 ?
customerPay REAL4 ?
customerChange REAL4 ?

;Formatted Date and Time
formatDate BYTE 31 DUP(?)
formatTime BYTE 31 DUP(?)

;Add Appointment
appointmentDay DWORD ?
appointmentMonth DWORD ?
appointmentYear DWORD ?
appointmentHour DWORD ?
appointmentMinute DWORD ?
doctorName BYTE 31 DUP(?)

row WORD ?
col WORD ?

.code

asmMain PROC C

XOR eax, eax

loginInterface:
	; Display Main Menu
	; [RETURN]: return selection to eax
	; [ASMFILE]: MainMenu.asm
	INVOKE MainMenu

	.IF (eax == 0)
		exit
	.ELSEIF (eax == 1)

		mWrite <"                     ----------------------------------------------------------                       ", 0dh,0ah>
		mWrite <"                     |                         LOGIN                          |                       ", 0dh,0ah>
		mWrite <"                     ----------------------------------------------------------                       ", 0dh,0ah>

		; Input login username
		; [maxSize]: maximum input for read
		; [staffName]: point to the staffName address
		; [staffNameSize]: pass the staffName Size
		INVOKE LoginUsername, MAX_SIZE_INPUT, ADDR loginStaffUsername, LENGTHOF loginStaffUsername

		; Input login password
		; [staffPassword]: point to the staffPassword address
		; [staffPasswordSize]: pass the staffPassword Size
		; [RETURN]: the typed password size
		INVOKE LoginPassword, ADDR loginStaffPassword, LENGTHOF loginStaffPassword
		mov passwordSize, eax

		; encrypt Password
		; [staffPassword]: point to the staffPassword address
		; [encryptKey]: point to the encryptKey address
		; [passwordSize]: get the staffPassword Size
		INVOKE encryptPassword, ADDR loginStaffPassword, ENCRYPT_KEY, passwordSize

		; Verify if account exist or not
		; [loginName]: point to the loginStaffName address
		; [loginUsername]: point to the loginStaffUsername address
		; [loginPassword]: point to the loginStaffPassword address
		; [nameSize]: the length of loginStaffName
		; [RETURN]: If account exist, return 1, else, return 0
		INVOKE login, ADDR loginStaffName, ADDR loginStaffUsername, ADDR loginStaffPassword, LENGTHOF loginStaffName
		mov accountExist, eax

		;clear the password string
		mov al,00h									; value to be stored
		mov edi,OFFSET loginStaffPassword			; EDI points to target
		mov ecx,LENGTHOF loginStaffPassword			; character count
		cld											; direction = forward
		rep stosb									; store 00h in every character

		.IF (accountExist == 1)
			jmp hospitalInterface
		.ELSE
			call Crlf
			call Crlf
			;Call The Login Error from extraMacros.inc
			mMainMenuError <"              Invalid Username or Password!               ", 0dh, 0ah>
			call Crlf
			call WaitMsg
			call Clrscr
			jmp loginInterface
		.ENDIF

	.ELSEIF (eax == 2)
		mWrite <"                     ----------------------------------------------------------                       ", 0dh,0ah>
		mWrite <"                     |                     CREATE ACCOUNT                     |                       ", 0dh,0ah>
		mWrite <"                     ----------------------------------------------------------                       ", 0dh,0ah>
		; Input staff Name
		; [maxSize]: maximum input for read
		; [staffName]: point to the staffName address
		; [staffNameSize]: get the staffName Size
		INVOKE InputStaffName, MAX_SIZE_INPUT, ADDR staffName, LENGTHOF staffName

		;mov edx, OFFSET staffName
		;call WriteString

		; Input staff Username
		; [maxSize]: maximum input for read
		; [staffUsername]: point to the staffUsername address
		; [staffUserameSize]: get the staffUsername Size
		INVOKE InputStaffUsername, MAX_SIZE_INPUT, ADDR staffUsername, LENGTHOF staffUsername

		;mov edx, OFFSET staffName
		;call WriteString

		; Input staff Password
		; [staffPassword]: point to the staffPassword address
		; [staffPasswordSize]: get the staffPassword Size
		; [RETURN]: the password size
		INVOKE InputStaffPassword, ADDR staffPassword, LENGTHOF staffPassword
		mov passwordSize, eax

		;call crlf
		;mov edx, OFFSET staffPassword
		;call WriteString

		; Encrypt Password
		; [staffPassword]: point to the staffPassword address
		; [encryptKey]: point to the encryptKey address
		; [passwordSize]: get the staffPassword Size
		INVOKE encryptPassword, ADDR staffPassword, ENCRYPT_KEY, passwordSize

		;call crlf
		;mov edx, OFFSET staffPassword
		;call WriteString

		; Save Staffname, username, password to file
		; [staffName]: paint to the staffName address
		; [staffUsername]: point to the staffUsername address
		; [staffPassword]: point to the staffPassword address
		INVOKE appendAccountFile, ADDR staffName, ADDR staffUsername, ADDR staffPassword

		;clear the password string
		mov al,00h											; value to be stored
		mov edi,OFFSET staffPassword						; EDI points to target
		mov ecx,LENGTHOF staffPassword						; character count
		cld													; direction = forward
		rep stosb											; store 00h in every character

		call Crlf
		call Crlf
		mMainMenuSuccessful <"                     Account Created!                     ", 0dh, 0ah>			; Display Success Message
		call Crlf
		call WaitMsg

		call Clrscr											; clear screen
		jmp loginInterface									; jump back to MainMenu

	.ELSE
		exit
	.ENDIF

hospitalInterface:

	call Clrscr
	; Display Hospital Menu
	; [ASMFILE]: MainMenu.asm
	; [staffName]: point to the loginStaffName address
	; [RETURN]: return selection to eax
	INVOKE HospitalMenu, ADDR loginStaffName
	
	.IF (eax == 0)
		exit
	.ELSEIF (eax == 1)
		call Clrscr
		mWrite <"            -------------------------------------------------------------------------        ", 0dh,0ah>
		mWrite <"            |                       ADD HOSPITALIZED HISTORY:                       |        ", 0dh,0ah>
		mWrite <"            -------------------------------------------------------------------------        ", 0dh,0ah>


		inputHospitalized:
			;Input Patient Name
			;[ASMFILE]: Patient.asm
			INVOKE InputPatientName, MAX_SIZE_INPUT, ADDR patientName, LENGTHOF patientName

			;Input Patient IC
			;[ASMFILE]: Patient.asm
			INVOKE InputPatientIC, MAX_SIZE_INPUT, ADDR patientIC, LENGTHOF patientIC

			;Input Patient Contact
			;[ASMFILE]: Patient.asm
			INVOKE InputPatientContact, MAX_SIZE_INPUT, ADDR patientContact, LENGTHOF patientContact

			;Input Patient Description
			;[ASMFILE]: Hospitalized.asm
			INVOKE InputPatientDescription, MAX_SIZE_INPUT, ADDR patientDescription, LENGTHOF patientDescription

			;Input Hospitalized Day
			;[ASMFILE]: Hospitalized.asm
			;[RETURN]: hospitalDay Input
			INVOKE InputHospitalizedDay
			mov hospitalDay, eax

			;Input Room
			;[ASMFILE]: Hospitalized.asm
			;[RETURN]: room Input
			INVOKE InputRoom
			mov room, eax

			call Clrscr

			mov eax, lightCyan + (black * 16)
			call SetTextColor
                                                                                                    
			mWrite <"                                      `..-::////::-..`                                          ", 0dh,0ah>
			mWrite <"                                  `.:++//:--....--://++:.`                                      ", 0dh,0ah>
			mWrite <"                                ./++:.`              `.:++/.                                    ", 0dh,0ah>
			mWrite <"                              .++:.        Receipt       .:++.                                  ", 0dh,0ah>
			mWrite <"                            `/o:`                          `:o/`                                ", 0dh,0ah>
			mWrite <"                           .o+.         `.`      `.`         .+o.                               ", 0dh,0ah>
			mWrite <"                          .o+`       .:/:/.  ``  ./:/:.       `+o.                              ", 0dh,0ah>
			mWrite <"                         `o+`       -+.`   `+ss+`   `.+-       `+o`                             ", 0dh,0ah>
			mWrite <"                         /o.        /:   `.:ssss:.`   :/        .o/                             ", 0dh,0ah>
			mWrite <"                        `o+         //  +ssssssssss+  //         +o`                            ", 0dh,0ah>
			mWrite <"                        .o:         -o. +ssssssssss+ .o-         :o.                            ", 0dh,0ah>
			mWrite <"                        -o:         -o+` ..:ssss:.. `+o-         :o-                            ", 0dh,0ah>
			mWrite <"                        .o/          /o/`  `osso`  `/o/          /o.                            ", 0dh,0ah>
			mWrite <"                         oo`          :o+-`  ``  `-+o:          `oo                             ", 0dh,0ah>
			mWrite <"                         -o:           ./o+:.``.:+o/.           :o-                             ", 0dh,0ah>
			mWrite <"                          /o-            `-+oooo+-`            -o/                              ", 0dh,0ah>
			mWrite <"                           /o:               oo               :o/                               ", 0dh,0ah>
			mWrite <"                            :o/`             oo             `/o:                                ", 0dh,0ah>
			mWrite <"                             `/o/`           /o-          `/o/`                                 ", 0dh,0ah>
			mWrite <"                               ./o+-`        `+o:`     `-+o/.                                   ", 0dh,0ah>
			mWrite <"                                 `-/o+/-.` .:::/+o+//+oo/-`                                     ", 0dh,0ah>
			mWrite <"                                     .-:/+oo:o:o  `...`                                         ", 0dh,0ah>
			mWrite <"                                           -:/:-                                                ", 0dh,0ah>

			mov eax, white + (black * 16)
			call SetTextColor

			call Crlf
			mWrite <"                                ReceiptID:  ">
			INVOKE displayReceiptNum												; Display Receipt Num from C++
			call Crlf
			mWrite <"                               Staff Name:  ">
			mWriteString loginStaffName												; Display Staff Name

			call Crlf
			INVOKE GetLocalTime, ADDR sysTime

			mWrite <"                                     Date:  ">
			INVOKE convertDate, sysTime.wDay, sysTime.wMonth, sysTime.wYear, ADDR formatDate, LENGTHOF formatDate			; Get Current Date String From C++
			mWriteString formatDate																							; Write Date

			call Crlf
			mWrite <"                                     Time:  ">
			INVOKE convertTime, sysTime.wHour, sysTime.wMinute, ADDR formatTime, LENGTHOF formatTime						; Get Current Time String From C++
			mWriteString formatTime																							; Write Time

			call Crlf
			;//PATIENT DETAILS
			mWrite <"         -----------------------------------------------------------------------------", 0dh, 0ah>
			mWrite <"                             Patient Name:  ">
			mWriteString patientName												; Display Patient Name
			call Crlf
			mWrite <"                               Patient IC:  ">
			mWriteString patientIC													; Display Patient IC
			call Crlf
			mWrite <"                          Patient Contact:  ">
			mWriteString patientContact												; Display Patient Contact
			call Crlf
			mWrite <"                      Patient Description:  ">
			mWriteString patientDescription											; Display Patient Decription
			call Crlf
			mWrite <"         -----------------------------------------------------------------------------", 0dh, 0ah>

			mWrite <"                                     Room:  ">
			mov eax, room
			call WriteDec															; Display Patient Room
			call Crlf
			mWrite <"                            Price per day:  RM 100.00", 0dh, 0ah>								; Display Price per day
			mWrite <"                        Hospitalized Days:  ">
			mov eax, hospitalDay													; Display Hospitalized Day
			call WriteDec

			;//calculate the price and total price
			fld pricePerDay															; store the RM 100(price per day) inside ST(0)
			;call ShowFPUStack			
			fimul hospitalDay														; multiply ST(0) with hospital day inside ST(0)
			;call ShowFPUStack
			fst price																; store the multiplied value into price
			;call ShowFPUStack
			fmul tax																; multiply ST(0) (price) with 0.06 tax
			fst taxPrice															; store the tax price into taxPrice
			;call ShowFPUStack
			fadd price																; add the tax price with price calculated before inside ST(0)
			;call ShowFPUStack
			fst totalPrice															; store the total price into totalPrice

			;Display price per day
			call Crlf
			mWrite <"                          Price total day:  RM ">
			INVOKE displayFloat, ADDR price											; Display Total price that is multiplied by day with RM 100 from C++

			;Display tax percentage
			call Crlf
			mWrite <"                                      Tax:  6%", 0dh, 0ah>											; Display Tax Percentage

			;Display calculated tax price
			mWrite <"                                Tax Price:  RM ">
			INVOKE displayFloat, ADDR taxPrice										; Display the price of tax from C++

			call Crlf
			mWrite <"                              Total Price:  RM ">
			INVOKE displayFloat, ADDR totalPrice									; Display total price with added tax from C++

			call Crlf

			inputCustomerPay:
				call Crlf
				mWrite <"                         Customer Payment:  RM ">
				INVOKE inputCustomerPayment, ADDR customerPay						; get the customer pay input from C++
				;call ShowFPUStack
				fcom customerPay													; compare the customer pay with total price
				fnstsw ax															; move status word into AX
				sahf																; copy AH into EFLAGS
				jb proceed															; proceed if customer pay is larger than total price

				call Crlf
				mHospitalMenuError <"                   Payment NOT Enough!                     ", 0dh, 0ah>		; else, display error message
				jmp inputCustomerPay												; then input again

		proceed:
			fsubr customerPay														; substract the total price with customer pay
			;call ShowFPUStack
			fstp customerChange														; store the substract price into customer change

			;call ShowFPUStack\
			mWrite <"                          Customer Change:  RM ">
			INVOKE displayFloat, ADDR customerChange								; Display customer changed from C++

			call Crlf
			call Crlf

			INVOKE appendHospitalizedFile,											; Append Hospitalized File
			ADDR patientName, ADDR patientIC, ADDR patientContact,
			ADDR patientDescription, hospitalDay, room, ADDR formatDate,
			ADDR formatTime, totalPrice

			mHospitalMenuSuccessful <"               Hospitalized History Added!                 ", 0dh, 0ah>        ; Display Success Message

			call Crlf
			mWrite <"                  Next Patient? (Yes=Y/y): ">
			call ReadChar															; Got Next Patient or not?

			call Clrscr
			.IF (al == 059h || al == 079h)											; IF Yes, Input Again, else jump back to hospital menu
				jmp inputHospitalized
			.ELSE
				jmp hospitalInterface
			.ENDIF
	.ELSEIF (eax == 2)
		call Clrscr

		;Display Hospitalized File From C++
		INVOKE displayHospitalizedHistory
		
		call Crlf
		call WaitMsg

		call Clrscr
		jmp hospitalInterface
	.ELSEIF (eax == 3)
		
		call Clrscr
		mWrite <"            -------------------------------------------------------------------------        ", 0dh,0ah>
		mWrite <"            |                           ADD APPOINTMENT                             |        ", 0dh,0ah>
		mWrite <"            -------------------------------------------------------------------------        ", 0dh,0ah>

		;Input Patient Name
		;[ASMFILE]: Patient.asm
		INVOKE InputPatientName, MAX_SIZE_INPUT, ADDR patientName, LENGTHOF patientName

		;Input Patient IC
		;[ASMFILE]: Patient.asm
		INVOKE InputPatientIC, MAX_SIZE_INPUT, ADDR patientIC, LENGTHOF patientIC

		;Input Patient Contact
		;[ASMFILE]: Patient.asm
		INVOKE InputPatientContact, MAX_SIZE_INPUT, ADDR patientContact, LENGTHOF patientContact

		;Get Current Date Time To Compare
		INVOKE GetLocalTime, ADDR sysTime

		;Input Year
		;[ASMFILE]: Appointment.asm
		;[currentYear]: Pass Todays Year
		;[RETURN]: appointmentYear Input
		INVOKE InputYear, sysTime.wYear
		mov appointmentYear, eax

		;Input Month
		;[ASMFILE]: Appointment.asm
		;[RETURN]: appointmentMonth Input
		INVOKE InputMonth
		mov appointmentMonth, eax

		;Input Day
		;[ASMFILE]: Appointment.asm
		;[RETURN]: appointmentDay Input
		INVOKE InputDay, appointmentYear, appointmentMonth
		mov appointmentDay, eax

		;Input Hour
		;[ASMFILE]: Appointment.asm
		;[RETURN]: appointmentHour Input
		INVOKE InputHour
		mov appointmentHour, eax

		;Input Minute
		;[ASMFILE]: Appointment.asm
		;[RETURN]: appointmentMinute Input
		INVOKE InputMinute
		mov appointmentMinute, eax

		;Input Doctor Name
		;[ASMFILE]: Appointment.asm
		INVOKE InputDoctor, MAX_SIZE_INPUT, ADDR doctorName, LENGTHOF doctorName

		; Get Appointment Date String From C++
		INVOKE convertDate, appointmentDay, appointmentMonth, appointmentYear, ADDR formatDate, LENGTHOF formatDate	

		; Get Appointment Time String From C++
		INVOKE convertTime, appointmentHour, appointmentMinute, ADDR formatTime, LENGTHOF formatTime

		INVOKE appendAppointmentFile, ADDR patientName, ADDR patientIC, ADDR patientContact, ADDR formatDate, ADDR formatTime, ADDR doctorName
		
		call Crlf

		mHospitalMenuSuccessful <"                    Appointment Added!                     ", 0dh, 0ah>        ; Display Success Message

		call Crlf
		call WaitMsg
		call Clrscr
		jmp hospitalInterface

	.ELSEIF (eax == 4)
		call Clrscr

		;Display Appointment File From C++
		INVOKE displayAppointment
		
		call Crlf
		call WaitMsg

		call Clrscr
		jmp hospitalInterface
	.ELSEIF (eax == 5)
		call Clrscr
		jmp loginInterface
	.ELSE
		exit
	.ENDIF

	call Crlf
	call WaitMsg

ret
asmMain ENDP
END