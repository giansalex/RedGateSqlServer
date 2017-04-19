SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE Procedure [dbo].[Rpt_ImpLetrasGeneral]
--declare 
@RucE nvarchar(11),
@Ejer nvarchar(4),
@Cd_Cnj nvarchar(10),
@NroLtr nvarchar(10), 
@msj nvarchar(100) output
--set @RucE = '11111111111'
--set @Ejer = '2012'
--set @Cd_Cnj = '0000000001'
--set @NroLtr = '0000000009'
--exec Rpt_ImpLetrasGeneral '11111111111','2012','0000000001','',null
as

select
cj.RucE,
cj.Ejer,
cj.Cd_Clt,
case when ISNULL(clt.RSocial,'') = '' then clt.ApPat +' '+ clt.ApMat+' '+ clt.Nom else clt.RSocial end as NomCliente,
ISNULL(clt.NDoc,'') as NDocCli,
ISNULL(clt.Ubigeo,'') as UbigeoCli,
ISNULL(clt.Direc,'') as DirecCli,
ISNULL(clt.Telf1,'') as TelfCli,
ISNULL(clt.Fax,'') as FaxCli,
ISNULL(clt.Correo,'') as CorreoCli,
cj.Cd_Cnj,
cj.Cd_MIS,
--Convert(nvarchar,cj.FecMov,103) as FecMov,
cj.FecMov,
cj.Cd_Mda,
cj.TipCam,
lc.NroLtr,
isnull(lc.NroRenv,'') as NroRenv,
isnull(lc.RefGdor,'') as RefGirador,
isnull(lc.LugGdor,'') as LugarGirador,
--convert(nvarchar,lc.FecReg,103) as FecReg,
--convert(nvarchar,lc.FecGiro,103) as FecGiro,
--convert(nvarchar,lc.FecVenc,103) as FecVenc,
lc.FecReg,
lc.FecGiro,
lc.FecVenc,
ISNULL(lc.Plazo,0) as DiasPlazo,
--convert(nvarchar,lc.FecMdf,103) as FecMdf,
lc.FecMdf,
ISNULL(lc.Imp,0) as IMP,
ISNULL(lc.Dsct,0) as Dscto,
isnull(lc.Total,0) as Total,
isnull(cj.Obs,'') as ObsCj,
/*campos adicionales de Letra_Cobro*/
isnull(lc.CA01,'--') as CA01LC, 
isnull(lc.CA02,'--') as CA02LC,
isnull(lc.CA03,'--') as CA03LC,
isnull(lc.CA04,'--') as CA04LC,
isnull(lc.CA05,'--') as CA05LC,
isnull(lc.CA06,'--') as CA06LC,
isnull(lc.CA07,'--') as CA07LC,
isnull(lc.CA08,'--') as CA08LC,
isnull(lc.CA09,'--') as CA09LC,
isnull(lc.CA10,'--') as CA10LC

from Letra_Cobro lc
left join Canje cj on lc.RucE = cj.RucE and lc.Cd_Cnj = cj.Cd_Cnj 
left join Cliente2 clt on lc.RucE = clt.RucE and cj.Cd_Clt = clt.Cd_Clt
--where lc.RucE = '11111111111' and cj.Ejer = '2012' and lc.Cd_Cnj = '0000000001' and lc.NroLtr = '0000000001'
where 
lc.RucE = @RucE 
and cj.Ejer = @Ejer 
and lc.Cd_Cnj = @Cd_Cnj 
and case when isnull(@NroLtr,'') <> '' then lc.NroLtr else '' end = isnull(@NroLtr,'')

if @@ROWCOUNT = 0
begin
	set @msj = 'Error en la Consulta de Letras'
end
GO
