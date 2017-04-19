SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Inv_MtvoIngSalMdf] --<Procedimiento que modifica los motivos de Ingreso y/o Salida>
@RucE nvarchar(11),
@Cd_MIS char(3),
@Descrip varchar(150),
@Cd_TM char(2) ,
@Estado bit,
@msj varchar(100) output
as
if not exists (select * from MtvoIngSal where RucE= @RucE and Cd_MIS=@Cd_MIS)
	set @msj = 'Motivo de Ingreso/Salida no existe'
else
begin
	update MtvoIngSal set Descrip=@Descrip,Cd_TM=@Cd_TM, Estado=@Estado
	where RucE= @RucE and Cd_MIS=@Cd_MIS

	if @@rowcount <= 0
	set @msj = 'Motivo de Ingreso/Salida no pudo ser modificado'	
end
------------
--J : 14-04-2010 - <Creacion del procedimiento almacenado>
GO
