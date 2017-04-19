SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create procedure [dbo].[Vta_CuotaDet_Elim]
@RucE nvarchar(11),
@Cd_EC int,
@Cd_Cuo int,
@Item int,
@msj varchar(100) output
as
if not exists (select *from CuotaDet where RucE=@RucE and Cd_EC=@Cd_EC and Cd_Cuo=@Cd_Cuo and Item=@Item)
	set @msj='Detalle de cuota no existe'
else
begin
	delete CuotaDet where RucE=@RucE and Cd_EC=@Cd_EC and Cd_Cuo=@Cd_Cuo and Item=@Item
	if @@rowcount <=0
		set @msj='Detalle de cuota no pudo ser eliminado'
end
--Leyenda --
-- JJ -- 2011-06-17: Creacion del procedimiento almacenado
GO
