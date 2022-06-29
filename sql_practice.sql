--EASY LEVEL

--Show first name, last name, and gender of patients who's gender is 'M'
SELECT
  first_name,
  last_name,
  gender
FROM patients
WHERE gender = 'M'

--Show first name and last name of patients who does not have allergies (null).
SELECT
  first_name,
  last_name
FROM patients
WHERE allergies IS NULL

--Show first name of patients that start with the letter 'C'
SELECT
  first_name
FROM patients
WHERE first_name LIKE 'C%'

--Show first name and last name of patients that weight within the range of 100 to 120 (inclusive)
SELECT
  first_name,
  last_name
FROM patients
WHERE weight BETWEEN 100 and 120

--Update the patients table for the allergies column. If the patient's allergies is null then replace it with 'NKA'
UPDATE
  patients
SET allergies = 'NKA'
WHERE allergies IS NULL


--Show first name and last name concatinated into one column to show their full name.
SELECT first_name || ' ' ||last_name
FROM patients

--Show first name, last name, and the full province name of each patient.
--Example: 'Ontario' instead of 'ON'
SELECT
  pa.first_name,
  pa.last_name,
  pr.province_name
FROM patients as pa
  INNER JOIN provinces AS pr ON pa.province_id = pr.province_id

--Show how many patients have a birth_date with 2010 as the birth year.
SELECT COUNT (*)
FROM patients
WHERE STRFTIME ('%Y', birth_date) = '2010'

Show the first_name, last_name, and height of the patient with the greatest height.
SELECT
  first_name,
  last_name,
  MAX(height)
FROM patients

--Show all columns for patients who have one of the following patient_ids:
--1,45,534,879,1000
SELECT *
FROM patients
WHERE
  patient_id IN (1, 45, 534, 879, 1000)

--Show the total number of admissions
SELECT COUNT (*)
FROM admissions

--Show all the columns from admissions where the patient was admitted and discharged on the same day.
SELECT *
FROM admissions
WHERE admission_date = discharge_date

--Show the total number of admissions for patient_id 573.
SELECT
  patient_id,
  COUNT (patient_id)
FROM admissions
WHERE patient_id = '573'


--MEDIUM LEVEL


--Show unique birth years from patients and order them by ascending.
SELECT
  DISTINCT (YEAR(birth_date)) AS birth_year
FROM patients
ORDER BY birth_year

--Show unique first names from the patients table which only occurs once in the list.
--For example, if two or more people are named 'John' in the first_name column then don't include their name in the output list. If only 1 person is named 'Leo' then include them in the output.
SELECT first_name
FROM patients
GROUP BY first_name
HAVINg COUNT (first_name) = 1

--Show patient_id and first_name from patients where their first_name start and ends with 's' and is at least 6 characters long.
SELECT
  patient_id,
  first_name
FROM patients
WHERE first_name LIKE 's____%s'

--Show patient_id, first_name, last_name from patients whos primary_diagnosis is 'Dementia'.
--Primary diagnosis is stored in the admissions table.
SELECT
  p.patient_id,
  p.first_name,
  p.last_name
FROM patients AS p
  INNER JOIN admissions AS a ON p.patient_id = a.patient_id
WHERE a.primary_diagnosis = 'Dementia'


--Show patient_id, first_name, last_name from the patients table.
--Order the rows by the first_name ascending and then by the last_name descending.
SELECT
  patient_id,
  first_name,
  last_name
FROM patients
ORDER BY
  first_name,
  last_name DESC

--Show the total amount of male patients and the total amount of female patients in the patients table
SELECT (
    SELECT COUNT(*) AS male_count
    FROM patients
    WHERE gender = "M"
  ), (
    SELECT COUNT(*) AS female_count
    FROM patients
    WHERE gender = "F"
  )

--Show first and last name, allergies from patients which have allergies to either 'Penicillin' or 'Morphine'. Show results ordered ascending by allergies then by --first_name then by last_name.
SELECT
  first_name,
  last_name,
  allergies
