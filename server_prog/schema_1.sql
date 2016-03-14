
CREATE FUNCTION schema_1() 
RETURNS setof text
AS $$

DECLARE
  rec record;
  rel text := '';
  att text := '';
  out text := '';

BEGIN
  for rec in 
    select t.relname, a.attname
    from pg_class t
         join pg_attribute a on (a.attrelid=t.oid)
         join pg_namespace n on (t.relnamespace=n.oid)
    WHERE t.relkind='r'
        AND n.nspname = 'public'
        AND a.attnum > 0
    ORDER BY t.relname,a.attnum

    -- the following loop also checks if
    -- the relation gets changes in between 
    -- so that the result is concrete.
    LOOP
      if(rec.relname <> rel) THEN
        if(rel <> '') THEN
          out := rel || '(' || att || ')';
          return next out;
        end if;
        rel := rec.relname;
        att := '';
      end if;
      if(att<> '') THEN
        att := att || ', ';
      end if;
      att := att || rec.attname;
  end loop;

  -- deal with last table

    if(rel <> '') THEN
      out := rel || '(' || att || ')';
      return next out;
    end if;

END;
$$ LANGUAGE plpgsql;
