SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [user321].[Rpt_RegistroCompras_X_Usu]
@RucE nvarchar(11),
@Ejer nvarchar(4),
@Rprdo1 nvarchar(2),
@Rprdo2 nvarchar(2),
@msj varchar(100) output
as
select 	com.RegCtb, Convert(nvarchar,com.FecMov,103) as FecED, Convert(nvarchar,com.FecVD,103) as FecVD ,
	com.Cd_TD, com.NroSre,com.NroDoc, prov.Cd_TDI, prov.NDoc,case(len(isnull(prov.RSocial,''))) when 0 then isnull(prov.ApPat,'')+' ' +isnull(prov.ApMat,'')+', '+isnull(prov.Nom,'') else prov.RSocial end as Proveedor,
	com.BIM_S,com.IGV_S,com.BIM_E,com.IGV_E,com.BIM_C,com.IGV_C,com.CamMda,com.Total,com.DR_NroDet,Convert(nvarchar,com.DR_FecDet,103) as DR_FecDet,Convert(nvarchar,com.DR_FecED,103) as DR_FecED,
	com.DR_CdTD,com.DR_NSre,com.DR_NDoc,  com.UsuCrea as Grupo
from 	Compra com left join Proveedor2 prov on prov.RucE=com.RucE and prov.Cd_Prv=com.Cd_Prv 
where 	com.RucE=@RucE and com.Ejer=@Ejer and com.Prdo >= @Rprdo1 and com.Prdo <= @Rprdo2
order by com.UsuCrea

--cabecera
declare @nom varchar(150)
set @nom=(select RSocial from Empresa Where Ruc=@RucE)
select @Rprdo1 as Rprdo1, @Rprdo2 as Rprdo2, @RucE as RucE, @Ejer as Ejer,@nom as nom
GO
