SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROC [dbo].[Pre_CCPresupFCConsUn]

@RucE nvarchar(11),
@Ejer nvarchar(4),
@Cd_CC varchar(8),
@Cd_SC varchar(8),
@Cd_SS varchar(8),

@msj varchar(100) output

AS

Begin
	Declare @TipoCons varchar(1000)
	Set @TipoCons = ''
	If(isnull(@Cd_SS,'') <> '') Set @TipoCons = ' and p.Cd_CC='''+@Cd_CC+''' and p.Cd_SC='''+@Cd_SC+''' and p.Cd_SS='''+@Cd_SS+''''
	Else If(isnull(@Cd_SC,'') <> '') Set @TipoCons = ' and p.Cd_CC='''+@Cd_CC+''' and p.Cd_SC='''+@Cd_SC+''''
	Else If(isnull(@Cd_CC,'') <> '') Set @TipoCons = ' and p.Cd_CC='''+@Cd_CC+''''

	Declare @SQL nvarchar(4000)

	Set @SQL = ' Select p.*,c.NomCta from PresupFC p 
		     Inner join PlanCtas c On c.RucE=p.RucE and c.Ejer=p.Ejer and c.NroCta=p.NroCta
		     Where p.RucE='''+@RucE+''' and p.Ejer='''+@Ejer+'''
		     '+@TipoCons+'
		   '
	Print @SQL
	Exec (@SQL)
End

-- Leyenda --
-- Di: 25/01/2011 <Creacion del procedimiento almacenado>



GO
