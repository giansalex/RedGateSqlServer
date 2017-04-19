SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Inv_Producto2ConsxCodComercial]
@RucE nvarchar(11),
@msj varchar(100) output
as
--set @RucE = '20513272848'
select 
	--isnull(CodCo1_,'-Sin Especificar-')+' | '+Nombre1,Cd_Prod,CodCo1_,Nombre1 
	Cd_Prod,isnull(CodCo1_,'-SinEspecificar-') as CodCol_,Nombre1
from 
	Producto2 
where 
	Estado=1 and  RucE = @RucE

-- LEYENDA
-- CAM 22/09/2011 Creacion - Reporte Margenes
-- exec Inv_Producto2ConsxCodComercial '11111111111','' 
-- exec Inv_Producto2ConsxCodComercial '20513272848','' -- Agritop
GO
