SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE procedure [dbo].[Seg_PermisoxGPxUsuCons]
@NomUsu nvarchar(20),
@msj varchar(100) output
as

if(@NomUsu = 'Admin')
begin
	select distinct 0 Cd_GP, a.Cd_Pm, a.Descrip, a.Estado from Permisos a
	where a.Estado = 1
	order by a.Cd_Pm
end
else
begin
	declare @nivel varchar(100)
	select @nivel = Nivel from Usuario
	where NomUsu = @NomUsu

	select 0 Cd_GP, Cd_Pm, Descrip, Estado from Permisos where Cd_Pm in (
		select distinct Cd_Pm from PermisosxGP where Cd_GP in 
		(
			select distinct Cd_GP from PermisosE where Cd_Prf in
			(
				select Cd_Prf from Perfil
				where NivUsuCrea = @Nivel
			)
		) and Estado = 1
	) and Estado = 1
	order by Cd_Pm
end

--Leyenda--
-- FL 2011/06/16 : <Creacion del procedimiento almacenado>






	
GO
