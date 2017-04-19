SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE procedure [dbo].[Vta_CampoCons]  --Consulta solo los campos activos para el frm de Ventas
@RucE nvarchar(11),
@msj varchar(100) output
as
/*if not exists (select top 1 * from Campo where RucE=@RucE)
	set @msj = 'Campo no se encontro'
else */ select a.RucE,a.Cd_Cp,a.Nombre as Nombre, a.NCorto,a.Cd_TC,b.Nombre as TNom,Estado from Campo a, CampoT b where RucE=@RucE and a.Cd_TC=b.Cd_TC and Estado=1
print @msj
GO
