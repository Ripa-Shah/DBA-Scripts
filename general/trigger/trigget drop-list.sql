SELECT 
    definition   
FROM 
    sys.sql_modules  
WHERE 
    object_id = OBJECT_ID('sales.trg_members_delete'); 

SELECT 
    OBJECT_DEFINITION (
        OBJECT_ID(
            'sales.trg_members_delete'
        )
    ) AS trigger_definition;\

EXEC sp_helptext 'sales.trg_members_delete' ;
--list trigger
SELECT  
    name,
    is_instead_of_trigger
FROM 
    sys.triggers  
WHERE 
    type = 'TR';

--drop trigger
DROP TRIGGER IF EXISTS sales.trg_member_insert;