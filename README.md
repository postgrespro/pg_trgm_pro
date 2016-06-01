# pg_trgm – text similarity measurement and index searching based on trigrams

## Introduction

The pg_trgm module provides functions and operators for determining the
similarity of alphanumeric text based on trigram matching, as well as index
operator classes that support fast searching for similar strings.

A trigram is a group of three consecutive characters taken from a string. We can
measure the similarity of two strings by counting the number of trigrams they
share. This simple idea turns out to be very effective for measuring the
similarity of words in many natural languages.

The original module is located in
[GitHub](https://github.com/postgres/postgres/tree/master/contrib/pg_trgm). This
module provides a new function and new operators which provide fuzzy searching
for word in a text.

**Note**. Functions of this module and functions of pg_trgm module, which
included in the PostgreSQL 9.6, are differ. Functions of this module have other
names and the module does not provide GUC parameters.

## License

This module available from [GitHub](https://github.com/postgrespro/pg_trgm_pro)
under the same license as [PostgreSQL](http://www.postgresql.org/about/licence/)
and supports PostgreSQL 9.4+.

## Installation

Before build and install pg_trgm you should ensure following:

* PostgreSQL version is 9.4 or higher.

Typical installation procedure may look like this:

    $ git clone https://github.com/postgrespro/pg_trgm_pro
    $ cd pg_trgm_pro
    $ make USE_PGXS=1
    $ sudo make USE_PGXS=1 install
    $ make USE_PGXS=1 installcheck
    $ psql DB -c "CREATE EXTENSION pg_trgm;"

## New functions and operators

The pg_trgm module provides the new functions.

|            Function              | Returns |                      Description
| -------------------------------- | ------- | ---------------------------------------------------
| substring_similarity(text, text) | real    | Returns a number that indicates how similar the first string to the most similar word of the second string. The function searches in the second string a most similar word not a most similar substring. The range of the result is zero (indicating that the two strings are completely dissimilar) to one (indicating that the first string is identical to one of the word of the second string).
| show_substring_limit()           | real    | Returns the current substring similarity threshold that is used by the **<%** operator.
| set_substring_limit(real)        | real    | Sets the current substring similarity threshold that is used by the **<%** operator. The threshold must be between 0 and 1 (default is 0.6).

The module provides new operators.

|    Operator    | Returns |                      Description
| -------------- | ------- | ---------------------------------------------------
| text <% text   | boolean | Returns **true** if its arguments have a substring similarity that is greater than the current substring similarity threshold set by **set_substring_limit()**.

GiST and GIN indexes support the operator **<%**.

## Examples

Let us assume we have an **test_trgm** table:

```sql
CREATE TABLE test_trgm (t text);
```

You can create GiST index:

```sql
CREATE INDEX trgm_idx ON test_trgm USING GIST (t gist_trgm_ops);
```

or GIN index:

```sql
CREATE INDEX trgm_idx ON test_trgm USING GIN (t gin_trgm_ops);
```

Now you can use an index on the **t** column for substring similarity. For example:

```sql
SELECT t, substring_similarity('word', t) AS sml
  FROM test_trgm
  WHERE 'word' <% t
  ORDER BY sml DESC, t;
```

This will return all values in the text column that have a word which
sufficiently similar to `word`, sorted from best match to worst. The index will be used to make this a fast operation even over very large data sets.

## Authors

Oleg Bartunov <oleg@sai.msu.su>

Teodor Sigaev <teodor@sigaev.ru>
