SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Gsp_PaisConsUn]
@Cd_Pais nvarchar(4),
@msj varchar(100) output
as
if not exists (select * from Pais where Cd_Pais=@Cd_Pais)
	set @msj = 'No se encontro pais'
else 	select Cd_Pais,Nombre,Siglas,Estado from Pais where Cd_Pais=@Cd_Pais 
print @msj

--exec Gsp_PaisConsUn '2253'
GO