FROM patients
WHERE
  allergies = 'Penicillin'
  or allergies = 'Morphine'
ORDER BY
  allergies,
  first_name,
  last_name

--Show patient_id, primary_diagnosis from admissions. Find patients admitted multiple times for the same primary_diagnosis.
SELECT
  patient_id,
  primary_diagnosis
FROM admissions
GROUP BY
  patient_id,
  primary_diagnosis
HAVING COUNT(primary_diagnosis) > 1

--Show the city and the total number of patients in the city in the order from most to least patients.
SELECT
  city,
  COUNT(*) AS num_patients
FROM patients
GROUP BY city
ORDER BY num_patients DESC

--Show first name, last name and role of every person that is either patient or physician.
--The roles are either "Patient" or "Physician"
SELECT
  first_name,
  last_name,
  'Patient' AS Role
FROM patients
UNION
SELECT
  first_name,
  last_name,
  'Physician' AS Role
FROM physicians

--Show all allergies ordered by popularity. Remove 'NKA' and NULL values from query.
SELECT
  allergies,
  COUNT (allergies) as Total
FROM patients
WHERE
  allergies IS NOT NULL
  and allergies IS NOT 'NKA'
GROUP BY allergies
ORDER BY Total DESC

--Show all patient's first_name, last_name, and birth_date who were born in the 1970s decade. Sort the list starting from the earliest birth_date.
SELECT
  first_name,
  last_name,
  birth_date
FROM patients
WHERE
  YEAR(birth_date) BETWEEN 1970 and 1979
ORDER BY birth_date

--We want to display each patient's full name in a single column. Their last_name in all upper letters must appear first, then first_name in all lower case letters. --Separate the last_name and first_name with a comma. Order the list by the first_name in decending order
--EX: SMITH,jane
SELECT
  UPPER(last_name) | | ',' | | LOWER(first_name)
FROM patients
ORDER BY first_name DESC

--Show the province_id(s), sum of height; where the total sum of its patient's height is greater than or equal to 7,000.
SELECT
  province_id,
  SUM (height)
FROM patients
GROUP BY province_id
HAVING SUM(height) >= 7000

--Show the difference between the largest weight and smallest weight for patients with the last name 'Maroni'
SELECT mAX(weight) - MIN (weight)
FROM patients
WHERE last_name = 'Maroni'

--Based on the cities that our patients live in, show unique cities that are in province_id 'NS'?
SELECT DISTINCT (city)
FROM patients
WHERE province_id = 'NS'

--Show all of the month's day numbers and how many admission_dates occurred on that number. Sort by the day with most admissions to least admissions.
SELECT
  DAY(admission_date) AS day_number,
  COUNT (admission_date) AS number_of_admissions
FROM admissions
GROUP BY day_number
ORDER BY number_of_admissions DESC

--Show the patient_id, nursing_unit_id, room, and bed for patient_id 542's most recent admission_date.
SELECT
  patient_id,
  nursing_unit_id,
  room,
  bed
FROM admissions
GROUP BY patient_id
HAVING
  patient_id = 542
  AND MAX(admission_date)

--Show the nursing_unit_id and count of admissions for each nursing_unit_id. Exclude the following nursing_unit_ids: 'CCU', 'OR', 'ICU', 'ER'.
SELECT
  nursing_unit_id,
  COUNT (*)
FROM admissions
WHERE
  nursing_unit_id NOT IN ('CCU', 'OR', 'ICU', 'ER')
GROUP BY nursing_unit_id

--Show patient_id, attending_physician_id, and primary_diagnosis for admissions that match one of the two criteria:
--1. patient_id is an odd number and attending_physician_id is either 1, 5, or 19.
--2. attending_physician_id contains a 2 and the length of patient_id is 3 characters.
SELECT
  patient_id,
  attending_physician_id,
  primary_diagnosis
FROM admissions
WHERE
  patient_id % 2 != 0
  AND attending_physician_id IN (1, 5, 19)
