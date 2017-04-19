SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Gsp_CampoCons]
@RucE nvarchar(11),
@TipCons int,
@msj varchar(100) output
as
/*if not exists (select top 1 * from Campo where RucE=@RucE)
	set @msj = 'Campo no se encontro'
else */
	if(@TipCons=0)
	   select a.RucE,a.Cd_Cp,a.Nombre as Nombre, a.NCorto,a.Cd_TC,b.Nombre as TNom,a.IB_Oblig,a.IB_Exp,Estado from Campo a, CampoT b where RucE=@RucE and a.Cd_TC=b.Cd_TC
/*Act*/  else  select a.RucE,a.Cd_Cp,a.Nombre as Nombre, a.NCorto,a.Cd_TC,b.Nombre as TNom,a.IB_Oblig,a.IB_Exp,Estado from Campo a, CampoT b where RucE=@RucE and a.Cd_TC=b.Cd_TC and Estado=1


print @msj
--Pv
GO
