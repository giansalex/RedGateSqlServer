SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROC [dbo].[Ctb_ReporteFinancieroElim]

@RucE nvarchar(11),
@Ejer nvarchar(4),
@Cd_REF nvarchar(5),
@msj varchar(100) output		

AS

if not exists (Select * From ReporteFinanciero Where RucE=@RucE and Ejer=@Ejer and Cd_REF=@Cd_REF)
	Set @msj = 'No se encontro informacion para poder eliminar'
else
begin
	Delete From ReporteFinancieroDet Where RucE=@RucE and Ejer=@Ejer and Cd_REF=@Cd_REF
	Delete From ReporteFinanciero Where RucE=@RucE and Ejer=@Ejer and Cd_REF=@Cd_REF
		                   
	if @@rowcount <= 0
		Set @msj = 'No se pudo eliminar reporte financiero'
	Else
	Begin
		Declare @Sql varchar(1000)
		Set @Sql= 'Update PlanCtas Set '+@Cd_REF+'=NULL Where RucE='''+@RucE+''' and Ejer='''+@Ejer+''' and isnull('+@Cd_REF+','''')<>'''''

		Print @Sql
		Exec(@Sql)
	End
end

-- Leyenda --
-- DI : 10/09/2012 <Creacion del SP>
-- DI : 12/10/2012 <Se agrego sintaxis para limpiar todos los rubros relacionados con plan de cuenta>

GO
