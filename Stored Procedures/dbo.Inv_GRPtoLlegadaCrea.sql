SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Inv_GRPtoLlegadaCrea]
@RucE nvarchar(11),
@Cd_GR char(10),
@Item int,
@Direc varchar(150),
@NroDoc varchar(50),
@Obs varchar(200),
@RSocial varchar(100),
@msj varchar(100) output
as
begin
	insert into GRPtoLlegada(RucE,Cd_GR,Item,Direc,NroDoc,Obs,RSocial)
	   values(@RucE,@Cd_GR,@Item,@Direc,@NroDoc,@Obs,@RSocial)
	if @@rowcount <= 0
		set @msj = 'Punto de llegada no pudo ser registrado'	
end
print @msj
-- Leyenda --
-- PP : 2010-05-05 13:20:27.330	: <Creacion del procedimiento almacenado>
-- FL : 2010-09-03 <se modificaron los campos porque al momento no se va a enviar factura>
-- FL : 2010-10-12 <se modificaron los campos ahora si se envia factura xD>
-- FL : 2010-12-18 <se modifico el sp para que guarde todos los campos de la tabla>



GO
