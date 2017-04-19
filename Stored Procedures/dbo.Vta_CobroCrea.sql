SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Vta_CobroCrea]
@RucE nvarchar(11),
--@ItmCo int,
@Cd_Vta nvarchar(10),
@Itm_BC nvarchar(10),
@FecPag smalldatetime,
@IC_TipPag varchar(1),
@Cd_Mda nvarchar(2),
@CamMda numeric(6,3),
@Monto numeric (13,2),
@UsuCrea nvarchar(10),
@Cd_FPC nvarchar(2), 
@msj varchar(100) output
as
if not exists (select * from Venta where RucE=@RucE and Cd_Vta=@Cd_Vta)
	set @msj = 'Error al ingresar cobro a la venta'
else
begin
Declare @ItmCo int
set @ItmCo = (select isnull(max(ItmCo),0)+1 from Cobro)
	insert into Cobro(RucE,ItmCo,Cd_Vta,Itm_BC,FecPag,IC_TipPag,Cd_Mda,CamMda,Monto)
		   values(@RucE,@ItmCo,@Cd_Vta,@Itm_BC,@FecPag,@IC_TipPag,@Cd_Mda,@CamMda,@Monto)
	
	if @@rowcount <= 0
	   set @msj = 'Cobro no pudo ser ingresado'
	else
	begin
	if @IC_TipPag='T'
		update Venta set IB_Cbdo=1 where RucE=@RucE and Cd_Vta=@Cd_Vta
	end
	
end
print @msj
--PV:
GO
