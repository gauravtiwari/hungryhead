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


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: activities; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE activities (
    id integer NOT NULL,
    trackable_id integer,
    trackable_type character varying,
    user_id integer,
    key character varying,
    type character varying DEFAULT 'Activity'::character varying,
    parameters jsonb DEFAULT '{}'::jsonb,
    published boolean DEFAULT true,
    recipient_id integer,
    recipient_type character varying,
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
-- Name: authentications; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE authentications (
    id integer NOT NULL,
    user_id integer,
    provider character varying,
    uid character varying,
    access_token character varying,
    token_secret character varying,
    parameters jsonb,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: authentications_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE authentications_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: authentications_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE authentications_id_seq OWNED BY authentications.id;


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
    commentable_id integer,
    commentable_type character varying,
    title character varying,
    body text,
    subject character varying,
    user_id integer NOT NULL,
    parent_id integer,
    lft integer,
    rgt integer,
    role character varying DEFAULT 'comments'::character varying,
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
-- Name: feedbacks; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE feedbacks (
    id integer NOT NULL,
    body text NOT NULL,
    idea_id integer NOT NULL,
    user_id integer NOT NULL,
    status integer DEFAULT 0 NOT NULL,
    parameters jsonb DEFAULT '{}'::jsonb,
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
    followable_id integer,
    followable_type character varying,
    follower_id integer,
    follower_type character varying,
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
-- Name: idea_messages; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE idea_messages (
    id integer NOT NULL,
    student_id integer NOT NULL,
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
    student_id integer NOT NULL,
    name character varying,
    slug character varying,
    high_concept_pitch character varying DEFAULT ''::character varying,
    elevator_pitch text DEFAULT ''::text,
    description text DEFAULT ''::text,
    logo character varying,
    cover character varying,
    team character varying[] DEFAULT '{}'::character varying[],
    team_invites character varying[] DEFAULT '{}'::character varying[],
    feedbackers character varying[] DEFAULT '{}'::character varying[],
    investors character varying[] DEFAULT '{}'::character varying[],
    looking_for_team boolean DEFAULT false,
    school_id integer,
    status integer DEFAULT 0,
    privacy integer DEFAULT 0,
    settings jsonb DEFAULT '{}'::jsonb,
    media jsonb DEFAULT '{}'::jsonb,
    profile jsonb DEFAULT '{}'::jsonb,
    sections jsonb DEFAULT '{}'::jsonb,
    fund jsonb DEFAULT '{}'::jsonb,
    cached_location_list character varying,
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
-- Name: investments; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE investments (
    id integer NOT NULL,
    amount integer NOT NULL,
    note character varying NOT NULL,
    user_id integer NOT NULL,
    idea_id integer NOT NULL,
    parameters jsonb DEFAULT '{}'::jsonb,
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
-- Name: mailboxer_conversation_opt_outs; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE mailboxer_conversation_opt_outs (
    id integer NOT NULL,
    unsubscriber_id integer,
    unsubscriber_type character varying,
    conversation_id integer
);


--
-- Name: mailboxer_conversation_opt_outs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE mailboxer_conversation_opt_outs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: mailboxer_conversation_opt_outs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE mailboxer_conversation_opt_outs_id_seq OWNED BY mailboxer_conversation_opt_outs.id;


--
-- Name: mailboxer_conversations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE mailboxer_conversations (
    id integer NOT NULL,
    subject character varying DEFAULT ''::character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: mailboxer_conversations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE mailboxer_conversations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: mailboxer_conversations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE mailboxer_conversations_id_seq OWNED BY mailboxer_conversations.id;


--
-- Name: mailboxer_notifications; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE mailboxer_notifications (
    id integer NOT NULL,
    type character varying,
    body text,
    subject character varying DEFAULT ''::character varying,
    sender_id integer,
    sender_type character varying,
    conversation_id integer,
    draft boolean DEFAULT false,
    notification_code character varying,
    notified_object_id integer,
    notified_object_type character varying,
    attachment character varying,
    updated_at timestamp without time zone NOT NULL,
    created_at timestamp without time zone NOT NULL,
    global boolean DEFAULT false,
    expires timestamp without time zone
);


--
-- Name: mailboxer_notifications_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE mailboxer_notifications_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: mailboxer_notifications_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE mailboxer_notifications_id_seq OWNED BY mailboxer_notifications.id;


--
-- Name: mailboxer_receipts; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE mailboxer_receipts (
    id integer NOT NULL,
    receiver_id integer,
    receiver_type character varying,
    notification_id integer NOT NULL,
    is_read boolean DEFAULT false,
    trashed boolean DEFAULT false,
    deleted boolean DEFAULT false,
    mailbox_type character varying(25),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: mailboxer_receipts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE mailboxer_receipts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: mailboxer_receipts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE mailboxer_receipts_id_seq OWNED BY mailboxer_receipts.id;


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
    mentionable_id integer,
    mentionable_type character varying,
    mentioner_id integer,
    mentioner_type character varying,
    user_id integer,
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
-- Name: notes; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE notes (
    id integer NOT NULL,
    title character varying,
    body text,
    status integer,
    user_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: notes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE notes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: notes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE notes_id_seq OWNED BY notes.id;


--
-- Name: organizations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE organizations (
    id integer NOT NULL,
    email character varying DEFAULT ''::character varying NOT NULL,
    name character varying NOT NULL,
    slug character varying NOT NULL,
    description text,
    logo character varying,
    type character varying,
    cover character varying,
    media jsonb DEFAULT '{}'::jsonb,
    data jsonb DEFAULT '{}'::jsonb,
    customizations jsonb DEFAULT '{}'::jsonb,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: organizations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE organizations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: organizations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE organizations_id_seq OWNED BY organizations.id;


--
-- Name: punches; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE punches (
    id integer NOT NULL,
    punchable_id integer NOT NULL,
    punchable_type character varying(20) NOT NULL,
    starts_at timestamp without time zone NOT NULL,
    ends_at timestamp without time zone NOT NULL,
    average_time timestamp without time zone NOT NULL,
    hits integer DEFAULT 1 NOT NULL
);


--
-- Name: punches_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE punches_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: punches_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE punches_id_seq OWNED BY punches.id;


--
-- Name: read_marks; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE read_marks (
    id integer NOT NULL,
    readable_id integer,
    readable_type character varying NOT NULL,
    user_id integer NOT NULL,
    "timestamp" timestamp without time zone
);


--
-- Name: read_marks_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE read_marks_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: read_marks_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE read_marks_id_seq OWNED BY read_marks.id;


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
-- Name: schools; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE schools (
    id integer NOT NULL,
    email character varying DEFAULT ''::character varying NOT NULL,
    name character varying NOT NULL,
    slug character varying NOT NULL,
    description text,
    logo character varying,
    type character varying,
    cover character varying,
    media jsonb DEFAULT '{}'::jsonb,
    data jsonb DEFAULT '{}'::jsonb,
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
-- Name: sessions; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE sessions (
    id integer NOT NULL,
    session_id character varying NOT NULL,
    data text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: sessions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE sessions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sessions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE sessions_id_seq OWNED BY sessions.id;


--
-- Name: shares; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE shares (
    id integer NOT NULL,
    body text,
    status integer,
    privacy integer,
    shareable_id integer,
    shareable_type character varying,
    user_id integer,
    parameters jsonb,
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
-- Name: slugs; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE slugs (
    id integer NOT NULL,
    slug character varying NOT NULL,
    sluggable_id integer,
    sluggable_type character varying,
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
-- Name: users; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE users (
    id integer NOT NULL,
    email character varying NOT NULL,
    first_name character varying DEFAULT ''::character varying NOT NULL,
    last_name character varying DEFAULT ''::character varying NOT NULL,
    name character varying DEFAULT ''::character varying NOT NULL,
    username character varying NOT NULL,
    avatar character varying DEFAULT ''::character varying,
    type character varying DEFAULT 'User'::character varying,
    cover character varying DEFAULT ''::character varying,
    slug character varying,
    mini_bio character varying DEFAULT ''::character varying,
    about_me text DEFAULT ''::text,
    profile jsonb DEFAULT '{}'::jsonb,
    interests jsonb DEFAULT '{}'::jsonb,
    media jsonb DEFAULT '{}'::jsonb,
    settings jsonb DEFAULT '{}'::jsonb,
    fund jsonb DEFAULT '{}'::jsonb,
    school_id integer,
    cached_location_list character varying,
    cached_market_list character varying,
    cached_skill_list character varying,
    cached_subject_list character varying,
    cached_technology_list character varying,
    cached_service_list character varying,
    verified boolean DEFAULT false,
    admin boolean DEFAULT false,
    terms_accepted boolean DEFAULT false,
    role integer DEFAULT 0,
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
    level integer DEFAULT 0
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
-- Name: versions; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE versions (
    id integer NOT NULL,
    item_type character varying NOT NULL,
    item_id integer NOT NULL,
    event character varying NOT NULL,
    whodunnit character varying,
    object text,
    created_at timestamp without time zone,
    object_changes text
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
    votable_id integer,
    votable_type character varying,
    voter_id integer,
    voter_type character varying,
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

ALTER TABLE ONLY authentications ALTER COLUMN id SET DEFAULT nextval('authentications_id_seq'::regclass);


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

ALTER TABLE ONLY feedbacks ALTER COLUMN id SET DEFAULT nextval('feedbacks_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY follows ALTER COLUMN id SET DEFAULT nextval('follows_id_seq'::regclass);


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

ALTER TABLE ONLY investments ALTER COLUMN id SET DEFAULT nextval('investments_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY locations ALTER COLUMN id SET DEFAULT nextval('locations_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY mailboxer_conversation_opt_outs ALTER COLUMN id SET DEFAULT nextval('mailboxer_conversation_opt_outs_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY mailboxer_conversations ALTER COLUMN id SET DEFAULT nextval('mailboxer_conversations_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY mailboxer_notifications ALTER COLUMN id SET DEFAULT nextval('mailboxer_notifications_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY mailboxer_receipts ALTER COLUMN id SET DEFAULT nextval('mailboxer_receipts_id_seq'::regclass);


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

ALTER TABLE ONLY notes ALTER COLUMN id SET DEFAULT nextval('notes_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY organizations ALTER COLUMN id SET DEFAULT nextval('organizations_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY punches ALTER COLUMN id SET DEFAULT nextval('punches_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY read_marks ALTER COLUMN id SET DEFAULT nextval('read_marks_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY sashes ALTER COLUMN id SET DEFAULT nextval('sashes_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY schools ALTER COLUMN id SET DEFAULT nextval('schools_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY sessions ALTER COLUMN id SET DEFAULT nextval('sessions_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY shares ALTER COLUMN id SET DEFAULT nextval('shares_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY slugs ALTER COLUMN id SET DEFAULT nextval('slugs_id_seq'::regclass);


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

ALTER TABLE ONLY users ALTER COLUMN id SET DEFAULT nextval('users_id_seq'::regclass);


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
-- Name: authentications_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY authentications
    ADD CONSTRAINT authentications_pkey PRIMARY KEY (id);


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
-- Name: investments_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY investments
    ADD CONSTRAINT investments_pkey PRIMARY KEY (id);


--
-- Name: locations_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY locations
    ADD CONSTRAINT locations_pkey PRIMARY KEY (id);


--
-- Name: mailboxer_conversation_opt_outs_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY mailboxer_conversation_opt_outs
    ADD CONSTRAINT mailboxer_conversation_opt_outs_pkey PRIMARY KEY (id);


--
-- Name: mailboxer_conversations_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY mailboxer_conversations
    ADD CONSTRAINT mailboxer_conversations_pkey PRIMARY KEY (id);


--
-- Name: mailboxer_notifications_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY mailboxer_notifications
    ADD CONSTRAINT mailboxer_notifications_pkey PRIMARY KEY (id);


--
-- Name: mailboxer_receipts_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY mailboxer_receipts
    ADD CONSTRAINT mailboxer_receipts_pkey PRIMARY KEY (id);


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
-- Name: notes_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY notes
    ADD CONSTRAINT notes_pkey PRIMARY KEY (id);


--
-- Name: organizations_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY organizations
    ADD CONSTRAINT organizations_pkey PRIMARY KEY (id);


--
-- Name: punches_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY punches
    ADD CONSTRAINT punches_pkey PRIMARY KEY (id);


--
-- Name: read_marks_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY read_marks
    ADD CONSTRAINT read_marks_pkey PRIMARY KEY (id);


--
-- Name: sashes_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY sashes
    ADD CONSTRAINT sashes_pkey PRIMARY KEY (id);


--
-- Name: schools_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY schools
    ADD CONSTRAINT schools_pkey PRIMARY KEY (id);


--
-- Name: sessions_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY sessions
    ADD CONSTRAINT sessions_pkey PRIMARY KEY (id);


--
-- Name: shares_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY shares
    ADD CONSTRAINT shares_pkey PRIMARY KEY (id);


--
-- Name: slugs_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY slugs
    ADD CONSTRAINT slugs_pkey PRIMARY KEY (id);


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
-- Name: users_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


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
-- Name: index_activities_on_key_and_published_and_type; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_activities_on_key_and_published_and_type ON activities USING btree (key, published, type);


--
-- Name: index_activities_on_recipient_id_and_recipient_type; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_activities_on_recipient_id_and_recipient_type ON activities USING btree (recipient_id, recipient_type);


--
-- Name: index_activities_on_trackable_id_and_trackable_type; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_activities_on_trackable_id_and_trackable_type ON activities USING btree (trackable_id, trackable_type);


--
-- Name: index_authentications_on_parameters; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_authentications_on_parameters ON authentications USING gin (parameters);


--
-- Name: index_authentications_on_uid_and_provider_and_access_token; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_authentications_on_uid_and_provider_and_access_token ON authentications USING btree (uid, provider, access_token);


--
-- Name: index_authentications_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_authentications_on_user_id ON authentications USING btree (user_id);


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
-- Name: index_comments_on_parent_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_comments_on_parent_id ON comments USING btree (parent_id);


--
-- Name: index_comments_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_comments_on_user_id ON comments USING btree (user_id);


--
-- Name: index_feedbacks_on_idea_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_feedbacks_on_idea_id ON feedbacks USING btree (idea_id);


--
-- Name: index_feedbacks_on_parameters; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_feedbacks_on_parameters ON feedbacks USING gin (parameters);


--
-- Name: index_feedbacks_on_sash_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_feedbacks_on_sash_id ON feedbacks USING btree (sash_id);


--
-- Name: index_feedbacks_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_feedbacks_on_user_id ON feedbacks USING btree (user_id);


--
-- Name: index_followables; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_followables ON follows USING btree (followable_id, followable_type);


--
-- Name: index_followers; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_followers ON follows USING btree (follower_id, follower_type);


--
-- Name: index_follows_on_followable_id_and_followable_type; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_follows_on_followable_id_and_followable_type ON follows USING btree (followable_id, followable_type);


--
-- Name: index_follows_on_follower_id_and_follower_type; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_follows_on_follower_id_and_follower_type ON follows USING btree (follower_id, follower_type);


--
-- Name: index_idea_messages_on_idea_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_idea_messages_on_idea_id ON idea_messages USING btree (idea_id);


--
-- Name: index_idea_messages_on_student_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_idea_messages_on_student_id ON idea_messages USING btree (student_id);


--
-- Name: index_ideas_on_fund; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_ideas_on_fund ON ideas USING gin (fund);


--
-- Name: index_ideas_on_looking_for_team; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_ideas_on_looking_for_team ON ideas USING btree (looking_for_team);


--
-- Name: index_ideas_on_privacy; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_ideas_on_privacy ON ideas USING btree (privacy);


--
-- Name: index_ideas_on_profile; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_ideas_on_profile ON ideas USING gin (profile);


--
-- Name: index_ideas_on_sash_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_ideas_on_sash_id ON ideas USING btree (sash_id);


--
-- Name: index_ideas_on_school_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_ideas_on_school_id ON ideas USING btree (school_id);


--
-- Name: index_ideas_on_settings; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_ideas_on_settings ON ideas USING gin (settings);


--
-- Name: index_ideas_on_slug; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_ideas_on_slug ON ideas USING btree (slug);


--
-- Name: index_ideas_on_status; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_ideas_on_status ON ideas USING btree (status);


--
-- Name: index_ideas_on_student_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_ideas_on_student_id ON ideas USING btree (student_id);


--
-- Name: index_investments_on_idea_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_investments_on_idea_id ON investments USING btree (idea_id);


--
-- Name: index_investments_on_parameters; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_investments_on_parameters ON investments USING gin (parameters);


--
-- Name: index_investments_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_investments_on_user_id ON investments USING btree (user_id);


--
-- Name: index_locations_on_slug; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_locations_on_slug ON locations USING btree (slug);


--
-- Name: index_mailboxer_conversation_opt_outs_on_conversation_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_mailboxer_conversation_opt_outs_on_conversation_id ON mailboxer_conversation_opt_outs USING btree (conversation_id);


--
-- Name: index_mailboxer_conversation_opt_outs_on_unsubscriber_id_type; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_mailboxer_conversation_opt_outs_on_unsubscriber_id_type ON mailboxer_conversation_opt_outs USING btree (unsubscriber_id, unsubscriber_type);


--
-- Name: index_mailboxer_notifications_on_conversation_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_mailboxer_notifications_on_conversation_id ON mailboxer_notifications USING btree (conversation_id);


--
-- Name: index_mailboxer_notifications_on_notified_object_id_and_type; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_mailboxer_notifications_on_notified_object_id_and_type ON mailboxer_notifications USING btree (notified_object_id, notified_object_type);


--
-- Name: index_mailboxer_notifications_on_sender_id_and_sender_type; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_mailboxer_notifications_on_sender_id_and_sender_type ON mailboxer_notifications USING btree (sender_id, sender_type);


--
-- Name: index_mailboxer_notifications_on_type; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_mailboxer_notifications_on_type ON mailboxer_notifications USING btree (type);


--
-- Name: index_mailboxer_receipts_on_notification_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_mailboxer_receipts_on_notification_id ON mailboxer_receipts USING btree (notification_id);


--
-- Name: index_mailboxer_receipts_on_receiver_id_and_receiver_type; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_mailboxer_receipts_on_receiver_id_and_receiver_type ON mailboxer_receipts USING btree (receiver_id, receiver_type);


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
-- Name: index_merit_activity_logs_on_action_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_merit_activity_logs_on_action_id ON merit_activity_logs USING btree (action_id);


--
-- Name: index_notes_on_status; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_notes_on_status ON notes USING btree (status);


--
-- Name: index_notes_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_notes_on_user_id ON notes USING btree (user_id);


--
-- Name: index_organizations_on_data; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_organizations_on_data ON organizations USING gin (data);


--
-- Name: index_organizations_on_email; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_organizations_on_email ON organizations USING btree (email);


--
-- Name: index_organizations_on_name; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_organizations_on_name ON organizations USING btree (name);


--
-- Name: index_organizations_on_slug; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_organizations_on_slug ON organizations USING btree (slug);


--
-- Name: index_organizations_on_type; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_organizations_on_type ON organizations USING btree (type);


--
-- Name: index_punches_on_average_time; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_punches_on_average_time ON punches USING btree (average_time);


--
-- Name: index_read_marks_on_user_id_and_readable_type_and_readable_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_read_marks_on_user_id_and_readable_type_and_readable_id ON read_marks USING btree (user_id, readable_type, readable_id);


--
-- Name: index_schools_on_data; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_schools_on_data ON schools USING gin (data);


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
-- Name: index_schools_on_type; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_schools_on_type ON schools USING btree (type);


--
-- Name: index_sessions_on_session_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_sessions_on_session_id ON sessions USING btree (session_id);


--
-- Name: index_sessions_on_updated_at; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_sessions_on_updated_at ON sessions USING btree (updated_at);


--
-- Name: index_shares_on_parameters; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_shares_on_parameters ON shares USING gin (parameters);


--
-- Name: index_shares_on_shareable_id_and_shareable_type; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_shares_on_shareable_id_and_shareable_type ON shares USING btree (shareable_id, shareable_type);


--
-- Name: index_shares_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_shares_on_user_id ON shares USING btree (user_id);


--
-- Name: index_slugs_on_slug_and_sluggable_type_and_scope; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_slugs_on_slug_and_sluggable_type_and_scope ON slugs USING btree (slug, sluggable_type, scope);


--
-- Name: index_slugs_on_sluggable_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_slugs_on_sluggable_id ON slugs USING btree (sluggable_id);


--
-- Name: index_slugs_on_sluggable_id_and_sluggable_type; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_slugs_on_sluggable_id_and_sluggable_type ON slugs USING btree (sluggable_id, sluggable_type);


--
-- Name: index_slugs_on_sluggable_type_and_sluggable_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_slugs_on_sluggable_type_and_sluggable_id ON slugs USING btree (sluggable_type, sluggable_id);


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
-- Name: index_users_on_confirmation_token; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_users_on_confirmation_token ON users USING btree (confirmation_token);


--
-- Name: index_users_on_email; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_users_on_email ON users USING btree (email);


--
-- Name: index_users_on_fund; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_users_on_fund ON users USING gin (fund);


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
-- Name: index_users_on_reset_password_token; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_users_on_reset_password_token ON users USING btree (reset_password_token);


--
-- Name: index_users_on_role; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_users_on_role ON users USING btree (role);


--
-- Name: index_users_on_school_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_users_on_school_id ON users USING btree (school_id);


--
-- Name: index_users_on_settings; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_users_on_settings ON users USING gin (settings);


--
-- Name: index_users_on_slug; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_users_on_slug ON users USING btree (slug);


--
-- Name: index_users_on_state; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_users_on_state ON users USING btree (state);


--
-- Name: index_users_on_type; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_users_on_type ON users USING btree (type);


--
-- Name: index_versions_on_item_type_and_item_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_versions_on_item_type_and_item_id ON versions USING btree (item_type, item_id);


--
-- Name: index_votes_on_votable_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_votes_on_votable_id ON votes USING btree (votable_id);


--
-- Name: index_votes_on_votable_id_and_votable_type; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_votes_on_votable_id_and_votable_type ON votes USING btree (votable_id, votable_type);


--
-- Name: index_votes_on_voter_id_and_voter_type; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_votes_on_voter_id_and_voter_type ON votes USING btree (voter_id, voter_type);


--
-- Name: punchable_index; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX punchable_index ON punches USING btree (punchable_type, punchable_id);


--
-- Name: taggings_idx; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX taggings_idx ON taggings USING btree (tag_id, taggable_id, taggable_type, context, tagger_id, tagger_type);


--
-- Name: unique_schema_migrations; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX unique_schema_migrations ON schema_migrations USING btree (version);


--
-- Name: idea_messages_idea_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY idea_messages
    ADD CONSTRAINT idea_messages_idea_id_fk FOREIGN KEY (idea_id) REFERENCES ideas(id);


--
-- Name: mb_opt_outs_on_conversations_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY mailboxer_conversation_opt_outs
    ADD CONSTRAINT mb_opt_outs_on_conversations_id FOREIGN KEY (conversation_id) REFERENCES mailboxer_conversations(id);


--
-- Name: mentions_user_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY mentions
    ADD CONSTRAINT mentions_user_id_fk FOREIGN KEY (user_id) REFERENCES users(id);


--
-- Name: notes_user_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY notes
    ADD CONSTRAINT notes_user_id_fk FOREIGN KEY (user_id) REFERENCES users(id);


--
-- Name: notifications_on_conversation_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY mailboxer_notifications
    ADD CONSTRAINT notifications_on_conversation_id FOREIGN KEY (conversation_id) REFERENCES mailboxer_conversations(id);


--
-- Name: receipts_on_notification_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY mailboxer_receipts
    ADD CONSTRAINT receipts_on_notification_id FOREIGN KEY (notification_id) REFERENCES mailboxer_notifications(id);


--
-- Name: shares_user_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY shares
    ADD CONSTRAINT shares_user_id_fk FOREIGN KEY (user_id) REFERENCES users(id);


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user",public;

INSERT INTO schema_migrations (version) VALUES ('20140805183219');

INSERT INTO schema_migrations (version) VALUES ('20140805184102');

INSERT INTO schema_migrations (version) VALUES ('20140805184420');

INSERT INTO schema_migrations (version) VALUES ('20140812190804');

INSERT INTO schema_migrations (version) VALUES ('20140814084456');

INSERT INTO schema_migrations (version) VALUES ('20140817173659');

INSERT INTO schema_migrations (version) VALUES ('20140817173660');

INSERT INTO schema_migrations (version) VALUES ('20140817173661');

INSERT INTO schema_migrations (version) VALUES ('20140817173662');

INSERT INTO schema_migrations (version) VALUES ('20140825003938');

INSERT INTO schema_migrations (version) VALUES ('20140830232833');

INSERT INTO schema_migrations (version) VALUES ('20140928202143');

INSERT INTO schema_migrations (version) VALUES ('20141003131909');

INSERT INTO schema_migrations (version) VALUES ('20141004015347');

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

INSERT INTO schema_migrations (version) VALUES ('20141126200705');

INSERT INTO schema_migrations (version) VALUES ('20141207174436');

INSERT INTO schema_migrations (version) VALUES ('20141209231249');

INSERT INTO schema_migrations (version) VALUES ('20150122230500');

INSERT INTO schema_migrations (version) VALUES ('20150219031949');

INSERT INTO schema_migrations (version) VALUES ('20150219031950');

INSERT INTO schema_migrations (version) VALUES ('20150219031951');

INSERT INTO schema_migrations (version) VALUES ('20150221035657');

INSERT INTO schema_migrations (version) VALUES ('20150312183515');

INSERT INTO schema_migrations (version) VALUES ('20150312183534');

INSERT INTO schema_migrations (version) VALUES ('20150317170955');

INSERT INTO schema_migrations (version) VALUES ('20150317220155');

INSERT INTO schema_migrations (version) VALUES ('20150321215014');

INSERT INTO schema_migrations (version) VALUES ('20150323234103');

INSERT INTO schema_migrations (version) VALUES ('20150420113616');

INSERT INTO schema_migrations (version) VALUES ('20150421231158');

INSERT INTO schema_migrations (version) VALUES ('20150425114736');

INSERT INTO schema_migrations (version) VALUES ('20150425121536');

INSERT INTO schema_migrations (version) VALUES ('20150425124545');

INSERT INTO schema_migrations (version) VALUES ('20150425124546');

INSERT INTO schema_migrations (version) VALUES ('20150425140518');

