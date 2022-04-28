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
    'administrator',
    'employee'
);


ALTER TYPE public.role OWNER TO apsi;

--
-- Name: status; Type: TYPE; Schema: public; Owner: apsi
--

CREATE TYPE public.status AS ENUM (
    'aktywny',
    'zakończony',
    'zawieszony'
);


ALTER TYPE public.status OWNER TO apsi;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: epics; Type: TABLE; Schema: public; Owner: apsi
--

CREATE TABLE public.epics (
    id integer NOT NULL,
    name character varying(50) NOT NULL,
    description character varying(500),
    creator integer,
    deadline date NOT NULL,
    supervisor_approved boolean NOT NULL,
    client_approved boolean NOT NULL,
    project integer NOT NULL
);


ALTER TABLE public.epics OWNER TO apsi;

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

ALTER SEQUENCE public.epics_id_seq OWNED BY public.epics.id;


--
-- Name: projects; Type: TABLE; Schema: public; Owner: apsi
--

CREATE TABLE public.projects (
    id integer NOT NULL,
    name character varying(50) NOT NULL,
    description character varying(500),
    status public.status NOT NULL,
    supervisor integer,
    client integer,
    start date NOT NULL,
    deadline date NOT NULL
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
-- Name: tasks; Type: TABLE; Schema: public; Owner: apsi
--

CREATE TABLE public.tasks (
    id integer NOT NULL,
    name character varying(50),
    description character varying(500),
    creator integer NOT NULL,
    expected_time double precision,
    assigned_to integer,
    finished boolean NOT NULL,
    supervisor_approved boolean NOT NULL,
    epic integer NOT NULL
);


ALTER TABLE public.tasks OWNER TO apsi;

--
-- Name: tasks_id_seq; Type: SEQUENCE; Schema: public; Owner: apsi
--

CREATE SEQUENCE public.tasks_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tasks_id_seq OWNER TO apsi;

--
-- Name: tasks_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: apsi
--

ALTER SEQUENCE public.tasks_id_seq OWNED BY public.tasks.id;


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
    supervisor integer,
    active boolean NOT NULL
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
-- Name: epics id; Type: DEFAULT; Schema: public; Owner: apsi
--

ALTER TABLE ONLY public.epics ALTER COLUMN id SET DEFAULT nextval('public.epics_id_seq'::regclass);


--
-- Name: projects id; Type: DEFAULT; Schema: public; Owner: apsi
--

ALTER TABLE ONLY public.projects ALTER COLUMN id SET DEFAULT nextval('public.projects_id_seq'::regclass);


--
-- Name: tasks id; Type: DEFAULT; Schema: public; Owner: apsi
--

ALTER TABLE ONLY public.tasks ALTER COLUMN id SET DEFAULT nextval('public.tasks_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: apsi
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Data for Name: epics; Type: TABLE DATA; Schema: public; Owner: apsi
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

INSERT INTO public.users (id, login, password, name, surname, role, supervisor, active) VALUES (2, 'test', '$2b$12$4oqRenQIPtSV6RQoWkPoROxbKujx3gMu/j2nXacrRET2we6CPYWnq', 'test', 'test', 'administrator', NULL, true);


--
-- Name: epics_id_seq; Type: SEQUENCE SET; Schema: public; Owner: apsi
--

SELECT pg_catalog.setval('public.epics_id_seq', 1, false);


--
-- Name: projects_id_seq; Type: SEQUENCE SET; Schema: public; Owner: apsi
--

SELECT pg_catalog.setval('public.projects_id_seq', 1, false);


--
-- Name: tasks_id_seq; Type: SEQUENCE SET; Schema: public; Owner: apsi
--

SELECT pg_catalog.setval('public.tasks_id_seq', 1, false);


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: apsi
--

SELECT pg_catalog.setval('public.users_id_seq', 2, true);


--
-- Name: epics epics_pk; Type: CONSTRAINT; Schema: public; Owner: apsi
--

ALTER TABLE ONLY public.epics
    ADD CONSTRAINT epics_pk PRIMARY KEY (id);


--
-- Name: projects projects_pk; Type: CONSTRAINT; Schema: public; Owner: apsi
--

ALTER TABLE ONLY public.projects
    ADD CONSTRAINT projects_pk PRIMARY KEY (id);


--
-- Name: tasks tasks_pk; Type: CONSTRAINT; Schema: public; Owner: apsi
--

ALTER TABLE ONLY public.tasks
    ADD CONSTRAINT tasks_pk PRIMARY KEY (id);


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
-- Name: epics epics_projects_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: apsi
--

ALTER TABLE ONLY public.epics
    ADD CONSTRAINT epics_projects_id_fk FOREIGN KEY (project) REFERENCES public.projects(id) ON DELETE CASCADE;


--
-- Name: epics epics_users_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: apsi
--

ALTER TABLE ONLY public.epics
    ADD CONSTRAINT epics_users_id_fk FOREIGN KEY (creator) REFERENCES public.users(id);


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
-- Name: tasks tasks_epics_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: apsi
--

ALTER TABLE ONLY public.tasks
    ADD CONSTRAINT tasks_epics_id_fk FOREIGN KEY (epic) REFERENCES public.epics(id) ON DELETE CASCADE;


--
-- Name: tasks tasks_users_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: apsi
--

ALTER TABLE ONLY public.tasks
    ADD CONSTRAINT tasks_users_id_fk FOREIGN KEY (assigned_to) REFERENCES public.users(id);


--
-- Name: tasks tasks_users_id_fk_2; Type: FK CONSTRAINT; Schema: public; Owner: apsi
--

ALTER TABLE ONLY public.tasks
    ADD CONSTRAINT tasks_users_id_fk_2 FOREIGN KEY (creator) REFERENCES public.users(id);


--
-- Name: users users_users_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: apsi
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_users_id_fk FOREIGN KEY (supervisor) REFERENCES public.users(id);


--
-- PostgreSQL database dump complete
--
