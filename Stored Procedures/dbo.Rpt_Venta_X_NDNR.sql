SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Rpt_Venta_X_NDNR]  /*ELIMINAR DESPUES DE ACTUALIZAR CEDIVE 03/02/09*/
@RucE nvarchar(11),
@Eje nvarchar(4),
@Cd_TD nvarchar(2),
@NroDoc nvarchar(15),
@RegCtb nvarchar(15),
--@UsuModf  nvarchar(10),   --> PARA QUE???
@msj varchar(100) output
as 
Declare @Cd_Vta nvarchar(10)
set @Cd_Vta = '0'

if(len(@NroDoc) > 0)
begin
	--set @Cd_Vta = (select Cd_Vta from Venta where RucE=@RucE and Eje=@Eje and Cd_TD=@Cd_TD and NroDoc=@NroDoc)
--	set @Cd_Vta = (select Cd_Vta from Venta where RucE=@RucE and Cd_TD=@Cd_TD and NroDoc=@NroDoc)
	select @Cd_Vta=Cd_Vta from Venta where RucE=@RucE and Cd_TD=@Cd_TD and NroDoc=@NroDoc and Eje=@Eje --> POR MIENTRAS 
	print @Cd_Vta

	if (@Cd_Vta = null or @Cd_Vta is null)
	begin
		set @msj = 'Nro Documento no pertenece a ninguna venta'
		return
	end
	else	exec Rpt_Venta @RucE,@Eje,@Cd_Vta,@msj output
end
else
begin
	--set @Cd_Vta = (select Cd_Vta from Venta where RucE=@RucE and Eje=@Eje and RegCtb=@RegCtb)
	set @Cd_Vta = (select Cd_Vta from Venta where RucE=@RucE and RegCtb=@RegCtb)
	
	if (@Cd_Vta = null or @Cd_Vta is null)
	begin
		set @msj = 'Nro de registro no pertenece a ninguna venta'
		return
	end
	else	exec Rpt_Venta @RucE,@Eje,@Cd_Vta,@msj output
end
print @msj
--> PV: Dom 23/11/08
GO
