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

ALTER TABLE ONLY public.users DROP CONSTRAINT users_users_id_fk;
ALTER TABLE ONLY public.tasks DROP CONSTRAINT tasks_projects_id_fk;
ALTER TABLE ONLY public.projects DROP CONSTRAINT projects_users_id_fk_2;
ALTER TABLE ONLY public.projects DROP CONSTRAINT projects_users_id_fk;
ALTER TABLE ONLY public.project_assignment DROP CONSTRAINT project_assignment_users_id_fk;
ALTER TABLE ONLY public.project_assignment DROP CONSTRAINT project_assignment_projects_id_fk;
ALTER TABLE ONLY public.documents DROP CONSTRAINT documents_projects_id_fk;
ALTER TABLE ONLY public.activities DROP CONSTRAINT activities_users_id_fk;
ALTER TABLE ONLY public.activities DROP CONSTRAINT activities_tasks_id_fk;
ALTER TABLE ONLY public.activities DROP CONSTRAINT activities_submitted_errors_id_fk;
ALTER TABLE ONLY public.activities DROP CONSTRAINT activities_documents_id_fk;
DROP INDEX public.users_login_uindex;
DROP INDEX public.submitted_errors_id_uindex;
DROP INDEX public.projects_name_uindex;
DROP INDEX public.documents_id_uindex;
ALTER TABLE ONLY public.users DROP CONSTRAINT users_pk;
ALTER TABLE ONLY public.submitted_errors DROP CONSTRAINT submitted_errors_pk;
ALTER TABLE ONLY public.projects DROP CONSTRAINT projects_pk;
ALTER TABLE ONLY public.project_assignment DROP CONSTRAINT project_assignment_pk;
ALTER TABLE ONLY public.tasks DROP CONSTRAINT tasks_pk;
ALTER TABLE ONLY public.documents DROP CONSTRAINT documents_pk;
ALTER TABLE ONLY public.activities DROP CONSTRAINT activities_pk;
ALTER TABLE public.users ALTER COLUMN id DROP DEFAULT;
ALTER TABLE public.tasks ALTER COLUMN id DROP DEFAULT;
ALTER TABLE public.submitted_errors ALTER COLUMN id DROP DEFAULT;
ALTER TABLE public.projects ALTER COLUMN id DROP DEFAULT;
ALTER TABLE public.project_assignment ALTER COLUMN id DROP DEFAULT;
ALTER TABLE public.documents ALTER COLUMN id DROP DEFAULT;
ALTER TABLE public.activities ALTER COLUMN id DROP DEFAULT;
DROP SEQUENCE public.users_id_seq;
DROP TABLE public.users;
DROP SEQUENCE public.project_assignment_id_seq;
DROP SEQUENCE public.submitted_errors_id_seq;
DROP TABLE public.submitted_errors;
DROP SEQUENCE public.projects_id_seq;
DROP TABLE public.projects;
DROP TABLE public.project_assignment;
DROP SEQUENCE public.task_id_seq;
DROP TABLE public.tasks;
DROP SEQUENCE public.documents_id_seq;
DROP TABLE public.documents;
DROP TABLE public.activities;
DROP TYPE public.role;
DROP TYPE public.related_resource;
DROP TYPE public.project_role;
DROP SEQUENCE public.activities_id_seq;


--
-- Name: project_role; Type: TYPE; Schema: public; Owner: apsi
--

CREATE TYPE public.project_role AS ENUM (
    'kierownik projektu',
    'uczestnik projektu'
);


ALTER TYPE public.project_role OWNER TO apsi;

--
-- Name: related_resource; Type: TYPE; Schema: public; Owner: apsi
--

CREATE TYPE public.related_resource AS ENUM (
    'brak',
    'dokument',
    'zgłoszony problem'
);


ALTER TYPE public.related_resource OWNER TO apsi;

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
    client_approved boolean,
    related_resource public.related_resource,
    document integer,
    error integer
);


ALTER TABLE public.activities OWNER TO apsi;

--
-- Name: documents; Type: TABLE; Schema: public; Owner: apsi
--

