SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Seg_AccesoExPerfilConsAll]
@Cd_Prf nvarchar(3),
@msj varchar(100) output
as

if not exists (select top 1 * from Perfil where Cd_Prf = @Cd_Prf)
	set @msj='No se encontro el perfil'
else
begin
	--if @Cd_Prf = '001'
	--begin
		select distinct Ruc [RucE], '001' Cd_Prf, /*1 Cd_GA,*/ RSocial from Empresa
		order by 3
	--end
	--else
	--begin
	--	select distinct a.Cd_Prf, a.RucE, /*a.Cd_GA,*/ e.RSocial from AccesoE a
	--	inner join Empresa e on e.Ruc = a.RucE
	--	where Cd_Prf = @Cd_Prf
	--	order by 3
	--end
end
--Leyenda

--MP : 25/03/2011 : <Creacion del procedimiento almacenado>
--MP : 28/03/2011 : <Modificacion del procedimiento almacenado>
--MP : 30/03/2011 : <Modificacion del procedimiento almacenado>
--MP : 16/04/2011 : <Modificacion del procedimiento almacenado>
--EXEC dbo.Seg_AccesoExPerfilCons  '200', NULL 
/*
select a.Cd_Prf, a.RucE, a.Cd_GA, e.RSocial from AccesoE a
inner join Empresa e on e.Ruc = a.RucE
where Cd_Prf = '001' and 
a.RucE not in (select a.RucE from AccesoE a 
		inner join Empresa e on e.Ruc = a.RucE
		where Cd_Prf = '002' )
order by 4
*/




GO
