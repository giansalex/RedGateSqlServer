SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Rpt_Venta_OASIS_X_NDNR]
@RucE nvarchar(11),
@Eje nvarchar(4),
@Cd_TD nvarchar(2),
@NroDoc nvarchar(15),
@RegCtb nvarchar(15),
--@UsuModf  nvarchar(10),   --> PARA QUE???
@msj varchar(100) output
as 
Declare @Cd_Vta nvarchar(10)
set @Cd_Vta = ''

if(len(@NroDoc) > 0)
begin
	set @Cd_Vta = (select Cd_Vta from Venta where RucE=@RucE and Eje=@Eje and Cd_TD=@Cd_TD and NroDoc=@NroDoc)

	if (@Cd_Vta = null or @Cd_Vta is null)
	begin
		set @msj = 'Nro Documento no pertenece a ninguna venta'
		return
	end
	else	exec Rpt_Venta_OASIS @RucE,@Eje,@Cd_Vta,@msj
end
else
begin
	set @Cd_Vta = (select Cd_Vta from Venta where RucE=@RucE and Eje=@Eje and RegCtb=@RegCtb)
	
	if (@Cd_Vta = null or @Cd_Vta is null)
	begin
		set @msj = 'Nro de registro no pertenece a ninguna venta'
		return
	end
	else	exec Rpt_Venta_OASIS @RucE,@Eje,@Cd_Vta,@msj
end
print @msj
GO
