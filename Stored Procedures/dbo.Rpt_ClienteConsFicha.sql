SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Rpt_ClienteConsFicha]
@RucE nvarchar(11),
@Cd_Clt char(10),
@msj varchar(100) output
as
--if not exists (select * from Auxiliar where RucE=@RucE and Cd_Aux=@Cd_Aux)
if not exists (select * from Cliente2 c2 where c2.RucE=@RucE and c2.Cd_Clt=@Cd_Clt)
	set @msj = 'Cliente no existe'
else
--Codigo Modificado
--select a.*,b.Cta, c.Descrip as NomTDI, d.Nombre as NomPais
--	from Auxiliar a, Cliente b, TipDocIdn c, Pais d
--	where a.RucE=@RucE and a.Cd_Aux=@Cd_Aux and a.RucE=b.RucE and a.Cd_Aux=b.Cd_Aux
--		and a.Cd_TDI = c.Cd_TDI and a.Cd_Pais = d.Cd_Pais

	select c2.*,c2.CtaCtb, c.Descrip as NomTDI, d.Nombre as NomPais
	from Cliente2 c2, TipDocIdn c, Pais d
	where c2.RucE=@RucE and c2.Cd_Clt=@Cd_Clt 
		and c2.Cd_TDI = c.Cd_TDI and c2.Cd_Pais = d.Cd_Pais

print @msj

--Leyenda
--CAM 16/09/2010 Modificado > 	Se elimino la tabla Auxiliar
--				Se agrego la tabla Cliente2

--select * from Cliente2
--exec Rpt_ClienteConsFicha '11111111111','CLT0000008',''

GO
