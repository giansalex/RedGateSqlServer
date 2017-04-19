SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
--SELECT COLUMN_NAME, DATA_TYPE, CHARACTER_MAXIMUM_LENGTH, IS_NULLABLE FROM information_schema.columns WHERE table_name = 'inventario'
CREATE PROCEDURE [user321].[Inv_Inventario_EliminaSeriales]
@RucE nvarchar(11),
@Cd_Inv char(12),
@msj varchar(100) output
as
if exists(select * from serialmov where RucE = @RucE and Cd_Inv = @Cd_Inv)
begin
	
	declare @temporal table (codSerial varchar(110))
	insert into @temporal select * from(
		select Cd_Prod + convert(nchar, Serial) as codSerial from serialmov where RucE = @RucE and Cd_Prod+convert(nchar, Serial) in (
			select Cd_Prod + convert(nchar, Serial) from serialmov where RucE = @RucE and Cd_Inv = @Cd_Inv)		
		group by Cd_Prod, Serial
		having count(*) = 1
	) as datos
	delete serialmov where RucE = @RucE and Cd_Inv = @Cd_Inv
	delete serial where RucE = @RucE and Cd_Prod + convert(nchar, Serial) in (select * from @temporal)
end
GO
