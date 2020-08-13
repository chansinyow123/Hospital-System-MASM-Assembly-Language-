#include <iostream>
#include <fstream>
#include <sstream>
#include <string>
#include <cstring>
#include <iomanip>

using namespace std;

// Main
extern "C" void asmMain();

//Create Account File
extern "C" {
	extern "C" void backspace();
	extern "C" void appendAccountFile(char staffName[], char staffUsername[], char staffPassword[]);
	extern "C" int readUsername(char staffUsername[]);
}

//login
extern "C" {
	int login(char loginName[], char loginUsername[], char loginPassword[], int nameSize);
}

//date and time
extern "C" {
	void convertDate(int day, int month, int year, char formatDate[], int dateSize);
	void convertTime(int hour, int minute, char formatTime[], int timeSize);
	void monthEnglish(int month, string & formatMonth);
}

//add hospitalized history
extern "C" {
	void displayReceiptNum();
	void inputCustomerPayment(float* number);
	void displayFloat(float* customerPay);
	void appendHospitalizedFile(
		char patientName[], char patientIC[], char patientContact[],
		char patientDescription[], int day, int room, char formatDate[],
		char formatTime[], float totalPayment
	);
}

//list hospitalized history
extern "C" {
	void displayHospitalizedHistory();
}

//add appointment
extern "C" {
	void appendAppointmentFile(
		char patientName[], char patientIC[], char patientContact[],
		char formatDate[], char formatTime[], char doctorName[]
	);
}

extern "C" {
	void displayAppointment();
}


int main() {

	asmMain();

	return 0;
}

void backspace() {
	printf("\b \b");
}

void appendAccountFile(char staffName[], char staffUsername[], char staffPassword[]) {

	string name(staffName);
	string username(staffUsername);
	string password(staffPassword);

	
	ofstream accountFile;
	accountFile.open("staff.txt", std::ios_base::app);

	if (accountFile.is_open()) {
		accountFile << name << "," << username  << "," << password << endl;
	}

	accountFile.close();
	
}

int readUsername(char staffUsername[]) {

	string username(staffUsername);
	string line;
	ifstream accountFile;
	accountFile.open("staff.txt");

	string fileName;
	string fileUsername;
	string filePassword;

	// return true if username already exist
	while (getline(accountFile, line)) {
		stringstream ss(line);
		getline(ss, fileName, ',');
		getline(ss, fileUsername, ',');
		getline(ss, filePassword);

		if (username == fileUsername) {
			accountFile.close();
			return 1;
		}
	}

	accountFile.close();
	return 0;
}

int login(char loginName[], char loginUsername[], char loginPassword[], int nameSize) {
	
	string name(loginName);
	string username(loginUsername);
	string password(loginPassword);

	ifstream accountFile;
	accountFile.open("staff.txt");

	string fileName;
	string fileUsername;
	string filePassword;

	string line;

	//if account exist, then return true
	while (getline(accountFile, line)) {
		stringstream ss(line);
		getline(ss, fileName, ',');
		getline(ss, fileUsername, ',');
		getline(ss, filePassword);

		if (fileUsername == username && filePassword == password) {
			strcpy_s(loginName, nameSize, fileName.c_str());
			accountFile.close();
			return 1;
		}
	}
	accountFile.close();
	return 0;
}

void displayReceiptNum() {
	ifstream hospitalizedFile;
	hospitalizedFile.open("hospitalized.txt");

	string line;
	int count = 1;

	while (getline(hospitalizedFile, line)) {
		stringstream ss(line);
		count++;
	}

	printf("R%04d", count);
}

void displayFloat(float* number) {
	printf("%.2f", *number);
}

void inputCustomerPayment(float* customerPay) {

	cin >> std::setw(1) >> *customerPay;


	while (!cin.good()) {

		std::cout << "\nInvalid Input" << endl;

		//Clear Stream
		cin.clear();
		cin.ignore(INT_MAX, '\n');

		//Get Input Again
		cout << "" << endl;
		cout << "Customer Payment: RM ";
		cin >> std::setw(1) >> *customerPay;
	}

	//Clear Stream
	cin.clear();
	cin.ignore(INT_MAX, '\n');
}

void appendHospitalizedFile (
	char patientName[], char patientIC[], char patientContact[], 
	char patientDescription[], int day, int room, char formatDate[], 
	char formatTime[], float totalPayment
) {
	string stringName(patientName);
	string stringIC(patientIC);
	string stringContact(patientContact);
	string stringDescription(patientDescription);
	string stringDate(formatDate);
	string stringTime(formatTime);


	ofstream hospitalizedFile;
	hospitalizedFile.open("hospitalized.txt", std::ios_base::app);

	hospitalizedFile.precision(2);
	if (hospitalizedFile.is_open()) {
		hospitalizedFile << stringName << "," << stringIC << "," << stringContact << ",";
		hospitalizedFile << stringDescription << endl << day << "," << room << ",";
		hospitalizedFile << stringDate << "," << stringTime << ",";
		hospitalizedFile << fixed << totalPayment << endl;
	}

	hospitalizedFile.close();
}

