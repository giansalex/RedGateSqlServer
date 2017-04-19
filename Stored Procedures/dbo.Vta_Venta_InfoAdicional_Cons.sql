SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
--CONSULTAR INFO ADCIONAL DE PRODUCTOS PARA ITALSCOOTER
CREATE procedure [dbo].[Vta_Venta_InfoAdicional_Cons]
@RucE nvarchar(11),
@Cd_Prod char(7),
@msj varchar(100) output

as
if exists (select * from Producto2 where RucE = @RucE and Cd_Prod = @Cd_Prod)
	select RucE,Cd_Prod,CA01,CA02,CA03,CA04,CA05,CA06,CA07,CA08,CA09,CA10 from Producto2 where RucE = @RucE and Cd_Prod = @Cd_Prod
else
	set @msj = 'El producto no existe'

-- Leyenda --
-- exec Vta_Venta_InfoAdicional_Cons '20392896369','PD00138','' --italscooter
GO
