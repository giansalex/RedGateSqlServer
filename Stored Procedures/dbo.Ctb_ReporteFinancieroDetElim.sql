SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE PROC [dbo].[Ctb_ReporteFinancieroDetElim]

@RucE nvarchar(11),
@Ejer nvarchar(4),
@Cd_REF nvarchar(5),
@Cd_Rub nvarchar(5),

@msj varchar(100) output		

AS


if not exists (Select * From ReporteFinancieroDet Where RucE=@RucE and Ejer=@Ejer and Cd_REF=@Cd_REF and Cd_Rub=@Cd_Rub)
	Set @msj = 'No existe registro para poder eliminar'
else
begin
	
	delete from ReporteFinancieroDet
	Where
		RucE=@RucE
		and Ejer=@Ejer
		and Cd_REF=@Cd_REF
		and Cd_Rub=@Cd_Rub

	if @@rowcount <= 0
		Set @msj = 'No se pudo eliminar informacion'
	Else
	Begin
		Declare @Sql varchar(1000)
		Set @Sql= 'Update PlanCtas Set '+@Cd_REF+'=NULL Where RucE='''+@RucE+''' and Ejer='''+@Ejer+''' and '+@Cd_REF+'='''+@Cd_Rub+''''

		Print @Sql
		Exec(@Sql)
	End
end
-- Leyenda --
-- DI : 10/09/2012 <Creacion del SP>
-- DI : 12/10/2012 <Se agrego codigo para borrar datos que estan amarrados con plan de cuenta>

GO
