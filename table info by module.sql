SELECT te_tables.table_name,   
         te_tables.super_module_id,   
         te_tables.module_id,   
         te_tables.has_default_data,   
         sysobjects.type  
    FROM te_tables,   
         sysobjects  
   WHERE ( te_tables.table_name = sysobjects.name )   
ORDER BY te_tables.super_module_id ASC,   
         te_tables.module_id ASC,   
         te_tables.table_name ASC   
