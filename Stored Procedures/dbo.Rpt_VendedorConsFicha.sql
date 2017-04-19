SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE procedure [dbo].[Rpt_VendedorConsFicha]
@RucE nvarchar(11),
@Cd_Aux nvarchar(7),
@msj varchar(100) output
as
if not exists (select * from Auxiliar where RucE=@RucE and Cd_Aux=@Cd_Aux)
	set @msj = 'Vendedor no existe'
else
	select a.*,b.Cta, c.Descrip as NomTDI, d.Nombre as NomPais
	from Auxiliar a, Vendedor b, TipDocIdn c, Pais d
	where a.RucE=@RucE and a.Cd_Aux=@Cd_Aux and a.RucE=b.RucE and a.Cd_Aux=b.Cd_Aux
		and a.Cd_TDI = c.Cd_TDI and a.Cd_Pais = d.Cd_Pais

print @msj
------CODIGO DE MODIFICACION--------
--CM=MG01
GO
