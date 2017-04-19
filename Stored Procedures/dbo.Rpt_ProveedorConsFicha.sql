SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Rpt_ProveedorConsFicha]
@RucE nvarchar(11),
@Cd_Prv char(7),
@msj varchar(100) output
as
if not exists (select * from Proveedor2 where RucE=@RucE and Cd_Prv=@Cd_Prv)
	set @msj = 'Proveedor no existe'
else
	/*select a.*,b.Cta, c.Descrip as NomTDI, d.Nombre as NomPais
	from Auxiliar a, Proveedor b, TipDocIdn c, Pais d
	where a.RucE=@RucE and a.Cd_Aux=@Cd_Aux and a.RucE=b.RucE and a.Cd_Aux=b.Cd_Aux
		and a.Cd_TDI = c.Cd_TDI and a.Cd_Pais = d.Cd_Pais*/
	select 	a.*,a.CtaCtb as Cta,b.Descrip as NomTDI,c.Nombre as NomPais
	from Proveedor2 a inner join TipDocIdn b
	on a.Cd_TDI=b.Cd_TDI inner join Pais c
	on a.Cd_Pais=c.Cd_Pais
	where a.RucE=@RucE and a.Cd_Prv=@Cd_Prv

print @msj
-- Leyenda --
-- JJ: 2010-09-19:	Modificacion del SP PR03, RA01


GO
