SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE proc [dbo].[Ctb_PlanCtasMdf_x_Colum]
@RucE nvarchar(11),
@Ejer varchar(4),
@NroCta nvarchar(10),
@Colum nvarchar(20),
@Valor bit,
@msj varchar(100) output

as

/*
Declare @RucE nvarchar(11)
Declare @NroCta nvarchar(10)
Declare @Colum nvarchar(10)
Declare @Valor nvarchar(20)

set @RucE='11111111111'
set @NroCta='10'
set @Colum='IB_Au'
set @Valor='0'
*/

Declare @nivel int
Set @nivel = (len(@NroCta)/2)

Declare @SQL nvarchar(4000)

if(@nivel = 1)
begin
	Set @SQL = 'Update PlanCtas Set '+@Colum+'='''+Convert(nvarchar,@Valor)+''' Where RucE='''+@RucE+''' and Ejer='''+@Ejer+''' and left(NroCta,2)='''+@NroCta+''''
	--print @SQL
	exec (@SQL)
end
else if(@nivel = 2)
begin
	Set @SQL = 'Update PlanCtas Set '+@Colum+'='''+Convert(nvarchar,@Valor)+''' Where RucE='''+@RucE+''' and Ejer='''+@Ejer+''' and left(NroCta,4)='''+@NroCta+''''
	exec (@SQL)
end
else if(@nivel = 3)
begin
	Set @SQL = 'Update PlanCtas Set '+@Colum+'='''+Convert(nvarchar,@Valor)+''' Where RucE='''+@RucE+''' and Ejer='''+@Ejer+''' and left(NroCta,6)='''+@NroCta+''''
	exec (@SQL)
end
else
begin	
	Set @SQL = 'Update PlanCtas Set '+@Colum+'='''+Convert(nvarchar,@Valor)+''' Where RucE='''+@RucE+''' and NroCta='''+@NroCta+''''
	exec (@SQL)
end

----------------------PRUEBA------------------------
--exec 

------CODIGO DE MODIFICACION--------
--CM=RE01

----------------------LEYENDA----------------------

-- DI : 30/11/09 --> CREACION : Creacion del procedimiento almacenado
-- DI : 01/11/09 --> MODIFICACION : Se debe alterar las cuentas de niveles inferiores a la del nivel ingresado
-- JJ : 01/11/09 --> MODIFICACION : Se Cambio Tamaño de Colum de nvarchar 10 a nvarchar 20
--FL: 17/09/2010 <se agrego ejercicio>
--exec Ctb_PlanCtasMdf_x_Colum '11111111111', '2011', '01', 'IB_Aux', false, null
GO
