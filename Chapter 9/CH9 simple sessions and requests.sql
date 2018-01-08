SELECT * FROM
sys.dm_exec_sessions s 
LEFT OUTER JOIN sys.dm_exec_requests r ON r.session_id = s.session_id;
