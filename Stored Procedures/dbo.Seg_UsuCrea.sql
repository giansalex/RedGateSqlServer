SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Seg_UsuCrea]
@NomUsu	nvarchar(10),
@Pass	nvarchar(50),
@NomComp varchar(50),
@Cd_Trab nvarchar(15),
@Cd_Prf	nvarchar(3),
--@Estado	bit
@msj varchar(100) output
as
if exists (select * from Usuario where NomUsu=@NomUsu)
   set @msj = 'Usuario ya existe'
else
begin
    insert into Usuario(NomUsu,Pass,NomComp,Cd_Trab,Cd_Prf,Estado)
	        values (@NomUsu,@Pass,@NomComp,@Cd_Trab,@Cd_Prf,1)
    if @@rowcount<=0
       set @msj = 'Usuario no pudo ser creado'
end
print @msj
GO
