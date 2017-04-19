SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Vta_GrupoSrvCons]
@RucE nvarchar(11),
@TipCons int,
@msj varchar(100) output
as
/*if not exists (select top 1 * from GrupoServ where RucE=@RucE)
	set @msj = 'No se encontro Grupo Servicio'
else	*/
begin
	if(@TipCons=0)
		select * from GrupoSrv where RucE=@RucE
	else select Cd_GS+'  |  '+Descrip as CodNom,Cd_GS,Descrip from GrupoSrv where RucE=@RucE and Estado=1
end
print @msj
GO
