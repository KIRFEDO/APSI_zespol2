--
-- PostgreSQL database dump
--

-- Dumped from database version 12.9 (Ubuntu 12.9-0ubuntu0.20.04.1)
-- Dumped by pg_dump version 12.9 (Ubuntu 12.9-0ubuntu0.20.04.1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: apsi_db; Type: DATABASE; Schema: -; Owner: apsi
--

CREATE DATABASE apsi_db WITH TEMPLATE = template0 ENCODING = 'UTF8' LC_COLLATE = 'C.UTF-8' LC_CTYPE = 'C.UTF-8';


ALTER DATABASE apsi_db OWNER TO apsi;

\connect apsi_db

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: role; Type: TYPE; Schema: public; Owner: apsi
--

CREATE TYPE public.role AS ENUM (
    'kierownik',
    'pracownik',
    'klient'
);


ALTER TYPE public.role OWNER TO apsi;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: activities; Type: TABLE; Schema: public; Owner: apsi
--

CREATE TABLE public.activities (
    id integer NOT NULL,
    user_id integer NOT NULL,
    task_id integer NOT NULL,
    date date NOT NULL,
    "time" interval NOT NULL,
    description character varying,
    supervisor_approved boolean,
    client_approved boolean
);


ALTER TABLE public.activities OWNER TO apsi;

--
-- Name: tasks; Type: TABLE; Schema: public; Owner: apsi
--

CREATE TABLE public.tasks (
    id integer NOT NULL,
    name character varying(50) NOT NULL,
    description character varying(500),
    project integer NOT NULL
);


ALTER TABLE public.tasks OWNER TO apsi;

--
-- Name: epics_id_seq; Type: SEQUENCE; Schema: public; Owner: apsi
--

CREATE SEQUENCE public.epics_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.epics_id_seq OWNER TO apsi;

--
-- Name: epics_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: apsi
--

ALTER SEQUENCE public.epics_id_seq OWNED BY public.tasks.id;


--
-- Name: project_assignment; Type: TABLE; Schema: public; Owner: apsi
--

CREATE TABLE public.project_assignment (
    id integer NOT NULL,
    user_id integer NOT NULL,
    project_id integer
);


ALTER TABLE public.project_assignment OWNER TO apsi;

--
-- Name: projects; Type: TABLE; Schema: public; Owner: apsi
--

CREATE TABLE public.projects (
    id integer NOT NULL,
    name character varying(50) NOT NULL,
    description character varying(500),
    supervisor integer NOT NULL,
    client integer
);


ALTER TABLE public.projects OWNER TO apsi;

--
-- Name: projects_id_seq; Type: SEQUENCE; Schema: public; Owner: apsi
--

CREATE SEQUENCE public.projects_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.projects_id_seq OWNER TO apsi;

--
-- Name: projects_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: apsi
--

ALTER SEQUENCE public.projects_id_seq OWNED BY public.projects.id;


--
-- Name: table_name_id_seq; Type: SEQUENCE; Schema: public; Owner: apsi
--

CREATE SEQUENCE public.table_name_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.table_name_id_seq OWNER TO apsi;

--
-- Name: table_name_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: apsi
--

ALTER SEQUENCE public.table_name_id_seq OWNED BY public.activities.id;


--
-- Name: table_name_id_seq1; Type: SEQUENCE; Schema: public; Owner: apsi
--

CREATE SEQUENCE public.table_name_id_seq1
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.table_name_id_seq1 OWNER TO apsi;

--
-- Name: table_name_id_seq1; Type: SEQUENCE OWNED BY; Schema: public; Owner: apsi
--

ALTER SEQUENCE public.table_name_id_seq1 OWNED BY public.project_assignment.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: apsi
--

CREATE TABLE public.users (
    id integer NOT NULL,
    login character varying(20) NOT NULL,
    password character varying(100) NOT NULL,
    name character varying(20) NOT NULL,
    surname character varying(30) NOT NULL,
    role public.role NOT NULL,
    supervisor integer
);


ALTER TABLE public.users OWNER TO apsi;

--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: apsi
--

CREATE SEQUENCE public.users_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.users_id_seq OWNER TO apsi;

--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: apsi
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: activities id; Type: DEFAULT; Schema: public; Owner: apsi
--

ALTER TABLE ONLY public.activities ALTER COLUMN id SET DEFAULT nextval('public.table_name_id_seq'::regclass);


--
-- Name: project_assignment id; Type: DEFAULT; Schema: public; Owner: apsi
--

ALTER TABLE ONLY public.project_assignment ALTER COLUMN id SET DEFAULT nextval('public.table_name_id_seq1'::regclass);


--
-- Name: projects id; Type: DEFAULT; Schema: public; Owner: apsi
--

ALTER TABLE ONLY public.projects ALTER COLUMN id SET DEFAULT nextval('public.projects_id_seq'::regclass);


--
-- Name: tasks id; Type: DEFAULT; Schema: public; Owner: apsi
--

ALTER TABLE ONLY public.tasks ALTER COLUMN id SET DEFAULT nextval('public.epics_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: apsi
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Data for Name: activities; Type: TABLE DATA; Schema: public; Owner: apsi
--



--
-- Data for Name: project_assignment; Type: TABLE DATA; Schema: public; Owner: apsi
--



--
-- Data for Name: projects; Type: TABLE DATA; Schema: public; Owner: apsi
--



--
-- Data for Name: tasks; Type: TABLE DATA; Schema: public; Owner: apsi
--



--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: apsi
--

INSERT INTO public.users (id, login, password, name, surname, role, supervisor) VALUES (2, 'test', '$2b$12$4oqRenQIPtSV6RQoWkPoROxbKujx3gMu/j2nXacrRET2we6CPYWnq', 'test', 'test', 'kierownik', NULL);
INSERT INTO public.users (id, login, password, name, surname, role, supervisor) VALUES (3, 'test22', '$2b$12$uxupU0jF6yUNkFXzDj2j9uGhVyiD5y46MF3iBXVSZtRl3BngO7Dqa', 'test2', 'test2', 'kierownik', NULL);
INSERT INTO public.users (id, login, password, name, surname, role, supervisor) VALUES (4, '123456', '$2b$12$f0WToV4/E9mVtGAFYprLD.o4KOhqLo5ZxG6x5uAkkswewmrY0j28O', '123456', '123456', 'pracownik', NULL);
INSERT INTO public.users (id, login, password, name, surname, role, supervisor) VALUES (5, 'qwerty', '$2b$12$56qegmRAHAdeYS3EV/8qWuP69Wt.kOCxvNRxFKjDY0Bww7bhgOTQ.', 'qwerty', 'qwerty', 'klient', NULL);


--
-- Name: epics_id_seq; Type: SEQUENCE SET; Schema: public; Owner: apsi
--

SELECT pg_catalog.setval('public.epics_id_seq', 1, true);


--
-- Name: projects_id_seq; Type: SEQUENCE SET; Schema: public; Owner: apsi
--

SELECT pg_catalog.setval('public.projects_id_seq', 1, true);


--
-- Name: table_name_id_seq; Type: SEQUENCE SET; Schema: public; Owner: apsi
--

SELECT pg_catalog.setval('public.table_name_id_seq', 1, true);


--
-- Name: table_name_id_seq1; Type: SEQUENCE SET; Schema: public; Owner: apsi
--

SELECT pg_catalog.setval('public.table_name_id_seq1', 1, true);


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: apsi
--

SELECT pg_catalog.setval('public.users_id_seq', 5, true);


--
-- Name: activities activities_pk; Type: CONSTRAINT; Schema: public; Owner: apsi
--

ALTER TABLE ONLY public.activities
    ADD CONSTRAINT activities_pk PRIMARY KEY (id);


--
-- Name: tasks epics_pk; Type: CONSTRAINT; Schema: public; Owner: apsi
--

ALTER TABLE ONLY public.tasks
    ADD CONSTRAINT epics_pk PRIMARY KEY (id);


--
-- Name: project_assignment project_assignment_pk; Type: CONSTRAINT; Schema: public; Owner: apsi
--

ALTER TABLE ONLY public.project_assignment
    ADD CONSTRAINT project_assignment_pk PRIMARY KEY (id);


--
-- Name: projects projects_pk; Type: CONSTRAINT; Schema: public; Owner: apsi
--

ALTER TABLE ONLY public.projects
    ADD CONSTRAINT projects_pk PRIMARY KEY (id);


--
-- Name: users users_pk; Type: CONSTRAINT; Schema: public; Owner: apsi
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pk PRIMARY KEY (id);


--
-- Name: projects_name_uindex; Type: INDEX; Schema: public; Owner: apsi
--

CREATE UNIQUE INDEX projects_name_uindex ON public.projects USING btree (name);


--
-- Name: users_login_uindex; Type: INDEX; Schema: public; Owner: apsi
--

CREATE UNIQUE INDEX users_login_uindex ON public.users USING btree (login);


--
-- Name: activities activities_tasks_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: apsi
--

ALTER TABLE ONLY public.activities
    ADD CONSTRAINT activities_tasks_id_fk FOREIGN KEY (task_id) REFERENCES public.tasks(id) ON DELETE CASCADE;


--
-- Name: activities activities_users_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: apsi
--

ALTER TABLE ONLY public.activities
    ADD CONSTRAINT activities_users_id_fk FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: project_assignment project_assignment_projects_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: apsi
--

ALTER TABLE ONLY public.project_assignment
    ADD CONSTRAINT project_assignment_projects_id_fk FOREIGN KEY (project_id) REFERENCES public.projects(id) ON DELETE CASCADE;


--
-- Name: project_assignment project_assignment_users_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: apsi
--

ALTER TABLE ONLY public.project_assignment
    ADD CONSTRAINT project_assignment_users_id_fk FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: projects projects_users_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: apsi
--

ALTER TABLE ONLY public.projects
    ADD CONSTRAINT projects_users_id_fk FOREIGN KEY (supervisor) REFERENCES public.users(id);


--
-- Name: projects projects_users_id_fk_2; Type: FK CONSTRAINT; Schema: public; Owner: apsi
--

ALTER TABLE ONLY public.projects
    ADD CONSTRAINT projects_users_id_fk_2 FOREIGN KEY (client) REFERENCES public.users(id);


--
-- Name: tasks tasks_projects_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: apsi
--

ALTER TABLE ONLY public.tasks
    ADD CONSTRAINT tasks_projects_id_fk FOREIGN KEY (project) REFERENCES public.projects(id) ON DELETE CASCADE;


--
-- Name: users users_users_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: apsi
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_users_id_fk FOREIGN KEY (supervisor) REFERENCES public.users(id);


--
-- PostgreSQL database dump complete
--



insert into projects (id, name, description, supervisor) values (1, 'Projekt sklepu SuperABC', 'Bardzo ciekawy projekt sklepu spożywczego', 2);

insert into tasks (id, name, description , project)
values (1,'Strona internetowa SuperABC', 'Stworzenie strony internetowej sklepu spożywczego SuperABC', 1);