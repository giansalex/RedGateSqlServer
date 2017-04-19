SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [pvo].[Ctb_VoucherConsUn_X_RC]  -->Solo jala un registro
@RucE nvarchar(11),
@Ejer nvarchar(4),
@RegCtb nvarchar(15),
--@PrdoIni nvarchar(2),
--@PrdoFin nvarchar(2),
@msj varchar(100) output
as
if not exists (select top 1 * from Voucher where RucE = @RucE and Ejer=@Ejer and RegCtb=@RegCtb) --and exists (select * from CampoV where RucE=@RucE)
	set @msj = 'Registro no existe'
else if not exists (select top 1 * from Voucher where RucE = @RucE and Ejer=@Ejer and RegCtb=@RegCtb and left(NroCta,2)in ('42','12') )
	set @msj = 'No se puede jalar registro contable'
else if (select top 1 IB_Cndo from Voucher where RucE = @RucE and Ejer=@Ejer and RegCtb=@RegCtb and left(NroCta,2)in ('42','12')) = 1
	set @msj = 'Documento ya fue cancelado'
else
begin
select 
	vou.RucE, --vou.Cd_Vou, vou.Ejer, vou.Prdo, 
	vou.Cd_Vou, 
	vou.RegCtb, 
	--vou.Cd_Fte, 
	convert(varchar(10),vou.FecMov,103) as FecMov,
	convert(varchar(10),vou.FecCbr,103) as FecCbr,
	--vou.Cd_Aux, 
	vou.Cd_Clt,
	vou.Cd_Prv,
	case(isnull(len(vou.Cd_Clt),0)) when 0 then p.Cd_TDI else c.Cd_TDI end as Cd_TDI,
    	case(isnull(len(vou.Cd_Clt),0)) when 0 then p.NDoc else c.NDoc end as NDoc,
	case(isnull(len(vou.Cd_Clt),0)) when 0 then case(isnull(len(p.RSocial),0)) 
    	when 0 then isnull(nullif(p.ApPat +' '+p.ApMat+' '+p.Nom,''),'------- SIN NOMBRE ------')
    	else p.RSocial  end  else case(isnull(len(c.RSocial),0)) when 0 then 
	isnull(nullif(c.ApPat +' '+c.ApMat+' '+c.Nom,''),'------- SIN NOMBRE ------')
    	else c.RSocial end end as NomAux,
	--au.Cd_TDI, au.NDoc,
	--case(isnull(len(au.RSocial),0)) when 0 then au.ApPat+' '+au.ApMat+' '+au.Nom
	--else au.RSocial end as NomAux,


	vou.NroCta,
	vou.Cd_TD, td.Descrip as DescripTD, td.NCorto as NCortoTD,
	vou.NroSre, vou.NroDoc, 
	convert(varchar(10),vou.FecED,103) as FecED,
	convert(varchar(10),vou.FecVD,103) as FecVD,
	vou.Glosa, vou.MtoOr, vou.MtoD, vou.MtoH,
	--vou.Cd_MdOr, moor.Simbolo as SimMdOr,
	vou.Cd_MdRg, morg.Simbolo as SimMdRg,
	vou.CamMda, 
	vou.MtoD_ME, vou.MtoH_ME,
	vou.Cd_CC, vou.Cd_SC, 
	vou.Cd_SS, vou.Cd_Area, ar.NCorto as NCortoArea,
	vou.Cd_MR, md.Nombre as NomMR,
	vou.IC_TipAfec,
	vou.TipOper, 
	vou.NroChke, 
	vou.Grdo, 
	vou.Cd_TG, tg.nombre as NomTGasto,
	vou.FecReg, vou.FecMdf,
	vou.UsuCrea, vou.UsuModf, vou.IB_Anulado


from Voucher vou
	--left join Auxiliar au on vou.RucE=au.RucE and vou.Cd_Aux=au.Cd_Aux
	left join proveedor2 p on p.RucE=vou.RucE and p.Cd_Prv=vou.Cd_Prv
	left join Cliente2 c on c.RucE=vou.RucE and vou.Cd_Clt=c.Cd_Clt
	left join TipDoc td on vou.Cd_TD=td.Cd_TD	
	left join Area ar on vou.RucE=ar.RucE and vou.Cd_Area=ar.Cd_Area
	left join Modulo md on  vou.Cd_MR=md.Cd_MR
	left join TipGasto tg on  vou.Cd_TG=tg.Cd_TG
	left join Moneda moor on  vou.Cd_MdOr=moor.Cd_Mda
	left join Moneda morg on  vou.Cd_MdRg=morg.Cd_Mda
	where vou.RucE=@RucE and vou.Ejer=@Ejer and RegCtb=@RegCtb and left(NroCta,2)in ('42','12') order by Cd_Vou 
--	where vou.RucE=@RucE and vou.Ejer=@Eje and vou.Prdo between @PrdoIni and @PrdoFin order by Cd_Vou

end


--Pruebas
--Comprobamos que estos 2 SPs den el mismo resultado
--exec pvo.Ctb_VoucherConsUn_X_RC '11111111111','2010','CTGE_RC10-00011', null
--exec pvo.Tsr_JalaProvision_X_CdVou '11111111111','2010',19773,null

--select *from voucher where Ruce='11111111111'

print @msj
--PV: MIE 17/03/09 --> Creado,
--PV: VIE 19/06/09 --> Modf, --> no jalaba por ejercicio
--KK: VIE 17/09/10 --> modf, --> se comento lineas relacionadas con tabla auxiliar
--PV: JUE 18/11/2010 -- Pruebas Columnas Cd_Clt, Cd_Prv
GO
