SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Seg_PrfCrea]
@Cd_Prf nvarchar(3) output,
@NomP varchar(30),
@Descrip varchar(200),
--@Estado	bit
@msj varchar(100) output
as
if exists (select * from Perfil where NomP=@NomP)
   set @msj = 'Ya existe un perfil con este nombre'
else
begin

    Set @Cd_Prf = dbo.Cod_Perfil()

    insert into Perfil (Cd_Prf, NomP, Descrip, Estado)
	        values (dbo.Cod_Perfil(), @NomP, @Descrip, 1)

    if @@rowcount<=0
       set @msj = 'Perfil no pudo ser creado'

end  
print @msj
print @Cd_Prf


--Leyenda------
---------------

--DI  28/08/2009 : Alteracion del procedimiento almacenado: se retorna el codigo del perfil creado
GO
