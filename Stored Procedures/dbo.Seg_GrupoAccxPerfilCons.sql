SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Seg_GrupoAccxPerfilCons]
@NomUsu nvarchar(20),
@Cd_Prf nvarchar(3),
@msj varchar(100) output,
@RucE nvarchar(11)
as

if not exists (select top 1 * from Perfil where Cd_Prf = @Cd_Prf)
	set @msj='No se encontro el perfil'
else
begin
	--if @Cd_Prf = '001'
	--begin
	--	select distinct g.Cd_GA, g.Descrip, g.Estado from GrupoAcceso g
	--	order by 2
	--end
	--else
	--begin
		declare @nivel nvarchar(100)
		select @nivel = Nivel
		from Usuario
		where NomUsu = @NomUsu
	
		if(@NomUsu != '')
			select distinct g.Cd_GA, g.Descrip, g.Estado from GrupoAcceso g
			left join AccesoE a on  g.Cd_GA = a.Cd_GA
			where (Cd_Prf = @Cd_Prf and RucE = @RucE) or g.NivUsuCrea = @nivel
			order by 2
		else
			select distinct g.Cd_GA, g.Descrip, g.Estado from GrupoAcceso g
			inner join AccesoE a on  g.Cd_GA = a.Cd_GA
			where Cd_Prf = @Cd_Prf and RucE = @RucE
			order by 2
	--end
end
--Leyenda

--MP : 27/03/2011 : <Creacion del procedimiento almacenado>
--MP : 28/03/2011 : <Modificacion del procedimiento almacenado>
--MP : 16/04/2011 : <Modificacion del procedimiento almacenado>
--MP : 28/09/2011 : <Modificacion del procedimiento almacenado>
/*
	declare @nivel nvarchar(100)
		select @nivel = Nivel
		from Usuario
		where NomUsu = 'C.GIOVANNA'
	
	print @nivel
		
	select distinct g.Cd_GA, g.Descrip, g.Estado from GrupoAcceso g
		left join AccesoE a on  g.Cd_GA = a.Cd_GA
		where (Cd_Prf = '320' and RucE = '66666666666') or g.NivUsuCrea = '0101229'
		order by 2
		
exec Seg_GrupoAccxPerfilCons 'C.GIOVANNA', '119', null, '20111175382'

*/
GO
