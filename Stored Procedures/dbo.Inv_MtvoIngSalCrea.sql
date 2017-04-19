SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Inv_MtvoIngSalCrea] --<Procedimiento que registra los motivos de Ingreso y/o Salida>
@RucE nvarchar(11),
@Cd_MIS char(3) output,
@Descrip varchar(150),
@Cd_TM char(2), --output,
@Estado bit,
@IC_Tipo char(1),
@msj varchar(100) output
as
if exists (select * from MtvoIngSal where RucE= @RucE and Descrip=@Descrip)
	set @msj = 'Ya existe Motivo de Ingreso/Salida con el nombre ['+@Descrip+']'
else
begin
	set @Cd_MIS = user123.Cd_MIS(@RucE)
	--set @Cd_TM= (select Cd_TM from MtvoIngSal Where RucE = @RucE and Cd_MIS=@Cd_MIS)
	insert into MtvoIngSal(RucE,Cd_MIS,Descrip,Cd_TM,Estado,IC_Tipo)
	values(@RucE,@Cd_MIS,@Descrip,@Cd_TM,@Estado,@IC_Tipo)	
	
	if @@rowcount <= 0
	set @msj = 'Motivo de Ingreso/Salida no pudo ser registrado'	
end
------------
--J : 14-04-2010 - <Creacion del procedimiento almacenado>
--MM : 23-11-2010 - <Modificacion del procedimiento almacenado por agregacion de mas campos>
GO
