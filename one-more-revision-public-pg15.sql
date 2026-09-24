--
-- PostgreSQL database dump
--

\restrict 0d9ctvjqXKLaleSCemjQv5nVewMN82bhfgmVCmHZXMaxcmWaQw3D0Jp5G6W0fTJ

-- Dumped from database version 17.6
-- Dumped by pg_dump version 17.11 (Homebrew)

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
-- Name: public; Type: SCHEMA; Schema: -; Owner: -
--



--
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON SCHEMA public IS 'standard public schema';


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: categories; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.categories (
    id bigint NOT NULL,
    name character varying(120) NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL
);


--
-- Name: categories_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.categories_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: categories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.categories_id_seq OWNED BY public.categories.id;


--
-- Name: flyway_schema_history; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.flyway_schema_history (
    installed_rank integer NOT NULL,
    version character varying(50),
    description character varying(200) NOT NULL,
    type character varying(20) NOT NULL,
    script character varying(1000) NOT NULL,
    checksum integer,
    installed_by character varying(100) NOT NULL,
    installed_on timestamp without time zone DEFAULT now() NOT NULL,
    execution_time integer NOT NULL,
    success boolean NOT NULL
);


--
-- Name: questions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.questions (
    id bigint NOT NULL,
    category_id bigint NOT NULL,
    subcategory_id bigint,
    question text NOT NULL,
    question_source character varying(255),
    question_source_url character varying(1000),
    answer_source character varying(255),
    answer_source_url character varying(1000),
    studied_before boolean DEFAULT false NOT NULL,
    practice_count integer DEFAULT 0 NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    CONSTRAINT ck_practice_count_nonnegative CHECK ((practice_count >= 0))
);


--
-- Name: questions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.questions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: questions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.questions_id_seq OWNED BY public.questions.id;


--
-- Name: subcategories; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.subcategories (
    id bigint NOT NULL,
    category_id bigint NOT NULL,
    name character varying(120) NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL
);


--
-- Name: subcategories_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.subcategories_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: subcategories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.subcategories_id_seq OWNED BY public.subcategories.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.users (
    id bigint NOT NULL,
    email character varying(255) NOT NULL,
    password_hash character varying(255) NOT NULL,
    display_name character varying(120) NOT NULL,
    enabled boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL
);


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: workspace_notes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.workspace_notes (
    id bigint NOT NULL,
    question_id bigint NOT NULL,
    user_id bigint NOT NULL,
    answer text NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL
);


--
-- Name: workspace_notes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.workspace_notes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: workspace_notes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.workspace_notes_id_seq OWNED BY public.workspace_notes.id;


--
-- Name: categories id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.categories ALTER COLUMN id SET DEFAULT nextval('public.categories_id_seq'::regclass);


--
-- Name: questions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.questions ALTER COLUMN id SET DEFAULT nextval('public.questions_id_seq'::regclass);


