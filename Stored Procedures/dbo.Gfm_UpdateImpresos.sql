SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create procedure [dbo].[Gfm_UpdateImpresos]
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
	if(@VentanaCons=0) 
	Begin
		set @Tabla='Venta'
		set @Campo='Cd_Vta'
	End
	else if(@VentanaCons=1) 
	Begin
		set @Tabla='OrdPedido'
		set @Campo='Cd_OP'
	End
	else if(@VentanaCons=2) 
	Begin
		set @Tabla='SolicitudCom'
		set @Campo='Cd_SCo'
	End
	else if(@VentanaCons=3) 
	Begin
		set @Tabla='OrdCompra'
		set @Campo='Cd_OC'
	End
	else if(@VentanaCons=4) 
	Begin
		set @Tabla='GuiaRemision'
		set @Campo='Cd_GR'
	End


set @consulta=' Update '+@Tabla+' Set IB_Impreso=1 Where RucE='''+@RucE+''' and '+@Campo+'='''+@Cod+'''
'
--print @Consulta
exec (@Consulta)
print @msj
GO
