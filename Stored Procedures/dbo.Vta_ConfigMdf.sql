SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Vta_ConfigMdf]
@RucE nvarchar(11),
@Cd_Cp nvarchar(2),
--@Nombre varchar(50),
@Valor varchar(100),
@IB_Oblig bit,
@IB_Hab bit,
@msj varchar(100) output
as
if not exists (select * from VentaCfg where RucE=@RucE and Cd_Cp=@Cd_Cp)
	set @msj = 'No existe campo'
else	
begin	
	update VentaCfg set Valor=@Valor, IB_Oblig=@IB_Oblig, IB_Hab=@IB_Hab
	where RucE=@RucE and Cd_Cp=@Cd_Cp

	if @@rowcount <= 0
	   set @msj = 'No se pudo modificar el valor del campo'
end
print @msj
GO
