--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


--
-- Name: hstore; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS hstore WITH SCHEMA public;


--
-- Name: EXTENSION hstore; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION hstore IS 'data type for storing sets of (key, value) pairs';


--
-- Name: unaccent; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS unaccent WITH SCHEMA public;


--
-- Name: EXTENSION unaccent; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION unaccent IS 'text search dictionary that removes accents';


--
-- Name: uuid-ossp; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA public;


--
-- Name: EXTENSION "uuid-ossp"; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION "uuid-ossp" IS 'generate universally unique identifiers (UUIDs)';


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: activities; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE activities (
    id integer NOT NULL,
    trackable_id integer NOT NULL,
    trackable_type character varying NOT NULL,
    owner_id integer NOT NULL,
    owner_type character varying NOT NULL,
    key character varying DEFAULT ''::character varying NOT NULL,
    parameters jsonb DEFAULT '{}'::jsonb,
    uuid uuid DEFAULT uuid_generate_v4(),
    published boolean DEFAULT true,
    is_notification boolean DEFAULT false,
    parent_id uuid,
    recipient_id integer NOT NULL,
    recipient_type character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: activities_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE activities_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: activities_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE activities_id_seq OWNED BY activities.id;


--
-- Name: badges_sashes; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE badges_sashes (
    id integer NOT NULL,
    badge_id integer,
    sash_id integer,
    notified_user boolean DEFAULT false,
    created_at timestamp without time zone
);


--
-- Name: badges_sashes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE badges_sashes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: badges_sashes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE badges_sashes_id_seq OWNED BY badges_sashes.id;


--
-- Name: comments; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE comments (
    id integer NOT NULL,
    commentable_id integer NOT NULL,
    commentable_type character varying NOT NULL,
    body text DEFAULT ''::text NOT NULL,
    user_id integer NOT NULL,
    parent_id integer,
    lft integer NOT NULL,
    rgt integer NOT NULL,
    depth integer DEFAULT 0 NOT NULL,
    children_count integer DEFAULT 0 NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: comments_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE comments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: comments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE comments_id_seq OWNED BY comments.id;


--
-- Name: crono_jobs; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE crono_jobs (
    id integer NOT NULL,
    job_id character varying NOT NULL,
    log text,
    last_performed_at timestamp without time zone,
    healthy boolean,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: crono_jobs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE crono_jobs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: crono_jobs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE crono_jobs_id_seq OWNED BY crono_jobs.id;


--
-- Name: event_attendees; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE event_attendees (
    id integer NOT NULL,
    attendee_id integer NOT NULL,
    event_id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: event_attendees_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE event_attendees_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: event_attendees_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE event_attendees_id_seq OWNED BY event_attendees.id;


--
-- Name: event_invites; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE event_invites (
    id integer NOT NULL,
    invited_id integer,
    inviter_id integer,
    inviter_type character varying,
    event_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: event_invites_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE event_invites_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: event_invites_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE event_invites_id_seq OWNED BY event_invites.id;


--
-- Name: events; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE events (
    id integer NOT NULL,
    owner_id integer NOT NULL,
    owner_type character varying DEFAULT ''::character varying NOT NULL,
    title character varying DEFAULT ''::character varying NOT NULL,
    excerpt text DEFAULT ''::text NOT NULL,
    description text DEFAULT ''::text NOT NULL,
    uuid uuid DEFAULT uuid_generate_v4(),
    featured boolean,
    cached_category_list character varying,
    cover character varying DEFAULT ''::character varying NOT NULL,
    slug character varying DEFAULT ''::character varying NOT NULL,
    address text,
    status integer DEFAULT 0,
    privacy integer DEFAULT 0,
    space integer DEFAULT 0,
    media jsonb DEFAULT '{}'::jsonb,
    start_time timestamp without time zone DEFAULT '2015-08-02 16:19:18.969251'::timestamp without time zone NOT NULL,
    end_time timestamp without time zone DEFAULT '2015-08-02 16:19:18.969294'::timestamp without time zone NOT NULL,
    latitude double precision DEFAULT 0.0 NOT NULL,
    longitude double precision DEFAULT 0.0 NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: events_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE events_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: events_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE events_id_seq OWNED BY events.id;


--
-- Name: feedbacks; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE feedbacks (
    id integer NOT NULL,
    uuid uuid DEFAULT uuid_generate_v4(),
    body text DEFAULT ''::text NOT NULL,
    idea_id integer NOT NULL,
    user_id integer NOT NULL,
    cached_category_list character varying,
    status integer DEFAULT 0 NOT NULL,
    badge integer DEFAULT 0 NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    sash_id integer,
    level integer DEFAULT 0
);


--
-- Name: feedbacks_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE feedbacks_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: feedbacks_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE feedbacks_id_seq OWNED BY feedbacks.id;


--
-- Name: follows; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE follows (
    id integer NOT NULL,
    followable_id integer NOT NULL,
    followable_type character varying NOT NULL,
    follower_id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: follows_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE follows_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: follows_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE follows_id_seq OWNED BY follows.id;


--
-- Name: help_articles; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE help_articles (
    id integer NOT NULL,
    title character varying,
    body text,
    slug character varying NOT NULL,
    published boolean DEFAULT true,
    category_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: help_articles_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE help_articles_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: help_articles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE help_articles_id_seq OWNED BY help_articles.id;


--
-- Name: help_categories; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE help_categories (
    id integer NOT NULL,
    name character varying NOT NULL,
    description character varying NOT NULL,
    slug character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: help_categories_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE help_categories_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: help_categories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE help_categories_id_seq OWNED BY help_categories.id;


--
-- Name: hobbies; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE hobbies (
    id integer NOT NULL,
    name character varying,
    slug character varying,
    description text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: hobbies_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE hobbies_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: hobbies_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE hobbies_id_seq OWNED BY hobbies.id;


--
-- Name: idea_components; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE idea_components (
    id integer NOT NULL,
    title character varying,
    help_text character varying,
    body text,
    idea_id integer,
    privacy integer,
    "position" integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: idea_components_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE idea_components_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: idea_components_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE idea_components_id_seq OWNED BY idea_components.id;


--
-- Name: idea_messages; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE idea_messages (
    id integer NOT NULL,
    user_id integer NOT NULL,
    idea_id integer NOT NULL,
    body text NOT NULL,
    status integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: idea_messages_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE idea_messages_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: idea_messages_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE idea_messages_id_seq OWNED BY idea_messages.id;


--
-- Name: ideas; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE ideas (
    id integer NOT NULL,
    user_id integer NOT NULL,
    uuid uuid DEFAULT uuid_generate_v4(),
    name character varying NOT NULL,
    slug character varying DEFAULT ''::character varying NOT NULL,
    high_concept_pitch character varying DEFAULT ''::character varying NOT NULL,
    elevator_pitch text DEFAULT ''::text NOT NULL,
    description text DEFAULT ''::text,
    logo character varying,
    cover character varying,
    team_ids character varying[] DEFAULT '{}'::character varying[],
    team_invites_ids character varying[] DEFAULT '{}'::character varying[],
    looking_for_team boolean DEFAULT false,
    school_id integer,
    status integer DEFAULT 0,
    privacy integer DEFAULT 0,
    investable boolean DEFAULT false,
    validated boolean DEFAULT false NOT NULL,
    rules_accepted boolean DEFAULT false,
    settings jsonb DEFAULT '{}'::jsonb,
    media jsonb DEFAULT '{}'::jsonb,
    profile jsonb DEFAULT '{}'::jsonb,
    fund jsonb DEFAULT '{}'::jsonb,
    cached_market_list character varying,
    cached_technology_list character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    sash_id integer,
    level integer DEFAULT 0
);


--
-- Name: ideas_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE ideas_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: ideas_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE ideas_id_seq OWNED BY ideas.id;


--
-- Name: impressions; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE impressions (
    id integer NOT NULL,
    impressionable_id integer NOT NULL,
    impressionable_type character varying NOT NULL,
    ip_address character varying NOT NULL,
    user_id integer NOT NULL,
    controller_name character varying,
    action_name character varying,
    referrer character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: impressions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE impressions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: impressions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE impressions_id_seq OWNED BY impressions.id;


--
-- Name: investments; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE investments (
    id integer NOT NULL,
    uuid uuid DEFAULT uuid_generate_v4(),
    amount integer NOT NULL,
    message character varying,
    user_id integer NOT NULL,
    idea_id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: investments_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE investments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: investments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE investments_id_seq OWNED BY investments.id;


--
-- Name: invite_requests; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE invite_requests (
    id integer NOT NULL,
    name character varying DEFAULT ''::character varying NOT NULL,
    email character varying DEFAULT ''::character varying NOT NULL,
    url character varying DEFAULT ''::character varying NOT NULL,
    user_type integer DEFAULT 1,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: invite_requests_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE invite_requests_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: invite_requests_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE invite_requests_id_seq OWNED BY invite_requests.id;


--
-- Name: locations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE locations (
    id integer NOT NULL,
    name character varying,
    slug character varying,
    description text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: locations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE locations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: locations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE locations_id_seq OWNED BY locations.id;


--
-- Name: markets; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE markets (
    id integer NOT NULL,
    name character varying,
    slug character varying,
    description text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: markets_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE markets_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: markets_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE markets_id_seq OWNED BY markets.id;


--
-- Name: mentions; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE mentions (
    id integer NOT NULL,
    mentionable_id integer NOT NULL,
    mentionable_type character varying NOT NULL,
    mentioner_id integer NOT NULL,
    mentioner_type character varying NOT NULL,
    user_id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: mentions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE mentions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: mentions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE mentions_id_seq OWNED BY mentions.id;


--
-- Name: merit_actions; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE merit_actions (
    id integer NOT NULL,
    user_id integer,
    action_method character varying,
    action_value integer,
    had_errors boolean DEFAULT false,
    target_model character varying,
    target_id integer,
    target_data text,
    processed boolean DEFAULT false,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: merit_actions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE merit_actions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: merit_actions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE merit_actions_id_seq OWNED BY merit_actions.id;


--
-- Name: merit_activity_logs; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE merit_activity_logs (
    id integer NOT NULL,
    action_id integer,
    related_change_type character varying,
    related_change_id integer,
    description character varying,
    created_at timestamp without time zone
);


--
-- Name: merit_activity_logs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE merit_activity_logs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: merit_activity_logs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE merit_activity_logs_id_seq OWNED BY merit_activity_logs.id;


--
-- Name: merit_score_points; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE merit_score_points (
    id integer NOT NULL,
    score_id integer,
    num_points integer DEFAULT 0,
    log character varying,
    created_at timestamp without time zone
);


--
-- Name: merit_score_points_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE merit_score_points_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: merit_score_points_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE merit_score_points_id_seq OWNED BY merit_score_points.id;


--
-- Name: merit_scores; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE merit_scores (
    id integer NOT NULL,
    sash_id integer,
    category character varying DEFAULT 'default'::character varying
);


--
-- Name: merit_scores_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE merit_scores_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: merit_scores_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE merit_scores_id_seq OWNED BY merit_scores.id;


--
-- Name: sashes; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE sashes (
    id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: sashes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE sashes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sashes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE sashes_id_seq OWNED BY sashes.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE schema_migrations (
    version character varying NOT NULL
);


--
-- Name: school_admins; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE school_admins (
    id integer NOT NULL,
    user_id integer,
    school_id integer,
    active boolean,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: school_admins_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE school_admins_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: school_admins_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE school_admins_id_seq OWNED BY school_admins.id;


--
-- Name: schools; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE schools (
    id integer NOT NULL,
    email character varying DEFAULT ''::character varying NOT NULL,
    uuid uuid DEFAULT uuid_generate_v4(),
    domain character varying DEFAULT ''::character varying NOT NULL,
    name character varying NOT NULL,
    description text,
    logo character varying,
    cover character varying,
    user_id integer DEFAULT 1 NOT NULL,
    slug character varying NOT NULL,
    phone character varying DEFAULT ''::character varying NOT NULL,
    website_url character varying DEFAULT ''::character varying NOT NULL,
    facebook_url character varying DEFAULT ''::character varying NOT NULL,
    twitter_url character varying DEFAULT ''::character varying NOT NULL,
    media jsonb DEFAULT '{}'::jsonb,
    cached_location_list character varying,
    customizations jsonb DEFAULT '{}'::jsonb,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: schools_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE schools_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: schools_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE schools_id_seq OWNED BY schools.id;


--
-- Name: shares; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE shares (
    id integer NOT NULL,
    body text DEFAULT ''::text NOT NULL,
    link text DEFAULT ''::text NOT NULL,
    uuid uuid DEFAULT uuid_generate_v4(),
    owner_id integer NOT NULL,
    owner_type character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: shares_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE shares_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: shares_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE shares_id_seq OWNED BY shares.id;


--
-- Name: site_feedback_feedbacks; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE site_feedback_feedbacks (
    id integer NOT NULL,
    user_id integer,
    email character varying DEFAULT ''::character varying NOT NULL,
    name character varying DEFAULT ''::character varying NOT NULL,
    attachment character varying,
    body text DEFAULT ''::text NOT NULL,
    status integer DEFAULT 0,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: site_feedback_feedbacks_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE site_feedback_feedbacks_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: site_feedback_feedbacks_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE site_feedback_feedbacks_id_seq OWNED BY site_feedback_feedbacks.id;


--
-- Name: skills; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE skills (
    id integer NOT NULL,
    name character varying,
    slug character varying,
    description text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: skills_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE skills_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: skills_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE skills_id_seq OWNED BY skills.id;


--
-- Name: slugs; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE slugs (
    id integer NOT NULL,
    slug character varying NOT NULL,
    sluggable_id integer NOT NULL,
    sluggable_type character varying NOT NULL,
    scope character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: slugs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE slugs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: slugs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE slugs_id_seq OWNED BY slugs.id;


--
-- Name: subjects; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE subjects (
    id integer NOT NULL,
    name character varying,
    slug character varying,
    description text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: subjects_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE subjects_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: subjects_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE subjects_id_seq OWNED BY subjects.id;


--
-- Name: taggings; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE taggings (
    id integer NOT NULL,
    tag_id integer,
    taggable_id integer,
    taggable_type character varying,
    tagger_id integer,
    tagger_type character varying,
    context character varying(128),
    created_at timestamp without time zone
);


--
-- Name: taggings_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE taggings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: taggings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE taggings_id_seq OWNED BY taggings.id;


--
-- Name: tags; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE tags (
    id integer NOT NULL,
    name character varying,
    taggings_count integer DEFAULT 0,
    slug character varying
);


--
-- Name: tags_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE tags_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: tags_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE tags_id_seq OWNED BY tags.id;


--
-- Name: team_invites; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE team_invites (
    id integer NOT NULL,
    inviter_id integer,
    invited_id integer,
    idea_id integer,
    msg text,
    pending boolean DEFAULT true NOT NULL,
    token character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: team_invites_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE team_invites_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: team_invites_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE team_invites_id_seq OWNED BY team_invites.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE users (
    id integer NOT NULL,
    email character varying NOT NULL,
    first_name character varying DEFAULT ''::character varying NOT NULL,
    last_name character varying DEFAULT ''::character varying NOT NULL,
    name character varying DEFAULT ''::character varying NOT NULL,
    username character varying DEFAULT ''::character varying NOT NULL,
    avatar character varying DEFAULT ''::character varying,
    feed_preferences integer DEFAULT 0,
    "integer" integer DEFAULT 0,
    cover character varying DEFAULT ''::character varying,
    slug character varying,
    mini_bio character varying DEFAULT ''::character varying,
    about_me text DEFAULT ''::text,
    profile jsonb DEFAULT '{}'::jsonb,
    media jsonb DEFAULT '{}'::jsonb,
    settings jsonb DEFAULT '{}'::jsonb,
    fund jsonb DEFAULT '{}'::jsonb,
    school_id integer,
    cached_location_list character varying,
    cached_market_list character varying,
    cached_skill_list character varying,
    cached_subject_list character varying,
    cached_hobby_list character varying,
    verified boolean DEFAULT false,
    admin boolean DEFAULT false,
    terms_accepted boolean DEFAULT false,
    rules_accepted boolean DEFAULT false,
    role integer DEFAULT 1,
    state integer DEFAULT 0,
    encrypted_password character varying DEFAULT ''::character varying,
    reset_password_token character varying,
    reset_password_sent_at timestamp without time zone,
    remember_created_at timestamp without time zone,
    sign_in_count integer DEFAULT 0 NOT NULL,
    current_sign_in_at timestamp without time zone,
    last_sign_in_at timestamp without time zone,
    current_sign_in_ip character varying,
    last_sign_in_ip character varying,
    confirmation_token character varying,
    confirmed_at timestamp without time zone,
    confirmation_sent_at timestamp without time zone,
    unconfirmed_email character varying,
    failed_attempts integer DEFAULT 0 NOT NULL,
    unlock_token character varying,
    locked_at timestamp without time zone,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    invitation_token character varying,
    invitation_created_at timestamp without time zone,
    invitation_sent_at timestamp without time zone,
    invitation_accepted_at timestamp without time zone,
    invitation_limit integer,
    invited_by_id integer,
    invited_by_type character varying,
    invitations_count integer DEFAULT 0,
    sash_id integer,
    level integer DEFAULT 0,
    uid character varying
);


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE users_id_seq OWNED BY users.id;


--
-- Name: version_associations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE version_associations (
    id integer NOT NULL,
    version_id integer,
    foreign_key_name character varying NOT NULL,
    foreign_key_id integer
);


--
-- Name: version_associations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE version_associations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: version_associations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE version_associations_id_seq OWNED BY version_associations.id;


--
-- Name: versions; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE versions (
    id integer NOT NULL,
    item_type character varying NOT NULL,
    item_id integer NOT NULL,
    event character varying NOT NULL,
    whodunnit character varying,
    user_name character varying,
    user_avatar character varying,
    name_badge character varying,
    owner_url character varying,
    object_changes json,
    object json,
    created_at timestamp without time zone,
    transaction_id integer
);


--
-- Name: versions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE versions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: versions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE versions_id_seq OWNED BY versions.id;


--
-- Name: votes; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE votes (
    id integer NOT NULL,
    votable_id integer NOT NULL,
    votable_type character varying NOT NULL,
    voter_id integer NOT NULL,
    vote_flag boolean DEFAULT true,
    vote_scope character varying,
    vote_weight integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: votes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE votes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: votes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE votes_id_seq OWNED BY votes.id;


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY activities ALTER COLUMN id SET DEFAULT nextval('activities_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY badges_sashes ALTER COLUMN id SET DEFAULT nextval('badges_sashes_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY comments ALTER COLUMN id SET DEFAULT nextval('comments_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY crono_jobs ALTER COLUMN id SET DEFAULT nextval('crono_jobs_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY event_attendees ALTER COLUMN id SET DEFAULT nextval('event_attendees_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY event_invites ALTER COLUMN id SET DEFAULT nextval('event_invites_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY events ALTER COLUMN id SET DEFAULT nextval('events_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY feedbacks ALTER COLUMN id SET DEFAULT nextval('feedbacks_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY follows ALTER COLUMN id SET DEFAULT nextval('follows_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY help_articles ALTER COLUMN id SET DEFAULT nextval('help_articles_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY help_categories ALTER COLUMN id SET DEFAULT nextval('help_categories_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY hobbies ALTER COLUMN id SET DEFAULT nextval('hobbies_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY idea_components ALTER COLUMN id SET DEFAULT nextval('idea_components_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY idea_messages ALTER COLUMN id SET DEFAULT nextval('idea_messages_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY ideas ALTER COLUMN id SET DEFAULT nextval('ideas_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY impressions ALTER COLUMN id SET DEFAULT nextval('impressions_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY investments ALTER COLUMN id SET DEFAULT nextval('investments_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY invite_requests ALTER COLUMN id SET DEFAULT nextval('invite_requests_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY locations ALTER COLUMN id SET DEFAULT nextval('locations_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY markets ALTER COLUMN id SET DEFAULT nextval('markets_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY mentions ALTER COLUMN id SET DEFAULT nextval('mentions_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY merit_actions ALTER COLUMN id SET DEFAULT nextval('merit_actions_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY merit_activity_logs ALTER COLUMN id SET DEFAULT nextval('merit_activity_logs_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY merit_score_points ALTER COLUMN id SET DEFAULT nextval('merit_score_points_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY merit_scores ALTER COLUMN id SET DEFAULT nextval('merit_scores_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY sashes ALTER COLUMN id SET DEFAULT nextval('sashes_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY school_admins ALTER COLUMN id SET DEFAULT nextval('school_admins_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY schools ALTER COLUMN id SET DEFAULT nextval('schools_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY shares ALTER COLUMN id SET DEFAULT nextval('shares_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY site_feedback_feedbacks ALTER COLUMN id SET DEFAULT nextval('site_feedback_feedbacks_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY skills ALTER COLUMN id SET DEFAULT nextval('skills_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY slugs ALTER COLUMN id SET DEFAULT nextval('slugs_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY subjects ALTER COLUMN id SET DEFAULT nextval('subjects_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY taggings ALTER COLUMN id SET DEFAULT nextval('taggings_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY tags ALTER COLUMN id SET DEFAULT nextval('tags_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY team_invites ALTER COLUMN id SET DEFAULT nextval('team_invites_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY users ALTER COLUMN id SET DEFAULT nextval('users_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY version_associations ALTER COLUMN id SET DEFAULT nextval('version_associations_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY versions ALTER COLUMN id SET DEFAULT nextval('versions_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY votes ALTER COLUMN id SET DEFAULT nextval('votes_id_seq'::regclass);


--
-- Name: activities_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY activities
    ADD CONSTRAINT activities_pkey PRIMARY KEY (id);


--
-- Name: badges_sashes_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY badges_sashes
    ADD CONSTRAINT badges_sashes_pkey PRIMARY KEY (id);


--
-- Name: comments_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY comments
    ADD CONSTRAINT comments_pkey PRIMARY KEY (id);


--
-- Name: crono_jobs_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY crono_jobs
    ADD CONSTRAINT crono_jobs_pkey PRIMARY KEY (id);


--
-- Name: event_attendees_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY event_attendees
    ADD CONSTRAINT event_attendees_pkey PRIMARY KEY (id);


--
-- Name: event_invites_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY event_invites
    ADD CONSTRAINT event_invites_pkey PRIMARY KEY (id);


--
-- Name: events_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY events
    ADD CONSTRAINT events_pkey PRIMARY KEY (id);


--
-- Name: feedbacks_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY feedbacks
    ADD CONSTRAINT feedbacks_pkey PRIMARY KEY (id);


--
-- Name: follows_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY follows
    ADD CONSTRAINT follows_pkey PRIMARY KEY (id);


--
-- Name: help_articles_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY help_articles
    ADD CONSTRAINT help_articles_pkey PRIMARY KEY (id);


--
-- Name: help_categories_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY help_categories
    ADD CONSTRAINT help_categories_pkey PRIMARY KEY (id);


--
-- Name: hobbies_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY hobbies
    ADD CONSTRAINT hobbies_pkey PRIMARY KEY (id);


--
-- Name: idea_components_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY idea_components
    ADD CONSTRAINT idea_components_pkey PRIMARY KEY (id);


--
-- Name: idea_messages_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY idea_messages
    ADD CONSTRAINT idea_messages_pkey PRIMARY KEY (id);


--
-- Name: ideas_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY ideas
    ADD CONSTRAINT ideas_pkey PRIMARY KEY (id);


--
-- Name: impressions_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY impressions
    ADD CONSTRAINT impressions_pkey PRIMARY KEY (id);


--
-- Name: investments_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY investments
    ADD CONSTRAINT investments_pkey PRIMARY KEY (id);


--
-- Name: invite_requests_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY invite_requests
    ADD CONSTRAINT invite_requests_pkey PRIMARY KEY (id);


--
-- Name: locations_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY locations
    ADD CONSTRAINT locations_pkey PRIMARY KEY (id);


--
-- Name: markets_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY markets
    ADD CONSTRAINT markets_pkey PRIMARY KEY (id);


--
-- Name: mentions_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY mentions
    ADD CONSTRAINT mentions_pkey PRIMARY KEY (id);


--
-- Name: merit_actions_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY merit_actions
    ADD CONSTRAINT merit_actions_pkey PRIMARY KEY (id);


--
-- Name: merit_activity_logs_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY merit_activity_logs
    ADD CONSTRAINT merit_activity_logs_pkey PRIMARY KEY (id);


--
-- Name: merit_score_points_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY merit_score_points
    ADD CONSTRAINT merit_score_points_pkey PRIMARY KEY (id);


--
-- Name: merit_scores_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY merit_scores
    ADD CONSTRAINT merit_scores_pkey PRIMARY KEY (id);


--
-- Name: sashes_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY sashes
    ADD CONSTRAINT sashes_pkey PRIMARY KEY (id);


--
-- Name: school_admins_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY school_admins
    ADD CONSTRAINT school_admins_pkey PRIMARY KEY (id);


--
-- Name: schools_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY schools
    ADD CONSTRAINT schools_pkey PRIMARY KEY (id);


--
-- Name: shares_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY shares
    ADD CONSTRAINT shares_pkey PRIMARY KEY (id);


--
-- Name: site_feedback_feedbacks_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY site_feedback_feedbacks
    ADD CONSTRAINT site_feedback_feedbacks_pkey PRIMARY KEY (id);


--
-- Name: skills_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY skills
    ADD CONSTRAINT skills_pkey PRIMARY KEY (id);


--
-- Name: slugs_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY slugs
    ADD CONSTRAINT slugs_pkey PRIMARY KEY (id);


--
-- Name: subjects_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY subjects
    ADD CONSTRAINT subjects_pkey PRIMARY KEY (id);


--
-- Name: taggings_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY taggings
    ADD CONSTRAINT taggings_pkey PRIMARY KEY (id);


--
-- Name: tags_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY tags
    ADD CONSTRAINT tags_pkey PRIMARY KEY (id);


--
-- Name: team_invites_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY team_invites
    ADD CONSTRAINT team_invites_pkey PRIMARY KEY (id);


--
-- Name: users_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: version_associations_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY version_associations
    ADD CONSTRAINT version_associations_pkey PRIMARY KEY (id);


--
-- Name: versions_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY versions
    ADD CONSTRAINT versions_pkey PRIMARY KEY (id);


--
-- Name: votes_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY votes
    ADD CONSTRAINT votes_pkey PRIMARY KEY (id);


--
-- Name: index_activities_on_parent_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_activities_on_parent_id ON activities USING btree (parent_id);


--
-- Name: index_activities_on_published_and_is_notification; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_activities_on_published_and_is_notification ON activities USING btree (published, is_notification);


--
-- Name: index_activities_on_trackable_id_and_trackable_type; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_activities_on_trackable_id_and_trackable_type ON activities USING btree (trackable_id, trackable_type);


--
-- Name: index_activities_on_uuid; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_activities_on_uuid ON activities USING btree (uuid);


--
-- Name: index_badges_sashes_on_badge_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_badges_sashes_on_badge_id ON badges_sashes USING btree (badge_id);


--
-- Name: index_badges_sashes_on_badge_id_and_sash_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_badges_sashes_on_badge_id_and_sash_id ON badges_sashes USING btree (badge_id, sash_id);


--
-- Name: index_badges_sashes_on_sash_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_badges_sashes_on_sash_id ON badges_sashes USING btree (sash_id);


--
-- Name: index_comments_on_commentable_id_and_commentable_type; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_comments_on_commentable_id_and_commentable_type ON comments USING btree (commentable_id, commentable_type);


--
-- Name: index_comments_on_lft; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_comments_on_lft ON comments USING btree (lft);


--
-- Name: index_comments_on_parent_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_comments_on_parent_id ON comments USING btree (parent_id);


--
-- Name: index_comments_on_rgt; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_comments_on_rgt ON comments USING btree (rgt);


--
-- Name: index_comments_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_comments_on_user_id ON comments USING btree (user_id);


--
-- Name: index_crono_jobs_on_job_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_crono_jobs_on_job_id ON crono_jobs USING btree (job_id);


--
-- Name: index_event_attendees_on_attendee_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_event_attendees_on_attendee_id ON event_attendees USING btree (attendee_id);


--
-- Name: index_event_attendees_on_attendee_id_and_event_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_event_attendees_on_attendee_id_and_event_id ON event_attendees USING btree (attendee_id, event_id);


--
-- Name: index_event_attendees_on_event_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_event_attendees_on_event_id ON event_attendees USING btree (event_id);


--
-- Name: index_event_invites_on_event_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_event_invites_on_event_id ON event_invites USING btree (event_id);


--
-- Name: index_event_invites_on_invited_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_event_invites_on_invited_id ON event_invites USING btree (invited_id);


--
-- Name: index_event_invites_on_inviter_type_and_inviter_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_event_invites_on_inviter_type_and_inviter_id ON event_invites USING btree (inviter_type, inviter_id);


--
-- Name: index_events_on_address; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_events_on_address ON events USING btree (address);


--
-- Name: index_events_on_end_time; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_events_on_end_time ON events USING btree (end_time);


--
-- Name: index_events_on_featured; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_events_on_featured ON events USING btree (featured);


--
-- Name: index_events_on_latitude_and_longitude; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_events_on_latitude_and_longitude ON events USING btree (latitude, longitude);


--
-- Name: index_events_on_owner_id_and_owner_type; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_events_on_owner_id_and_owner_type ON events USING btree (owner_id, owner_type);


--
-- Name: index_events_on_privacy; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_events_on_privacy ON events USING btree (privacy);


--
-- Name: index_events_on_slug; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_events_on_slug ON events USING btree (slug);


--
-- Name: index_events_on_start_time; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_events_on_start_time ON events USING btree (start_time);


--
-- Name: index_feedback_helpful; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_feedback_helpful ON feedbacks USING btree (badge) WHERE (badge = 1);


--
-- Name: index_feedback_irrelevant; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_feedback_irrelevant ON feedbacks USING btree (badge) WHERE (badge = 3);


--
-- Name: index_feedback_status; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_feedback_status ON feedbacks USING btree (status) WHERE (status = 1);


--
-- Name: index_feedback_unhelpful; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_feedback_unhelpful ON feedbacks USING btree (badge) WHERE (badge = 2);


--
-- Name: index_feedbacks_on_idea_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_feedbacks_on_idea_id ON feedbacks USING btree (idea_id);


--
-- Name: index_feedbacks_on_level; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_feedbacks_on_level ON feedbacks USING btree (level);


--
-- Name: index_feedbacks_on_sash_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_feedbacks_on_sash_id ON feedbacks USING btree (sash_id);


--
-- Name: index_feedbacks_on_status_and_badge; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_feedbacks_on_status_and_badge ON feedbacks USING btree (status, badge);


--
-- Name: index_feedbacks_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_feedbacks_on_user_id ON feedbacks USING btree (user_id);


--
-- Name: index_feedbacks_on_user_id_and_idea_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_feedbacks_on_user_id_and_idea_id ON feedbacks USING btree (user_id, idea_id);


--
-- Name: index_feedbacks_on_uuid; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_feedbacks_on_uuid ON feedbacks USING btree (uuid);


--
-- Name: index_follows_on_followable_id_and_followable_type; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_follows_on_followable_id_and_followable_type ON follows USING btree (followable_id, followable_type);


--
-- Name: index_follows_on_follower_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_follows_on_follower_id ON follows USING btree (follower_id);


--
-- Name: index_help_articles_on_category_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_help_articles_on_category_id ON help_articles USING btree (category_id);


--
-- Name: index_help_articles_on_slug; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_help_articles_on_slug ON help_articles USING btree (slug);


--
-- Name: index_help_categories_on_slug; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_help_categories_on_slug ON help_categories USING btree (slug);


--
-- Name: index_hobbies_on_slug; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_hobbies_on_slug ON hobbies USING btree (slug);


--
-- Name: index_idea_components_on_idea_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_idea_components_on_idea_id ON idea_components USING btree (idea_id);


--
-- Name: index_idea_components_on_idea_id_and_privacy; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_idea_components_on_idea_id_and_privacy ON idea_components USING btree (idea_id, privacy);


--
-- Name: index_idea_components_on_position; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_idea_components_on_position ON idea_components USING btree ("position");


--
-- Name: index_idea_components_on_privacy; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_idea_components_on_privacy ON idea_components USING btree (privacy);


--
-- Name: index_idea_investable; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_idea_investable ON ideas USING btree (investable) WHERE (investable IS TRUE);


--
-- Name: index_idea_looking_for_team; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_idea_looking_for_team ON ideas USING btree (looking_for_team) WHERE (looking_for_team IS TRUE);


--
-- Name: index_idea_messages_on_idea_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_idea_messages_on_idea_id ON idea_messages USING btree (idea_id);


--
-- Name: index_idea_messages_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_idea_messages_on_user_id ON idea_messages USING btree (user_id);


--
-- Name: index_idea_validated; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_idea_validated ON ideas USING btree (validated) WHERE (validated IS TRUE);


--
-- Name: index_ideas_on_level; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_ideas_on_level ON ideas USING btree (level);


--
-- Name: index_ideas_on_rules_accepted; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_ideas_on_rules_accepted ON ideas USING btree (rules_accepted);


--
-- Name: index_ideas_on_sash_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_ideas_on_sash_id ON ideas USING btree (sash_id);


--
-- Name: index_ideas_on_school_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_ideas_on_school_id ON ideas USING btree (school_id);


--
-- Name: index_ideas_on_school_id_and_validated; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_ideas_on_school_id_and_validated ON ideas USING btree (school_id, validated);


--
-- Name: index_ideas_on_slug; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_ideas_on_slug ON ideas USING btree (slug);


--
-- Name: index_ideas_on_status_and_privacy; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_ideas_on_status_and_privacy ON ideas USING btree (status, privacy);


--
-- Name: index_ideas_on_status_and_privacy_and_school_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_ideas_on_status_and_privacy_and_school_id ON ideas USING btree (status, privacy, school_id);


--
-- Name: index_ideas_on_status_and_privacy_and_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_ideas_on_status_and_privacy_and_user_id ON ideas USING btree (status, privacy, user_id);


--
-- Name: index_ideas_on_team_ids; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_ideas_on_team_ids ON ideas USING gin (team_ids);


--
-- Name: index_ideas_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_ideas_on_user_id ON ideas USING btree (user_id);


--
-- Name: index_ideas_on_user_id_and_validated; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_ideas_on_user_id_and_validated ON ideas USING btree (user_id, validated);


--
-- Name: index_impressions_on_impressionable_type_and_impressionable_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_impressions_on_impressionable_type_and_impressionable_id ON impressions USING btree (impressionable_type, impressionable_id);


--
-- Name: index_impressions_on_ip_address; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_impressions_on_ip_address ON impressions USING btree (ip_address);


--
-- Name: index_impressions_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_impressions_on_user_id ON impressions USING btree (user_id);


--
-- Name: index_investment_angel; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_investment_angel ON investments USING btree (amount) WHERE ((amount < 500) AND (amount > 200));


--
-- Name: index_investment_vc; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_investment_vc ON investments USING btree (amount) WHERE ((amount < 900) AND (amount > 500));


--
-- Name: index_investments_on_idea_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_investments_on_idea_id ON investments USING btree (idea_id);


--
-- Name: index_investments_on_idea_id_and_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_investments_on_idea_id_and_user_id ON investments USING btree (idea_id, user_id);


--
-- Name: index_investments_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_investments_on_user_id ON investments USING btree (user_id);


--
-- Name: index_investments_on_uuid; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_investments_on_uuid ON investments USING btree (uuid);


--
-- Name: index_invite_requests_on_email; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_invite_requests_on_email ON invite_requests USING btree (email);


--
-- Name: index_invite_requests_on_user_type; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_invite_requests_on_user_type ON invite_requests USING btree (user_type);


--
-- Name: index_locations_on_slug; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_locations_on_slug ON locations USING btree (slug);


--
-- Name: index_markets_on_slug; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_markets_on_slug ON markets USING btree (slug);


--
-- Name: index_mentions_on_mentionable_type_and_mentionable_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_mentions_on_mentionable_type_and_mentionable_id ON mentions USING btree (mentionable_type, mentionable_id);


--
-- Name: index_mentions_on_mentioner_id_and_mentioner_type; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_mentions_on_mentioner_id_and_mentioner_type ON mentions USING btree (mentioner_id, mentioner_type);


--
-- Name: index_mentions_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_mentions_on_user_id ON mentions USING btree (user_id);


--
-- Name: index_school_admins_on_active; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_school_admins_on_active ON school_admins USING btree (active);


--
-- Name: index_school_admins_on_school_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_school_admins_on_school_id ON school_admins USING btree (school_id);


--
-- Name: index_school_admins_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_school_admins_on_user_id ON school_admins USING btree (user_id);


--
-- Name: index_school_admins_on_user_id_and_school_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_school_admins_on_user_id_and_school_id ON school_admins USING btree (user_id, school_id);


--
-- Name: index_schools_on_email; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_schools_on_email ON schools USING btree (email);


--
-- Name: index_schools_on_name; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_schools_on_name ON schools USING btree (name);


--
-- Name: index_schools_on_slug; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_schools_on_slug ON schools USING btree (slug);


--
-- Name: index_schools_on_uuid; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_schools_on_uuid ON schools USING btree (uuid);


--
-- Name: index_shares_on_owner_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_shares_on_owner_id ON shares USING btree (owner_id);


--
-- Name: index_site_feedback_feedbacks_on_email; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_site_feedback_feedbacks_on_email ON site_feedback_feedbacks USING btree (email);


--
-- Name: index_site_feedback_feedbacks_on_status; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_site_feedback_feedbacks_on_status ON site_feedback_feedbacks USING btree (status);


--
-- Name: index_site_feedback_feedbacks_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_site_feedback_feedbacks_on_user_id ON site_feedback_feedbacks USING btree (user_id);


--
-- Name: index_skills_on_slug; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_skills_on_slug ON skills USING btree (slug);


--
-- Name: index_slugs_on_slug; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_slugs_on_slug ON slugs USING btree (slug);


--
-- Name: index_slugs_on_sluggable_id_and_sluggable_type; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_slugs_on_sluggable_id_and_sluggable_type ON slugs USING btree (sluggable_id, sluggable_type);


--
-- Name: index_slugs_on_sluggable_id_and_sluggable_type_and_slug; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_slugs_on_sluggable_id_and_sluggable_type_and_slug ON slugs USING btree (sluggable_id, sluggable_type, slug);


--
-- Name: index_slugs_on_sluggable_type_and_sluggable_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_slugs_on_sluggable_type_and_sluggable_id ON slugs USING btree (sluggable_type, sluggable_id);


--
-- Name: index_subjects_on_slug; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_subjects_on_slug ON subjects USING btree (slug);


--
-- Name: index_taggings_on_tag_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_taggings_on_tag_id ON taggings USING btree (tag_id);


--
-- Name: index_taggings_on_taggable_id_and_taggable_type_and_context; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_taggings_on_taggable_id_and_taggable_type_and_context ON taggings USING btree (taggable_id, taggable_type, context);


--
-- Name: index_tags_on_name; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_tags_on_name ON tags USING btree (name);


--
-- Name: index_tags_on_slug; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_tags_on_slug ON tags USING btree (slug);


--
-- Name: index_team_invites_on_idea_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_team_invites_on_idea_id ON team_invites USING btree (idea_id);


--
-- Name: index_team_invites_on_invited_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_team_invites_on_invited_id ON team_invites USING btree (invited_id);


--
-- Name: index_team_invites_on_invited_id_and_idea_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_team_invites_on_invited_id_and_idea_id ON team_invites USING btree (invited_id, idea_id);


--
-- Name: index_team_invites_on_inviter_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_team_invites_on_inviter_id ON team_invites USING btree (inviter_id);


--
-- Name: index_team_invites_on_inviter_id_and_invited_id_and_idea_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_team_invites_on_inviter_id_and_invited_id_and_idea_id ON team_invites USING btree (inviter_id, invited_id, idea_id);


--
-- Name: index_team_invites_on_token; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_team_invites_on_token ON team_invites USING btree (token);


--
-- Name: index_user_admin; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_user_admin ON users USING btree (admin) WHERE (admin IS TRUE);


--
-- Name: index_user_published; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_user_published ON users USING btree (state) WHERE (state = 1);


--
-- Name: index_user_verified; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_user_verified ON users USING btree (verified) WHERE (verified IS TRUE);


--
-- Name: index_users_on_confirmation_token; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_users_on_confirmation_token ON users USING btree (confirmation_token);


--
-- Name: index_users_on_email; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_users_on_email ON users USING btree (email);


--
-- Name: index_users_on_invitation_token; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_users_on_invitation_token ON users USING btree (invitation_token);


--
-- Name: index_users_on_invitations_count; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_users_on_invitations_count ON users USING btree (invitations_count);


--
-- Name: index_users_on_invited_by_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_users_on_invited_by_id ON users USING btree (invited_by_id);


--
-- Name: index_users_on_invited_by_id_and_invited_by_type; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_users_on_invited_by_id_and_invited_by_type ON users USING btree (invited_by_id, invited_by_type);


--
-- Name: index_users_on_level; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_users_on_level ON users USING btree (level);


--
-- Name: index_users_on_reset_password_token; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_users_on_reset_password_token ON users USING btree (reset_password_token);


--
-- Name: index_users_on_role; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_users_on_role ON users USING btree (role);


--
-- Name: index_users_on_sash_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_users_on_sash_id ON users USING btree (sash_id);


--
-- Name: index_users_on_school_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_users_on_school_id ON users USING btree (school_id);


--
-- Name: index_users_on_school_id_and_role; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_users_on_school_id_and_role ON users USING btree (school_id, role);


--
-- Name: index_users_on_school_id_and_state; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_users_on_school_id_and_state ON users USING btree (school_id, state);


--
-- Name: index_users_on_slug; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_users_on_slug ON users USING btree (slug);


--
-- Name: index_users_on_state; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_users_on_state ON users USING btree (state);


--
-- Name: index_users_on_state_and_role; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_users_on_state_and_role ON users USING btree (state, role);


--
-- Name: index_users_on_state_and_role_and_school_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_users_on_state_and_role_and_school_id ON users USING btree (state, role, school_id);


--
-- Name: index_users_on_uid; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_users_on_uid ON users USING btree (uid);


--
-- Name: index_users_on_username; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_users_on_username ON users USING btree (username);


--
-- Name: index_version_associations_on_foreign_key; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_version_associations_on_foreign_key ON version_associations USING btree (foreign_key_name, foreign_key_id);


--
-- Name: index_version_associations_on_version_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_version_associations_on_version_id ON version_associations USING btree (version_id);


--
-- Name: index_versions_on_item_type_and_item_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_versions_on_item_type_and_item_id ON versions USING btree (item_type, item_id);


--
-- Name: index_versions_on_transaction_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_versions_on_transaction_id ON versions USING btree (transaction_id);


--
-- Name: index_votes_on_votable_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_votes_on_votable_id ON votes USING btree (votable_id);


--
-- Name: index_votes_on_votable_id_and_votable_type_and_voter_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_votes_on_votable_id_and_votable_type_and_voter_id ON votes USING btree (votable_id, votable_type, voter_id);


--
-- Name: index_votes_on_voter_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_votes_on_voter_id ON votes USING btree (voter_id);


--
-- Name: owner_published_activities; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX owner_published_activities ON activities USING btree (owner_id, owner_type, published, is_notification);


--
-- Name: recipient_published_activities; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX recipient_published_activities ON activities USING btree (recipient_id, recipient_type, published, is_notification);


--
-- Name: taggings_idx; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX taggings_idx ON taggings USING btree (tag_id, taggable_id, taggable_type, context, tagger_id, tagger_type);


--
-- Name: unique_activity_per_owner; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX unique_activity_per_owner ON activities USING btree (owner_id, owner_type, trackable_id, trackable_type, key);


--
-- Name: unique_event_invites; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX unique_event_invites ON event_invites USING btree (inviter_id, inviter_type, invited_id, event_id);


--
-- Name: unique_follows_index; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX unique_follows_index ON follows USING btree (followable_id, followable_type, follower_id);


--
-- Name: unique_impressions; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX unique_impressions ON impressions USING btree (impressionable_id, impressionable_type, user_id);


--
-- Name: unique_schema_migrations; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX unique_schema_migrations ON schema_migrations USING btree (version);


--
-- Name: user_commentable_comments; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX user_commentable_comments ON comments USING btree (user_id, commentable_id, commentable_type);


--
-- Name: fk_rails_15f20ac5cc; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY team_invites
    ADD CONSTRAINT fk_rails_15f20ac5cc FOREIGN KEY (idea_id) REFERENCES ideas(id);


--
-- Name: fk_rails_1b711e94aa; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY mentions
    ADD CONSTRAINT fk_rails_1b711e94aa FOREIGN KEY (user_id) REFERENCES users(id);


--
-- Name: fk_rails_4a2a343dbc; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY school_admins
    ADD CONSTRAINT fk_rails_4a2a343dbc FOREIGN KEY (school_id) REFERENCES schools(id);


--
-- Name: fk_rails_ad83b2aa73; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY school_admins
    ADD CONSTRAINT fk_rails_ad83b2aa73 FOREIGN KEY (user_id) REFERENCES users(id);


--
-- Name: fk_rails_c93dfeb29b; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY event_attendees
    ADD CONSTRAINT fk_rails_c93dfeb29b FOREIGN KEY (event_id) REFERENCES events(id);


--
-- Name: fk_rails_dd5ebcb656; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY event_invites
    ADD CONSTRAINT fk_rails_dd5ebcb656 FOREIGN KEY (event_id) REFERENCES events(id);


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user",public;

INSERT INTO schema_migrations (version) VALUES ('20140805183219');

INSERT INTO schema_migrations (version) VALUES ('20140805183225');

INSERT INTO schema_migrations (version) VALUES ('20140805184420');

INSERT INTO schema_migrations (version) VALUES ('20140812190804');

INSERT INTO schema_migrations (version) VALUES ('20140812190810');

INSERT INTO schema_migrations (version) VALUES ('20140814084456');

INSERT INTO schema_migrations (version) VALUES ('20140817173659');

INSERT INTO schema_migrations (version) VALUES ('20140817173660');

INSERT INTO schema_migrations (version) VALUES ('20140817173661');

INSERT INTO schema_migrations (version) VALUES ('20140817173662');

INSERT INTO schema_migrations (version) VALUES ('20140825003938');

INSERT INTO schema_migrations (version) VALUES ('20140830232833');

INSERT INTO schema_migrations (version) VALUES ('20140928202143');

INSERT INTO schema_migrations (version) VALUES ('20141003131909');

INSERT INTO schema_migrations (version) VALUES ('20141018180129');

INSERT INTO schema_migrations (version) VALUES ('20141102035238');

INSERT INTO schema_migrations (version) VALUES ('20141102045507');

INSERT INTO schema_migrations (version) VALUES ('20141102045508');

INSERT INTO schema_migrations (version) VALUES ('20141102045509');

INSERT INTO schema_migrations (version) VALUES ('20141102045510');

INSERT INTO schema_migrations (version) VALUES ('20141102045511');

INSERT INTO schema_migrations (version) VALUES ('20141102045532');

INSERT INTO schema_migrations (version) VALUES ('20141102050735');

INSERT INTO schema_migrations (version) VALUES ('20141102050834');

INSERT INTO schema_migrations (version) VALUES ('20141122174311');

INSERT INTO schema_migrations (version) VALUES ('20141209231249');

INSERT INTO schema_migrations (version) VALUES ('20150122230500');

INSERT INTO schema_migrations (version) VALUES ('20150312183515');

INSERT INTO schema_migrations (version) VALUES ('20150312183534');

INSERT INTO schema_migrations (version) VALUES ('20150312183535');

INSERT INTO schema_migrations (version) VALUES ('20150312183540');

INSERT INTO schema_migrations (version) VALUES ('20150312183545');

INSERT INTO schema_migrations (version) VALUES ('20150317170955');

INSERT INTO schema_migrations (version) VALUES ('20150317220155');

INSERT INTO schema_migrations (version) VALUES ('20150321215014');

INSERT INTO schema_migrations (version) VALUES ('20150323234103');

INSERT INTO schema_migrations (version) VALUES ('20150420113616');

INSERT INTO schema_migrations (version) VALUES ('20150425124545');

INSERT INTO schema_migrations (version) VALUES ('20150425140518');

INSERT INTO schema_migrations (version) VALUES ('20150512113344');

INSERT INTO schema_migrations (version) VALUES ('20150517032505');

INSERT INTO schema_migrations (version) VALUES ('20150517032506');

INSERT INTO schema_migrations (version) VALUES ('20150528181322');

INSERT INTO schema_migrations (version) VALUES ('20150605120916');

INSERT INTO schema_migrations (version) VALUES ('20150610172254');

INSERT INTO schema_migrations (version) VALUES ('20150610172255');

INSERT INTO schema_migrations (version) VALUES ('20150615210512');

INSERT INTO schema_migrations (version) VALUES ('20150616232524');

INSERT INTO schema_migrations (version) VALUES ('20150618162746');

INSERT INTO schema_migrations (version) VALUES ('20150627164750');

INSERT INTO schema_migrations (version) VALUES ('20150711185427');

INSERT INTO schema_migrations (version) VALUES ('20150715172544');

INSERT INTO schema_migrations (version) VALUES ('20150715185616');

