SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Seg_GrupoAccxPerfilConsAll]
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
		select distinct g.Cd_GA, g.Descrip, g.Estado from GrupoAcceso g
		order by 2
	--end
	--else
	--begin
	--	select distinct g.Cd_GA, g.Descrip, g.Estado from GrupoAcceso g
	--	inner join AccesoE a on  g.Cd_GA = a.Cd_GA
	--	where Cd_Prf = @Cd_Prf and RucE = @RucE
	--	order by 2
	--end
end
--Leyenda

--MP : 27/03/2011 : <Creacion del procedimiento almacenado>
--MP : 28/03/2011 : <Modificacion del procedimiento almacenado>
--MP : 16/04/2011 : <Modificacion del procedimiento almacenado>
/*
	select distinct g.Cd_GA, g.Descrip, g.Estado, a.Cd_Prf, a.RucE from GrupoAcceso g
	inner join AccesoE a on  g.Cd_GA = a.Cd_GA
	where Cd_Prf = '004' and RucE = '20538866556'
	order by 2
*/


GO
