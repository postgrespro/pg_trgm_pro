CREATE TABLE test_trgm2(t text COLLATE "C");

\copy test_trgm2 from 'data/trgm2.data'

select t,substring_similarity('Baykal',t) as sml from test_trgm2 where 'Baykal' <% t order by sml desc, t;
select t,substring_similarity('Kabankala',t) as sml from test_trgm2 where 'Kabankala' <% t order by sml desc, t;
select t,substring_similarity('Baykal',t) as sml from test_trgm2 where t %> 'Baykal' order by sml desc, t;
select t,substring_similarity('Kabankala',t) as sml from test_trgm2 where t %> 'Kabankala' order by sml desc, t;
select t <->> 'Kabankala', t from test_trgm2 order by t <->> 'Kabankala' limit 7;

create index trgm_idx2 on test_trgm2 using gist (t gist_trgm_ops);
set enable_seqscan=off;

select t,substring_similarity('Baykal',t) as sml from test_trgm2 where 'Baykal' <% t order by sml desc, t;
select t,substring_similarity('Kabankala',t) as sml from test_trgm2 where 'Kabankala' <% t order by sml desc, t;
select t,substring_similarity('Baykal',t) as sml from test_trgm2 where t %> 'Baykal' order by sml desc, t;
select t,substring_similarity('Kabankala',t) as sml from test_trgm2 where t %> 'Kabankala' order by sml desc, t;

select t <->> 'Kabankala', t from test_trgm2 order by t <->> 'Kabankala' limit 7;

drop index trgm_idx2;
create index trgm_idx2 on test_trgm2 using gin (t gin_trgm_ops);
set enable_seqscan=off;

select t,substring_similarity('Baykal',t) as sml from test_trgm2 where 'Baykal' <% t order by sml desc, t;
select t,substring_similarity('Kabankala',t) as sml from test_trgm2 where 'Kabankala' <% t order by sml desc, t;
select t,substring_similarity('Baykal',t) as sml from test_trgm2 where t %> 'Baykal' order by sml desc, t;
select t,substring_similarity('Kabankala',t) as sml from test_trgm2 where t %> 'Kabankala' order by sml desc, t;

select set_substring_limit(0.5);
select t,substring_similarity('Baykal',t) as sml from test_trgm2 where 'Baykal' <% t order by sml desc, t;
select t,substring_similarity('Kabankala',t) as sml from test_trgm2 where 'Kabankala' <% t order by sml desc, t;
select t,substring_similarity('Baykal',t) as sml from test_trgm2 where t %> 'Baykal' order by sml desc, t;
select t,substring_similarity('Kabankala',t) as sml from test_trgm2 where t %> 'Kabankala' order by sml desc, t;

select set_substring_limit(0.3);
select t,substring_similarity('Baykal',t) as sml from test_trgm2 where 'Baykal' <% t order by sml desc, t;
select t,substring_similarity('Kabankala',t) as sml from test_trgm2 where 'Kabankala' <% t order by sml desc, t;
select t,substring_similarity('Baykal',t) as sml from test_trgm2 where t %> 'Baykal' order by sml desc, t;
select t,substring_similarity('Kabankala',t) as sml from test_trgm2 where t %> 'Kabankala' order by sml desc, t;
