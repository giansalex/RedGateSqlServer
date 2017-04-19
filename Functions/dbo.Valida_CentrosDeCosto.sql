SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE FUNCTION [dbo].[Valida_CentrosDeCosto](@RucE nvarchar(11),@Cd_CC nvarchar(8), @Cd_SC nvarchar(8), @Cd_SS nvarchar(8))
returns varchar(100) AS
begin 

		--Validacion para Sub CC 
		if isnull(@Cd_CC, '') ='' and  isnull(@Cd_SC,'') <> ''  and isnull(@Cd_SS, '') ='' 
			return 'No se ingreso Cod. C.Costos para Sub C.Costos'

		--Validacion para Sub Sub CC 
		if (isnull(@Cd_CC, '') ='') and isnull(@Cd_SS,'') <> '' 
			return 'No se ingreso Cod. C.Costos para Sub Sub C.Costos'
		
		--Validacion para Sub Sub CC 
		if (isnull(@Cd_SC, '')  ='') and isnull(@Cd_SS,'') <> ''
			return 'No se ingreso Cod. Sub C.Costos para Sub Sub C.Cotos'




		if isnull(@Cd_CC,'')<>''  and  isnull(@Cd_SC, '') =''  and  isnull(@Cd_SS, '') =''  --Caso: Si solo mandamos CC
			if not exists (select * from CCostos where RucE=@RucE and Cd_CC=@Cd_CC) --> Validamos CC
				return 'No existe C.Costos: ' +isnull(@Cd_CC,'Vacio')
				

		if  isnull(@Cd_CC, '') <> ''  and   isnull(@Cd_SC, '') <> ''  and  isnull(@Cd_SS, '') ='' --Caso: Si mandamos CC y SC
			if not exists (select * from CCSub where RucE=@RucE and Cd_CC=@Cd_CC and  Cd_SC=@Cd_SC) --> Validamos CC y SC
				return 'No existe Sub C.Costos: ' +isnull(@Cd_CC,'Vacio') + ' | '+isnull(@Cd_SC,'Vacio')
		

		if isnull(@Cd_CC,'')<>''  and  isnull(@Cd_SC,'')<>''  and  isnull(@Cd_SS,'')<>'' --Caso: Si mandamos CC, SC y SS
			if not exists (select * from CCSubSub where RucE=@RucE and Cd_CC=@Cd_CC and  Cd_SC=@Cd_SC and Cd_SS=@Cd_SS)  --> Validamos CC, SC y SS
				return 'No existe Sub Sub C.Costos: ' +isnull(@Cd_CC,'Vacio') + ' | '+isnull(@Cd_SC,'Vacio')+' | '+isnull(@Cd_SS,'Vacio')


	return ''

end


-- PV: creado: 06/12/2016  se creo para validar clases al importar productos.

-- CASOS DE PRUEBA:
/*
print dbo.Valida_CentrosDeCosto('20169999991','','','' )

print dbo.Valida_CentrosDeCosto('20169999991','','bb','' )
print dbo.Valida_CentrosDeCosto('20169999991','','bb','cc' )
print dbo.Valida_CentrosDeCosto('20169999991','','','cc' )
print dbo.Valida_CentrosDeCosto('20169999991','aa','','cc' )

print dbo.Valida_CentrosDeCosto('20169999991','aax','','' )
print dbo.Valida_CentrosDeCosto('20169999991','aax','bbx','' )
print dbo.Valida_CentrosDeCosto('20169999991','aax','bbx','ccx' )

*/
GO
