SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Seg_UsuConsHabilitados]
@msj varchar(100) output
as
--select NomUsu, Paaa, NomComp, Cd_Trab, Cd_Prf, Estado from Usuario
/*if not exists (select top 1 * from Usuario)
   set @msj = 'No se encontro Usuario'
else */
select a.NomUsu,a.Pass,a.NomComp,a.Cd_Trab,b.NomP,a.Estado from Usuario a, Perfil b where a.Cd_Prf=b.Cd_Prf and a.Estado='1'
print @msj
GO
