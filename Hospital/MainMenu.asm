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
MainMenu PROC C
	
		mov eax, lightCyan + (black * 16)
		call SetTextColor

		mWrite <" :dmmdhsoooooo+o+                                                                   +o+ooooooshdmmd- ", 0dh, 0ah> 
		mWrite <"  :dmmdhysooo+o++.                                                                 .o+o+ooosyhdmmd:  ", 0dh, 0ah> 
		mWrite <"   /mmmdysoooooo+:                                                                 /+ooo+ossydmmm/   ", 0dh, 0ah> 
		mWrite <"    smmdhyso++ooo+.                          Credit To:                           .+ooo++osyhdmms    ", 0dh, 0ah> 
		mWrite <"    `hmmdhso++++++/                         Chan Sin Yow                          /++++++oshdmmh`    ", 0dh, 0ah> 
		mWrite <"     :mmmhyso+////+.                         Ong Yi Pin                          -+////+osydmmm:     ", 0dh, 0ah> 
		mWrite <"      smmdhyo+++////                        Wong Ket Yee                        `////+++oyhdmms      ", 0dh, 0ah> 
		mWrite <"      `ymdhyo++//::/-                                                           -/:://++oyhdmy`      ", 0dh, 0ah> 
		mWrite <"       .ddhso++///:::`                                                         `:::///++oshdd.       ", 0dh, 0ah> 
		mWrite <"        hmhso+++//::::                                                         :::://+++oyhmy        ", 0dh, 0ah> 
		mWrite <"        hmdhso+++oo+//-                                                       -//+oo+++oshdmh        ", 0dh, 0ah> 
		mWrite <"       .mmddhsoooso/:::.                                                     -:::/osoooshddmm.       ", 0dh, 0ah> 
		mWrite <"       smmmdhsoooo+/:---                                                     ---:/+ooooshdmmmo       ", 0dh, 0ah> 
		mWrite <"      -dmmmhyo++++/:----                  ::^::      ::^::                   ----:/+++ooyhmmmd.      ", 0dh, 0ah> 
		mWrite <"      smNmdys++//+/:----       o`       -::::::::``::::::::-        .+       ----:/+//+osydmmms      ", 0dh, 0ah> 
		mWrite <"     -dmNmhs+++/++/:---.      `y-     `+-xuehua`/+`piaopiao.+.      :s       .---:/++/+++shmNmd-     ", 0dh, 0ah> 
		mWrite <"    `hmmmhy++s+++/:----       .y:     /:                    .o      /y`       ----:/+++s++ydNmmy`    ", 0dh, 0ah> 
		mWrite <"    smmmmyo//h+//--.-.        -++     -+                    :/      o+.        .-.-://+h//oymmmms    ", 0dh, 0ah> 
		mWrite <"   /mmmmhy+/+h+/:-...         /-s      -+.                `/:       s::         ...-:/+h+/+ydmmmm/   ", 0dh, 0ah> 
		mWrite <"  .dmmdhso+/hy+/--..     `+   +`o`       :/-            -/:`       .+-/   o`     ..-:/+yh/+oshdmmd.  ", 0dh, 0ah> 
		mWrite <"  .dmdso+++sdyo/:-.`     +s.  s +.         .:/.      .//.          -/`o  -s/     `.-:/oyds+++osdmd.  ", 0dh, 0ah> 
		mWrite <"   .smhys++hdy+/:---:::::/-/  o ::::::::::::::+/    :+::::::::::::-/- s  +./:::::---:/oydh++syhms.   ", 0dh, 0ah> 
		mWrite <"     :dmdsymhs+/:--`      `o .+ .s-    WELCOME TO CARE HOSPITAL   :s` o` s       `--:/+shmssdmd:     ", 0dh, 0ah> 
		mWrite <"      .hmdhdys+/:-:`       o`::  `                                 `  +.-/       `:-:/osydhdmh.      ", 0dh, 0ah> 
		mWrite <"       .dmmdoo/--:--`      ::/-                                       ::/.      `-::--/osmmmd.       ", 0dh, 0ah> 
		mWrite <"        .hmmyo/--//::`     `o+`                                       -/s      `:://--/oymmy.        ", 0dh, 0ah> 
		mWrite <"          odmho/::::::`     os                                        `s+     `::::::/ohmdo          ", 0dh, 0ah> 
		mWrite <"           /ydyy+/:::/:`    :o                                         y-    `:/:::/+yydy/           ", 0dh, 0ah> 
		mWrite <"             -ohhs+:://:`   `-                                         :    `://::+shho-             ", 0dh, 0ah> 
		mWrite <"               `/yhs+:://:`                                               `://::+shy/`               ", 0dh, 0ah> 
		mWrite <"                  -shs/://-                                               ://:/shs-                  ", 0dh, 0ah> 
		mWrite <"                    `-:/+++                                              `+++/:-`                    ", 0dh, 0ah> 
		mWrite <"                        `.`                                               `.`                        ", 0dh, 0ah> 

	mov eax, white + (black * 16)
	call SetTextColor

	call Crlf

	inputAgain:
		mWrite <"                     ----------------------------------------------------------                       ", 0dh,0ah>
		mWrite <"                     |               Welcome to Care Hospital                 |                       ", 0dh,0ah>
		mWrite <"                     ----------------------------------------------------------                       ", 0dh,0ah>
		mWrite <"                     |           1) Login                                     |                       ", 0dh,0ah>
		mWrite <"                     |           2) Create Account                            |                       ", 0dh,0ah>
		mWrite <"                     |           0) Exit                                      |                       ", 0dh,0ah>
		mWrite <"                     ----------------------------------------------------------                       ", 0dh,0ah>
		mWrite <"                                 Select Option: ">

		call ReadInt
		.IF OVERFLOW? || (eax < 0) || (eax > 2)
			call Crlf
			mMainMenuError <"                     Incorrect Input                      ", 0dh, 0ah>
			call Crlf
			jmp inputAgain
		.ENDIF

		call Crlf

	ret
