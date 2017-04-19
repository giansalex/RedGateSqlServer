SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Seg_PrfModf]
@Cd_Prf nvarchar(3),
@NomP	varchar(30),
@Descrip varchar(200),
@Estado	bit,
@msj varchar(100) output
as
if not exists (select * from Perfil where Cd_Prf=@Cd_Prf)
   set @msj = 'Perfil no existe'
else
begin
    update Perfil set NomP=@NomP, Descrip=@Descrip, Estado=@Estado
		  where Cd_Prf=@Cd_Prf	        
    if @@rowcount<=0
       set @msj = 'Perfil no pudo ser modificado'
end
print @msj
GO
