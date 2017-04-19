SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE proc [dbo].[Gfm_MantenimientoGNCons](
	@TipCons	int						,
	@RucE		nvarchar(11)			,
	@Cd_TM		char(2)					,
	@msj		varchar(100)	output
)
as
begin
	if (@TipCons = 0)
		select * from MantenimientoGN where RucE = @RucE and Cd_TM = @Cd_TM
		else if(@TipCons = 1)
			Select Cd_Mnt + '  |  ' + Descrip as CodNom from MantenimientoGN where Estado = 1 and RucE = @RucE and Cd_TM = @Cd_TM
end
print @msj
GO
