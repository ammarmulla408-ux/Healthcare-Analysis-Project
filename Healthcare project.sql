CREATE DATABASE HealthcareDB;
USE HealthcareDB;
#-----Patients--------
CREATE TABLE patientsdata(
Patient_ID VARCHAR (20),
Name VARCHAR(20),
Age INT,
Gender VARCHAR (10),
Disease VARCHAR(20),
Visit_Date Date,
VisitType VARCHAR(20),
Doctor_ID VARCHAR(20));
SELECT *FROM labtests;
show tables;
DROP TABLE patients;
#-------Doctors---------
CREATE TABLE Doctors(
Doctor_ID VARCHAR(20),
Doctor_Name VARCHAR(20),
Department VARCHAR(20));
#---------Billings---------
CREATE TABLE Billing(
Bill_ID VARCHAR (20),
Patient_ID VARCHAR (20),
Treatment_Cost INT,
Visit_Charge INT );
#---------Lab Tests----------
CREATE TABLE LabTests(
Test_ID VARCHAR (10),
Patinet_ID VARCHAR(10),
Test_Name VARCHAR (25),
Result VARCHAR (20),
Status VARCHAR (20)
);
#Total Patients
SELECT count(distinct Patient_ID)AS Total_Patients
FROM Patientsdata;
#Male VS Female Count
SELECT Gender ,COUNT(*) AS Total
FROM patientsdata
Group BY Gender;

#Average Age
SELECT avg(Age) AS Avg_Age
FROM Patientsdata;

#Top 3 Disease
SELECT Disease,count(*) AS Total
FROM Patientsdata
GROUP BY Disease
ORDER BY Total DESC
LIMIT 3;

#Monthly patients visit
SELECT month(Visit_Date),count(*) AS Monthly_Visits
FROM Patientsdata
GROUP BY Visit_Date
ORDER BY Visit_Date ;

#Doctor Workload 
SELECT Doctor_ID, count(*) AS Total_Patients
From Patientsdata
GROUP BY Doctor_ID
ORDER BY Total_Patients DESC;

#Total Revenue
SELECT  sum(Treatment_cost + Visit_charge) AS Total_Revenue
FROM Billing ;

#Revenue Per Patient
SELECT Patient_ID ,SUM(Treatment_cost + Visit_Charge) AS Revenue
FROM Billing
GROUP BY Patient_ID;

#Abnormal Lab Test%
SELECT (sum(CASE WHEN status="Abnormal" THEN 1 ELSE 0 END)*100)/count(*) AS Abnormal_Percentage
FROM Labtests;

#Most Common Test
SELECT Test_Name,count(*) AS Common_Test
FROM labtests
GROUP BY Test_Name
ORDER BY Common_Test DESC
LIMIT 1;

#Age Group Analysis
SELECT 
CASE
    WHEN Age <18 THEN "Child"
	WHEN Age Between 18 AND 40 THEN "Adult"
	ELSE "Senior Citizen"
END AS Age_Group,
COUNT(*) AS Total
FROM Patientsdata GROUP BY Age_Group;

#Patients + Doctor
SELECT p.Patient_ID,p.Name,p.Disease,
d.Doctor_Name,d.Department
FROM Patientsdata p
JOIN Doctors d
ON p.Doctor_ID = d.Doctor_ID;

#Patient+Billing
SELECT p.Patient_ID,p.Name,
SUM(b.Treatment_Cost + b.Visit_charge ) AS Total
FROM patientsdata p
JOIN Billing b
ON p.Patient_ID = b.Patient_ID
GROUP BY p.Patient_ID,p.Name;

#Patient +Lab test
SELECT p.Patient_ID,p.Name,
l.Test_Name,l.status
FROM patientsdata p
JOIN Labtests l
ON p.Patient_ID= l.Patinet_ID;

#
SELECT p.Patient_ID,p.Name,p.Disease,d.Doctor_Name,
sum(b.Treatment_Cost+Visit_Charge) AS REVENUE,
count(l.Test_ID) AS Total_Tests
FROM Patientsdata p
JOIN Doctors d 
ON p.Doctor_ID = d.Doctor_ID
LEFT JOIN Billing b
ON p.Patient_ID = b.Patient_ID
LEFT JOIN Labtests l
ON p.Patient_ID=b.Patient_ID
GROUP BY P.Patient_ID,p.Name,p.Disease,d.Doctor_Name;



