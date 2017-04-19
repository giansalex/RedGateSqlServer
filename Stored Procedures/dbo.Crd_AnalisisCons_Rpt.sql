SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROC [dbo].[Crd_AnalisisCons_Rpt]

@RucE nvarchar(11),
@Ejer nvarchar(4),
@Cd_ACrd int,
@msj varchar(100) output

As

select 
c.RucE,e.RSocial, 
c.Ejer,
Convert(Nvarchar,c.FecMov,103) as FecMov,
case when isnull(clt.RSocial,'')<>'' then clt.RSocial else clt.ApPat + ' ' + clt.ApMat + ' ' +clt.Nom end as Cliente,
isnull(clt.Direc,'') as Direccion,
isnull(c.TipoVivienda,'') as TipoVivienda,
isnull(c.EstCivil,'') as EstadoCivil,
isnull(c.CantFam,0) as CantFam,
isnull(c.CantHijos,0) as CantHijos,
isnull(c.Sexo,'') as Genero,
isnull(c.Ren01,0.00) as Ren01,
isnull(c.Ren02,0.00) as Ren02,
isnull(c.Ren03,0.00) as Ren03,
isnull(c.Ren04,0.00) as Ren04,
isnull(c.Ren05,0.00) as Ren05,
isnull(c.OtrosIng,0.00) as OtrosIngresos,
isnull(c.TotalIng,0.00) as TotalIngreso,
isnull(c.CanastaFam,0.00) as CanastaFam,
isnull(c.Vivienda,0.00) as Vivienda,
isnull(c.Colegio,0.00) as Colegio,
isnull(c.PrestamoBan,0.00) as PrestamoBan,
isnull(c.CreditoBan,0.00) as CreditoBan,
isnull(c.OtrosEgr1,0.00) as OtrosEgr1,
isnull(c.OtrosEgr2,0.00) as OtrosEgr2,
isnull(c.TotalEgr,0.00) as TotalEgr,
--isnull(c.SaldoDisp,0.00) as Ren01,
isnull(c.SaldoDisp,0.00) as SaldoDisp,
isnull(c.PorcDisp,0.00) as PorcDisp,
isnull(c.ImpDisp,0.00) as ImpDisp,
isnull(c.ValorCrd,0.00) as ValorCrd,
isnull(c.TasaAnu,0.00) as TasaAnu,
isnull(c.ValorTasa,0.00) as ValorTasa,
isnull(c.TotalCrd,0.00) as TotalCrd,
isnull(c.NroCuotas,0) as NroCuotas,
isnull(c.CuotaMen,0) as CoutaMen,
isnull(c.CA01,'') as CA01,
isnull(c.CA02,'') as CA02,
isnull(c.CA03,'') as CA03,
isnull(c.CA04,'') as CA04,
isnull(c.CA05,'') as CA05,
isnull(c.CA06,'') as CA06,
isnull(c.CA07,'') as CA07,
isnull(c.CA08,'') as CA08,
isnull(c.CA09,'') as CA09,
isnull(c.CA10,'') as CA10,
isnull(c.CA11,'') as CA11,
isnull(c.CA12,'') as CA12,
isnull(c.CA13,'') as CA13,
isnull(c.CA14,'') as CA14,
isnull(c.CA15,'') as CA15,
isnull(c.CA16,'') as CA16,
isnull(c.CA17,'') as CA17,
isnull(c.CA18,'') as CA18,
isnull(c.CA19,'') as CA19,
isnull(c.CA20,'') as CA20
from CreditoAnalisis c
Left join Empresa e on e.Ruc= c.RucE
Left join Cliente2 clt on c.RucE = clt.RucE and c.Cd_Clt = clt.Cd_Clt
Where
	c.RucE=@RucE and c.Ejer=@Ejer and c.Cd_ACrd=@Cd_ACrd

-- Leyenda --
-- DI : 01/12/2011 <Creacion del SP>
	
GO
