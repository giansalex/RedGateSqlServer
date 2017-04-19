SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Rpt_ValidaCd_Vta]
@RucE nvarchar(11),
@Eje nvarchar(4),
@Cd_TD nvarchar(2),
@NroDoc nvarchar(15),
@RegCtb nvarchar(15),
@Cd_Vta nvarchar(10) output,
@msj varchar(100) output
as 

if(ltrim(@NroDoc) <> '') 
begin
	set @Cd_Vta = (select Cd_Vta from Venta where RucE=@RucE and Eje=@Eje and Cd_TD=@Cd_TD and NroDoc=@NroDoc)

	if (@Cd_Vta = null or @Cd_Vta is null)
	begin
		set @msj = 'Nro Documento no pertenece a ninguna venta'
		return
	end
end
else
begin
	set @Cd_Vta = (select Cd_Vta from Venta where RucE=@RucE and Eje=@Eje and RegCtb=@RegCtb)
	
	if (@Cd_Vta = null or @Cd_Vta is null)
	begin
		set @msj = 'Nro de registro no pertenece a ninguna venta'
		return
	end
end
print @Cd_Vta
print @msj
GO
