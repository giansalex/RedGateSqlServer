SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- Stored Procedure

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------																																																
--Com_PrecioProdProvCarga																																																
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------																																																
CREATE proc [dbo].[Com_PrecioProdProvCarga]																																																
@RucE nvarchar(11),																																																
@Id_PrecPrv int,																																																
@Cd_Prv char(7),																																																
@msj varchar(100) output																																																
--WITH ENCRYPTION 
AS																																																
begin																																																
	select * from prodprovprecio																																															
	where Id_PrecPrv=@Id_PrecPrv and Cd_Prv=@Cd_Prv																																															
end 																																																
-- Leyenda --																																																
--FL : 23/08/2010 <Creacion del procedimiento almacenado>																																																


GO
