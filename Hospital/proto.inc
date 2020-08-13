; Display Main Menu
; [ASMFILE]: MainMenu.asm
; [RETURN]: return selection to eax
MainMenu PROTO C	

; Display Hospital Menu
; [ASMFILE]: MainMenu.asm
; [staffName]: point to the loginStaffName address
; [RETURN]: return selection to eax
HospitalMenu PROTO C, staffName:PTR BYTE

; Input staff Name
; [ASMFILE]: CreateAccount.asm
; [maxSize]: maximum input for read
; [staffName]: point to the staffName address
; [staffNameSize]: pass the staffName Size
InputStaffName PROTO C, maxSize:DWORD, staffName:PTR BYTE, staffNameSize:DWORD

; Input staff Username
; [ASMFILE]: CreateAccount.asm
; [maxSize]: maximum input for read
; [staffUsername]: point to the staffUsername address
; [staffUserameSize]: pass the staffUsername Size
InputStaffUsername PROTO C, maxSize:DWORD, staffUsername:PTR BYTE, staffUsernameSize:DWORD

; Input staff Password
; [ASMFILE]: CreateAccount.asm
; [staffPassword]: point to the staffPassword address
; [staffPasswordSize]: pass the staffPassword Size
; [RETURN]: the typed password size
InputStaffPassword PROTO C, staffPassword:PTR BYTE, staffPasswordSize:DWORD

; Encrypt / Decrypt Password
; [ASMFILE]: CreateAccount.asm
; [staffPassword]: point to the staffPassword address
; [encryptKey]: point to the encryptKey address
; [passwordSize]: get the staffPassword Size
encryptPassword PROTO C, staffPassword:PTR BYTE, encryptKey:DWORD, passwordSize:DWORD

; delete last output from c++
backspace PROTO C  

; Save Staffname, username, password to file
; [ASMFILE]: CreateAccount.asm
; [staffName]: paint to the staffName address
; [staffUsername]: point to the staffUsername address
; [staffPassword]: point to the staffPassword address
appendAccountFile PROTO C, staffName:PTR BYTE, staffUsername:PTR BYTE, staffPassword:PTR BYTE

; To check if the username already existed
; [staffUsername]: point to the staffUsername address
readUsername PROTO C, staffUsername:PTR BYTE

; Input login username
; [ASMFILE]: Login.asm
; [maxSize]: maximum input for read
; [staffName]: point to the staffName address
; [staffNameSize]: pass the staffName Size
LoginUsername PROTO C, maxSize:DWORD, loginStaffUsername:PTR BYTE, usernameSize:DWORD

; Input login password
; [ASMFILE]: Login.asm
; [staffPassword]: point to the staffPassword address
; [staffPasswordSize]: pass the staffPassword Size
; [RETURN]: the typed password size
LoginPassword PROTO C, loginStaffPassword:PTR BYTE, passwordSize:DWORD

; Verify if account exist or not
; [ASMFILE]: Login.asm
; [loginName]: point to the loginStaffName address
; [loginUsername]: point to the loginStaffUsername address
; [loginPassword]: point to the loginStaffPassword address
; [nameSize]: the length of loginStaffName
; [RETURN]: If account exist, return 1, else, return 0
login PROTO C, loginName:PTR BYTE, loginUsername:PTR BYTE, loginPassword:PTR BYTE, nameSize:DWORD

;Input Patient Name
;[ASMFILE]: Patient.asm
InputPatientName PROTO C, maxSize:DWORD, patientName:PTR BYTE, patientNameSize:DWORD

;Input Patient IC
;[ASMFILE]: Patient.asm
InputPatientIC PROTO C, maxSize:DWORD, patientIC:PTR BYTE, patientICsize:DWORD

;Input Patient Contact
;[ASMFILE]: Patient.asm
InputPatientContact PROTO C, maxSize:DWORD, patientContact:PTR BYTE, patientContactsize:DWORD

;Input Patient Description
;[ASMFILE]: Hospitalized.asm
InputPatientDescription PROTO C, maxSize:DWORD, patientDescription:PTR BYTE, patientDescriptionSize:DWORD

;Input Hospitalized Day
;[ASMFILE]: Hospitalized.asm
;[RETURN]: hospitalDay Input
InputHospitalizedDay PROTO C

;Input Room
;[ASMFILE]: Hospitalized.asm
;[RETURN]: room Input
InputRoom PROTO C

;Display Receipt Num From C++
displayReceiptNum PROTO C

;Get Date String From C++ with the given day, month and year
convertDate PROTO C, day:DWORD, month:DWORD, year:DWORD, formatDate:PTR BYTE, dateSize:DWORD

;Get Time String From C++ with the given hour and minute
convertTime PROTO C, hour:DWORD, minute:DWORD, formatTime:PTR BYTE, timeSize:DWORD

;Display Price From C++
displayFloat PROTO C, number:PTR REAL4

;Input Price from C++
inputCustomerPayment PROTO C, customerPay:PTR REAL4

;Append hospitalized File From C++
appendHospitalizedFile PROTO C, patientName:PTR BYTE, patientIC:PTR BYTE, patientContact:PTR BYTE, patientDescription:PTR BYTE, day:DWORD, room:DWORD, formatDate:PTR BYTE, formatTime:PTR BYTE, totalPayment:REAL4

;Display Hospitalized File From C++
displayHospitalizedHistory PROTO C

;Input Year
;[ASMFILE]: Appointment.asm
;[currentYear]: Pass Todays Year
;[RETURN]: appointmentYear Input
InputYear PROTO C, currentYear:DWORD

;Input Month
;[ASMFILE]: Appointment.asm
;[RETURN]: appointmentMonth Input
InputMonth PROTO C

;Input Day
;[ASMFILE]: Appointment.asm
;[RETURN]: appointmentDay Input
InputDay PROTO C, yearInput:DWORD, monthInput:DWORD

;Input Hour
;[ASMFILE]: Appointment.asm
;[RETURN]: appointmentHour Input
InputHour PROTO C

;Input Minute
;[ASMFILE]: Appointment.asm
;[RETURN]: appointmentMinute Input
InputMinute PROTO C

;Input Doctor Name
;[ASMFILE]: Appointment.asm
InputDoctor PROTO C, maxSize:DWORD, doctorName:PTR BYTE, doctorNameSize:DWORD

;Append Appointment File From C++
appendAppointmentFile PROTO C, patientName:PTR BYTE, patientIC:PTR BYTE, patientContact:PTR BYTE, formatDate:PTR BYTE, formatTime:PTR BYTE, doctorName:PTR BYTE

;Display Appointment File From C++
displayAppointment PROTO C