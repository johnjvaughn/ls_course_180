--
-- PostgreSQL database dump
--

-- Dumped from database version 9.6.5
-- Dumped by pg_dump version 9.6.5

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: SCHEMA "public"; Type: COMMENT; Schema: -; Owner: postgres
--

COMMENT ON SCHEMA "public" IS 'standard public schema';


--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS "plpgsql" WITH SCHEMA "pg_catalog";


--
-- Name: EXTENSION "plpgsql"; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION "plpgsql" IS 'PL/pgSQL procedural language';


SET search_path = "public", pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: expenses; Type: TABLE; Schema: public; Owner: John
--

CREATE TABLE "expenses" (
    "id" integer NOT NULL,
    "amount" numeric(6,2) NOT NULL,
    "memo" "text" NOT NULL,
    "created_on" "date" NOT NULL,
    CONSTRAINT "expenses_amount_check" CHECK (("amount" > (0)::numeric))
);


ALTER TABLE "expenses" OWNER TO "John";

--
-- Name: expenses_id_seq; Type: SEQUENCE; Schema: public; Owner: John
--

CREATE SEQUENCE "expenses_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "expenses_id_seq" OWNER TO "John";

--
-- Name: expenses_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: John
--

ALTER SEQUENCE "expenses_id_seq" OWNED BY "expenses"."id";


--
-- Name: expenses id; Type: DEFAULT; Schema: public; Owner: John
--

ALTER TABLE ONLY "expenses" ALTER COLUMN "id" SET DEFAULT "nextval"('"expenses_id_seq"'::"regclass");


--
-- Data for Name: expenses; Type: TABLE DATA; Schema: public; Owner: John
--

COPY "expenses" ("id", "amount", "memo", "created_on") FROM stdin;
4	14.56	Pencils	2017-10-09
5	3.29	Coffee	2017-10-09
6	49.99	Text Editor	2017-10-09
8	3.59	More Coffee	2017-10-09
9	57.55	3-martini lunch	2017-10-09
11	7.59	Gas for Karen's car	2017-10-09
15	91.23	Electric bill	2017-10-09
\.


--
-- Name: expenses_id_seq; Type: SEQUENCE SET; Schema: public; Owner: John
--

SELECT pg_catalog.setval('"expenses_id_seq"', 15, true);


--
-- Name: expenses expenses_pkey; Type: CONSTRAINT; Schema: public; Owner: John
--

ALTER TABLE ONLY "expenses"
    ADD CONSTRAINT "expenses_pkey" PRIMARY KEY ("id");


--
-- PostgreSQL database dump complete
--

