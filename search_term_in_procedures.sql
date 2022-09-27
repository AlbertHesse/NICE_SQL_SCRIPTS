--Albert Hesse
--23/05/2022
--This creates a query that searches for words in all procedures
--This can be used to search an term in all procedures, for instance bulk insert
--Define the searchtext
declare  @searchtext nvarchar(max)
set @searchtext = N'%bulk%insert%' --for instance we look for '%bulk insert'  or 'bulk    insert'

--create a table of all databases with id higher than 4
if OBJECT_ID('tempdb..##sadf', 'U') is not null drop table ##sadf
--drop table ##sadf
--insert the use statement
select 'use ' + name as cmd into ##sadf  from sys.databases D where D.database_id>4
declare @cmd nvarchar(max)
declare @cmd1 nvarchar(max)

--Loop all databases
while (select COUNT(*) from ##sadf)> 0
begin
	select @cmd =cmd  from ##sadf
	set @cmd1 = @cmd
	--select all procedures having the searchtem
	set @cmd = @cmd + N' ;with ropucha as (select name, object_id, OBJECT_DEFINITION(object_id) as p_text, create_date, modify_date from sys.procedures S)
	select * from ropucha
	where p_text like @searchtext '	
	select @cmd1 -- Show the use-statement so that we know in which database we are
	begin try
		exec sp_executesql @cmd, N'@searchtext nvarchar(max)', @searchtext=@searchtext
	end try
	begin catch
		print 'fuck that'
	end catch
	--Delete the part from the list, so that the list becomes smaller
	delete from ##sadf where @cmd1 = cmd
end

--Yipp yipp we have a result

