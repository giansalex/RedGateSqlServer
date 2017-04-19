SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Seg_UsuModf]
@NomUsu	nvarchar(10),
@Pass	nvarchar(50),
@NomComp varchar(50),
@Cd_Trab nvarchar(15),
@Cd_Prf	nvarchar(3),
@Estado	bit,
@msj varchar(100) output
as
if not exists (select * from Usuario where NomUsu=@NomUsu)
   set @msj = 'Usuario no existe'
else
begin
   update Usuario set Pass=@Pass, NomComp=@NomComp, Cd_Trab=@Cd_Trab, Cd_Prf=@Cd_Prf, Estado=@Estado
		  where NomUsu=@NomUsu
   if @@rowcount<=0
      set @msj = 'Usuario no pudo ser modificado'
end
print @msj
GO
