SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Vta_OrdenPCrea]
@RucE nvarchar(11),
@Cd_OP nvarchar(10),
@NroOP nvarchar(15),
@FecE smalldatetime,
@Cd_FPC nvarchar(2),
@Cd_Vdr nvarchar(7),
@Cd_Area nvarchar(6),
@Cd_MR nvarchar(2),
@Cd_Cte nvarchar(7),
@DirecEnt varchar(100),
@FecEnt smalldatetime,
@Obs varchar(1000),
@Imp numeric(13,2),
@IGV numeric(13,2),
@Total numeric(13,2),
@Cd_Mda nvarchar(2),
@CamMda numeric(6,3),
--@FecReg datetime,
--@FecMdf datetime,
@UsuCrea nvarchar(10),
--@UsuModf nvarchar(10),
--@IB_Anulado bit,
@msj varchar(100) output
as
if exists (select * from OrdenP where RucE=@RucE and Cd_OP=@Cd_OP)
	set @msj = 'Ya existe codigo de pedido'
else
begin
	insert into OrdenP(RucE,Cd_OP,NroOP,FecE,Cd_FPC,Cd_Vdr,Cd_Area,Cd_MR,
			   Cd_Cte,DirecEnt,FecEnt,Obs,Imp,IGV,Total,Cd_Mda,FecReg,
			   UsuCrea,IB_Anulado)
		    values(@RucE,@Cd_OP,@NroOP,@FecE,@Cd_FPC,@Cd_Vdr,@Cd_Area,@Cd_MR,
			   @Cd_Cte,@DirecEnt,@FecEnt,@Obs,@Imp,@IGV,@Total,@Cd_Mda,getdate(),
			   @UsuCrea,0)

	if @@rowcount <= 0
		set @msj = 'Orden de Pedido no pudo ser creado'

	--INSERTANDO MOVIMIENTO DE REGISTRO
	-----------------------------------------------------------------------------------	
	Declare @Cd_Tab nvarchar(3), @Descrip1 varchar(50), @Descrip2 varchar(50), @FecMov datetime
	Set @Cd_Tab = 'V04'
	Set @Descrip1 = @Cd_OP 
	Set @Descrip2 = @Total
	Set @FecMov = getdate()
	exec Gsp_GeneralRMCrea @RucE, @Cd_Tab, @Cd_Area, '01', @Descrip1, @Descrip2, @UsuCrea, @FecMov, @msj output
	-----------------------------------------------------------------------------------	
end
print @msj
--DI: 16/02/2009
GO
