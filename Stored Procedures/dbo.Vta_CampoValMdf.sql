SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Vta_CampoValMdf]
@RucE nvarchar(11),
@Cd_Vta nvarchar(10),
@Cd_Cp nvarchar(2),
@Valor varchar(100),
@msj varchar(100) output
as

/*if not exists (select * from CampoV where RucE=@RucE and Cd_Vta=@Cd_Vta and  Cd_Cp=@Cd_Cp )
	set @msj = 'No existe campo en este registro'
*/
if not exists (select * from Campo where RucE=@RucE and Cd_Cp=@Cd_Cp )
	set @msj = 'Campo no pertenece a esta empresa'

else
begin
	/*if(@RucE = '20535946893' and @Cd_Cp='05')
	begin
		if isnumeric(@Valor)=0 -- IsNumeric : devuelve 0 si es false y 1 en caso contrario
		begin
		    set @msj ='El formato del campo Descuento no es correcto'
			return
		end
	end*/

	if not exists (select Cd_Cp from CampoV where RucE=@RucE and Cd_Vta=@Cd_Vta and  Cd_Cp=@Cd_Cp )
	begin 
			if((@RucE = '20535946893'  or @RucE ='20492317251' or @RucE ='20535946621') and @Cd_Cp='05')
			begin
				if isnumeric(@Valor)=0 -- IsNumeric : devuelve 0 si es false y 1 en caso contrario
				begin
				    set @msj ='El formato del campo Descuento no es correcto'
				    return
				end
				update Venta set DsctoFnzI = Convert(numeric(13,2),@Valor)
				--,DsctoFnzP = (@Valor*100)/Total
				--Actualiza el Campo DsctoFnzI & DsctoFnzP de la Tabla Venta
				Where (@RucE='20535946893' or @RucE ='20492317251' or @RucE ='20535946621')  and Cd_Vta=@Cd_Vta
			end
			insert into CampoV (RucE, Cd_Vta, Cd_Cp, Valor) values(@RucE, @Cd_Vta, @Cd_Cp, @Valor)				
	end 
	else
	begin
			if((@RucE = '20535946893'  or @RucE ='20492317251' or @RucE ='20535946621') and @Cd_Cp='05')
			begin
				if isnumeric(@Valor)=0 -- IsNumeric : devuelve 0 si es false y 1 en caso contrario
				begin
				    set @msj ='El formato del campo Descuento no es correcto'
				    return
				end
				update Venta set DsctoFnzI = Convert(numeric(13,2),@Valor)
				--,DsctoFnzP = (@Valor*100)/Total
				--Actualiza el Campo DsctoFnzI & DsctoFnzP de la Tabla Venta
				Where (@RucE='20535946893' or @RucE ='20492317251' or @RucE ='20535946621')  and Cd_Vta=@Cd_Vta
			end			
			update CampoV set Valor=@Valor where RucE=@RucE and Cd_Vta=@Cd_Vta and  Cd_Cp=@Cd_Cp
	end

			

	if @@rowcount <= 0
	   set @msj = 'Campo Adicional no pudo ser modificado' 
end
print @msj
--J : Mdf -> 01/06/2010
GO
