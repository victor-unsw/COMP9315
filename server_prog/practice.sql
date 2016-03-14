CREATE FUNCTION get_beers() 
RETURNS SETOF beers
AS $$
DECLARE
    rw beers%ROWTYPE;
BEGIN
  FOR rw IN select * from beers
    LOOP
      RETURN NEXT rw;
  END LOOP;
  RETURN;
END;
$$ LANGUAGE plpgsql;
