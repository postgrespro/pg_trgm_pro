CREATE TABLE test_trgm2(t text COLLATE "C");

\copy test_trgm2 from 'data/trgm2.data'

select t,substring_similarity('Baykal',t) as sml from test_trgm2 where 'Baykal' <% t order by sml desc, t;
select t,substring_similarity('Kabankala',t) as sml from test_trgm2 where 'Kabankala' <% t order by sml desc, t;
select t,substring_similarity('Baykal',t) as sml from test_trgm2 where t %> 'Baykal' order by sml desc, t;
select t,substring_similarity('Kabankala',t) as sml from test_trgm2 where t %> 'Kabankala' order by sml desc, t;

create index trgm_idx2 on test_trgm2 using gist (t gist_trgm_ops);
set enable_seqscan=off;

select t,substring_similarity('Baykal',t) as sml from test_trgm2 where 'Baykal' <% t order by sml desc, t;
select t,substring_similarity('Kabankala',t) as sml from test_trgm2 where 'Kabankala' <% t order by sml desc, t;
select t,substring_similarity('Baykal',t) as sml from test_trgm2 where t %> 'Baykal' order by sml desc, t;
select t,substring_similarity('Kabankala',t) as sml from test_trgm2 where t %> 'Kabankala' order by sml desc, t;

drop index trgm_idx2;
create index trgm_idx2 on test_trgm2 using gin (t gin_trgm_ops);
set enable_seqscan=off;

select t,substring_similarity('Baykal',t) as sml from test_trgm2 where 'Baykal' <% t order by sml desc, t;
select t,substring_similarity('Kabankala',t) as sml from test_trgm2 where 'Kabankala' <% t order by sml desc, t;
select t,substring_similarity('Baykal',t) as sml from test_trgm2 where t %> 'Baykal' order by sml desc, t;
select t,substring_similarity('Kabankala',t) as sml from test_trgm2 where t %> 'Kabankala' order by sml desc, t;

set "pg_trgm.substring_limit" to 0.5;
select t,substring_similarity('Baykal',t) as sml from test_trgm2 where 'Baykal' <% t order by sml desc, t;
select t,substring_similarity('Kabankala',t) as sml from test_trgm2 where 'Kabankala' <% t order by sml desc, t;
select t,substring_similarity('Baykal',t) as sml from test_trgm2 where t %> 'Baykal' order by sml desc, t;
select t,substring_similarity('Kabankala',t) as sml from test_trgm2 where t %> 'Kabankala' order by sml desc, t;

set "pg_trgm.substring_limit" to 0.3;
select t,substring_similarity('Baykal',t) as sml from test_trgm2 where 'Baykal' <% t order by sml desc, t;
select t,substring_similarity('Kabankala',t) as sml from test_trgm2 where 'Kabankala' <% t order by sml desc, t;
select t,substring_similarity('Baykal',t) as sml from test_trgm2 where t %> 'Baykal' order by sml desc, t;
select t,substring_similarity('Kabankala',t) as sml from test_trgm2 where t %> 'Kabankala' order by sml desc, t;