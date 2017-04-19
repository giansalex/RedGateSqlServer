SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [user321].[ConvertPrdo_CodANom](@dato varchar(50),@May bit,@Abr bit) --Me devuelve el nombre del periodo
returns varchar(50) AS
BEGIN 

	DECLARE @long int
	DECLARE @i int
	DECLARE @acu varchar(10)
	DECLARE @c char(1)
	DECLARE @val varchar(50)
	
	SET @long = len(@dato)
	SET @i = 1
	SET @acu = ''
	SET @c = ''
	SET @val =''
	
	WHILE (@i <= @long)
	BEGIN
		SET @c = SubString(@dato,@i,1)
		IF(@c in ('0','1','2','3','4','5','6','7','8','9'))
		BEGIN
			SET @acu = @acu + @c
			
			IF(len(@acu)=2 and @acu in ('01','02','03','04','05','06','07','08','09','10','11','12'))
			BEGIN
				SET @val = @val + User123.DameFormPrdo(@acu,@May,@Abr) + ' - '
				SET @acu = ''
			END	
		END
		SET @i=@i+1
	END
	
	SET @val = left(@val,len(@val)-2)

	Return @val
END

GO
