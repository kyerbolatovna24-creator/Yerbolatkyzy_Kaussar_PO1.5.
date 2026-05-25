CREATE ROLE student_role;

GRANT SELECT ON film TO student_role;
GRANT SELECT ON actor TO student_role;

GRANT USAGE ON SCHEMA public TO student_role;

CREATE USER student1
WITH PASSWORD 'pass123';

GRANT student_role TO student1;

-- Verify permissions
SELECT grantee, table_name, privilege_type
FROM information_schema.role_table_grants
WHERE table_name IN ('film', 'actor');

