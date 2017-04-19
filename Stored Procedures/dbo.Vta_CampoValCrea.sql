SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Vta_CampoValCrea]
@RucE nvarchar(11),
@Cd_Vta nvarchar(10),
@Cd_Cp nvarchar(2),
@Valor varchar(100),
@msj varchar(100) output
as

if exists (select * from CampoV where RucE=@RucE and Cd_Vta=@Cd_Vta and  Cd_Cp=@Cd_Cp )
	set @msj = 'No se puede registrar un campo adicional dos veces para una misma venta'
else
begin

	/*--------------------------------------------------------------------------------*/
	-- Validando que el Campo Adicional Dscto sea numérico
	/*--------------------------------------------------------------------------------*/

	if((@RucE ='20535946893' or @RucE ='20492317251' or @RucE ='20535946621') and @Cd_Cp='05')
	begin
		if isnumeric(@Valor)=0 -- IsNumeric : devuelve 0 si es false y 1 en caso contrario
		begin
		    set @msj ='El formato del campo Descuento no es correcto'
			return
		end
		update Venta set DsctoFnzI = Convert(numeric(13,2),@Valor)
		/*,DsctoFnzP = (@Valor*100)/Total*/--Actualiza el Campo DsctoFnzI, No DsctoFnzP ya que se necesita el Total de la venta
		Where (@RucE='20535946893' or @RucE ='20492317251' or @RucE ='20535946621') and Cd_Vta=@Cd_Vta
		
	end
	
	else if(@RucE ='20101949461' and (@Cd_Cp='02' or @Cd_Cp='03'))
	begin
		if isdate(@Valor)=0
		begin
		   set @msj ='El formato de la fecha del periodo no es correcto. Ej. dd/mm/aaaa'
		   return
		end

		/********************************************************************************************************************************************/
		--if(@Cd_Cp='02')
		--begin
			/*if exists (select * from CampoV where RucE='20101949461' and Cd_Vta=@Cd_Vta and Cd_Cp='03')
				Update CampoV set Valor=@Valor Where RucE='20101949461' and Cd_Vta=@Cd_Vta and Cd_Cp='03'
			else
			begin*/
				--if exists (select * from Campo where RucE='20101949461' and Cd_Cp='03')
				--if exists (select * from CampoV where RucE='20101949461' and Cd_Vta=@Cd_Vta and Cd_Cp='03')
				--begin
					/*insert into CampoV(RucE,Cd_Vta,Cd_Cp,Valor)
		  			 values(@RucE,@Cd_Vta,'03',@Valor)*/
					--Update CampoV set Valor=@Valor Where RucE='20101949461' and Cd_Vta=@Cd_Vta and Cd_Cp='03'

				--end
				--else if exists (select * from Campo where RucE='20101949461' and Cd_Cp='03')
				--begin
					--insert into CampoV(RucE,Cd_Vta,Cd_Cp,Valor)
		  			--values(@RucE,@Cd_Vta,'03',@Valor)
				--end
			--end
		--end
		/********************************************************************************************************************************************/
		--Update CampoV set Valor=@Valor Where RucE='20101949461' and Cd_Vta=@Cd_Vta and (Cd_Cp='02' or Cd_Cp='03')
	end

	insert into CampoV(RucE,Cd_Vta,Cd_Cp,Valor)
		   values(@RucE,@Cd_Vta,@Cd_Cp,@Valor)

	

	
	if @@rowcount <= 0
	   set @msj = 'Campo Adicional no pudo ser registrado' 


	
end
print @msj

--JS: MDF: Mar 01/06/10 ---
GO
