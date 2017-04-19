SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Seg_AccesoMxUsuCons]
@NomUsu nvarchar(20),
@msj varchar(100) output
as

if(@NomUsu = 'Admin')
begin
	select distinct 0 Cd_GA, a.Cd_MN, a.Nombre, a.Estado from Menu a
	where a.Estado = 1
	order by a.Cd_MN
end
else
begin
	--declare @nivel varchar(100)
	--select @nivel = Nivel from Usuario
	--where NomUsu = @NomUsu

	/*select 0 Cd_GA, Cd_MN, Nombre, Estado from Menu where Cd_MN in (
		select distinct Cd_MN from AccesoM where Cd_GA in 
		(
			select distinct Cd_GA from AccesoE where Cd_Prf in
			(
				select Cd_Prf from Perfil
				where NivUsuCrea like @nivel + '%' or NivUsuCrea = @nivel
			)
		) and Estado = 1
	) and Estado = 1
	order by Cd_MN
	*/
	select 0 Cd_GA, Cd_MN, Nombre, Estado from Menu where Cd_MN in (
		select distinct Cd_MN from AccesoM where Cd_GA in(
			select distinct Cd_GA from AccesoE where Cd_Prf in (
				select Cd_Prf from Usuario where NomUsu = @NomUsu)
			)
		and Estado = 1)
	and Estado = 1 
	order by Cd_MN
end

--Leyenda--
-- MP 2011/06/14 : <Creacion del procedimiento almacenado>
-- MP 28-09-2011 : <Modificacion del procedimiento almacenado> 

GO
