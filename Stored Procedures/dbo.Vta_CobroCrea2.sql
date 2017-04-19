SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Vta_CobroCrea2]
@RucE nvarchar(11),
--@ItmCo int,
@Cd_Vta nvarchar(10),
@Itm_BC nvarchar(10),
@FecPag smalldatetime,
@IC_TipPag varchar(1),
@Cd_Mda nvarchar(2),
@CamMda numeric(6,3),
@Monto numeric (13,2),
@Cd_FPC nvarchar(2),
---------------------
@Ejer nvarchar(4),
@RegCtb nvarchar(15),
@UsuCrea nvarchar(10), --ya estaba
--@UsuModf nvarchar(10),
--@FecReg datetime 8
--@FecMdf datetime 8
@TipOper varchar(4),
@NroChke varchar(30),   
@Cd_Area nvarchar(4), --ya estaba
@msj varchar(100) output


as
if not exists (select * from Venta where RucE=@RucE and Cd_Vta=@Cd_Vta)
	set @msj = 'Error al ingresar cobro a la venta'
else
begin
Declare @ItmCo int, @FecReg datetime

set @ItmCo = (select isnull(max(ItmCo),0)+1 from Cobro)
set @FecReg = getdate()


	insert into Cobro(RucE,ItmCo,Ejer,RegCtb,Cd_Vta,Itm_BC,FecPag,IC_TipPag,Cd_Mda,CamMda,Monto,TipOper,NroChke,Cd_Area,UsuCrea,FecReg )
		   values(@RucE,@ItmCo,@Ejer,@RegCtb,@Cd_Vta,@Itm_BC,@FecPag,@IC_TipPag,@Cd_Mda,@CamMda,@Monto, @TipOper,@NroChke,@Cd_Area,@UsuCrea,@FecReg )
	
	if @@rowcount <= 0
	   set @msj = 'Cobro no pudo ser ingresado'
	else
	begin
	if @IC_TipPag='T'
		update Venta set IB_Cbdo=1 where RucE=@RucE and Cd_Vta=@Cd_Vta
	end




	--INSERTANDO MOVIMIENTO DE REGISTRO
	--if (select IB_CbrEnLinea from TablaCfg where RucE=@RucE and NroCfg= NroCfg_PrfUsu )
	-----------------------------------------------------------------------------------	
	Declare @Cd_Tab nvarchar(3), @Descrip1 varchar(50), @Descrip2 varchar(50), @FecMov datetime, @Cd_Est nvarchar(2)
	Set @Cd_Tab = 'V02'
	Set @Descrip1 = @Cd_Vta 
	Set @Descrip2 = @Monto
	Set @FecMov = getdate()
	Set @Cd_Est = '01'
	exec Gsp_GeneralRMCrea @RucE, @Cd_Tab, @Cd_Area, '01', @Descrip1, @Descrip2, @UsuCrea, @FecMov, @Cd_Est, @msj output
	-----------------------------------------------------------------------------------	


end
print @msj
--PV:
--DI: 16/02/2009
--PV: 20/08/2009 Mdf: Reestructurado
--PV: 25/08/2009 Mdf: @Cd_Est
GO