CREATE TABLE public.documents (
    id integer NOT NULL,
    project integer NOT NULL,
    name character varying(50) NOT NULL
);


ALTER TABLE public.documents OWNER TO apsi;

--
-- Name: documents_id_seq; Type: SEQUENCE; Schema: public; Owner: apsi
--

CREATE SEQUENCE public.documents_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.documents_id_seq OWNER TO apsi;

--
-- Name: documents_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: apsi
--

ALTER SEQUENCE public.documents_id_seq OWNED BY public.documents.id;


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
-- Name: task_id_seq; Type: SEQUENCE; Schema: public; Owner: apsi
--

CREATE SEQUENCE public.task_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.task_id_seq OWNER TO apsi;

ALTER SEQUENCE public.task_id_seq OWNED BY public.tasks.id;
--
-- Name: activities_id_seq; Type: SEQUENCE; Schema: public; Owner: apsi
--

CREATE SEQUENCE public.activities_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.activities_id_seq OWNER TO apsi;

ALTER SEQUENCE public.activities_id_seq OWNED BY public.activities.id;


--
-- Name: project_assignment; Type: TABLE; Schema: public; Owner: apsi
--

CREATE TABLE public.project_assignment (
    id integer NOT NULL,
    user_id integer NOT NULL,
    project_id integer,
    project_role public.project_role NOT NULL,
    start date NOT NULL,
    "end" date
);


ALTER TABLE public.project_assignment OWNER TO apsi;

--
-- Name: projects; Type: TABLE; Schema: public; Owner: apsi
--