MainMenu ENDP

HospitalMenu PROC C, 
	staffName:PTR BYTE

	LOCAL countStaffName:DWORD, countSpace:DWORD

	mov eax, lightCyan + (black * 16)
	call SetTextColor

	mWrite <"                                             `.----.`  `.-                                          ", 0dh, 0ah>
	mWrite <"                                          ./osyhhhhyysoss/                                          ", 0dh, 0ah>
	mWrite <"                                        `+yhhhhhhhhhhhhhy.                                          ", 0dh, 0ah>
	mWrite <"                                       .shhhhhhhhhhhhyoshy-                                         ", 0dh, 0ah>
	mWrite <"                                       shsssosyyyss+:. .shy`                                        ", 0dh, 0ah>
	mWrite <"                                      -hy-`. `...`      -yh/                                        ", 0dh, 0ah>
	mWrite <"                                      :hs                sy+                                        ", 0dh, 0ah>
	mWrite <"                                      so.    ^       ^   ./y.                                       ", 0dh, 0ah>
	mWrite <"                                      os-`               -+s`                                       ", 0dh, 0ah>
	mWrite <"                                      `:s+               /y:`                                       ", 0dh, 0ah>
	mWrite <"                                        `so`   \___/   `+y.                                         ", 0dh, 0ah>
	mWrite <"                                         `+s:        -so`                                           ", 0dh, 0ah>
	mWrite <"                                           .+s/-..-/so-                                             ", 0dh, 0ah>
	mWrite <"                                         `.` `-////-`  ..`                                          ", 0dh, 0ah>
	mWrite <"                                 `   .:/syyy+-`     `:oyyyo/-`                                      ", 0dh, 0ah>
	mWrite <"                               ``-/oys+ss:yy/+sssssss+/yo/y++ss+:-`                                 ", 0dh, 0ah>
	mWrite <"                             `/sso/-``o+` /y-  /yyy-  /y: -s. `-/oyo:`                              ", 0dh, 0ah>
	mWrite <"                            /y+-   `-oy:` `yo   sh+   sy   :s     `-oy:                             ", 0dh, 0ah>
	mWrite <"                           +y:    -s/..:s- +y.  yho  -h/    y.       /y:                            ", 0dh, 0ah>
	mWrite <"                          .y+     +o    /s -h+ `hhs  oy`   -o/        sy`                           ", 0dh, 0ah>
	mWrite <"                          /h-     +o    .y. sy`-hhy .yo    /so`       /h-                           ", 0dh, 0ah>
	mWrite <"                          sy      oo     s+ :h::hhh./h-     `         .y+                           ", 0dh, 0ah>
	mWrite <"                         .h+      o+     /y `ys+bei:ys                 sy                           ", 0dh, 0ah>
	mWrite <"                         /h-      /s:   .ss  +yfengsh:                 /h-                          ", 0dh, 0ah>
	mWrite <"                         sy        ::    .`  .yxiaohy`                 .h+                          ", 0dh, 0ah>
	mWrite <"                        .y+                   oxiaoh+                   sy                          ", 0dh, 0ah>
	mWrite <"                        /ys+++++++++++++++++++syyyyyo+++++++++++++++++++sy-                         ", 0dh, 0ah>
	mWrite <"                        `.................................................`                         ", 0dh, 0ah>
	mWrite <"                                                                                                    ", 0dh, 0ah>
	mWrite <"                                                                                                    ", 0dh, 0ah>
	mWrite <"             .++++++/-`     `-/+++/:.     `-:+++/:.  +++++++++-  .:/+++/-`   `+++++/:.              ", 0dh, 0ah>
	mWrite <"             .oo+///+oo/`  -ooo///+oo/`  .+oo///+o+- :::+oo/::-`+oo+///ooo-  `ooo//+oo:             ", 0dh, 0ah>
	mWrite <"             .oo:   `-oo/ .oo/`    .oo+ `oo+`    ``     /oo.   +oo.    `+oo. `oo/  `ooo             ", 0dh, 0ah>
	mWrite <"             .oo:     ooo :oo-      +oo -oo:            /oo.   oo+      -oo- `ooo++ooo-             ", 0dh, 0ah>
	mWrite <"             .oo:```./oo: `ooo-```.:oo/ `+oo-````-.`    /oo.   /oo:.```-ooo` `ooo:/oo/              ", 0dh, 0ah>
	mWrite <"             .ooo++ooo+-   `/ooo++oo+-   `/ooo++oo+-    /oo.    :+oo++ooo/`  `oo/  -oo/`            ", 0dh, 0ah>
	mWrite <"             `:::::--`       `.-::-.`      `.-::-.`     .::`     `.-::-.`     ::-   `-:-            ", 0dh, 0ah>
                                                                                                    
	mov eax, white + (black * 16)
	call SetTextColor

	call Crlf

	;To Count the total input of string in staffName
	mov esi, staffName
	mov countStaffName, 0
	
	.REPEAT
		inc esi													; increment the address
		inc countStaffName										; increment the total input
	.UNTIL (BYTE PTR [esi] == 00h)

	inputAgain:
		mWrite <"                    -----------------------------------------------------------              ", 0dh,0ah>
		mWrite <"                    |        Welcome ">
		mov edx, staffName
		call WriteString
		mWrite <"!">
		mov eax, countStaffName		  ; assign the total input into eax
		mov countSpace, 40			  ; original space for the staff name has 40
		sub countSpace, eax           ; subtract space from total input
		mov ecx, countSpace			  ; space put into loop counter
		writeSpace:
			mWrite <" ">			  ; put a space in every loop
			loop writeSpace
		mWrite <"|", 0dh, 0ah>		  ; put '|'
		mWrite <"                    |        What would you like to do?                       |              ", 0dh,0ah>
		mWrite <"                    -----------------------------------------------------------              ", 0dh,0ah>
		mWrite <"                    |        1) Add Hospitalized History                      |              ", 0dh,0ah>
		mWrite <"                    |        2) List History                                  |              ", 0dh,0ah>
		mWrite <"                    |        3) Add appointment                               |              ", 0dh,0ah>
		mWrite <"                    |        4) List Appointment                              |              ", 0dh,0ah>
		mWrite <"                    |        5) Log Out                                       |              ", 0dh,0ah>
		mWrite <"                    |        0) Exit                                          |              ", 0dh,0ah>
		mWrite <"                    -----------------------------------------------------------              ", 0dh,0ah>
		mWrite <"                             Select Option: ">

		call ReadInt
		.IF OVERFLOW? || (eax < 0) || (eax > 5)
			call Crlf
			mHospitalMenuError <"                      Incorrect Input                      ", 0dh, 0ah>
			call Crlf
			jmp inputAgain
		.ENDIF

		call Crlf

	ret
HospitalMenu ENDP

END