SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Inv_MtvoIngSalConsUn] --<Procedimiento que consulta x motivo de Ingreso y/o Salida>
@RucE nvarchar(11),
@Cd_MIS char(3),
@msj varchar(100) output
as
if not exists (select * from MtvoIngSal where RucE= @RucE and Cd_MIS=@Cd_MIS)
	set @msj = 'Motivo de Ingreso/Salida no existe'
else	select * from MtvoIngSal where RucE= @RucE and Cd_MIS=@Cd_MIS
print @msj
------------
--J : 14-04-2010 - <Creacion del procedimiento almacenado>
GO
