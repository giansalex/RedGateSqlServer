SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/*
declare @msj varchar(100)
exec Gfm_VerificaImpresos '11111111111',0,'VT00001061', @msj out
print @msj
*/
CREATE procedure [dbo].[Gfm_VerificaImpresos]
@RucE nvarchar(11),
@VentanaCons int,
@Cod varchar(20),
@msj varchar(100) output
as

--set @RucE='11111111111'
--set @VentanaCons=0
--set @Cod='VT00000464'
--set @msj=''

--0 Ventas
--1 Ord Pedido
--2 SolicitudCom
--3 OrdCompra
--4 GuiaRemision


--Internos
declare @consulta nvarchar(4000)
declare @Tabla Varchar(20)
declare @Campo Varchar(20)
declare @Campo1 varchar(50)
	if(@VentanaCons=0) 
	Begin
		set @Tabla='Venta'
		set @Campo='Cd_Vta'
		set @Campo1='Cd_TD+'' - ''+NroSre+'' - ''+NroDoc '
	End
	else if(@VentanaCons=1) 
	Begin
		set @Tabla='OrdPedido'
		set @Campo='Cd_OP'
		set @Campo1='NroOP '
	End
	else if(@VentanaCons=2) 
	Begin
		set @Tabla='SolicitudCom'
		set @Campo='Cd_SCo'
		set @Campo1='NroSC '
	End
	else if(@VentanaCons=3) 
	Begin
		set @Tabla='OrdCompra'
		set @Campo='Cd_OC'
		set @Campo1='NroOC '
	End
	else if(@VentanaCons=4) 
	Begin
		set @Tabla='GuiaRemision'
		set @Campo='Cd_GR'
		set @Campo1='Cd_TD+'' - ''+NroSre+'' - ''+NroGR '
	End


set @consulta='

select @Rmsj = (case when isnull(IB_Impreso,0)=1 then '+@Campo1+'
		else '''' end)
from '+@Tabla+' where RucE='''+@RucE+''' and '+@Campo+'='''+@Cod+'''
'
print @Consulta
exec sp_executesql @Consulta,N'@Rmsj varchar(100) output',@msj out
print @msj
GO
