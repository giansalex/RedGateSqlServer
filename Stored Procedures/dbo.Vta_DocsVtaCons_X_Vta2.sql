SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROC [dbo].[Vta_DocsVtaCons_X_Vta2]

@RucE nvarchar(11),
@Cd_Vta nvarchar(10),
@msj varchar(100) output

AS

select * from (
select RucE ,Cd_Vta,Titulo,Obs, ruta 
from DocsVta where RucE=@RucE and Cd_Vta=@Cd_Vta
union
select RucE ,Cd_Vta,'CDR SUNAT' as  Titulo, 'Enviado y Acepto' as Obs, 'vacio'  as ruta
from Venta where RucE=@RucE and Cd_Vta=@Cd_Vta and  venta.DE_EstEnvSNT ='02'
union
select RucE ,Cd_Vta,'XML SUNAT' as  Titulo, 'Firmado' as Obs, 'vacio'  as ruta
from Venta where RucE=@RucE and Cd_Vta=@Cd_Vta and  venta.DE_EstEnvSNT='02'
) tb




--select * from EstEnvSNT
--select * from Venta
--select * from docsvta

-- Leyenda --

-- DI : 18/12/2010 <Creacion del procedimiento almacenado>

GO
