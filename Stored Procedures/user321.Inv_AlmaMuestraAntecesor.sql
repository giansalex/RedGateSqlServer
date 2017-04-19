SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [user321].[Inv_AlmaMuestraAntecesor]
@RucE nvarchar(11),
@Cd_Alm varchar(20),
@Respuesta varchar(1000) output,
@msj varchar(100) output
as
set @Respuesta = ''

declare @Length int 		/*TamaÃ±o inicial 3 Va aumentando de 2 en 2*/--se resta al @Cd_Alm
declare @TamFinMSJ int 		/*TamaÃ±o final del Mensaje*/-- para quitarle lo ultimo
declare @Tamano int 		/*TamaÃ±o real del mensaje */--condicion restando de 2 en 2
declare @Cd_Alm2 varchar(20)	/*se almacena aqui el valor del codigo del almacen*/
declare @Cd_Alm1 varchar(20)	/*para  el nombre del almacen consultado por codigo*/--cada vez que entra al while cambia de valor.
	if not exists (select top 1 * from Almacen where RucE=@RucE and Cd_Alm=@Cd_Alm)
		set @msj = 'No se encontro Almacen'
	else
	begin
	set @Cd_Alm2=(Select Cd_Alm from Almacen where Cd_Alm=@Cd_Alm and RucE=@RucE)
	set @Tamano=len(@Cd_Alm2)
	set  @Length=3
	while(@Tamano >= 3)
	begin
	   set @Cd_Alm1= SUBSTRING(@Cd_Alm2, 1, @Length)
           set @Respuesta = @Respuesta + (select Nombre from Almacen where Cd_Alm=@Cd_Alm1 and RucE=@RucE)
	   set @Respuesta = @Respuesta + ' ('+SUBSTRING(@Cd_Alm2, 1, @Length) + ') -> '
	   set @Length=  @Length + 2
	   set @Tamano = @Tamano - 2
	end
	set @TamFinMSJ=len(@Respuesta)
	if(@TamFinMSJ > 0)
	begin
	   set @Respuesta = substring(@Respuesta,1,@TamFinMSJ - 3)
	end
	else
	begin
	   set @Respuesta=(select Nombre from Almacen where Cd_Alm=@Cd_Alm2 and RucE = @RucE) +' ('+@Cd_Alm2+')'
	end
	--exec Inv_InventarioCons_MuestraAntecesorALM '11111111111','uyfji',@salida1 out,@salida2 out
	end

--print @msj
--print @respuesta


-- Leyenda --
-- JJ : 2010-07-16	: <Creacion del procedimiento almacenado>
-- MM : 2011-03-28	: <Modificacion del SP : Se corrigio problemas con el ruc en las lineas 18 y 36>

GO
