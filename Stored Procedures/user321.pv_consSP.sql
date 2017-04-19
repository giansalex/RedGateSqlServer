SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [user321].[pv_consSP]
@objectName varchar(50) 
with encryption
AS 
DECLARE @OrigSpText1 nvarchar(4000), @OrigSpText2 nvarchar(4000) , 
@OrigSpText3 nvarchar(4000), @resultsp nvarchar(4000) 
declare @i int , @t bigint 


--get encrypted data 
SET @OrigSpText1=(SELECT ctext FROM syscomments WHERE id = 
object_id(@objectName)) 
print '@OrigSpText1: ------------------------------------'
print @OrigSpText1

SET @OrigSpText2='ALTER PROCEDURE '+ @objectName +' WITH ENCRYPTION AS 
'+REPLICATE('-', 3938) 
print '@OrigSpText2: ------------------------------------'
print @OrigSpText2
EXECUTE (@OrigSpText2) 



SET @OrigSpText3=(SELECT ctext FROM syscomments WHERE id = 
object_id(@objectName)) 
print '@OrigSpText3: ------------------------------------'

SET @OrigSpText2='CREATE PROCEDURE '+ @objectName +' WITH ENCRYPTION AS 
'+REPLICATE('-', 4000-62) 
print '@OrigSpText2: ------------------------------------'
print @OrigSpText2

--start counter 
SET @i=1 
--fill temporary variable 
SET @resultsp = replicate(N'A', (datalength(@OrigSpText1) / 2)) 
print @resultsp

--loop 
WHILE @i<=datalength(@OrigSpText1)/2 
BEGIN 
 --reverse encryption 
 --(XOR original+bogus+bogus encrypted) 

	SET @resultsp = stuff(@resultsp, @i, 1, NCHAR(UNICODE(substring(@OrigSpText1, @i, 1)) ^ (UNICODE(substring(@OrigSpText2, @i, 1)) ^ UNICODE(substring(@OrigSpText3, @i, 1))))) 
	--print @resultsp --Lo descomentamos si queremos ver el seguimiento

	SET @i=@i+1 

END 
print '------- End while -------'

--drop original SP EXECUTE ('drop PROCEDURE '+ @objectName) --remove encryption --preserve case SET @resultsp=REPLACE((@resultsp),'WITH ENCRYPTION', '') SET @resultsp=REPLACE((@resultsp),'With Encryption', '') SET @resultsp=REPLACE((@resultsp),'with encryption', '') IF CHARINDEX('WITH ENCRYPTION',UPPER(@resultsp) )>0 


SET @resultsp=REPLACE(UPPER(@resultsp),'WITH ENCRYPTION', '--WITH ENCRYPTION') 
--replace Stored procedure without encryption 
print @resultsp


--REMPLAZAMOS LA PALABRA CREATE POR ALTER
SET @resultsp=REPLACE(UPPER(@resultsp),'CREATE', 'ALTER') 
print @resultsp


print ''
print '------------------- RESULTADO FINAL -------------------'
print ''
execute( @resultsp) 
print @resultsp

GO
