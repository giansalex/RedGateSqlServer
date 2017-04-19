SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[Valida_Clases](@RucE nvarchar(11),@Cd_CL nvarchar(3), @Cd_CLS nvarchar(3), @Cd_CLSS nvarchar(3))
returns varchar(100) AS
begin 
	declare @msj varchar(100)
	set @msj=''

		--Validacion para Sub Clase 
		if isnull(@Cd_CL, '') ='' and  isnull(@Cd_CLS,'') <> ''  and isnull(@Cd_CLSS, '') ='' 
		begin
			set @msj = 'No se ingreso Codigo de Clase para Sub Clase'
			return @msj
		end

		--Validacion para Sub Sub Clase
		if (isnull(@Cd_CL, '') ='') and isnull(@Cd_CLSS,'') <> '' 
		begin
			set @msj = 'No se ingreso Codigo de Clase para Sub Sub Clase'
			return @msj
		end
		
		--Validacion para Sub Sub Clase
		if (isnull(@Cd_CLS, '')  ='') and isnull(@Cd_CLSS,'') <> '' 
		begin
			set @msj = 'No se ingreso Codigo de Sub Clase para Sub Sub Clase'
			return @msj
		end



		if isnull(@Cd_CL,'')<>''  and  isnull(@Cd_CLS, '') =''  and  isnull(@Cd_CLSS, '') =''  --Caso: Si solo mandamos Clase
			if not exists (select * from Clase where RucE=@RucE and Cd_CL=@Cd_CL)  --> Validamos Clase
			begin
				set @msj = 'No existe Clase: ' +isnull(@Cd_CL,'Vacio')
				return @msj
			end


		if  isnull(@Cd_CL, '') <> ''  and   isnull(@Cd_CLS, '') <> ''  and  isnull(@Cd_CLSS, '') =''  --Caso: Si mandamos Cl y SCl 
			if not exists (select * from ClaseSub where RucE=@RucE and Cd_CL=@Cd_CL and  Cd_CLS=@Cd_CLS) --> Validamos Cl y SCl
			begin
				set @msj = 'No existe Sub Clase: ' +isnull(@Cd_CL,'Vacio') + ' | '+isnull(@Cd_CLS,'Vacio')
				return @msj
			end
		

		if isnull(@Cd_CL,'')<>''  and  isnull(@Cd_CLS,'')<>''  and  isnull(@Cd_CLSS,'')<>'' --Caso: Si mandamos Cl, SCl y SSCl
			if not exists (select * from ClaseSubSub where RucE=@RucE and Cd_CL=@Cd_CL and  Cd_CLS=@Cd_CLS and Cd_CLSS=@Cd_CLSS)  --> Validamos Cl, SCl, y SSCl
			begin
				set @msj = 'No existe Sub Sub Clase: ' +isnull(@Cd_CL,'Vacio') + ' | '+isnull(@Cd_CLS,'Vacio')+' | '+isnull(@Cd_CLSS,'Vacio')
				return @msj
			end 


	return @msj

end


-- PV: creado: 06/12/2016  se creo para validar clases al importar productos.

-- CASOS DE PRUEBA:
/*
print dbo.Valida_Clases('20169999991','','','' )

print dbo.Valida_Clases('20169999991','','bb','' )
print dbo.Valida_Clases('20169999991','','bb','cc' )
print dbo.Valida_Clases('20169999991','','','cc' )
print dbo.Valida_Clases('20169999991','aa','','cc' )

print dbo.Valida_Clases('20169999991','aax','','' )
print dbo.Valida_Clases('20169999991','aax','bbx','' )
print dbo.Valida_Clases('20169999991','aax','bbx','ccx' )
*/
GO
