/* contrib/pg_trgm/pg_trgm--1.1--1.2.sql */

-- complain if script is sourced in psql, rather than via ALTER EXTENSION
\echo Use "ALTER EXTENSION pg_trgm UPDATE TO '1.2'" to load this file. \quit

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

CREATE FUNCTION gin_trgm_triconsistent(internal, int2, text, int4, internal, internal, internal)
RETURNS "char"
AS 'MODULE_PATHNAME'
LANGUAGE C IMMUTABLE STRICT;

ALTER OPERATOR FAMILY gist_trgm_ops USING gist ADD
        OPERATOR        7       %> (text, text);

ALTER OPERATOR FAMILY gin_trgm_ops USING gin ADD
        OPERATOR        7       %> (text, text),
        FUNCTION        6      (text, text)   gin_trgm_triconsistent (internal, int2, text, int4, internal, internal, internal);