void displayHospitalizedHistory(){

	ifstream hospitalizedFile;
	hospitalizedFile.open("hospitalized.txt");

	string line;

	string patientName;
	string patientIC;
	string patientContact;
	string patientDescription;
	string day;
	string room;
	string date;
	string time;
	string totalPayment;

	float tempPayment;
	float calculateTotal = 0.0;

	bool secondline = false;

	cout << left;
	cout << setw(25) << "PatientName" << setw(15) << "PatientIC";
	cout << setw(20) << "PatientContact" << setw(40) << "PatientDescription";
	cout << setw(6) << "Day" << setw(6) << "Room" << setw(21) << "Date";
	cout << setw(10) << "Time" << setw(13) << "Payment" << endl;
	cout << setfill('-') << setw(156) << "-" << endl;
	cout << setfill(' ');
	//if account exist, then return true
	while (getline(hospitalizedFile, line)) {
		stringstream ss(line);
		
		if (!secondline) {
			getline(ss, patientName, ',');
			getline(ss, patientIC, ',');
			getline(ss, patientContact, ',');
			getline(ss, patientDescription);
			secondline = true;
		}
		else {
			getline(ss, day, ',');
			getline(ss, room, ',');
			getline(ss, date, ',');
			getline(ss, time, ',');
			getline(ss, totalPayment);
			secondline = false;

			tempPayment = stof(totalPayment);
			calculateTotal += tempPayment;

			cout << setw(25) << patientName << setw(15) << patientIC;
			cout << setw(20) << patientContact << setw(40) << patientDescription;
			cout << setw(6) << day << setw(6) << room << setw(21) << date;
			cout << setw(10) << time << setw(3) << "RM " << setw(10) << totalPayment << endl;
		}
	}
	cout << setfill('-') << setw(156) << "-" << endl;
	cout << setfill(' ');
	cout << setw(5) << "Total";
	cout << right;
	cout.precision(2);
	cout << fixed;
	cout << setw(141) << "RM ";
	cout << left;
	cout << setw(10) << calculateTotal << endl;

	hospitalizedFile.close();
}

void convertDate(int day, int month, int year, char formatDate[], int dateSize) {

	string formatMonth;

	//get the english of the month
	monthEnglish(month, formatMonth);

	string dateString;
	dateString.append(to_string(day) + " " + formatMonth + " " + to_string(year));
	strcpy_s(formatDate, dateSize, dateString.c_str());
}

void convertTime(int hour, int minute, char formatTime[], int timeSize) {

	string timeString;
	string dimension;

	if (hour >= 12) {
		dimension = "PM";
	}
	else {
		dimension = "AM";
	}

	string hourString = to_string(hour);
	string minuteString = to_string(minute);
	string leadingZeroHourString = string(2 - hourString.length(), '0') + hourString;
	string leadingZeroMinuteString = string(2 - minuteString.length(), '0') + minuteString;


	timeString.append(leadingZeroHourString + ":" + leadingZeroMinuteString + " " + dimension);
	strcpy_s(formatTime, timeSize, timeString.c_str());

}

//get the english of the month
void monthEnglish(int month, string &formatMonth) {
	switch (month) {
	case 1:
		formatMonth = "January";
		break;
	case 2:
		formatMonth = "February";
		break;
	case 3:
		formatMonth = "March";
		break;
	case 4:
		formatMonth = "April";
		break;
	case 5:
		formatMonth = "May";
		break;
	case 6:
		formatMonth = "June";
		break;
	case 7:
		formatMonth = "July";
		break;
	case 8:
		formatMonth = "August";
		break;
	case 9:
		formatMonth = "September";
		break;
	case 10:
		formatMonth = "October";
		break;
	case 11:
		formatMonth = "November";
		break;
	case 12:
		formatMonth = "December";
		break;
	default:
		formatMonth = "Error";
	}
}

void appendAppointmentFile(
	char patientName[], char patientIC[], char patientContact[],
	char formatDate[], char formatTime[], char doctorName[]
) {
	string stringName(patientName);
	string stringIC(patientIC);
	string stringContact(patientContact);
	string stringDate(formatDate);
	string stringTime(formatTime);
	string stringDoctor(doctorName);

	ofstream appointmentFile;
	appointmentFile.open("appointment.txt", std::ios_base::app);

	appointmentFile.precision(2);
	if (appointmentFile.is_open()) {
		appointmentFile << stringName << "," << stringIC << "," << stringContact << ",";
		appointmentFile << stringDate << "," << stringTime << "," << stringDoctor << endl;
	}

	appointmentFile.close();
}

void displayAppointment() {

	ifstream appointmentFile;
	appointmentFile.open("appointment.txt");

	string line;

	string patientName;
	string patientIC;
	string patientContact;
	string date;
	string time;
	string doctorName;

	cout << left;
	cout << setw(25) << "PatientName" << setw(15) << "PatientIC";
	cout << setw(20) << "PatientContact";
	cout << setw(21) << "Date" << setw(12) << "Time" << setw(25) << "DoctorName" << endl;
	cout << setfill('-') << setw(120) << "-" << endl;
	cout << setfill(' ');

	//if account exist, then return true
	while (getline(appointmentFile, line)) {
		stringstream ss(line);
			getline(ss, patientName, ',');
			getline(ss, patientIC, ',');
			getline(ss, patientContact, ',');
			getline(ss, date, ',');
			getline(ss, time, ',');
			getline(ss, doctorName);

			cout << setw(25) << patientName << setw(15) << patientIC;
			cout << setw(20) << patientContact;
			cout << setw(21) << date << setw(12) << time << setw(25) << doctorName << endl;
		
	}
	cout << setfill('-') << setw(120) << "-" << endl;
	cout << setfill(' ');

	appointmentFile.close();
}