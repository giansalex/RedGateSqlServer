SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Seg_AccesoExPerfil]  
@Cd_Prf nvarchar(3),
@msj varchar(100) output
as

if not exists (select top 1 * from Perfil where Cd_Prf = @Cd_Prf)
	set @msj='No se encontro el perfil'
else
begin
	if @Cd_Prf = '001'
	begin
		select '' Cd_Prf, Ruc, '' Cd_GA, RSocial from Empresa
		order by 4
	end
	else
	begin
		select a.Cd_Prf, a.RucE, a.Cd_GA, e.RSocial from AccesoE a
		inner join Empresa e on e.Ruc = a.RucE
		where Cd_Prf = @Cd_Prf
		order by 4
	end
end
--Leyenda

--MP : 25/03/2011 : <Creacion del procedimiento almacenado>


GO
