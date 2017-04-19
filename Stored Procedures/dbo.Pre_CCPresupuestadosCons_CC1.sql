SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
--[Pre_CCPresupuestadosCons_CC1] '11111111111','2011',null,null,null,null
--[Pre_CCPresupuestadosCons_CC1] '11111111111','2011','''c001'',''CONSTRUC''','''N01'',''CHICLAYO'',''LIMA''',null,null
CREATE PROC [dbo].[Pre_CCPresupuestadosCons_CC1]

@RucE nvarchar(11),
@Ejer nvarchar(4),
@Cd_CC varchar(8000),
@Cd_SC varchar(8000),
@Cd_SS varchar(8000),

@msj varchar(100) output


AS
declare @Consulta varchar(8000)
declare @Consulta1 varchar(8000)
Declare @Tipo varchar(2)
Set @Tipo = ''

If(isnull(@Cd_SC,'') <> '') Set @Tipo = 'ss'
Else If(isnull(@Cd_CC,'') <> '') Set @Tipo = 'sc'
Else Set @Tipo = 'cc'

--print @Tipo

if (@Tipo = 'cc')
Begin
	Print 'cc'
	set @Consulta='
	Select p.Cd_CC, c.Cd_CC, c.NCorto, c.Descrip from Presupuesto p Inner Join CCostos c On c.RucE=p.RucE and c.Cd_CC=p.Cd_CC
	Where p.RucE='''+Convert(varchar,@RucE)+''' and p.Ejer='''+Convert(Varchar,@Ejer)+''' Group by p.Cd_CC, c.Cd_CC, c.NCorto, c.Descrip Having isnull(p.Cd_CC,'''') <> ''''
	'
Exec (@Consulta)
End
Else if (@Tipo = 'sc')
Begin
	Print 'sc'
	set @Consulta='
	Select p.Cd_CC, c.Cd_CC,p.Cd_SC, c.Cd_SC, c.NCorto, c.Descrip from Presupuesto p Inner Join CCSub c On c.RucE=p.RucE and c.Cd_CC=p.Cd_CC and c.Cd_SC=p.Cd_SC
	Where p.RucE='''+Convert(Varchar,@RucE)+''' and p.Ejer='''+Convert(Varchar,@Ejer)+''' and p.Cd_CC in ('
	print @Consulta+@Cd_CC+')Group by p.Cd_CC, c.Cd_CC,p.Cd_SC, c.Cd_SC, c.NCorto, c.Descrip Having isnull(p.Cd_SC,'''') <> '''' '
	exec (@Consulta+@Cd_CC+')Group by p.Cd_CC, c.Cd_CC,p.Cd_SC, c.Cd_SC, c.NCorto, c.Descrip Having isnull(p.Cd_SC,'''') <> '''' ')
End
Else if (@Tipo = 'ss')
Begin
	--Print 'ss'
	set @Consulta='
	select * from(
		Select	p.Cd_CC, c.Cd_CC as Cd_CC1,p.Cd_SC, c.Cd_SC as Cd_SC1,p.Cd_SS, c.Cd_SS as Cd_SS1, c.NCorto, c.Descrip from Presupuesto p Inner Join CCSubSub c 
				On c.RucE=p.RucE and c.Cd_CC=p.Cd_CC and c.Cd_SC=p.Cd_SC and c.Cd_SS=p.Cd_SS
		Where	p.RucE='''+Convert(varchar,@RucE)+''' and p.Ejer='''+Convert(varchar,@Ejer)+''' and p.Cd_CC in ('
	set @Consulta1=')
		Group by p.Cd_CC, c.Cd_CC,p.Cd_SC, c.Cd_SC, p.Cd_SS, c.Cd_SS, c.NCorto, c.Descrip 
		Having isnull(p.Cd_SS,'''') <> ''''
	) as a where a.Cd_SC1 in ('
		print @Consulta+@Cd_CC+@Consulta1+@Cd_SC+')'
		exec (@Consulta+@Cd_CC+@Consulta1+@Cd_SC+')')

End

-- Leyenda --
-- Di : 30/12/2010 <Creacion del procedimiento almacenado>
GO
