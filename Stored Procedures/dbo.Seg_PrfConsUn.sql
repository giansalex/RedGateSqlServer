SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Seg_PrfConsUn]
@Cd_Prf nvarchar(3),
@msj varchar(100) output
as
--select Cd_Prf, NomP, Descrip, Estado from Perfil
if not exists (select * from Perfil where Cd_Prf=@Cd_Prf)
   set @msj = 'Perfil no existe'
else select * from Perfil where Cd_Prf=@Cd_Prf
print @msj 
GO
