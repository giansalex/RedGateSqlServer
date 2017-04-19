SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Seg_PrfCreaxNivel]
@Cd_Prf nvarchar(3) output,
@NomUsu nvarchar(20),
@NomP varchar(30),
@Descrip varchar(200),
--@Estado	bit
@msj varchar(100) output
as
if exists (select * from Perfil where NomP=@NomP)
   set @msj = 'Ya existe un perfil con este nombre'
else
begin
	declare @nivel nvarchar(100)
	select @nivel = Nivel
	from Usuario
	where NomUsu = @NomUsu

    Set @Cd_Prf = dbo.Cod_Perfil()
    insert into Perfil (Cd_Prf, NomP, Descrip, NivUsuCrea, Estado)
	        values (dbo.Cod_Perfil(), @NomP, @Descrip, @nivel, 1)

    if @@rowcount<=0
       set @msj = 'Perfil no pudo ser creado'

end  
print @msj
print @Cd_Prf


--Leyenda------
---------------

--MP : 2011/06/06 : <Modificacion del procedimiento almacenado>
GO