CREATE TABLE public.projects (
    id integer NOT NULL,
    name character varying(50) NOT NULL,
    description character varying(500),
    creator integer NOT NULL,
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
-- Name: submitted_errors; Type: TABLE; Schema: public; Owner: apsi
--

CREATE TABLE public.submitted_errors (
    id integer NOT NULL,
    project integer NOT NULL,
    name character varying(50) NOT NULL
);


ALTER TABLE public.submitted_errors OWNER TO apsi;

--
-- Name: submitted_errors_id_seq; Type: SEQUENCE; Schema: public; Owner: apsi
--

CREATE SEQUENCE public.submitted_errors_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.submitted_errors_id_seq OWNER TO apsi;

--
-- Name: submitted_errors_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: apsi
--

ALTER SEQUENCE public.submitted_errors_id_seq OWNED BY public.submitted_errors.id;


--
-- Name: project_assignment_id_seq; Type: SEQUENCE; Schema: public; Owner: apsi
--

CREATE SEQUENCE public.project_assignment_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.project_assignment_id_seq OWNER TO apsi;

--
-- Name: project_assignment_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: apsi
--

ALTER SEQUENCE public.project_assignment_id_seq OWNED BY public.project_assignment.id;


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
-- Name: documents id; Type: DEFAULT; Schema: public; Owner: apsi
--

ALTER TABLE ONLY public.documents ALTER COLUMN id SET DEFAULT nextval('public.documents_id_seq'::regclass);


--
-- Name: project_assignment id; Type: DEFAULT; Schema: public; Owner: apsi
--

ALTER TABLE ONLY public.project_assignment ALTER COLUMN id SET DEFAULT nextval('public.project_assignment_id_seq'::regclass);


--
-- Name: projects id; Type: DEFAULT; Schema: public; Owner: apsi
--

ALTER TABLE ONLY public.projects ALTER COLUMN id SET DEFAULT nextval('public.projects_id_seq'::regclass);


--
-- Name: submitted_errors id; Type: DEFAULT; Schema: public; Owner: apsi
--

ALTER TABLE ONLY public.submitted_errors ALTER COLUMN id SET DEFAULT nextval('public.submitted_errors_id_seq'::regclass);


--
-- Name: tasks id; Type: DEFAULT; Schema: public; Owner: apsi
--

ALTER TABLE ONLY public.tasks ALTER COLUMN id SET DEFAULT nextval('public.task_id_seq'::regclass);

--
-- Name: activities id; Type: DEFAULT; Schema: public; Owner: apsi
--

ALTER TABLE ONLY public.activities ALTER COLUMN id SET DEFAULT nextval('public.activities_id_seq'::regclass);

--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: apsi
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Data for Name: activities; Type: TABLE DATA; Schema: public; Owner: apsi
--





--
-- Domyślni użytkownicy do developmentu
-- Hasło dla wszystkich to 123456
--

--	Pracownicy	--
INSERT INTO public.users (id, login, password, name, surname, role, supervisor) VALUES (2, 'pracownik1', '$2b$12$2pUji2QFKl2wr0O7tuMDyOvtkQBz.Qa5IuSWYw8/0RAKp2zxqn5/6', 'Janusz', 'Kowal', 'pracownik', NULL);
INSERT INTO public.users (id, login, password, name, surname, role, supervisor) VALUES (3, 'pracownik2', '$2b$12$2pUji2QFKl2wr0O7tuMDyOvtkQBz.Qa5IuSWYw8/0RAKp2zxqn5/6', 'Andrzej', 'Nowakowski', 'pracownik', NULL);
INSERT INTO public.users (id, login, password, name, surname, role, supervisor) VALUES (4, 'pracownik3', '$2b$12$2pUji2QFKl2wr0O7tuMDyOvtkQBz.Qa5IuSWYw8/0RAKp2zxqn5/6', 'Krzysztof', 'Janowski', 'pracownik', NULL);
--	Kierownicy/menadżerowie	--
INSERT INTO public.users (id, login, password, name, surname, role, supervisor) VALUES (5, 'kierownik1', '$2b$12$2pUji2QFKl2wr0O7tuMDyOvtkQBz.Qa5IuSWYw8/0RAKp2zxqn5/6', 'Adrian', 'Kierwoniczy', 'kierownik', NULL);
INSERT INTO public.users (id, login, password, name, surname, role, supervisor) VALUES (6, 'kierownik2', '$2b$12$2pUji2QFKl2wr0O7tuMDyOvtkQBz.Qa5IuSWYw8/0RAKp2zxqn5/6', 'Jan', 'Testowy', 'kierownik', NULL);
INSERT INTO public.users (id, login, password, name, surname, role, supervisor) VALUES (7, 'kierownik3', '$2b$12$2pUji2QFKl2wr0O7tuMDyOvtkQBz.Qa5IuSWYw8/0RAKp2zxqn5/6', 'Przemysław', 'Bazowy', 'kierownik', NULL);
--	Klienci	--
INSERT INTO public.users (id, login, password, name, surname, role, supervisor) VALUES (8, 'klient1', '$2b$12$2pUji2QFKl2wr0O7tuMDyOvtkQBz.Qa5IuSWYw8/0RAKp2zxqn5/6', 'Radosław', 'Kliencki', 'klient', NULL);
INSERT INTO public.users (id, login, password, name, surname, role, supervisor) VALUES (9, 'klient2', '$2b$12$2pUji2QFKl2wr0O7tuMDyOvtkQBz.Qa5IuSWYw8/0RAKp2zxqn5/6', 'Mścisław', 'Klientowy', 'klient', NULL);
INSERT INTO public.users (id, login, password, name, surname, role, supervisor) VALUES (10, 'klient3', '$2b$12$2pUji2QFKl2wr0O7tuMDyOvtkQBz.Qa5IuSWYw8/0RAKp2zxqn5/6', 'Dobromir', 'Kustomerowy', 'klient', NULL);






--- Projekt nr 1, brak klienta, 1 pracownik jako kierownik projektu (zakładający), 2 pracowników zwykłych, 1 menadżer również jako kierownik projektu

INSERT INTO public.projects (id, name, description, creator, client) VALUES (1, 'Projekt sklepu SuperABC', 'Bardzo ciekawy projekt sklepu spożywczego', 2, NULL);

INSERT INTO public.tasks (id, name, description, project) VALUES (1, 'Strona internetowa SuperABC', 'Stworzenie strony internetowej sklepu spożywczego SuperABC', 1);
INSERT INTO public.tasks (id, name, description, project) VALUES (2, 'SEO strony internetowej', 'Elementy związane z SEO strony', 1);

INSERT INTO public.project_assignment (id, user_id, project_id, project_role, start, "end") VALUES (1, 2, 1, 'kierownik projektu', '2022-06-16', NULL);
INSERT INTO public.project_assignment (id, user_id, project_id, project_role, start, "end") VALUES (2, 3, 1, 'uczestnik projektu', '2022-06-16', NULL);
INSERT INTO public.project_assignment (id, user_id, project_id, project_role, start, "end") VALUES (3, 4, 1, 'uczestnik projektu', '2022-06-16', NULL);
INSERT INTO public.project_assignment (id, user_id, project_id, project_role, start, "end") VALUES (4, 5, 1, 'kierownik projektu', '2022-06-16', NULL);

INSERT INTO public.activities (id, user_id, task_id, date, "time", description, supervisor_approved, client_approved, related_resource, document, error) VALUES (2, 2, 1, '2022-06-12', INTERVAL '5' HOUR, 'Widok strony głównej', TRUE, NULL, 'brak', NULL, NULL);
INSERT INTO public.activities (id, user_id, task_id, date, "time", description, supervisor_approved, client_approved, related_resource, document, error) VALUES (3, 2, 1, '2022-06-13', INTERVAL '7' HOUR, 'Widok podstrony produktu X', FALSE, NULL, 'brak', NULL, NULL);
INSERT INTO public.activities (id, user_id, task_id, date, "time", description, supervisor_approved, client_approved, related_resource, document, error) VALUES (4, 2, 1, '2022-06-14', INTERVAL '4' HOUR, 'Poprawiony widok podstrony produktu X', NULL, NULL, 'brak', NULL, NULL);
INSERT INTO public.activities (id, user_id, task_id, date, "time", description, supervisor_approved, client_approved, related_resource, document, error) VALUES (5, 3, 1, '2022-06-12', INTERVAL '2' HOUR, 'Poprawki widoku strony głównej', TRUE, NULL, 'brak', NULL, NULL);
INSERT INTO public.activities (id, user_id, task_id, date, "time", description, supervisor_approved, client_approved, related_resource, document, error) VALUES (6, 3, 1, '2022-06-13', INTERVAL '3' HOUR, 'Poprawki widoku podstrony produktu X', NULL, NULL, 'brak', NULL, NULL);
INSERT INTO public.activities (id, user_id, task_id, date, "time", description, supervisor_approved, client_approved, related_resource, document, error) VALUES (7, 3, 1, '2022-06-13', INTERVAL '5' HOUR, 'Podstrona produktu Y', NULL, NULL, 'brak', NULL, NULL);
INSERT INTO public.activities (id, user_id, task_id, date, "time", description, supervisor_approved, client_approved, related_resource, document, error) VALUES (8, 4, 1, '2022-06-16', INTERVAL '12' HOUR, 'Backend produktów', NULL, NULL, 'brak', NULL, NULL);
INSERT INTO public.activities (id, user_id, task_id, date, "time", description, supervisor_approved, client_approved, related_resource, document, error) VALUES (9, 4, 2, '2022-06-17', INTERVAL '12' HOUR, 'Baza dla SEO strony głównej', TRUE, NULL, 'brak', NULL, NULL);
INSERT INTO public.activities (id, user_id, task_id, date, "time", description, supervisor_approved, client_approved, related_resource, document, error) VALUES (10, 4, 2, '2022-06-18', INTERVAL '7' HOUR, 'SEO podstron produktów', FALSE, NULL, 'brak', NULL, NULL);
INSERT INTO public.activities (id, user_id, task_id, date, "time", description, supervisor_approved, client_approved, related_resource, document, error) VALUES (11, 4, 2, '2022-06-18', INTERVAL '1' HOUR, 'Poprawka SEO podstron produktów', FALSE, NULL, 'brak', NULL, NULL);
INSERT INTO public.activities (id, user_id, task_id, date, "time", description, supervisor_approved, client_approved, related_resource, document, error) VALUES (12, 4, 2, '2022-06-18', INTERVAL '2' HOUR, 'SEO strony głównej - poprawki', NULL, NULL, 'brak', NULL, NULL);




--- Projekt nr 2, 1 klient, 1 menadżer jako kierownik projektu (zakładający), 2 pracowników zwykłych, 1 menadżer również jako kierownik projektu

INSERT INTO public.projects (id, name, description, creator, client) VALUES (2, 'Aplikacja mobilna dla Firmy Testowej S.A.', 'Aplikacja mobilna dla klienta', 5, 8);

INSERT INTO public.tasks (id, name, description, project) VALUES (3, 'Mockup aplikacji', 'Mockup aplikacji mobilnej dla klienta', 2);
INSERT INTO public.tasks (id, name, description, project) VALUES (4, 'UX design', 'Projekt UX dla aplikacji mobilnej klienta', 2);
INSERT INTO public.tasks (id, name, description, project) VALUES (5, 'Infrastruktura', 'Elementy związane z infrastrukturą i deploymentem', 2);

INSERT INTO public.project_assignment (id, user_id, project_id, project_role, start, "end") VALUES (5, 3, 2, 'uczestnik projektu', '2022-06-16', NULL);
INSERT INTO public.project_assignment (id, user_id, project_id, project_role, start, "end") VALUES (6, 4, 2, 'uczestnik projektu', '2022-06-16', NULL);
INSERT INTO public.project_assignment (id, user_id, project_id, project_role, start, "end") VALUES (7, 5, 2, 'kierownik projektu', '2022-06-16', NULL);
INSERT INTO public.project_assignment (id, user_id, project_id, project_role, start, "end") VALUES (8, 6, 2, 'kierownik projektu', '2022-06-16', NULL);

INSERT INTO public.activities (id, user_id, task_id, date, "time", description, supervisor_approved, client_approved, related_resource, document, error) VALUES (13, 3, 5, '2022-06-13', INTERVAL '1' HOUR, 'Bazowa infrastruktura', TRUE, NULL, 'brak', NULL, NULL);
INSERT INTO public.activities (id, user_id, task_id, date, "time", description, supervisor_approved, client_approved, related_resource, document, error) VALUES (14, 6, 5, '2022-06-13', INTERVAL '3' HOUR, 'Struktura deploymentu', NULL, NULL, 'brak', NULL, NULL);
INSERT INTO public.activities (id, user_id, task_id, date, "time", description, supervisor_approved, client_approved, related_resource, document, error) VALUES (15, 3, 3, '2022-06-13', INTERVAL '4' HOUR, 'Wstępna wersja mockupu', TRUE, NULL, 'brak', NULL, NULL);
INSERT INTO public.activities (id, user_id, task_id, date, "time", description, supervisor_approved, client_approved, related_resource, document, error) VALUES (16, 4, 3, '2022-06-13', INTERVAL '2' HOUR, 'Poprawki wizualne do mockupu', TRUE, NULL, 'brak', NULL, NULL);
INSERT INTO public.activities (id, user_id, task_id, date, "time", description, supervisor_approved, client_approved, related_resource, document, error) VALUES (17, 5, 3, '2022-06-14', INTERVAL '3' HOUR, 'Poprawki funkcjonalne do mockupu', NULL, NULL, 'brak', NULL, NULL);
INSERT INTO public.activities (id, user_id, task_id, date, "time", description, supervisor_approved, client_approved, related_resource, document, error) VALUES (18, 5, 4, '2022-06-14', INTERVAL '5' HOUR, 'UX strony startowej', TRUE, NULL, 'brak', NULL, NULL);
INSERT INTO public.activities (id, user_id, task_id, date, "time", description, supervisor_approved, client_approved, related_resource, document, error) VALUES (19, 5, 4, '2022-06-19', INTERVAL '7' HOUR, 'UX przycisków aplikacji', NULL, NULL, 'brak', NULL, NULL);
INSERT INTO public.activities (id, user_id, task_id, date, "time", description, supervisor_approved, client_approved, related_resource, document, error) VALUES (20, 5, 4, '2022-06-20', INTERVAL '8' HOUR, 'UX podstron', NULL, NULL, 'brak', NULL, NULL);
INSERT INTO public.activities (id, user_id, task_id, date, "time", description, supervisor_approved, client_approved, related_resource, document, error) VALUES (21, 5, 4, '2022-06-22', INTERVAL '12' HOUR, 'UX podstron cd', NULL, NULL, 'brak', NULL, NULL);



--- Projekt nr 3, 1 klient, 1 menadżer jako kierownik projektu (zakładający), 1 pracowników zwykłych

INSERT INTO public.projects (id, name, description, creator, client) VALUES (3, 'Instalacja oprogramowania w Firmie Testowej S.A.', 'Instalacja oprogramowania dla Firmy Testowej', 5, 8);

INSERT INTO public.tasks (id, name, description, project) VALUES (6, 'Instalacja on-site', 'Instalacja oprogramowania w firmie klienta', 3);

INSERT INTO public.project_assignment (id, user_id, project_id, project_role, start, "end") VALUES (9, 2, 3, 'uczestnik projektu', '2022-06-16', NULL);
INSERT INTO public.project_assignment (id, user_id, project_id, project_role, start, "end") VALUES (10, 3, 3, 'uczestnik projektu', '2022-06-16', NULL);
INSERT INTO public.project_assignment (id, user_id, project_id, project_role, start, "end") VALUES (11, 4, 3, 'uczestnik projektu', '2022-06-16', NULL);
INSERT INTO public.project_assignment (id, user_id, project_id, project_role, start, "end") VALUES (12, 5, 3, 'kierownik projektu', '2022-06-16', NULL);

INSERT INTO public.activities (id, user_id, task_id, date, "time", description, supervisor_approved, client_approved, related_resource, document, error) VALUES (22, 2, 6, '2022-06-23', INTERVAL '7' HOUR, 'Instalacja programów X', TRUE, NULL, 'brak', NULL, NULL);
INSERT INTO public.activities (id, user_id, task_id, date, "time", description, supervisor_approved, client_approved, related_resource, document, error) VALUES (23, 3, 6, '2022-06-24', INTERVAL '7' HOUR, 'Instalacja programów Y', NULL, NULL, 'brak', NULL, NULL);
INSERT INTO public.activities (id, user_id, task_id, date, "time", description, supervisor_approved, client_approved, related_resource, document, error) VALUES (24, 4, 6, '2022-06-25', INTERVAL '7' HOUR, 'Instalacja programów Z', NULL, NULL, 'brak', NULL, NULL);
INSERT INTO public.activities (id, user_id, task_id, date, "time", description, supervisor_approved, client_approved, related_resource, document, error) VALUES (25, 5, 6, '2022-06-26', INTERVAL '7' HOUR, 'Instalacja programów W', NULL, NULL, 'brak', NULL, NULL);



--
-- Data for Name: submitted_errors; Type: TABLE DATA; Schema: public; Owner: apsi
--

INSERT INTO public.submitted_errors (id, project, name) VALUES (1, 1, '20931 - Connection error');
INSERT INTO public.submitted_errors (id, project, name) VALUES (2, 1, '13339 - Wrong validation');
INSERT INTO public.submitted_errors (id, project, name) VALUES (3, 2, '18992 - Infinite loading');
INSERT INTO public.submitted_errors (id, project, name) VALUES (4, 3, '22301 - UI bug');


--
-- Data for Name: documents; Type: TABLE DATA; Schema: public; Owner: apsi
--

INSERT INTO public.documents (id, project, name) VALUES (1, 1, 'dokumentacja');
INSERT INTO public.documents (id, project, name) VALUES (2, 2, 'dokumentacja');
INSERT INTO public.documents (id, project, name) VALUES (3, 3, 'dokumentacja');
INSERT INTO public.documents (id, project, name) VALUES (4, 3, 'dokumentacja użytkowa');
INSERT INTO public.documents (id, project, name) VALUES (5, 1, 'wykresy');


--
-- Name: task_id_seq; Type: SEQUENCE SET; Schema: public; Owner: apsi
--

SELECT pg_catalog.setval('public.task_id_seq', 7, true);


--
-- Name: documents_id_seq; Type: SEQUENCE SET; Schema: public; Owner: apsi
--

SELECT pg_catalog.setval('public.documents_id_seq', 5, true);


--
-- Name: task_id_seq; Type: SEQUENCE SET; Schema: public; Owner: apsi
--

SELECT pg_catalog.setval('public.activities_id_seq', 26, true);

--
-- Name: projects_id_seq; Type: SEQUENCE SET; Schema: public; Owner: apsi
--

SELECT pg_catalog.setval('public.projects_id_seq', 4, true);

--
-- Name: submitted_errors_id_seq; Type: SEQUENCE SET; Schema: public; Owner: apsi
--

SELECT pg_catalog.setval('public.submitted_errors_id_seq', 4, true);


--
-- Name: project_assignment_id_seq; Type: SEQUENCE SET; Schema: public; Owner: apsi
--

SELECT pg_catalog.setval('public.project_assignment_id_seq', 13, true);


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: apsi
--

SELECT pg_catalog.setval('public.users_id_seq', 11, true);


--
-- Name: activities activities_pk; Type: CONSTRAINT; Schema: public; Owner: apsi
--

ALTER TABLE ONLY public.activities
    ADD CONSTRAINT activities_pk PRIMARY KEY (id);


--
-- Name: documents documents_pk; Type: CONSTRAINT; Schema: public; Owner: apsi
--

ALTER TABLE ONLY public.documents
    ADD CONSTRAINT documents_pk PRIMARY KEY (id);


--
-- Name: tasks tasks_pk; Type: CONSTRAINT; Schema: public; Owner: apsi
--

ALTER TABLE ONLY public.tasks
    ADD CONSTRAINT tasks_pk PRIMARY KEY (id);


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
-- Name: submitted_errors submitted_errors_pk; Type: CONSTRAINT; Schema: public; Owner: apsi
--

ALTER TABLE ONLY public.submitted_errors
    ADD CONSTRAINT submitted_errors_pk PRIMARY KEY (id);


--
-- Name: users users_pk; Type: CONSTRAINT; Schema: public; Owner: apsi
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pk PRIMARY KEY (id);


--
-- Name: documents_id_uindex; Type: INDEX; Schema: public; Owner: apsi
--

CREATE UNIQUE INDEX documents_id_uindex ON public.documents USING btree (id);


--
-- Name: projects_name_uindex; Type: INDEX; Schema: public; Owner: apsi
--

CREATE UNIQUE INDEX projects_name_uindex ON public.projects USING btree (name);


--
-- Name: submitted_errors_id_uindex; Type: INDEX; Schema: public; Owner: apsi
--

CREATE UNIQUE INDEX submitted_errors_id_uindex ON public.submitted_errors USING btree (id);


--
-- Name: users_login_uindex; Type: INDEX; Schema: public; Owner: apsi
--

CREATE UNIQUE INDEX users_login_uindex ON public.users USING btree (login);


--
-- Name: activities activities_documents_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: apsi
--

ALTER TABLE ONLY public.activities
    ADD CONSTRAINT activities_documents_id_fk FOREIGN KEY (document) REFERENCES public.documents(id);


--
-- Name: activities activities_submitted_errors_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: apsi
--

ALTER TABLE ONLY public.activities
    ADD CONSTRAINT activities_submitted_errors_id_fk FOREIGN KEY (error) REFERENCES public.submitted_errors(id);


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
-- Name: documents documents_projects_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: apsi
--

ALTER TABLE ONLY public.documents
    ADD CONSTRAINT documents_projects_id_fk FOREIGN KEY (project) REFERENCES public.projects(id);


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
    ADD CONSTRAINT projects_users_id_fk FOREIGN KEY (creator) REFERENCES public.users(id);


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

