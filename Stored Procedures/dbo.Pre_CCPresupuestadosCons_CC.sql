SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROC [dbo].[Pre_CCPresupuestadosCons_CC]

@RucE nvarchar(11),
@Ejer nvarchar(4),
@Cd_CC varchar(8),
@Cd_SC varchar(8),
@Cd_SS varchar(8),

@msj varchar(100) output


AS

Declare @Tipo varchar(2)
Set @Tipo = ''

If(isnull(@Cd_SC,'') <> '') Set @Tipo = 'ss'
Else If(isnull(@Cd_CC,'') <> '') Set @Tipo = 'sc'
Else Set @Tipo = 'cc'

print @Tipo

if (@Tipo = 'cc')
Begin
	Print 'cc'
	Select p.Cd_CC, c.Cd_CC, c.NCorto, c.Descrip from Presupuesto p Inner Join CCostos c On c.RucE=p.RucE and c.Cd_CC=p.Cd_CC
	Where p.RucE=@RucE and p.Ejer=@Ejer Group by p.Cd_CC, c.Cd_CC, c.NCorto, c.Descrip Having isnull(p.Cd_CC,'') <> ''
End
Else if (@Tipo = 'sc')
Begin
	Print 'sc'
	Select p.Cd_SC, c.Cd_SC, c.NCorto, c.Descrip from Presupuesto p Inner Join CCSub c On c.RucE=p.RucE and c.Cd_CC=p.Cd_CC and c.Cd_SC=p.Cd_SC
	Where p.RucE=@RucE and p.Ejer=@Ejer and p.Cd_CC=@Cd_CC Group by p.Cd_SC, c.Cd_SC, c.NCorto, c.Descrip Having isnull(p.Cd_SC,'') <> ''
End
Else if (@Tipo = 'ss')
Begin
	Print 'ss'
	Select p.Cd_SS, c.Cd_SS, c.NCorto, c.Descrip from Presupuesto p Inner Join CCSubSub c On c.RucE=p.RucE and c.Cd_CC=p.Cd_CC and c.Cd_SC=p.Cd_SC and c.Cd_SS=p.Cd_SS
	Where p.RucE=@RucE and p.Ejer=@Ejer and p.Cd_CC=@Cd_CC and p.Cd_SC=@Cd_SC Group by p.Cd_SS, c.Cd_SS, c.NCorto, c.Descrip Having isnull(p.Cd_SS,'') <> ''
End

-- Leyenda --
-- Di : 30/12/2010 <Creacion del procedimiento almacenado>
GO
