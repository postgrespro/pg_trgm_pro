/* contrib/pg_trgm/pg_trgm--1.2--1.3.sql */

-- complain if script is sourced in psql, rather than via ALTER EXTENSION
\echo Use "ALTER EXTENSION pg_trgm UPDATE TO '1.3'" to load this file. \quit

CREATE FUNCTION set_substring_limit(float4)
RETURNS float4
AS 'MODULE_PATHNAME'
LANGUAGE C STRICT VOLATILE;

CREATE FUNCTION show_substring_limit()
RETURNS float4
AS 'MODULE_PATHNAME'
LANGUAGE C STRICT STABLE;

CREATE FUNCTION substring_similarity(text,text)
RETURNS float4
AS 'MODULE_PATHNAME'
LANGUAGE C STRICT IMMUTABLE;

CREATE FUNCTION substring_similarity_op(text,text)
RETURNS bool
AS 'MODULE_PATHNAME'
LANGUAGE C STRICT STABLE;  -- stable because depends on trgm_substring_limit

CREATE FUNCTION substring_similarity_commutator_op(text,text)
RETURNS bool
AS 'MODULE_PATHNAME'
LANGUAGE C STRICT STABLE;  -- stable because depends on trgm_substring_limit

CREATE FUNCTION substring_similarity_dist_op(text,text)
RETURNS float4
AS 'MODULE_PATHNAME'
LANGUAGE C STRICT IMMUTABLE;

CREATE FUNCTION substring_similarity_dist_commutator_op(text,text)
RETURNS float4
AS 'MODULE_PATHNAME'
LANGUAGE C STRICT IMMUTABLE;

CREATE OPERATOR <% (
        LEFTARG = text,
        RIGHTARG = text,
		PROCEDURE = substring_similarity_op,
        COMMUTATOR = '%>',
        RESTRICT = contsel,
        JOIN = contjoinsel
);

CREATE OPERATOR %> (
        LEFTARG = text,
        RIGHTARG = text,
		PROCEDURE = substring_similarity_commutator_op,
        COMMUTATOR = '<%',
        RESTRICT = contsel,
        JOIN = contjoinsel
);

CREATE OPERATOR <<-> (
        LEFTARG = text,
        RIGHTARG = text,
		PROCEDURE = substring_similarity_dist_op,
        COMMUTATOR = '<->>'
);

CREATE OPERATOR <->> (
        LEFTARG = text,
        RIGHTARG = text,
		PROCEDURE = substring_similarity_dist_commutator_op,
        COMMUTATOR = '<<->'
);

ALTER OPERATOR FAMILY gist_trgm_ops USING gist ADD
        OPERATOR        7       %> (text, text);

-- In pre-9.5 we have not the recheck parameter in the distance function.
DO $$
BEGIN
        IF (SELECT setting::int FROM pg_settings WHERE name = 'server_version_num') >= 90500 THEN
                ALTER OPERATOR FAMILY gist_trgm_ops USING gist ADD
                        OPERATOR        8       <->> (text, text) FOR ORDER BY pg_catalog.float_ops;
        END IF;
END $$;

ALTER OPERATOR FAMILY gin_trgm_ops USING gin ADD
		OPERATOR        7       %> (text, text);;
