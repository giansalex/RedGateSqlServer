SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Gsp_CampoCrea]
@RucE nvarchar(11),
@Cd_Cp nvarchar(2),
@Nombre varchar(50),
@NCorto varchar(10),
@Cd_TC nvarchar(2),
@IB_Oblig bit,
@IB_Exp bit,
--@Estado bit,
@msj varchar(100) output
as
Declare @Cd nvarchar(2)
set @Cd = (select user123.Cod_Cp(@RucE))
if exists (select * from Campo where RucE=@RucE and Nombre=@Nombre)
	set @msj = 'Ya existe un campo con ese nombre'
else
begin
	insert into Campo(RucE,Cd_Cp,Nombre,NCorto,Cd_TC,IB_Oblig,IB_Exp,Estado)
		   values(@RucE,@Cd,@Nombre,@NCorto,@Cd_TC,@IB_Oblig,@IB_Exp,1)
	if @@rowcount <= 0
	   set @msj = 'Campo no pudo ser registrado' 
	else
	begin

		 --Creamos el campo en la tabla Configuracion de Venta:
		insert into VentaCfg(RucE,Cd_Cp,Nombre,Valor,IB_Oblig,IB_Hab)
	                    values(@RucE,@Cd,@Nombre,'0',0,1)
		
	end
end
print @msj
--DE  --> Vie26/12/08
GO
