1.
SELECT lr."name"
FROM public."Lectures" l JOIN public."Teachers" t ON t.id = l.teacher_id
						 JOIN public."Schedules" s ON s.lectures_id=l.id
						 JOIN public."Lectures_rooms" lr ON lr.id = s.lectures_room_id
WHERE t."name" LIKE 'Edward' AND t.surname LIKE 'Hooper';

2.
SELECT t.surname
FROM public."Groups" g JOIN public."Groups_lectures" gl ON g.id = gl.group_id
                       JOIN public."Lectures" l ON gl.lecture_id=l.id
					   JOIN public."Teachers" t ON l.teacher_id = t.id
					   JOIN public."Assistance" a ON a.teacher_id = t.id
WHERE g."name" LIKE 'F505';

3.
SELECT s."name"
FROM public."Subject" s JOIN public."Lectures" l ON l.subject_id = s.id
						JOIN public."Groups_lectures" gl ON gl.lecture_id=l.id
						JOIN public."Groups" g ON g.id = gl.group_id
						JOIN public."Teachers" t ON t.id = l.teacher_id
WHERE g."year"=5 AND t."name" LIKE 'Alex' AND t.surname LIKE 'Carmack';

4.
SELECT distinct t.surname
FROM public."Teachers" t FULL JOIN public."Lectures" l ON l.teacher_id = t.id
						 JOIN public."Schedules" sh ON sh.lectures_id = l.id
WHERE sh.day_of_week !=1;

5.
SELECT distinct lr."name",lr.building
FROM public."Lectures_rooms" lr 
	FULL JOIN public."Schedules" sh ON sh.lectures_room_id = lr.id
	FULL JOIN public."Lectures" l ON l.id = sh.lectures_id
WHERE lr.id NOT IN (SELECT lr.id FROM public."Lectures_rooms" lr 
	JOIN public."Schedules" sh ON sh.lectures_room_id = lr.id
	JOIN public."Lectures" l ON l.id = sh.lectures_id
	WHERE sh.day_of_week = 3 AND sh.week = 2 AND sh."class" = 3);

6.
SELECT t."name"||' '||t.surname AS fullname
FROM public."Faculties" f JOIN public."Departments" d ON d.faculty_id = f.id
						  JOIN public."Groups" g ON g.department_id = d.id
						  JOIN public."Groups_curators" gc ON gc.group_id = g.id
						  JOIN public."Curators" c ON c.id = gc.curator_id
						  JOIN public."Teachers" t ON t.id = c.teacher_id
WHERE t.id NOT IN (SELECT t.id FROM public."Faculties" f JOIN public."Departments" d ON d.faculty_id = f.id
						  JOIN public."Groups" g ON g.department_id = d.id
						  JOIN public."Groups_curators" gc ON gc.group_id = g.id
						  JOIN public."Curators" c ON c.id = gc.curator_id
						  JOIN public."Teachers" t ON t.id = c.teacher_id
WHERE f."name" LIKE 'Computer Science' AND d."name" LIKE 'Sofware Development');

7.
SELECT f.building AS list_of_building_number
FROM public."Faculties" f
UNION
SELECT d.building
FROM public."Departments" d
UNION
SELECT lr.building
FROM public."Lectures_rooms" lr;

8.
SELECT t."name"||' '||t.surname AS fullname
FROM public."Teachers" t, public."Deans" d
WHERE d.teacher_id=t.id
UNION ALL
SELECT t."name"||' '||t.surname AS fullname
FROM public."Teachers" t, public."Heads" h
WHERE h.teacher_id = t.id
UNION ALL
SELECT DISTINCT t."name"||' '||t.surname AS fullname
FROM public."Teachers" t
WHERE t.id NOT IN (SELECT DISTINCT t.id FROM public."Teachers" t, public."Assistance" a,
						  public."Curators" c ,public."Deans" d ,public."Heads" h
						 WHERE a.teacher_id=t.id OR c.teacher_id=t.id OR d.teacher_id = t.id
						 OR h.teacher_id=t.id)
UNION ALL
SELECT t."name"||' '||t.surname AS fullname
FROM public."Teachers" t,public."Curators" c
WHERE c.teacher_id=t.id
UNION ALL
SELECT t."name"||' '||t.surname AS fullname
FROM public."Teachers" t,public."Assistance" a
WHERE a.teacher_id=t.id;

9.
SELECT DISTINCT sh.day_of_week
FROM public."Lectures_rooms" l JOIN public."Schedules" sh ON l.id = sh.lectures_room_id
WHERE l.building=6 AND l."name" LIKE 'A311' OR l."name" LIKE 'A104'
