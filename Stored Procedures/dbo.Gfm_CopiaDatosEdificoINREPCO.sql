SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE procedure [dbo].[Gfm_CopiaDatosEdificoINREPCO]
@RucEDesde nvarchar(22),
@RucE nvarchar(22)
as

--declare @RucEDesde nvarchar(22)
--declare @RucE nvarchar(22)
--select * from Empresa where Ruc = '00000000130'
--set @RucEDesde = '00000000010'
--set @RucE = '00000000131'

--Copia de Campos Adicionales
insert into CfgCampos
select 
@RucE RucE,--> Hacia donde
Id_CTb,
Id_TDt,
Nom,
ValorDef,
MaxCarac,
IB_Oblig,
IB_Hab,
MinDate,
MaxDate,
ValList,
Fmla
from CfgCampos where RucE= @RucEDesde--> Desde donde

--PROPIETARIOS
declare @cd_TipManP char(2)
set @cd_TipManP = dbo.Cd_TM(@RucE)

insert into TipMant values(
@RucE,
@cd_TipManP,
'Propietario',
0,
1
)

--INQUILINOS
declare @cd_TipManI char(2)
set @cd_TipManI =  dbo.Cd_TM(@RucE)

insert into TipMant values(
@RucE,
@cd_TipManI,
'Inquilino',
0,
1
)

--CREA PLAN DE CTAS
insert into PlanCtas
select
@RucE RucE,
Ejer,
NroCta,
NomCta,
Nivel,
IB_Aux,
IB_CC,
IB_DifC,
IC_ACV,
IC_ASM,
IB_GCB,
IB_Psp,
IB_CtaD,
IB_MdVta,
IB_MdCom,
IB_MdCtb,
IB_MdTsr,
IB_MdPrs,
IB_MdInv,
Cd_Blc,
Cd_EGPN,
Cd_EGPF,
IB_CtasXCbr,
IB_CtasXPag,
Estado,
Cd_Mda,
IC_IEF,
IC_IEN,
NroCtaH1,
NomCtaH1,
NroCtaH2,
NomCtaH2,
IB_PFC,
IB_NDoc
from PlanCtas where RucE= @RucEDesde--> Desde donde
and NroCta <> '9999999999'

--CREA AMARRE CTA
--select * from PlanCtasDef where RucE = '00000000015'
/*
update PlanCtasDef
select 
@RucE RucE,
Ejer,
IGV,
ISC,
QCtg,
RCons,
Perc,
Det,
Ret,
LCm,
DC_MN,
DC_ME,
DP_MN,
DP_ME,
DCPer,
DCGan,
IN_DigCls 
from PlanCtasDef where RucE = @RucEDesde
*/

--CREA MOTIVO INGRESO SALIDA
insert into MtvoIngSal
select 
@RucE RucE,
Cd_MIS,
Descrip,
Cd_TM,
Estado,
Tutorial,
IC_ES
from MtvoIngSal where RucE= @RucEDesde--> Desde donde

--CREA ASIENTO
insert into Asiento
select 
@RucE RucE,
Cd_MIS,
'2011' Ejer,
Item,
Cta,
CtaME,
IC_JDCtaPA,
IC_CaAb,
IN_TipoCta,
Cd_IV,
Porc,
Fmla,
FmlaUsu,
IC_PFI,
Glosa,
GlosaUsu,
IC_VFG,
Cd_CC,
Cd_SC,
Cd_SS,
IC_JDCC,
IB_Aux,
IB_EsDes,
IB_JalaAmr,
Cd_IA
from Asiento where RucE= @RucEDesde--> Desde donde

--CREA SERIE
insert into Serie
select 
@RucE RucE,
Cd_Sr,
Cd_TD,
NroSerie,
PtoEmision
from Serie where RucE= @RucEDesde--> Desde donde

--CREA NUMERACION 
insert into Numeracion
select 
@RucE RucE,
Cd_Num,
Cd_Sr,
Desde,
Hasta,
NroAutSunat
from Numeracion where RucE= @RucEDesde--> Desde donde

--CREAR VENDEDORES
insert into Vendedor2
select 
@RucE RucE,
Cd_Vdr,
Cd_TDI,
NDoc,
RSocial,
ApPat,
ApMat,
Nom,
Cd_Pais,
Ubigeo,
Direc,
Telf1,
Telf2,
Correo,
Cargo,
Obs,
Cd_CGV,
Cd_Ct,
Estado,
CA01,
CA02,
CA03,
CA04,
CA05,
CA06,
CA07,
CA08,
CA09,
CA10
from Vendedor2 where RucE= @RucEDesde--> Desde donde


--CREAR SERVICIOS
insert into Servicio2
select 
@RucE RucE,
Cd_Srv,
CodCo,
Nombre,
Descrip,
NCorto,
Cta1,
Cta2,
Img,
Cd_GS,
Cd_CGP,
Cd_CC,
Cd_SC,
Cd_SS,
IC_TipServ,
UsuCrea,
UsuMdf,
FecReg,
FecMdf,
Estado,
CA01,
CA02,
CA03,
CA04,
CA05,
CA06,
CA07,
CA08,
CA09,
CA10
from Servicio2 where RucE= @RucEDesde--> Desde donde

insert into PrecioSrv
select 
@RucE RucE,
ID_PrSv,
Cd_Srv,
Descrip,
Cd_Mda,
PVta,
IB_IncIGV,
IB_Exrdo,
ValVta,
IC_TipDscto,
Dscto,
IC_TipVP,
MrgInf,
MrgSup,
Estado
from PrecioSrv where RucE= @RucEDesde--> Desde donde

--select * from Proveedor2 where RucE = '00000000131'
insert into Proveedor2
select 
@RucE RucE,
Cd_Prv,
Cd_TDI,
NDoc,
RSocial,
ApPat,
ApMat,
Nom,
Cd_Pais,
CodPost,
Ubigeo,
Direc,
Telf1,
Telf2,
Fax,
Correo,
PWeb,
Obs,
CtaCtb,
Estado,
CA01,
CA02,
CA03,
CA04,
CA05,
CA06,
CA07,
CA08,
CA09,
CA10,
IB_SjDet,
Cd_TPrv,
FecReg,
UsuCrea,
FecMdf,
UsuMdf
from Proveedor2 where RucE= @RucEDesde --> Desde donde

GO
