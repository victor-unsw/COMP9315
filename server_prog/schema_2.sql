-- SCHEMA_2 
-- Prac excercise 2
--
-- Author: victor choudhary
-- UNSW

CREATE OR REPLACE FUNCTION schema_2()
RETURNS setof schematuple
AS $$
DECLARE
    rec record;
    rel text:= '';
    att text:= '';
    out schematuple;

BEGIN
    for rec in 
     select cl.oid as oid,cl.relname as relation,attname as attribute_name,ty.typname as typename
        from pg_attribute at 
            JOIN pg_class cl on (at.attrelid=cl.oid) 
            JOIN pg_type ty ON (at.atttypid=ty.oid) 
            WHERE cl.relname in ('beers','frequents','sells','bars','drinkers','likes') 
                AND attnum>0 
        ORDER BY relname,attname

    LOOP
      out.table := rec.relation;
      out.attribute := rec.attribute_name ||','||rec.typename;
       --OUT := rec.oid || ',' || rec.relation || ',' || rec.attribute_name  || ',' || rec.typename;
      RETURN NEXT out;
    END LOOP;
    return;

END;
$$ LANGUAGE plpgsql;
