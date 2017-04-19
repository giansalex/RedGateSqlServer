SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Seg_PrfElim]
@Cd_Prf nvarchar(3),
@msj varchar(100) output
as
if not exists (select * from Perfil where Cd_Prf=@Cd_Prf)
   set @msj = 'Perfil no existe'
else
begin
    delete Perfil where Cd_Prf=@Cd_Prf	        
    if @@rowcount<=0
       set @msj = 'Perfil no pudo ser modificado'
end
print @msj
GO
