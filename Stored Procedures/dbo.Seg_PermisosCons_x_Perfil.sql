SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Seg_PermisosCons_x_Perfil]
@Cd_Prf nvarchar(3),
@RucE nvarchar(11),
@msj varchar(100) output
as
select p.Cd_Pm, p.Descrip from Permisos as p 
inner join PermisosxGp pg on p.Cd_Pm = pg.Cd_Pm and p.Estado = '1' and pg.Estado = '1'
inner join GrupoPermisos g on pg.Cd_GP = g.Cd_GP and g.Estado = '1'
inner join PermisosE pe on pe.Cd_GP = g.Cd_GP
inner join perfil pf on pe.Cd_Prf = pf.Cd_Prf
where pe.RucE = @RucE and pf.Cd_Prf = @Cd_Prf
print @msj

--Leyenda
-----------

-- FL - 07/06/2011 creacion del SP
GO
