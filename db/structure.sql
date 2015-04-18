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
    owner_id integer,
    owner_type character varying,
    key character varying,
    parameters text,
    recipient_id integer,
    recipient_type character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    published boolean DEFAULT true
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
    cached_votes_total integer DEFAULT 0,
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
    comments_count integer DEFAULT 0,
    cached_votes_total integer DEFAULT 0,
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
    feedbacks_count integer DEFAULT 0,
    investments_count integer DEFAULT 0,
    followers_count integer DEFAULT 0,
    comments_count integer DEFAULT 0,
    cached_votes_total integer DEFAULT 0,
    shares_count integer DEFAULT 0,
    idea_messages_count integer DEFAULT 0,
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
    comments_count integer DEFAULT 0,
    cached_votes_total integer DEFAULT 0,
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
-- Name: notifications; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE notifications (
    id integer NOT NULL,
    reciever_id integer,
    sender_id integer,
    parameters jsonb,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: notifications_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE notifications_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: notifications_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE notifications_id_seq OWNED BY notifications.id;


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
-- Name: read_marks; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE read_marks (
    id integer NOT NULL,
    readable_id integer,
    user_id integer NOT NULL,
    readable_type character varying(20) NOT NULL,
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
    updated_at timestamp without time zone NOT NULL,
    users_count integer DEFAULT 0,
    ideas_count integer DEFAULT 0,
    followers_count integer DEFAULT 0
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
    updated_at timestamp without time zone NOT NULL,
    cached_votes_total integer DEFAULT 0
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
    school_id integer NOT NULL,
    cached_school_list character varying,
    cached_location_list character varying,
    cached_market_list character varying,
    cached_roles_list character varying,
    followers_count integer DEFAULT 0,
    followings_count integer DEFAULT 0,
    investments_count integer DEFAULT 0,
    feedbacks_count integer DEFAULT 0,
    comments_count integer DEFAULT 0,
    ideas_count integer DEFAULT 0,
    shares_count integer DEFAULT 0,
    verified boolean DEFAULT false,
    terms_accepted boolean DEFAULT false,
    state integer DEFAULT 0,
    role integer DEFAULT 0,
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
-- Name: votes; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE votes (
    id integer NOT NULL,
    votable_id integer,
    votable_type character varying,
    voter_id integer,
    voter_type character varying,
    vote_flag boolean,
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

ALTER TABLE ONLY notifications ALTER COLUMN id SET DEFAULT nextval('notifications_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY organizations ALTER COLUMN id SET DEFAULT nextval('organizations_id_seq'::regclass);


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
-- Name: notifications_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY notifications
    ADD CONSTRAINT notifications_pkey PRIMARY KEY (id);


--
-- Name: organizations_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY organizations
    ADD CONSTRAINT organizations_pkey PRIMARY KEY (id);


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
-- Name: votes_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY votes
    ADD CONSTRAINT votes_pkey PRIMARY KEY (id);


--
-- Name: index_activities_on_owner_id_and_owner_type; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_activities_on_owner_id_and_owner_type ON activities USING btree (owner_id, owner_type);


--
-- Name: index_activities_on_published; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_activities_on_published ON activities USING btree (published);


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
-- Name: index_comments_on_cached_votes_total; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_comments_on_cached_votes_total ON comments USING btree (cached_votes_total);


--
-- Name: index_comments_on_commentable_id_and_commentable_type; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_comments_on_commentable_id_and_commentable_type ON comments USING btree (commentable_id, commentable_type);


--
-- Name: index_comments_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_comments_on_user_id ON comments USING btree (user_id);


--
-- Name: index_feedbacks_on_cached_votes_total; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_feedbacks_on_cached_votes_total ON feedbacks USING btree (cached_votes_total);


--
-- Name: index_feedbacks_on_comments_count; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_feedbacks_on_comments_count ON feedbacks USING btree (comments_count);


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
-- Name: index_idea_messages_on_idea_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_idea_messages_on_idea_id ON idea_messages USING btree (idea_id);


--
-- Name: index_idea_messages_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_idea_messages_on_user_id ON idea_messages USING btree (user_id);


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
-- Name: index_investments_on_cached_votes_total; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_investments_on_cached_votes_total ON investments USING btree (cached_votes_total);


--
-- Name: index_investments_on_comments_count; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_investments_on_comments_count ON investments USING btree (comments_count);


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
-- Name: index_notifications_on_reciever_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_notifications_on_reciever_id ON notifications USING btree (reciever_id);


--
-- Name: index_notifications_on_sender_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_notifications_on_sender_id ON notifications USING btree (sender_id);


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
-- Name: index_partisan_followables; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_partisan_followables ON follows USING btree (followable_id, followable_type);


--
-- Name: index_partisan_followers; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_partisan_followers ON follows USING btree (follower_id, follower_type);


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
-- Name: index_slugs_on_sluggable_type_and_sluggable_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_slugs_on_sluggable_type_and_sluggable_id ON slugs USING btree (sluggable_type, sluggable_id);


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
-- Name: index_users_on_followers_count; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_users_on_followers_count ON users USING btree (followers_count);


--
-- Name: index_users_on_followings_count; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_users_on_followings_count ON users USING btree (followings_count);


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
-- Name: index_votes_on_votable_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_votes_on_votable_id ON votes USING btree (votable_id);


--
-- Name: index_votes_on_votable_id_and_votable_type_and_vote_scope; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_votes_on_votable_id_and_votable_type_and_vote_scope ON votes USING btree (votable_id, votable_type, vote_scope);


--
-- Name: index_votes_on_voter_id_and_voter_type_and_vote_scope; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_votes_on_voter_id_and_voter_type_and_vote_scope ON votes USING btree (voter_id, voter_type, vote_scope);


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
-- Name: idea_messages_user_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY idea_messages
    ADD CONSTRAINT idea_messages_user_id_fk FOREIGN KEY (user_id) REFERENCES users(id);


--
-- Name: mb_opt_outs_on_conversations_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY mailboxer_conversation_opt_outs
    ADD CONSTRAINT mb_opt_outs_on_conversations_id FOREIGN KEY (conversation_id) REFERENCES mailboxer_conversations(id);


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

INSERT INTO schema_migrations (version) VALUES ('20150119202844');

INSERT INTO schema_migrations (version) VALUES ('20150122230500');

INSERT INTO schema_migrations (version) VALUES ('20150131181527');

INSERT INTO schema_migrations (version) VALUES ('20150216233226');

INSERT INTO schema_migrations (version) VALUES ('20150219031949');

INSERT INTO schema_migrations (version) VALUES ('20150219031950');

INSERT INTO schema_migrations (version) VALUES ('20150219031951');

INSERT INTO schema_migrations (version) VALUES ('20150221035657');

INSERT INTO schema_migrations (version) VALUES ('20150308175637');

INSERT INTO schema_migrations (version) VALUES ('20150312183515');

INSERT INTO schema_migrations (version) VALUES ('20150312183534');

INSERT INTO schema_migrations (version) VALUES ('20150317170955');

INSERT INTO schema_migrations (version) VALUES ('20150317220155');

INSERT INTO schema_migrations (version) VALUES ('20150317231458');

INSERT INTO schema_migrations (version) VALUES ('20150321215014');

INSERT INTO schema_migrations (version) VALUES ('20150321230318');

INSERT INTO schema_migrations (version) VALUES ('20150323234103');

