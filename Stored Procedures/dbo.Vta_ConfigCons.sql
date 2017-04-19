SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Vta_ConfigCons]
@RucE nvarchar(11),
--@Cd_Cp nvarchar(2),
--@Nombre varchar(50),
--@Valor varchar(100),
--@IB_Oblig bit,
--@IB_Hab bit,
@msj varchar(100) output
as
if not exists (select top 1 * from VentaCfg where RucE=@RucE)
	set @msj = 'No existe configuracion para esta empresa'
else	
begin	
	select * from VentaCfg where RucE=@RucE and Cd_Cp >= '50'Order by 2
	select * from VentaCfg where RucE=@RucE and Cd_Cp < '50' Order by 2
end
print @msj
GO
