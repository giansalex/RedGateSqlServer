SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Vta_VtaDetalleElim]
@RucE nvarchar(11),
@Cd_Vta nvarchar(10),
@Nro_RegVdt int,
@Ad_INF_Vta numeric(13,2) output,
@Ad_BIM_Vta numeric(13,2) output,
@Ad_IGV_Vta numeric(13,2) output,
@Ad_Total_Vta numeric(13,2) output,
@msj varchar(100) output
as
if not exists (select * from VentaDet where RucE=@RucE and Cd_Vta=@Cd_Vta and Nro_RegVdt=@Nro_RegVdt)
	set @msj = 'Venta Detalle no existe'
else
begin
	declare @IMP numeric(13,2)
	declare @IGV numeric(13,2)
	declare @TOT numeric(13,2)
	declare @Cd_Pro nvarchar(7)

	set @IMP = 0.00
	set @IGV = 0.00
	set @TOT = 0.00
	set @Cd_Pro = ''

	select @Cd_Pro=Cd_Pro, @IMP=IMP, @IGV=IGV, @TOT=Total from  VentaDet  where RucE = @RucE and Cd_Vta=@Cd_Vta and Nro_RegVdt=@Nro_RegVdt
---
	declare @IB_IncIGV bit, @IB_Exrdo bit, @BIM numeric(13,2), @INF numeric(13,2), @EXO numeric(13,2)
	select @IB_IncIGV=IB_IncIGV, @IB_Exrdo=IB_Exrdo  from Producto where Cd_Pro=@Cd_Pro
	
	if(@IB_IncIGV=1)
	begin
	   set @BIM=@IMP set @INF=0.00 set @EXO=0.00
	end
	else if (@IB_Exrdo=1)
		begin  set @INF=0.00  set @EXO=@IMP set @BIM=0.00  end
	     else begin  set @INF=@IMP  set @EXO=0.00  set @BIM=0.00  end
	
	update Venta set INF=INF-@INF, EXO=EXO-@EXO, BIM=BIM-@BIM, IGV=IGV-@IGV, Total=Total-@TOT where RucE = @RucE and Cd_Vta=@Cd_Vta
---


	delete from VentaDet where RucE=@RucE and Cd_Vta=@Cd_Vta and Nro_RegVdt=@Nro_RegVdt

	if @@rowcount <= 0
	   set @msj = 'Venta Detalle no pudo ser eliminado'
	else
	begin
		set @Ad_INF_Vta = 0.00
		set @Ad_BIM_Vta = 0.00
		set @Ad_IGV_Vta = 0.00
		set @Ad_Total_Vta = 0.00
		select @Ad_INF_Vta= INF+EXO, @Ad_BIM_Vta= BIM, @Ad_IGV_Vta = IGV,  @Ad_Total_Vta = Total from  Venta  where RucE = @RucE and Cd_Vta=@Cd_Vta

	end
end
print @msj
--PV
GO
