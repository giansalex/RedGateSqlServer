SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Seg_PrfCons]
@msj varchar(100) output
as
--select Cd_Prf, NomP, Descrip, Estado from Perfil
/*if not exists (select top 1 * from Perfil)
   set @msj = 'No se encontro Perfiles'
else */select *, Cd_Prf+'   |         '+NomP as CodNom from Perfil
print @msj
GO
