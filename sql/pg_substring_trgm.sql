CREATE TABLE test_trgm2(t text);

\copy test_trgm2 from 'data/trgm2.data'

select t,substring_similarity('Baykal',t) as sml from test_trgm2 where 'Baykal' <% t order by sml desc, t;
select t,substring_similarity('Kabankala',t) as sml from test_trgm2 where 'Kabankala' <% t order by sml desc, t;