--
-- Name: subcategories id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.subcategories ALTER COLUMN id SET DEFAULT nextval('public.subcategories_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Name: workspace_notes id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.workspace_notes ALTER COLUMN id SET DEFAULT nextval('public.workspace_notes_id_seq'::regclass);


--
-- Data for Name: categories; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.categories (id, name, created_at, updated_at) FROM stdin;
2	DSA	2026-09-19 06:53:27.49948+00	2026-09-19 06:53:27.49948+00
\.


--
-- Data for Name: flyway_schema_history; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.flyway_schema_history (installed_rank, version, description, type, script, checksum, installed_by, installed_on, execution_time, success) FROM stdin;
1	1	init	SQL	V1__init.sql	1810787650	postgres	2026-09-19 06:26:54.162777	2205	t
2	2	drop checklist no	SQL	V2__drop_checklist_no.sql	819637115	postgres	2026-09-19 06:26:58.527831	989	t
\.


--
-- Data for Name: questions; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.questions (id, category_id, subcategory_id, question, question_source, question_source_url, answer_source, answer_source_url, studied_before, practice_count, created_at, updated_at) FROM stdin;
2	2	2	Two Sum	LeetCode	https://leetcode.com/problems/two-sum/	\N	\N	f	0	2026-09-19 06:53:27.950866+00	2026-09-19 06:53:27.950866+00
3	2	2	Contains Duplicate	LeetCode	https://leetcode.com/problems/contains-duplicate/	\N	\N	f	0	2026-09-19 06:53:28.384722+00	2026-09-19 06:53:28.384722+00
4	2	2	Contains Duplicate II	LeetCode	https://leetcode.com/problems/contains-duplicate-ii/	\N	\N	f	0	2026-09-19 06:53:28.812053+00	2026-09-19 06:53:28.812053+00
5	2	2	Valid Anagram	LeetCode	https://leetcode.com/problems/valid-anagram/	\N	\N	f	0	2026-09-19 06:53:29.238372+00	2026-09-19 06:53:29.238372+00
6	2	2	Majority Element	LeetCode	https://leetcode.com/problems/majority-element/	\N	\N	f	0	2026-09-19 06:53:29.66677+00	2026-09-19 06:53:29.66677+00
7	2	2	Missing Number	LeetCode	https://leetcode.com/problems/missing-number/	\N	\N	f	0	2026-09-19 06:53:30.233375+00	2026-09-19 06:53:30.233375+00
8	2	2	Find All Numbers Disappeared in an Array	LeetCode	https://leetcode.com/problems/find-all-numbers-disappeared-in-an-array/	\N	\N	f	0	2026-09-19 06:53:30.810936+00	2026-09-19 06:53:30.810936+00
9	2	2	Single Number	LeetCode	https://leetcode.com/problems/single-number/	\N	\N	f	0	2026-09-19 06:53:31.376133+00	2026-09-19 06:53:31.376133+00
10	2	2	Intersection of Two Arrays	LeetCode	https://leetcode.com/problems/intersection-of-two-arrays/	\N	\N	f	0	2026-09-19 06:53:31.940987+00	2026-09-19 06:53:31.940987+00
11	2	2	Intersection of Two Arrays II	LeetCode	https://leetcode.com/problems/intersection-of-two-arrays-ii/	\N	\N	f	0	2026-09-19 06:53:32.506644+00	2026-09-19 06:53:32.506644+00
12	2	2	Best Time to Buy and Sell Stock	LeetCode	https://leetcode.com/problems/best-time-to-buy-and-sell-stock/	\N	\N	f	0	2026-09-19 06:53:33.071944+00	2026-09-19 06:53:33.071944+00
13	2	3	Maximum Subarray	LeetCode	https://leetcode.com/problems/maximum-subarray/	\N	\N	f	0	2026-09-19 06:53:33.776027+00	2026-09-19 06:53:33.776027+00
14	2	4	Maximum Product Subarray	LeetCode	https://leetcode.com/problems/maximum-product-subarray/	\N	\N	f	0	2026-09-19 06:53:34.482327+00	2026-09-19 06:53:34.482327+00
15	2	5	Product of Array Except Self	LeetCode	https://leetcode.com/problems/product-of-array-except-self/	\N	\N	f	0	2026-09-19 06:53:35.188737+00	2026-09-19 06:53:35.188737+00
16	2	2	Longest Consecutive Sequence	LeetCode	https://leetcode.com/problems/longest-consecutive-sequence/	\N	\N	f	0	2026-09-19 06:53:35.751875+00	2026-09-19 06:53:35.751875+00
17	2	5	Subarray Sum Equals K	LeetCode	https://leetcode.com/problems/subarray-sum-equals-k/	\N	\N	f	0	2026-09-19 06:53:36.315592+00	2026-09-19 06:53:36.315592+00
18	2	5	Find Pivot Index	LeetCode	https://leetcode.com/problems/find-pivot-index/	\N	\N	f	0	2026-09-19 06:53:36.880435+00	2026-09-19 06:53:36.880435+00
19	2	5	Running Sum of 1d Array	LeetCode	https://leetcode.com/problems/running-sum-of-1d-array/	\N	\N	f	0	2026-09-19 06:53:37.444986+00	2026-09-19 06:53:37.444986+00
20	2	2	Find the Difference of Two Arrays	LeetCode	https://leetcode.com/problems/find-the-difference-of-two-arrays/	\N	\N	f	0	2026-09-19 06:53:38.009021+00	2026-09-19 06:53:38.009021+00
21	2	2	Find the Number That Appears Once	GFG	\N	\N	\N	f	0	2026-09-19 06:53:38.572901+00	2026-09-19 06:53:38.572901+00
25	2	6	4Sum	LeetCode	https://leetcode.com/problems/4sum/	\N	\N	f	0	2026-09-19 06:53:41.111447+00	2026-09-19 06:53:41.111447+00
28	2	6	Remove Duplicates from Sorted Array	LeetCode	https://leetcode.com/problems/remove-duplicates-from-sorted-array/	\N	\N	f	0	2026-09-19 06:53:42.803132+00	2026-09-19 06:53:42.803132+00
30	2	6	Move Zeroes	LeetCode	https://leetcode.com/problems/move-zeroes/	\N	\N	f	0	2026-09-19 06:53:43.930762+00	2026-09-19 06:53:43.930762+00
31	2	6	Sort Colors	LeetCode	https://leetcode.com/problems/sort-colors/	\N	\N	f	0	2026-09-19 06:53:44.49521+00	2026-09-19 06:53:44.49521+00
32	2	6	Valid Palindrome	LeetCode	https://leetcode.com/problems/valid-palindrome/	\N	\N	f	0	2026-09-19 06:53:45.059245+00	2026-09-19 06:53:45.059245+00
33	2	6	Valid Palindrome II	LeetCode	https://leetcode.com/problems/valid-palindrome-ii/	\N	\N	f	0	2026-09-19 06:53:45.623544+00	2026-09-19 06:53:45.623544+00
34	2	6	Squares of a Sorted Array	LeetCode	https://leetcode.com/problems/squares-of-a-sorted-array/	\N	\N	f	0	2026-09-19 06:53:46.19047+00	2026-09-19 06:53:46.19047+00
35	2	7	Longest Substring Without Repeating Characters	LeetCode	https://leetcode.com/problems/longest-substring-without-repeating-characters/	\N	\N	f	0	2026-09-19 06:53:47.035016+00	2026-09-19 06:53:47.035016+00
36	2	7	Longest Repeating Character Replacement	LeetCode	https://leetcode.com/problems/longest-repeating-character-replacement/	\N	\N	f	0	2026-09-19 06:53:47.599592+00	2026-09-19 06:53:47.599592+00
37	2	7	Permutation in String	LeetCode	https://leetcode.com/problems/permutation-in-string/	\N	\N	f	0	2026-09-19 06:53:48.163385+00	2026-09-19 06:53:48.163385+00
38	2	7	Minimum Window Substring	LeetCode	https://leetcode.com/problems/minimum-window-substring/	\N	\N	f	0	2026-09-19 06:53:48.727566+00	2026-09-19 06:53:48.727566+00
39	2	7	Find All Anagrams in a String	LeetCode	https://leetcode.com/problems/find-all-anagrams-in-a-string/	\N	\N	f	0	2026-09-19 06:53:49.291618+00	2026-09-19 06:53:49.291618+00
40	2	7	Maximum Average Subarray I	LeetCode	https://leetcode.com/problems/maximum-average-subarray-i/	\N	\N	f	0	2026-09-19 06:53:49.857704+00	2026-09-19 06:53:49.857704+00
41	2	8	Sliding Window Maximum	LeetCode	https://leetcode.com/problems/sliding-window-maximum/	\N	\N	f	0	2026-09-19 06:53:50.702596+00	2026-09-19 06:53:50.702596+00
42	2	5	Range Sum Query – Immutable	LeetCode	https://leetcode.com/problems/range-sum-query-immutable/	\N	\N	f	0	2026-09-19 06:53:51.266811+00	2026-09-19 06:53:51.266811+00
43	2	5	Continuous Subarray Sum	LeetCode	https://leetcode.com/problems/continuous-subarray-sum/	\N	\N	f	0	2026-09-19 06:53:51.830281+00	2026-09-19 06:53:51.830281+00
44	2	5	Contiguous Array	LeetCode	https://leetcode.com/problems/contiguous-array/	\N	\N	f	0	2026-09-19 06:53:52.434744+00	2026-09-19 06:53:52.434744+00
45	2	5	Maximum Size Subarray Sum Equals k	GFG	\N	\N	\N	f	0	2026-09-19 06:53:52.997592+00	2026-09-19 06:53:52.997592+00
46	2	5	Equilibrium Point	GFG	\N	\N	\N	f	0	2026-09-19 06:53:53.634141+00	2026-09-19 06:53:53.634141+00
47	2	9	Count Number of Subarrays With Given XOR	GFG	\N	\N	\N	f	0	2026-09-19 06:53:54.616324+00	2026-09-19 06:53:54.616324+00
48	2	10	Corporate Flight Bookings	LeetCode	https://leetcode.com/problems/corporate-flight-bookings/	\N	\N	f	0	2026-09-19 06:53:55.462524+00	2026-09-19 06:53:55.462524+00
22	2	6	Two Sum II – Sorted Array	LeetCode	https://leetcode.com/problems/two-sum-ii-input-array-is-sorted/	Youtube - Nikhil	https://www.youtube.com/watch?v=Bk6Im9h6ouA	t	1	2026-09-19 06:53:39.419127+00	2026-09-19 08:51:23.044067+00
24	2	6	3Sum Closest	LeetCode	https://leetcode.com/problems/3sum-closest/	Youtube - Nikhil	https://www.youtube.com/watch?v=uSpJQa6MRZ8	t	1	2026-09-19 06:53:40.548329+00	2026-09-19 10:31:56.485207+00
27	2	6	Trapping Rain Water	LeetCode	https://leetcode.com/problems/trapping-rain-water/	Utube	https://www.youtube.com/watch?v=09KF1hjWoSU	t	1	2026-09-19 06:53:42.239277+00	2026-09-21 17:29:24.259937+00
29	2	6	Remove Element	LeetCode	https://leetcode.com/problems/remove-element/	LeetCode	https://leetcode.com/problems/remove-element/	t	1	2026-09-19 06:53:43.367336+00	2026-09-21 17:54:56.686039+00
49	2	10	Car Pooling	LeetCode	https://leetcode.com/problems/car-pooling/	\N	\N	f	0	2026-09-19 06:53:56.028143+00	2026-09-19 06:53:56.028143+00
50	2	11	Bubble Sort	GFG	\N	\N	\N	f	0	2026-09-19 06:53:56.875066+00	2026-09-19 06:53:56.875066+00
51	2	11	Selection Sort	GFG	\N	\N	\N	f	0	2026-09-19 06:53:57.440317+00	2026-09-19 06:53:57.440317+00
52	2	11	Insertion Sort	GFG	\N	\N	\N	f	0	2026-09-19 06:53:58.134963+00	2026-09-19 06:53:58.134963+00
53	2	11	Merge Sort	GFG	\N	\N	\N	f	0	2026-09-19 06:53:58.69863+00	2026-09-19 06:53:58.69863+00
54	2	11	Quick Sort	GFG	\N	\N	\N	f	0	2026-09-19 06:53:59.262394+00	2026-09-19 06:53:59.262394+00
55	2	11	Sort an Array	LeetCode	https://leetcode.com/problems/sort-an-array/	\N	\N	f	0	2026-09-19 06:53:59.825476+00	2026-09-19 06:53:59.825476+00
56	2	12	Kth Largest Element in an Array	LeetCode	https://leetcode.com/problems/kth-largest-element-in-an-array/	\N	\N	f	0	2026-09-19 06:54:00.669196+00	2026-09-19 06:54:00.669196+00
57	2	12	Kth Smallest Element in an Array	GFG	\N	\N	\N	f	0	2026-09-19 06:54:01.231911+00	2026-09-19 06:54:01.231911+00
58	2	6	Merge Sorted Array	LeetCode	https://leetcode.com/problems/merge-sorted-array/	\N	\N	f	0	2026-09-19 06:54:01.795363+00	2026-09-19 06:54:01.795363+00
59	2	13	Relative Sort Array	LeetCode	https://leetcode.com/problems/relative-sort-array/	\N	\N	f	0	2026-09-19 06:54:02.640701+00	2026-09-19 06:54:02.640701+00
60	2	14	Largest Number	LeetCode	https://leetcode.com/problems/largest-number/	\N	\N	f	0	2026-09-19 06:54:03.483749+00	2026-09-19 06:54:03.483749+00
61	2	15	Maximum Gap	LeetCode	https://leetcode.com/problems/maximum-gap/	\N	\N	f	0	2026-09-19 06:54:04.327491+00	2026-09-19 06:54:04.327491+00
62	2	16	Meeting Rooms	LeetCode	https://leetcode.com/problems/meeting-rooms/	\N	\N	f	0	2026-09-19 06:54:05.171361+00	2026-09-19 06:54:05.171361+00
63	2	17	Meeting Rooms II	LeetCode	https://leetcode.com/problems/meeting-rooms-ii/	\N	\N	f	0	2026-09-19 06:54:06.01431+00	2026-09-19 06:54:06.01431+00
64	2	18	Binary Search	LeetCode	https://leetcode.com/problems/binary-search/	\N	\N	f	0	2026-09-19 06:54:06.861609+00	2026-09-19 06:54:06.861609+00
65	2	18	Search Insert Position	LeetCode	https://leetcode.com/problems/search-insert-position/	\N	\N	f	0	2026-09-19 06:54:07.425194+00	2026-09-19 06:54:07.425194+00
66	2	19	First Bad Version	LeetCode	https://leetcode.com/problems/first-bad-version/	\N	\N	f	0	2026-09-19 06:54:08.269959+00	2026-09-19 06:54:08.269959+00
67	2	18	Find First and Last Position	LeetCode	https://leetcode.com/problems/find-first-and-last-position-of-element-in-sorted-array/	\N	\N	f	0	2026-09-19 06:54:08.832722+00	2026-09-19 06:54:08.832722+00
68	2	20	Search in Rotated Sorted Array	LeetCode	https://leetcode.com/problems/search-in-rotated-sorted-array/	\N	\N	f	0	2026-09-19 06:54:09.676644+00	2026-09-19 06:54:09.676644+00
69	2	20	Search in Rotated Sorted Array II	LeetCode	https://leetcode.com/problems/search-in-rotated-sorted-array-ii/	\N	\N	f	0	2026-09-19 06:54:10.24107+00	2026-09-19 06:54:10.24107+00
70	2	20	Find Minimum in Rotated Sorted Array	LeetCode	https://leetcode.com/problems/find-minimum-in-rotated-sorted-array/	\N	\N	f	0	2026-09-19 06:54:10.834438+00	2026-09-19 06:54:10.834438+00
71	2	18	Find Peak Element	LeetCode	https://leetcode.com/problems/find-peak-element/	\N	\N	f	0	2026-09-19 06:54:11.398384+00	2026-09-19 06:54:11.398384+00
72	2	18	Single Element in a Sorted Array	LeetCode	https://leetcode.com/problems/single-element-in-a-sorted-array/	\N	\N	f	0	2026-09-19 06:54:11.962176+00	2026-09-19 06:54:11.962176+00
73	2	19	Koko Eating Bananas	LeetCode	https://leetcode.com/problems/koko-eating-bananas/	\N	\N	f	0	2026-09-19 06:54:12.525747+00	2026-09-19 06:54:12.525747+00
74	2	19	Capacity To Ship Packages Within D Days	LeetCode	https://leetcode.com/problems/capacity-to-ship-packages-within-d-days/	\N	\N	f	0	2026-09-19 06:54:13.088503+00	2026-09-19 06:54:13.088503+00
75	2	19	Split Array Largest Sum	LeetCode	https://leetcode.com/problems/split-array-largest-sum/	\N	\N	f	0	2026-09-19 06:54:13.652605+00	2026-09-19 06:54:13.652605+00
76	2	18	Median of Two Sorted Arrays	LeetCode	https://leetcode.com/problems/median-of-two-sorted-arrays/	\N	\N	f	0	2026-09-19 06:54:14.215627+00	2026-09-19 06:54:14.215627+00
77	2	18	Search a 2D Matrix	LeetCode	https://leetcode.com/problems/search-a-2d-matrix/	\N	\N	f	0	2026-09-19 06:54:14.778881+00	2026-09-19 06:54:14.778881+00
78	2	21	Search a 2D Matrix II	LeetCode	https://leetcode.com/problems/search-a-2d-matrix-ii/	\N	\N	f	0	2026-09-19 06:54:15.622205+00	2026-09-19 06:54:15.622205+00
79	2	22	Spiral Matrix	LeetCode	https://leetcode.com/problems/spiral-matrix/	\N	\N	f	0	2026-09-19 06:54:16.465308+00	2026-09-19 06:54:16.465308+00
80	2	22	Spiral Matrix II	LeetCode	https://leetcode.com/problems/spiral-matrix-ii/	\N	\N	f	0	2026-09-19 06:54:17.02921+00	2026-09-19 06:54:17.02921+00
81	2	22	Rotate Image	LeetCode	https://leetcode.com/problems/rotate-image/	\N	\N	f	0	2026-09-19 06:54:17.592891+00	2026-09-19 06:54:17.592891+00
82	2	22	Set Matrix Zeroes	LeetCode	https://leetcode.com/problems/set-matrix-zeroes/	\N	\N	f	0	2026-09-19 06:54:18.156399+00	2026-09-19 06:54:18.156399+00
83	2	22	Transpose Matrix	LeetCode	https://leetcode.com/problems/transpose-matrix/	\N	\N	f	0	2026-09-19 06:54:18.721557+00	2026-09-19 06:54:18.721557+00
84	2	22	Reshape the Matrix	LeetCode	https://leetcode.com/problems/reshape-the-matrix/	\N	\N	f	0	2026-09-19 06:54:19.285444+00	2026-09-19 06:54:19.285444+00
85	2	23	Game of Life	LeetCode	https://leetcode.com/problems/game-of-life/	\N	\N	f	0	2026-09-19 06:54:20.12959+00	2026-09-19 06:54:20.12959+00
86	2	24	Word Search	LeetCode	https://leetcode.com/problems/word-search/	\N	\N	f	0	2026-09-19 06:54:20.97297+00	2026-09-19 06:54:20.97297+00
87	2	22	Diagonal Traverse	LeetCode	https://leetcode.com/problems/diagonal-traverse/	\N	\N	f	0	2026-09-19 06:54:21.536067+00	2026-09-19 06:54:21.536067+00
88	2	22	Lucky Numbers in a Matrix	LeetCode	https://leetcode.com/problems/lucky-numbers-in-a-matrix/	\N	\N	f	0	2026-09-19 06:54:22.099414+00	2026-09-19 06:54:22.099414+00
89	2	25	Reverse String	LeetCode	https://leetcode.com/problems/reverse-string/	\N	\N	f	0	2026-09-19 06:54:22.942447+00	2026-09-19 06:54:22.942447+00
90	2	25	Reverse Words in a String	LeetCode	https://leetcode.com/problems/reverse-words-in-a-string/	\N	\N	f	0	2026-09-19 06:54:23.505709+00	2026-09-19 06:54:23.505709+00
91	2	25	Reverse Words in a String III	LeetCode	https://leetcode.com/problems/reverse-words-in-a-string-iii/	\N	\N	f	0	2026-09-19 06:54:24.069002+00	2026-09-19 06:54:24.069002+00
92	2	2	Group Anagrams	LeetCode	https://leetcode.com/problems/group-anagrams/	\N	\N	f	0	2026-09-19 06:54:24.632629+00	2026-09-19 06:54:24.632629+00
93	2	25	Longest Common Prefix	LeetCode	https://leetcode.com/problems/longest-common-prefix/	\N	\N	f	0	2026-09-19 06:54:25.195244+00	2026-09-19 06:54:25.195244+00
94	2	2	First Unique Character in a String	LeetCode	https://leetcode.com/problems/first-unique-character-in-a-string/	\N	\N	f	0	2026-09-19 06:54:25.758027+00	2026-09-19 06:54:25.758027+00
95	2	2	Isomorphic Strings	LeetCode	https://leetcode.com/problems/isomorphic-strings/	\N	\N	f	0	2026-09-19 06:54:26.434619+00	2026-09-19 06:54:26.434619+00
96	2	2	Word Pattern	LeetCode	https://leetcode.com/problems/word-pattern/	\N	\N	f	0	2026-09-19 06:54:27.055075+00	2026-09-19 06:54:27.055075+00
98	2	26	Longest Palindromic Substring	LeetCode	https://leetcode.com/problems/longest-palindromic-substring/	\N	\N	f	0	2026-09-19 06:54:28.460987+00	2026-09-19 06:54:28.460987+00
99	2	26	Palindromic Substrings	LeetCode	https://leetcode.com/problems/palindromic-substrings/	\N	\N	f	0	2026-09-19 06:54:29.024042+00	2026-09-19 06:54:29.024042+00
100	2	27	Valid Parentheses	LeetCode	https://leetcode.com/problems/valid-parentheses/	\N	\N	f	0	2026-09-19 06:54:29.868626+00	2026-09-19 06:54:29.868626+00
101	2	4	Longest Valid Parentheses	LeetCode	https://leetcode.com/problems/longest-valid-parentheses/	\N	\N	f	0	2026-09-19 06:54:30.43473+00	2026-09-19 06:54:30.43473+00
102	2	28	Implement strStr / Find Index	LeetCode	https://leetcode.com/problems/find-the-index-of-the-first-occurrence-in-a-string/	\N	\N	f	0	2026-09-19 06:54:31.277659+00	2026-09-19 06:54:31.277659+00
103	2	29	Reverse Linked List	LeetCode	https://leetcode.com/problems/reverse-linked-list/	\N	\N	f	0	2026-09-19 06:54:32.120122+00	2026-09-19 06:54:32.120122+00
104	2	30	Middle of the Linked List	LeetCode	https://leetcode.com/problems/middle-of-the-linked-list/	\N	\N	f	0	2026-09-19 06:54:32.962942+00	2026-09-19 06:54:32.962942+00
105	2	30	Linked List Cycle	LeetCode	https://leetcode.com/problems/linked-list-cycle/	\N	\N	f	0	2026-09-19 06:54:33.525794+00	2026-09-19 06:54:33.525794+00
106	2	30	Linked List Cycle II	LeetCode	https://leetcode.com/problems/linked-list-cycle-ii/	\N	\N	f	0	2026-09-19 06:54:34.088673+00	2026-09-19 06:54:34.088673+00
107	2	29	Merge Two Sorted Lists	LeetCode	https://leetcode.com/problems/merge-two-sorted-lists/	\N	\N	f	0	2026-09-19 06:54:34.652786+00	2026-09-19 06:54:34.652786+00
108	2	29	Remove Duplicates from Sorted List	LeetCode	https://leetcode.com/problems/remove-duplicates-from-sorted-list/	\N	\N	f	0	2026-09-19 06:54:35.216087+00	2026-09-19 06:54:35.216087+00
110	2	29	Add Two Numbers	LeetCode	https://leetcode.com/problems/add-two-numbers/	\N	\N	f	0	2026-09-19 06:54:36.343164+00	2026-09-19 06:54:36.343164+00
111	2	30	Palindrome Linked List	LeetCode	https://leetcode.com/problems/palindrome-linked-list/	\N	\N	f	0	2026-09-19 06:54:36.906202+00	2026-09-19 06:54:36.906202+00
113	2	29	Swap Nodes in Pairs	LeetCode	https://leetcode.com/problems/swap-nodes-in-pairs/	\N	\N	f	0	2026-09-19 06:54:38.032251+00	2026-09-19 06:54:38.032251+00
114	2	31	Reverse Nodes in k-Group	LeetCode	https://leetcode.com/problems/reverse-nodes-in-k-group/	\N	\N	f	0	2026-09-19 06:54:38.913866+00	2026-09-19 06:54:38.913866+00
115	2	29	Rotate List	LeetCode	https://leetcode.com/problems/rotate-list/	\N	\N	f	0	2026-09-19 06:54:39.535272+00	2026-09-19 06:54:39.535272+00
116	2	32	Merge K Sorted Lists	LeetCode	https://leetcode.com/problems/merge-k-sorted-lists/	\N	\N	f	0	2026-09-19 06:54:40.534094+00	2026-09-19 06:54:40.534094+00
117	2	33	LRU Cache	LeetCode	https://leetcode.com/problems/lru-cache/	\N	\N	f	0	2026-09-19 06:54:41.393464+00	2026-09-19 06:54:41.393464+00
118	2	27	Implement Stack Using Array	GFG	\N	\N	\N	f	0	2026-09-19 06:54:41.956492+00	2026-09-19 06:54:41.956492+00
119	2	34	Implement Queue Using Array	GFG	\N	\N	\N	f	0	2026-09-19 06:54:42.798875+00	2026-09-19 06:54:42.798875+00
120	2	34	Implement Queue Using Stacks	LeetCode	https://leetcode.com/problems/implement-queue-using-stacks/	\N	\N	f	0	2026-09-19 06:54:43.362292+00	2026-09-19 06:54:43.362292+00
121	2	27	Implement Stack Using Queues	LeetCode	https://leetcode.com/problems/implement-stack-using-queues/	\N	\N	f	0	2026-09-19 06:54:43.924415+00	2026-09-19 06:54:43.924415+00
122	2	27	Min Stack	LeetCode	https://leetcode.com/problems/min-stack/	\N	\N	f	0	2026-09-19 06:54:44.492934+00	2026-09-19 06:54:44.492934+00
123	2	27	Evaluate Reverse Polish Notation	LeetCode	https://leetcode.com/problems/evaluate-reverse-polish-notation/	\N	\N	f	0	2026-09-19 06:54:45.135768+00	2026-09-19 06:54:45.135768+00
124	2	35	Daily Temperatures	LeetCode	https://leetcode.com/problems/daily-temperatures/	\N	\N	f	0	2026-09-19 06:54:45.980187+00	2026-09-19 06:54:45.980187+00
125	2	35	Next Greater Element I	LeetCode	https://leetcode.com/problems/next-greater-element-i/	\N	\N	f	0	2026-09-19 06:54:46.5424+00	2026-09-19 06:54:46.5424+00
126	2	35	Next Greater Element II	LeetCode	https://leetcode.com/problems/next-greater-element-ii/	\N	\N	f	0	2026-09-19 06:54:47.104958+00	2026-09-19 06:54:47.104958+00
127	2	35	Online Stock Span	LeetCode	https://leetcode.com/problems/online-stock-span/	\N	\N	f	0	2026-09-19 06:54:47.734367+00	2026-09-19 06:54:47.734367+00
128	2	35	Largest Rectangle in Histogram	LeetCode	https://leetcode.com/problems/largest-rectangle-in-histogram/	\N	\N	f	0	2026-09-19 06:54:48.296306+00	2026-09-19 06:54:48.296306+00
129	2	27	Asteroid Collision	LeetCode	https://leetcode.com/problems/asteroid-collision/	\N	\N	f	0	2026-09-19 06:54:48.858914+00	2026-09-19 06:54:48.858914+00
130	2	27	Simplify Path	LeetCode	https://leetcode.com/problems/simplify-path/	\N	\N	f	0	2026-09-19 06:54:49.421989+00	2026-09-19 06:54:49.421989+00
131	2	27	Decode String	LeetCode	https://leetcode.com/problems/decode-string/	\N	\N	f	0	2026-09-19 06:54:49.984176+00	2026-09-19 06:54:49.984176+00
132	2	35	Remove K Digits	LeetCode	https://leetcode.com/problems/remove-k-digits/	\N	\N	f	0	2026-09-19 06:54:50.5467+00	2026-09-19 06:54:50.5467+00
133	2	32	Top K Frequent Elements	LeetCode	https://leetcode.com/problems/top-k-frequent-elements/	\N	\N	f	0	2026-09-19 06:54:51.114983+00	2026-09-19 06:54:51.114983+00
134	2	32	Top K Frequent Words	LeetCode	https://leetcode.com/problems/top-k-frequent-words/	\N	\N	f	0	2026-09-19 06:54:51.677412+00	2026-09-19 06:54:51.677412+00
135	2	32	K Closest Points to Origin	LeetCode	https://leetcode.com/problems/k-closest-points-to-origin/	\N	\N	f	0	2026-09-19 06:54:52.239944+00	2026-09-19 06:54:52.239944+00
136	2	32	Find K Pairs with Smallest Sums	LeetCode	https://leetcode.com/problems/find-k-pairs-with-smallest-sums/	\N	\N	f	0	2026-09-19 06:54:52.80245+00	2026-09-19 06:54:52.80245+00
137	2	36	Find Median from Data Stream	LeetCode	https://leetcode.com/problems/find-median-from-data-stream/	\N	\N	f	0	2026-09-19 06:54:53.645029+00	2026-09-19 06:54:53.645029+00
138	2	32	Task Scheduler	LeetCode	https://leetcode.com/problems/task-scheduler/	\N	\N	f	0	2026-09-19 06:54:54.23464+00	2026-09-19 06:54:54.23464+00
139	2	32	Reorganize String	LeetCode	https://leetcode.com/problems/reorganize-string/	\N	\N	f	0	2026-09-19 06:54:54.879674+00	2026-09-19 06:54:54.879674+00
140	2	37	Assign Cookies	LeetCode	https://leetcode.com/problems/assign-cookies/	\N	\N	f	0	2026-09-19 06:54:55.723461+00	2026-09-19 06:54:55.723461+00
141	2	37	Jump Game	LeetCode	https://leetcode.com/problems/jump-game/	\N	\N	f	0	2026-09-19 06:54:56.286895+00	2026-09-19 06:54:56.286895+00
142	2	37	Jump Game II	LeetCode	https://leetcode.com/problems/jump-game-ii/	\N	\N	f	0	2026-09-19 06:54:56.848693+00	2026-09-19 06:54:56.848693+00
143	2	37	Gas Station	LeetCode	https://leetcode.com/problems/gas-station/	\N	\N	f	0	2026-09-19 06:54:57.411543+00	2026-09-19 06:54:57.411543+00
144	2	37	Partition Labels	LeetCode	https://leetcode.com/problems/partition-labels/	\N	\N	f	0	2026-09-19 06:54:57.974099+00	2026-09-19 06:54:57.974099+00
145	2	37	Non-overlapping Intervals	LeetCode	https://leetcode.com/problems/non-overlapping-intervals/	\N	\N	f	0	2026-09-19 06:54:58.536237+00	2026-09-19 06:54:58.536237+00
146	2	37	Minimum Number of Arrows to Burst Balloons	LeetCode	https://leetcode.com/problems/minimum-number-of-arrows-to-burst-balloons/	\N	\N	f	0	2026-09-19 06:54:59.098291+00	2026-09-19 06:54:59.098291+00
109	2	6	Remove Nth Node From End	LeetCode	https://leetcode.com/problems/remove-nth-node-from-end-of-list/	LeetCode	https://leetcode.com/problems/remove-nth-node-from-end-of-list/	t	1	2026-09-19 06:54:35.780017+00	2026-09-21 18:26:52.942293+00
147	2	37	Queue Reconstruction by Height	LeetCode	https://leetcode.com/problems/queue-reconstruction-by-height/	\N	\N	f	0	2026-09-19 06:54:59.661014+00	2026-09-19 06:54:59.661014+00
148	2	37	Lemonade Change	LeetCode	https://leetcode.com/problems/lemonade-change/	\N	\N	f	0	2026-09-19 06:55:00.223457+00	2026-09-19 06:55:00.223457+00
149	2	37	Candy	LeetCode	https://leetcode.com/problems/candy/	\N	\N	f	0	2026-09-19 06:55:00.78554+00	2026-09-19 06:55:00.78554+00
150	2	31	Factorial	GFG	\N	\N	\N	f	0	2026-09-19 06:55:01.34764+00	2026-09-19 06:55:01.34764+00
151	2	4	Fibonacci	GFG	\N	\N	\N	f	0	2026-09-19 06:55:01.909955+00	2026-09-19 06:55:01.909955+00
152	2	38	Power of a Number	LeetCode	https://leetcode.com/problems/powx-n/	\N	\N	f	0	2026-09-19 06:55:02.752156+00	2026-09-19 06:55:02.752156+00
153	2	24	Generate Parentheses	LeetCode	https://leetcode.com/problems/generate-parentheses/	\N	\N	f	0	2026-09-19 06:55:03.313782+00	2026-09-19 06:55:03.313782+00
154	2	24	Subsets	LeetCode	https://leetcode.com/problems/subsets/	\N	\N	f	0	2026-09-19 06:55:03.875814+00	2026-09-19 06:55:03.875814+00
155	2	24	Subsets II	LeetCode	https://leetcode.com/problems/subsets-ii/	\N	\N	f	0	2026-09-19 06:55:04.437905+00	2026-09-19 06:55:04.437905+00
156	2	24	Permutations	LeetCode	https://leetcode.com/problems/permutations/	\N	\N	f	0	2026-09-19 06:55:05.000266+00	2026-09-19 06:55:05.000266+00
157	2	24	Permutations II	LeetCode	https://leetcode.com/problems/permutations-ii/	\N	\N	f	0	2026-09-19 06:55:05.562314+00	2026-09-19 06:55:05.562314+00
158	2	24	Combination Sum	LeetCode	https://leetcode.com/problems/combination-sum/	\N	\N	f	0	2026-09-19 06:55:06.124737+00	2026-09-19 06:55:06.124737+00
159	2	24	Combination Sum II	LeetCode	https://leetcode.com/problems/combination-sum-ii/	\N	\N	f	0	2026-09-19 06:55:06.6876+00	2026-09-19 06:55:06.6876+00
160	2	39	Number of 1 Bits	LeetCode	https://leetcode.com/problems/number-of-1-bits/	\N	\N	f	0	2026-09-19 06:55:07.53004+00	2026-09-19 06:55:07.53004+00
161	2	40	Counting Bits	LeetCode	https://leetcode.com/problems/counting-bits/	\N	\N	f	0	2026-09-19 06:55:08.373143+00	2026-09-19 06:55:08.373143+00
162	2	39	Reverse Bits	LeetCode	https://leetcode.com/problems/reverse-bits/	\N	\N	f	0	2026-09-19 06:55:08.935415+00	2026-09-19 06:55:08.935415+00
163	2	39	Power of Two	LeetCode	https://leetcode.com/problems/power-of-two/	\N	\N	f	0	2026-09-19 06:55:09.497303+00	2026-09-19 06:55:09.497303+00
164	2	41	Missing Number using XOR	LeetCode	https://leetcode.com/problems/missing-number/	\N	\N	f	0	2026-09-19 06:55:10.338975+00	2026-09-19 06:55:10.338975+00
165	2	39	Single Number II	LeetCode	https://leetcode.com/problems/single-number-ii/	\N	\N	f	0	2026-09-19 06:55:10.900748+00	2026-09-19 06:55:10.900748+00
166	2	39	Single Number III	LeetCode	https://leetcode.com/problems/single-number-iii/	\N	\N	f	0	2026-09-19 06:55:11.46334+00	2026-09-19 06:55:11.46334+00
167	2	42	Subsets using Bitmask	LeetCode	https://leetcode.com/problems/subsets/	\N	\N	f	0	2026-09-19 06:55:12.305647+00	2026-09-19 06:55:12.305647+00
168	2	39	Maximum XOR of Two Numbers in an Array	LeetCode	https://leetcode.com/problems/maximum-xor-of-two-numbers-in-an-array/	\N	\N	f	0	2026-09-19 06:55:12.868025+00	2026-09-19 06:55:12.868025+00
169	2	43	Climbing Stairs	LeetCode	https://leetcode.com/problems/climbing-stairs/	\N	\N	f	0	2026-09-19 06:55:13.710334+00	2026-09-19 06:55:13.710334+00
170	2	43	Min Cost Climbing Stairs	LeetCode	https://leetcode.com/problems/min-cost-climbing-stairs/	\N	\N	f	0	2026-09-19 06:55:14.272157+00	2026-09-19 06:55:14.272157+00
171	2	43	House Robber	LeetCode	https://leetcode.com/problems/house-robber/	\N	\N	f	0	2026-09-19 06:55:14.83411+00	2026-09-19 06:55:14.83411+00
172	2	43	House Robber II	LeetCode	https://leetcode.com/problems/house-robber-ii/	\N	\N	f	0	2026-09-19 06:55:15.396566+00	2026-09-19 06:55:15.396566+00
173	2	3	Maximum Subarray — Kadane	LeetCode	https://leetcode.com/problems/maximum-subarray/	\N	\N	f	0	2026-09-19 06:55:15.961432+00	2026-09-19 06:55:15.961432+00
174	2	43	Decode Ways	LeetCode	https://leetcode.com/problems/decode-ways/	\N	\N	f	0	2026-09-19 06:55:16.532479+00	2026-09-19 06:55:16.532479+00
175	2	43	Word Break	LeetCode	https://leetcode.com/problems/word-break/	\N	\N	f	0	2026-09-19 06:55:17.094526+00	2026-09-19 06:55:17.094526+00
176	2	44	Coin Change	LeetCode	https://leetcode.com/problems/coin-change/	\N	\N	f	0	2026-09-19 06:55:17.937374+00	2026-09-19 06:55:17.937374+00
177	2	44	Coin Change II	LeetCode	https://leetcode.com/problems/coin-change-ii/	\N	\N	f	0	2026-09-19 06:55:18.499614+00	2026-09-19 06:55:18.499614+00
178	2	45	0/1 Knapsack	GFG	\N	\N	\N	f	0	2026-09-19 06:55:19.340608+00	2026-09-19 06:55:19.340608+00
179	2	46	Subset Sum	GFG	\N	\N	\N	f	0	2026-09-19 06:55:20.181479+00	2026-09-19 06:55:20.181479+00
180	2	45	Partition Equal Subset Sum	LeetCode	https://leetcode.com/problems/partition-equal-subset-sum/	\N	\N	f	0	2026-09-19 06:55:20.74347+00	2026-09-19 06:55:20.74347+00
181	2	45	Target Sum	LeetCode	https://leetcode.com/problems/target-sum/	\N	\N	f	0	2026-09-19 06:55:21.305553+00	2026-09-19 06:55:21.305553+00
182	2	47	Unique Paths	LeetCode	https://leetcode.com/problems/unique-paths/	\N	\N	f	0	2026-09-19 06:55:22.147517+00	2026-09-19 06:55:22.147517+00
183	2	48	Longest Common Subsequence	LeetCode	https://leetcode.com/problems/longest-common-subsequence/	\N	\N	f	0	2026-09-19 06:55:22.989305+00	2026-09-19 06:55:22.989305+00
184	2	43	Longest Increasing Subsequence	LeetCode	https://leetcode.com/problems/longest-increasing-subsequence/	\N	\N	f	0	2026-09-19 06:55:23.551299+00	2026-09-19 06:55:23.551299+00
185	2	48	Longest Palindromic Subsequence	LeetCode	https://leetcode.com/problems/longest-palindromic-subsequence/	\N	\N	f	0	2026-09-19 06:55:24.114569+00	2026-09-19 06:55:24.114569+00
186	2	48	Edit Distance	LeetCode	https://leetcode.com/problems/edit-distance/	\N	\N	f	0	2026-09-19 06:55:24.676618+00	2026-09-19 06:55:24.676618+00
187	2	48	Distinct Subsequences	LeetCode	https://leetcode.com/problems/distinct-subsequences/	\N	\N	f	0	2026-09-19 06:55:25.238324+00	2026-09-19 06:55:25.238324+00
188	2	49	Matrix Chain Multiplication	GFG	\N	\N	\N	f	0	2026-09-19 06:55:26.080504+00	2026-09-19 06:55:26.080504+00
189	2	44	Rod Cutting	GFG	\N	\N	\N	f	0	2026-09-19 06:55:26.642804+00	2026-09-19 06:55:26.642804+00
190	2	49	Burst Balloons	LeetCode	https://leetcode.com/problems/burst-balloons/	\N	\N	f	0	2026-09-19 06:55:27.20419+00	2026-09-19 06:55:27.20419+00
191	2	50	Best Time to Buy and Sell Stock with Cooldown	LeetCode	https://leetcode.com/problems/best-time-to-buy-and-sell-stock-with-cooldown/	\N	\N	f	0	2026-09-19 06:55:28.050507+00	2026-09-19 06:55:28.050507+00
192	2	50	Best Time to Buy and Sell Stock IV	LeetCode	https://leetcode.com/problems/best-time-to-buy-and-sell-stock-iv/	\N	\N	f	0	2026-09-19 06:55:28.612504+00	2026-09-19 06:55:28.612504+00
23	2	6	3Sum	LeetCode	https://leetcode.com/problems/3sum/	Youtube - Striver	https://www.youtube.com/watch?v=DhFh8Kw7ymk	t	1	2026-09-19 06:53:39.983821+00	2026-09-19 08:52:53.675894+00
26	2	6	Container With Most Water	LeetCode	https://leetcode.com/problems/container-with-most-water/	LeetCode	https://leetcode.com/problems/container-with-most-water/submissions/1720359521	t	1	2026-09-19 06:53:41.675247+00	2026-09-19 10:33:58.354291+00
112	2	6	Intersection of Two Linked Lists	LeetCode	https://leetcode.com/problems/intersection-of-two-linked-lists/	Utube	https://www.youtube.com/watch?v=fwUTXaMom6U	t	1	2026-09-19 06:54:37.468752+00	2026-09-21 18:14:16.851727+00
97	2	6	String Compression	LeetCode	https://leetcode.com/problems/string-compression/	Utube	https://www.youtube.com/watch?v=cAB15h6-sWA	t	1	2026-09-19 06:54:27.617704+00	2026-09-22 04:47:08.521446+00
\.


--
-- Data for Name: subcategories; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.subcategories (id, category_id, name, created_at, updated_at) FROM stdin;
2	2	Hashing	2026-09-19 06:53:27.802338+00	2026-09-19 06:53:27.802338+00
3	2	Kadane	2026-09-19 06:53:33.635053+00	2026-09-19 06:53:33.635053+00
4	2	DP	2026-09-19 06:53:34.340956+00	2026-09-19 06:53:34.340956+00
5	2	Prefix Sum	2026-09-19 06:53:35.047146+00	2026-09-19 06:53:35.047146+00
6	2	2 Pointers	2026-09-19 06:53:39.137865+00	2026-09-19 06:53:39.137865+00
7	2	Sliding Window	2026-09-19 06:53:46.754814+00	2026-09-19 06:53:46.754814+00
8	2	Monotonic Deque	2026-09-19 06:53:50.422408+00	2026-09-19 06:53:50.422408+00
9	2	Prefix XOR	2026-09-19 06:53:54.335484+00	2026-09-19 06:53:54.335484+00
10	2	Difference Array	2026-09-19 06:53:55.181879+00	2026-09-19 06:53:55.181879+00
11	2	Sorting	2026-09-19 06:53:56.592459+00	2026-09-19 06:53:56.592459+00
12	2	Quickselect	2026-09-19 06:54:00.389094+00	2026-09-19 06:54:00.389094+00
13	2	Counting Sort	2026-09-19 06:54:02.360382+00	2026-09-19 06:54:02.360382+00
14	2	Custom Sort	2026-09-19 06:54:03.204134+00	2026-09-19 06:54:03.204134+00
15	2	Bucket Sort	2026-09-19 06:54:04.047539+00	2026-09-19 06:54:04.047539+00
16	2	Intervals	2026-09-19 06:54:04.891086+00	2026-09-19 06:54:04.891086+00
17	2	Intervals + Heap	2026-09-19 06:54:05.734705+00	2026-09-19 06:54:05.734705+00
18	2	Binary Search	2026-09-19 06:54:06.578914+00	2026-09-19 06:54:06.578914+00
19	2	BS on Answer	2026-09-19 06:54:07.989606+00	2026-09-19 06:54:07.989606+00
20	2	Rotated BS	2026-09-19 06:54:09.396717+00	2026-09-19 06:54:09.396717+00
21	2	Matrix Search	2026-09-19 06:54:15.341884+00	2026-09-19 06:54:15.341884+00
22	2	Matrix	2026-09-19 06:54:16.185359+00	2026-09-19 06:54:16.185359+00
23	2	Simulation	2026-09-19 06:54:19.848794+00	2026-09-19 06:54:19.848794+00
24	2	Backtracking	2026-09-19 06:54:20.69295+00	2026-09-19 06:54:20.69295+00
25	2	Strings	2026-09-19 06:54:22.662533+00	2026-09-19 06:54:22.662533+00
26	2	Palindrome	2026-09-19 06:54:28.180938+00	2026-09-19 06:54:28.180938+00
27	2	Stack	2026-09-19 06:54:29.588269+00	2026-09-19 06:54:29.588269+00
28	2	String Matching	2026-09-19 06:54:30.997511+00	2026-09-19 06:54:30.997511+00
29	2	Linked List	2026-09-19 06:54:31.840187+00	2026-09-19 06:54:31.840187+00
30	2	Fast & Slow	2026-09-19 06:54:32.68344+00	2026-09-19 06:54:32.68344+00
31	2	Recursion	2026-09-19 06:54:38.634317+00	2026-09-19 06:54:38.634317+00
32	2	Heap	2026-09-19 06:54:40.233407+00	2026-09-19 06:54:40.233407+00
33	2	LRU	2026-09-19 06:54:41.095673+00	2026-09-19 06:54:41.095673+00
34	2	Queue	2026-09-19 06:54:42.518973+00	2026-09-19 06:54:42.518973+00
35	2	Monotonic Stack	2026-09-19 06:54:45.698906+00	2026-09-19 06:54:45.698906+00
36	2	2 Heaps	2026-09-19 06:54:53.364895+00	2026-09-19 06:54:53.364895+00
37	2	Greedy	2026-09-19 06:54:55.442621+00	2026-09-19 06:54:55.442621+00
38	2	Binary Exponentiation	2026-09-19 06:55:02.472279+00	2026-09-19 06:55:02.472279+00
39	2	Bit Manipulation	2026-09-19 06:55:07.250495+00	2026-09-19 06:55:07.250495+00
40	2	Bit DP	2026-09-19 06:55:08.093535+00	2026-09-19 06:55:08.093535+00
41	2	XOR	2026-09-19 06:55:10.059142+00	2026-09-19 06:55:10.059142+00
42	2	Bitmask	2026-09-19 06:55:12.026071+00	2026-09-19 06:55:12.026071+00
43	2	1D DP	2026-09-19 06:55:13.430221+00	2026-09-19 06:55:13.430221+00
44	2	Unbounded Knapsack	2026-09-19 06:55:17.657049+00	2026-09-19 06:55:17.657049+00
45	2	0/1 Knapsack	2026-09-19 06:55:19.061208+00	2026-09-19 06:55:19.061208+00
46	2	Subset Sum	2026-09-19 06:55:19.90216+00	2026-09-19 06:55:19.90216+00
47	2	Grid DP	2026-09-19 06:55:21.867421+00	2026-09-19 06:55:21.867421+00
48	2	2D DP	2026-09-19 06:55:22.709541+00	2026-09-19 06:55:22.709541+00
49	2	Interval DP	2026-09-19 06:55:25.800328+00	2026-09-19 06:55:25.800328+00
50	2	State DP	2026-09-19 06:55:27.770822+00	2026-09-19 06:55:27.770822+00
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.users (id, email, password_hash, display_name, enabled, created_at, updated_at) FROM stdin;
1	admin@example.com	$2a$10$iSmoixQ7BJYG2Yix2npocuG56tup5WeP5QVbglKzRV24NJA.lecF6	Admin User	t	2026-09-19 06:28:02.999805+00	2026-09-19 06:28:02.999805+00
\.


--
-- Data for Name: workspace_notes; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.workspace_notes (id, question_id, user_id, answer, created_at, updated_at) FROM stdin;
\.


--
-- Name: categories_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.categories_id_seq', 2, true);


--
-- Name: questions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.questions_id_seq', 192, true);


--
-- Name: subcategories_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.subcategories_id_seq', 50, true);


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.users_id_seq', 1, true);


--
-- Name: workspace_notes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.workspace_notes_id_seq', 2, true);


--
-- Name: categories categories_name_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.categories
    ADD CONSTRAINT categories_name_key UNIQUE (name);


--
-- Name: categories categories_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.categories
    ADD CONSTRAINT categories_pkey PRIMARY KEY (id);


--
-- Name: flyway_schema_history flyway_schema_history_pk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.flyway_schema_history
    ADD CONSTRAINT flyway_schema_history_pk PRIMARY KEY (installed_rank);


--
-- Name: questions questions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.questions
    ADD CONSTRAINT questions_pkey PRIMARY KEY (id);


--
-- Name: subcategories subcategories_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.subcategories
    ADD CONSTRAINT subcategories_pkey PRIMARY KEY (id);


--
-- Name: workspace_notes uk_note_user_question; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.workspace_notes
    ADD CONSTRAINT uk_note_user_question UNIQUE (user_id, question_id);


--
-- Name: subcategories uk_subcategory_category_name; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.subcategories
    ADD CONSTRAINT uk_subcategory_category_name UNIQUE (category_id, name);


--
-- Name: users users_email_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key UNIQUE (email);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: workspace_notes workspace_notes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.workspace_notes
    ADD CONSTRAINT workspace_notes_pkey PRIMARY KEY (id);


--
-- Name: flyway_schema_history_s_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX flyway_schema_history_s_idx ON public.flyway_schema_history USING btree (success);


--
-- Name: idx_notes_user; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_notes_user ON public.workspace_notes USING btree (user_id);


--
-- Name: idx_questions_category; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_questions_category ON public.questions USING btree (category_id);


--
-- Name: idx_questions_category_subcategory; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_questions_category_subcategory ON public.questions USING btree (category_id, subcategory_id);


--
-- Name: idx_questions_studied; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_questions_studied ON public.questions USING btree (studied_before);


--
-- Name: idx_questions_subcategory; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_questions_subcategory ON public.questions USING btree (subcategory_id);


--
-- Name: questions questions_category_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.questions
    ADD CONSTRAINT questions_category_id_fkey FOREIGN KEY (category_id) REFERENCES public.categories(id);


--
-- Name: questions questions_subcategory_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.questions
    ADD CONSTRAINT questions_subcategory_id_fkey FOREIGN KEY (subcategory_id) REFERENCES public.subcategories(id);


--
-- Name: subcategories subcategories_category_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.subcategories
    ADD CONSTRAINT subcategories_category_id_fkey FOREIGN KEY (category_id) REFERENCES public.categories(id);


--
-- Name: workspace_notes workspace_notes_question_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.workspace_notes
    ADD CONSTRAINT workspace_notes_question_id_fkey FOREIGN KEY (question_id) REFERENCES public.questions(id) ON DELETE CASCADE;


--
-- Name: workspace_notes workspace_notes_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.workspace_notes
    ADD CONSTRAINT workspace_notes_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

\unrestrict 0d9ctvjqXKLaleSCemjQv5nVewMN82bhfgmVCmHZXMaxcmWaQw3D0Jp5G6W0fTJ

