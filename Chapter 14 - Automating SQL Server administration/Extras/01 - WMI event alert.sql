--##############################################################################
--
-- SAMPLE SCRIPTS TO ACCOMPANY "SQL SERVER 2017 ADMINISTRATION INSIDE OUT"
--
-- © 2018 MICROSOFT PRESS
--
--##############################################################################
--
-- CHAPTER 14: AUTOMATING SQL SERVER ADMINISTRATION
-- EXTRA T-SQL SAMPLE 1
--
USE [msdb]
GO
--TODO complete all TODO's in below code
/*
--Must execute this statement to allow for tokenization of WMI commands in TSQL job step
EXEC msdb.dbo.sp_set_sqlagent_properties @email_save_in_sent_folder=1, 
		@alert_replace_runtime_tokens=1
GO
*/

/*
--create simple table to receive WMI alert data
create table dbo.WMI_Alert_data
(	id int IDENTITY(1,1) not null PRIMARY KEY
,	DateCollected datetimeoffset not null CONSTRAINT DF_WMI_Alert_data_DateCollected DEFAULT (sysdatetimeoffset())
,	WMIText nvarchar (4000) null
)
GO

select * from dbo.WMI_Alert_data order by DateCollected desc
*/
USE [msdb]
GO

EXEC msdb.dbo.sp_delete_job @job_name = 'Capture WMI Event Alert data in table', @delete_unused_schedule=1

EXEC msdb.dbo.sp_delete_alert @name=N'WMI - Capture Database Creation'
GO

DECLARE @jobId BINARY(16)

--Create job to be called by WMI Event alert
EXEC msdb.dbo.sp_add_job @job_name=N'Capture WMI Event Alert data in table', 
		@enabled=1, 
		@notify_level_eventlog=0, 
		@notify_level_email=0, 
		@notify_level_netsend=0, 
		@notify_level_page=0, 
		@delete_level=0, 
		@description=N'capture WMI data', 
		@category_name=N'[Uncategorized (Local)]', 
		@owner_login_name=N'sa', @job_id = @jobId OUTPUT --TODO: subsitute 'sa' for a service account here

EXEC msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'collect WSQL data', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'--Accept WMI Data
		INSERT INTO msdb.dbo.WMI_Alert_data (WMIText) VALUES  (''$(ESCAPE_SQUOTE(WMI(TSQLCommand)))'')', 
		@database_name=N'msdb', 
		@flags=0
EXEC msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'

--Create WMI Event Alert
EXEC msdb.dbo.sp_add_alert @name=N'WMI - Capture Database Creation', 
		@message_id=0, 
		@severity=0, 
		@enabled=1, 
		@job_id=@jobId, 
		@delay_between_responses=0, 
		@include_event_description_in=0, 
		@category_name=N'[Uncategorized]', 
		@wmi_namespace=N'\\.\root\Microsoft\SqlServer\ServerEvents\SQL2017', --TODO: Substitute SQL2017 for your SQL Server instance name here, or MSSQLSERVER if a default instance
		@wmi_query=N'SELECT * FROM CREATE_DATABASE'; --Reference: https://docs.microsoft.com/en-us/sql/relational-databases/wmi-provider-server-events/wmi-provider-for-server-events-classes-and-properties

EXEC msdb.dbo.sp_add_notification 
	@alert_name=N'WMI - Capture Database Creation', 
	@operator_name=N'OperatorName',  --TODO: Substite your operator name here
	@notification_method = 1
GO
