SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE proc [dbo].[Com_ServProvPrecioCrea] -- <Procedimiento que registra ServProvPrecio>
@RucE nvarchar(11),
@ID_PrecSP int output,
@Cd_Prv char(7),
@Cd_SP char(6),
@Fecha smalldatetime,
@PrecioCom numeric,
@IB_IncIGV bit,
@Cd_Mda nvarchar(2),
@Estado bit,
@msj varchar(100) output
as
set @ID_PrecSP = dbo.ID_PrecSP(@RucE)
if exists (select * from ServProvPrecio where RucE=@RucE and ID_PrecSP=@ID_PrecSP)
	set @msj = 'Este proveedor ya tiene registrado un precio para este servicio'
else
begin
	insert into ServProvPrecio(RucE,ID_PrecSP,Cd_Prv,Cd_SP,Fecha,PrecioCom,IB_IncIGV,Cd_Mda,Estado)
	values(@RucE,@ID_PrecSP,@Cd_Prv,@Cd_SP,@Fecha,@PrecioCom,@IB_IncIGV,@Cd_Mda,@Estado)	
	
	if @@rowcount <= 0
	set @msj = 'Precio se registro correctamente'	
end
-- Leyenda --
-- FL : 2010-08-26 : <Creacion del procedimiento almacenado>
print @msj
GO
