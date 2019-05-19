-- Table: public."Assistance"

-- DROP TABLE public."Assistance";

CREATE TABLE public."Assistance"
(
    id integer NOT NULL DEFAULT nextval('"Assistance_id_seq"'::regclass) ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 2147483647 CACHE 1 ),
    teacher_id integer NOT NULL,
    CONSTRAINT "Assistance_pkey" PRIMARY KEY (id),
    CONSTRAINT assistanse_to_teacher_link FOREIGN KEY (teacher_id)
        REFERENCES public."Teachers" (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public."Assistance"
    OWNER to postgres;

-- Table: public."Curators"

-- DROP TABLE public."Curators";

CREATE TABLE public."Curators"
(
    id integer NOT NULL DEFAULT nextval('"Curators_id_seq"'::regclass) ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 2147483647 CACHE 1 ),
    teacher_id integer NOT NULL,
    CONSTRAINT "Curators_pkey" PRIMARY KEY (id),
    CONSTRAINT link_curators_to_teacher FOREIGN KEY (teacher_id)
        REFERENCES public."Teachers" (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public."Curators"
    OWNER to postgres;

-- Table: public."Deans"

-- DROP TABLE public."Deans";

CREATE TABLE public."Deans"
(
    id integer NOT NULL DEFAULT nextval('deans_id_seq'::regclass) ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 2147483647 CACHE 1 ),
    teacher_id integer NOT NULL,
    CONSTRAINT deans_pkey PRIMARY KEY (id),
    CONSTRAINT link_dean_to_teachers FOREIGN KEY (teacher_id)
        REFERENCES public."Teachers" (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public."Deans"
    OWNER to postgres;

-- Table: public."Departments"

-- DROP TABLE public."Departments";

CREATE TABLE public."Departments"
(
    id integer NOT NULL DEFAULT nextval('"Departments_id_seq"'::regclass) ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 2147483647 CACHE 1 ),
    financing money NOT NULL DEFAULT 0,
    name character varying(100) COLLATE pg_catalog."default" NOT NULL,
    faculty_id integer NOT NULL,
    building integer NOT NULL,
    head_id integer NOT NULL,
    CONSTRAINT "Departments_pkey" PRIMARY KEY (id),
    CONSTRAINT departments_name_unique UNIQUE (name)
,
    CONSTRAINT departments_faculries_link FOREIGN KEY (faculty_id)
        REFERENCES public."Faculties" (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT check_departments_name_not_empty CHECK (name::text <> ' '::text),
    CONSTRAINT check_financing_valid CHECK (financing >= 0::money),
    CONSTRAINT check_valid_building CHECK (building >= 1 AND building <= 5) NOT VALID
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public."Departments"
    OWNER to postgres;


-- Table: public."Faculties"

-- DROP TABLE public."Faculties";

CREATE TABLE public."Faculties"
(
    id integer NOT NULL DEFAULT nextval('"Faculties_id_seq"'::regclass) ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 2147483647 CACHE 1 ),
    name character varying(100) COLLATE pg_catalog."default" NOT NULL,
    financing money NOT NULL DEFAULT '0,00 ?'::money,
    building integer NOT NULL,
    dean_id integer NOT NULL,
    CONSTRAINT "Faculties_pkey" PRIMARY KEY (id),
    CONSTRAINT check_name_unique UNIQUE (name)
,
    CONSTRAINT link_faculty_to_dean FOREIGN KEY (dean_id)
        REFERENCES public."Deans" (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT check_financing_valid CHECK (financing > 0::money),
    CONSTRAINT check_valid_building CHECK (building >= 1 AND building <= 5) NOT VALID
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public."Faculties"
    OWNER to postgres;


-- Table: public."Groups"

-- DROP TABLE public."Groups";

CREATE TABLE public."Groups"
(
    id integer NOT NULL DEFAULT nextval('"Groups_id_seq"'::regclass) ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 2147483647 CACHE 1 ),
    name character varying(10) COLLATE pg_catalog."default" NOT NULL,
    year integer NOT NULL,
    department_id integer NOT NULL,
    CONSTRAINT "Groups_pkey" PRIMARY KEY (id),
    CONSTRAINT groups_name_unique UNIQUE (name)
,
    CONSTRAINT link_groups_on_departments FOREIGN KEY (department_id)
        REFERENCES public."Departments" (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT check_name_not_empty CHECK (name::text <> ' '::text),
    CONSTRAINT check_year_valid CHECK (year > 0 AND year < 6)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public."Groups"
    OWNER to postgres;


-- Table: public."Groups_curators"

-- DROP TABLE public."Groups_curators";

CREATE TABLE public."Groups_curators"
(
    id integer NOT NULL DEFAULT nextval('groups_curators_id_seq'::regclass) ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 2147483647 CACHE 1 ),
    curator_id integer NOT NULL,
    group_id integer NOT NULL,
    CONSTRAINT groups_curators_pkey PRIMARY KEY (id),
    CONSTRAINT link_group_curator_on_group FOREIGN KEY (group_id)
        REFERENCES public."Groups" (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT "link_group_curators_on curator" FOREIGN KEY (curator_id)
        REFERENCES public."Curators" (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public."Groups_curators"
    OWNER to postgres;


-- Table: public."Groups_lectures"

-- DROP TABLE public."Groups_lectures";

CREATE TABLE public."Groups_lectures"
(
    id integer NOT NULL DEFAULT nextval('"Groups_lectures_id_seq"'::regclass) ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 2147483647 CACHE 1 ),
    group_id integer NOT NULL,
    lecture_id integer NOT NULL,
    CONSTRAINT "Groups_lectures_pkey" PRIMARY KEY (id),
    CONSTRAINT link_groups_lecture_on_group FOREIGN KEY (group_id)
        REFERENCES public."Groups" (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public."Groups_lectures"
    OWNER to postgres;


-- Table: public."Heads"

-- DROP TABLE public."Heads";

CREATE TABLE public."Heads"
(
    id integer NOT NULL DEFAULT nextval('"Heads_id_seq"'::regclass) ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 2147483647 CACHE 1 ),
    teacher_id integer NOT NULL,
    CONSTRAINT "Heads_pkey" PRIMARY KEY (id),
    CONSTRAINT link_head_to_teacher FOREIGN KEY (teacher_id)
        REFERENCES public."Teachers" (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public."Heads"
    OWNER to postgres;


-- Table: public."Lectures"

-- DROP TABLE public."Lectures";

CREATE TABLE public."Lectures"
(
    id integer NOT NULL DEFAULT nextval('"Lectures_id_seq"'::regclass) ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 2147483647 CACHE 1 ),
    subject_id integer NOT NULL,
    teacher_id integer NOT NULL,
    CONSTRAINT "Lectures_pkey" PRIMARY KEY (id),
    CONSTRAINT link_lecture_on_subject FOREIGN KEY (subject_id)
        REFERENCES public."Subject" (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT link_lectures_on_teachers FOREIGN KEY (teacher_id)
        REFERENCES public."Teachers" (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public."Lectures"
    OWNER to postgres;


-- Table: public."Lectures_rooms"

-- DROP TABLE public."Lectures_rooms";

CREATE TABLE public."Lectures_rooms"
(
    id integer NOT NULL DEFAULT nextval('"Lectures_rooms_id_seq"'::regclass) ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 2147483647 CACHE 1 ),
    building integer NOT NULL,
    name character varying(10) COLLATE pg_catalog."default" NOT NULL,
    CONSTRAINT "Lectures_rooms_pkey" PRIMARY KEY (id),
    CONSTRAINT name_unique UNIQUE (name)
,
    CONSTRAINT check_name_not_empty CHECK (name::text <> ' '::text) NOT VALID
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public."Lectures_rooms"
    OWNER to postgres;


-- Table: public."Schedules"

-- DROP TABLE public."Schedules";

CREATE TABLE public."Schedules"
(
    id integer NOT NULL DEFAULT nextval('"Schedules_id_seq"'::regclass) ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 2147483647 CACHE 1 ),
    class integer NOT NULL,
    day_of_week integer NOT NULL,
    week integer NOT NULL,
    lectures_id integer NOT NULL,
    lectures_room_id integer NOT NULL,
    CONSTRAINT "Schedules_pkey" PRIMARY KEY (id),
    CONSTRAINT link_schedules_to_lectures FOREIGN KEY (lectures_id)
        REFERENCES public."Lectures" (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT link_schedules_to_lectures_rooms FOREIGN KEY (lectures_room_id)
        REFERENCES public."Lectures_rooms" (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT check_valid_class CHECK (class >= 1 AND class <= 8),
    CONSTRAINT check_valid_day_of_week CHECK (day_of_week >= 1 AND day_of_week <= 7),
    CONSTRAINT check_valid_week CHECK (week >= 1 AND week <= 52)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public."Schedules"
    OWNER to postgres;



-- Table: public."Subject"

-- DROP TABLE public."Subject";

CREATE TABLE public."Subject"
(
    id integer NOT NULL DEFAULT nextval('"Subject_id_seq"'::regclass) ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 2147483647 CACHE 1 ),
    name character varying(100) COLLATE pg_catalog."default" NOT NULL,
    CONSTRAINT "Subject_pkey" PRIMARY KEY (id),
    CONSTRAINT unique_name UNIQUE (name)
,
    CONSTRAINT check_name_not_empty CHECK (name::text <> ' '::text)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public."Subject"
    OWNER to postgres;


-- Table: public."Teachers"

-- DROP TABLE public."Teachers";

CREATE TABLE public."Teachers"
(
    id integer NOT NULL DEFAULT nextval('"Teachers_id_seq"'::regclass) ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 2147483647 CACHE 1 ),
    name character varying(10485760) COLLATE pg_catalog."default" NOT NULL,
    salary money NOT NULL,
    surname character varying(10485760) COLLATE pg_catalog."default" NOT NULL,
    CONSTRAINT "Teachers_pkey" PRIMARY KEY (id),
    CONSTRAINT check_teachers_name CHECK (name::text <> ' '::text),
    CONSTRAINT check_teachers_solary CHECK (salary > 0::money),
    CONSTRAINT check_teachers_surname CHECK (surname::text <> ' '::text)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public."Teachers"
    OWNER to postgres;