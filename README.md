# Electronic-Health-Record
Research project to give ownership of the health record to the Patient  

## Registration Contract Initialisaton

![alt text](https://i.imgur.com/CuoyI7D.png)

-	In this picture, we see deployment of registration contracts of Employee and Patients
-	These contracts will register the Patients and Employees respectively and store their address ID and contract address in a mapping
-	The address of the deployed registration contracts should in turn be securely saved (as “BaseID” in our case) by the deploying body as they will be used for their mapping stored within them

## Registering and DataID 

![alt text](https://i.imgur.com/inmvwIZ.png)

-	It is a simple contract, each user clicks on the “Deploy_employee”/”Deploy_patient” button depending on who they are
-	Contract saves their ID and deploys the instance of the Patient_Data or Employee_Data contract with the user as the owner of that instance
-	The ethereum address of the deployed instance is given the user as “DataID”

## Opening Data from DataID

![alt text](https://i.imgur.com/CuoyI7D.png)

-	Using DataID provided by the Registration contract, we open the instance of our Patient_Data/Employee_Data
-	The contract thus deployed is at a specific address and the values stored are kept only at that specific address as a separate form

## Employee Data form 

![alt text](https://i.imgur.com/dMIwFU9.png)

-	Shows all the entries in the Employee_Data form

## Patient Data form

![alt text](https://i.imgur.com/iytYGXs.png)

-	Shows all the entries in the Patient_Data form

## Entering the data(Employee)

![alt text](https://i.imgur.com/G7ttvys.png)

-	Filling of the Employee_Data form

## Entering the data(Patient)

![alt text](https://i.imgur.com/9PExg2m.png)

-	Filling of the Patient_Data form

## Error Message (Wrong owner)

![alt text](https://i.imgur.com/81x7GKt.jpg)

-	Certain functions in each of the employee and patient contracts can only be called by the owner of the contract
-	Image shows the addition of the officer (employee) in the list of approved employees of the patient is unable to run
-	This function can only be called by the owner (i.e The patient who owns this instance of contract), and since it is not them, the function doesn’t work

## Same Method Works (Right Owner)

![alt text](https://i.imgur.com/GvfZi8P.jpg)

-	With correct owner, the function which previously did not work is working as it should

## Approval is Checked(True)

![alt text](https://i.imgur.com/o0JXM0g.png)

-	Doctor needs to get confirmation that they are added in the patient’s approval list
-	For this, they use “BaseID” to ask the registration contract for the mappings
-	They provide with the patient’s ID, and receive their respective data contract instance
-	From there they check the list, and get confirmation of their approval

## Display of Data to Doctor(Approved)

![alt text](https://i.imgur.com/yZBymWL.png)

-	Data of the patient is divided into two parts: Sensitive and Non- Sensitive.
-	For test purpose, we have added:
  -	Sensitive data: Issue, Insurance and Contact
  -	Non-Sensitive Data: Name, Guardian, Medication and Age.
-	Sensitive data of the patient can only be seen by the approved employees, while non-sensitive is for public knowledge.
-	Here in the image is the approved employee, able to access both the sensitive and non-sensitive data.

## Approval Check (False)  

![alt text](https://i.imgur.com/Pzy7AI2.png)

-	An employee can ask for its approval confirmation for a patient’s data.
-	In this image, we see a doctor that is not being authorized to access patient’s sensitive data record by the patient.
-	Here, as the employee goes through the approval check by using the BaseID and patient’s ID. The resulting answer is “False”.

## Display of Data to Doctor(Not Approved)

![alt text](https://i.imgur.com/ukk1tmK.jpg)

-	As the sensitive data is only for approved employees, while non-sensitive data is for the public access.
-	Employees that are not approved are only able to access the non-sensitive data, and as per the error message encircled, they are unable to access the sensitive data.
