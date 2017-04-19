SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Gsp_CampoMdf]
@RucE nvarchar(11),
@Cd_Cp nvarchar(2),
@Nombre varchar(50),
@NCorto varchar(10),
@Cd_TC nvarchar(2),
@IB_Oblig bit,
@IB_Exp bit,
@Estado bit,
@msj varchar(100) output
as
if not exists (select * from Campo where RucE=@RucE and Cd_Cp=@Cd_Cp)
	set @msj = 'No existe Campo'
else
begin
	update Campo set Nombre=@Nombre, NCorto=@NCorto, Cd_TC=@Cd_TC, IB_Oblig=@IB_Oblig, IB_Exp=@IB_Exp, Estado=@Estado
	where RucE=@RucE and Cd_Cp=@Cd_Cp

	if @@rowcount <= 0
	   set @msj = 'Campo no pudo ser modificado'
	else
	begin
		--Modificando los valores en la tabla VentaCfg
		update VentaCfg set Nombre=@Nombre
		where RucE=@RucE and Cd_Cp=@Cd_Cp
	end
end
print @msj
--DE  --> Vie26/12/08
GO
