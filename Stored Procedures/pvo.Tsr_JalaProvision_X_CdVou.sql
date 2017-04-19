SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [pvo].[Tsr_JalaProvision_X_CdVou] -->Solo jala un registro
@RucE nvarchar(11),
@Ejer nvarchar(4),
@Cd_Vou int,
--@RegCtb nvarchar(15),
--@PrdoIni nvarchar(2),
--@PrdoFin nvarchar(2),
@msj varchar(100) output
as
if not exists (select top 1 * from Voucher where RucE = @RucE /*and Ejer=@Ejer*/ and Cd_Vou=@Cd_Vou) --and exists (select * from CampoV where RucE=@RucE)
	set @msj = 'Registro no existe'
-- Lo de abajo se pudo haber validado asi tb: select top 1 * from Voucher v, PlanCtas p where v.RucE = @RucE and v.RucE = p.RucE /*and Ejer=@Ejer*/ and Cd_Vou=@Cd_Vou and v.NroCta = p.NroCta and (IB.CtaxCbr=1 or IB.CtaxPag=1)
--else if not exists (select top 1 * from Voucher where RucE = @RucE /*and Ejer=@Ejer*/ and Cd_Vou=@Cd_Vou /*and left(NroCta,2)in ('42','12')*/ )
--	set @msj = 'No se puede jalar registro contable'
else if (select top 1 IB_Cndo from Voucher where RucE = @RucE /*and Ejer=@Ejer*/ and Cd_Vou=@Cd_Vou  /*and left(NroCta,2)in ('42','12')*/) = 1
	set @msj = 'Documento ya fue cancelado'
else
	begin
	
	declare @Cd_Prv nvarchar(7)
	set @Cd_Prv = (select top 1 Cd_Prv from Voucher where RucE = @RucE and Cd_Vou = @Cd_Vou)
	--print @Cd_Prv

	if @Cd_Prv is null or rtrim(@Cd_Prv) = ''
		begin
		--print 'Llegue'
		select 
			vou.RucE, --vou.Cd_Vou, vou.Ejer, vou.Prdo, 
			vou.Cd_Vou, 
			vou.RegCtb, 
			--vou.Cd_Fte, 
			convert(varchar(10),vou.FecMov,103) as FecMov,
			convert(varchar(10),vou.FecCbr,103) as FecCbr,
			/*vou.Cd_Aux, */
			--vou.Cd_Clt as Cd_Aux, --Se tiene que renombrar la columna y cambiar el enlaze en la progra
			vou.Cd_Clt,
			null as Cd_Prv, --Nos cerciorarnos que mande null
			cl2.Cd_TDI, 
			cl2.NDoc,
		
			case(isnull(len(cl2.RSocial),0)) 
				when 0 then isnull(nullif(cl2.ApPat +' '+cl2.ApMat+' '+cl2.Nom,''),'------- SIN NOMBRE ------')
				else cl2.RSocial end as NomAux,
		
			/*cl2.ApPat+' '+cl2.ApMat+' '+cl2.Nom as NomAux,*/
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
			left join Cliente2 cl2 on cl2.RucE = vou.RucE and cl2.Cd_Clt = vou.Cd_Clt
			left join TipDoc td on vou.Cd_TD=td.Cd_TD	
			left join Area ar on vou.RucE=ar.RucE and vou.Cd_Area=ar.Cd_Area
			left join Modulo md on  vou.Cd_MR=md.Cd_MR
			left join TipGasto tg on  vou.Cd_TG=tg.Cd_TG
			left join Moneda moor on  vou.Cd_MdOr=moor.Cd_Mda
			left join Moneda morg on  vou.Cd_MdRg=morg.Cd_Mda
			where vou.RucE=@RucE /*and vou.Ejer=@Ejer*/ and  vou.Cd_Vou=@Cd_Vou /*and left(NroCta,2)in ('42','12')*/ order by Cd_Vou 
		--	where vou.RucE=@RucE and vou.Ejer=@Eje and vou.Prdo between @PrdoIni and @PrdoFin order by Cd_Vou
		end
	else
		begin
		--print 'Llegue proveedor'
		select 
			vou.RucE, --vou.Cd_Vou, vou.Ejer, vou.Prdo, 
			vou.Cd_Vou, 
			vou.RegCtb, 
			--vou.Cd_Fte, 
			convert(varchar(10),vou.FecMov,103) as FecMov,
			convert(varchar(10),vou.FecCbr,103) as FecCbr,
			/*vou.Cd_Aux,*/
			--vou.Cd_Prv as Cd_Aux, --Se tiene que renombrar la columna y cambiar el enlaze en la progra
			null as Cd_Clt, --Nos cerciorarnos que mande null
			vou.Cd_Prv,
			pv2.Cd_TDI, 
			pv2.NDoc,
		
			case(isnull(len(pv2.RSocial),0)) 
				when 0 then isnull(nullif(pv2.ApPat +' '+pv2.ApMat+' '+pv2.Nom,''),'------- SIN NOMBRE ------')
				else pv2.RSocial end as NomAux,
		
			/*pv2.RSocial as NomAux,*/
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
			left join Proveedor2 pv2 on pv2.RucE=vou.RucE and pv2.Cd_Prv = vou.Cd_Prv
			left join TipDoc td on vou.Cd_TD=td.Cd_TD	
			left join Area ar on vou.RucE=ar.RucE and vou.Cd_Area=ar.Cd_Area
			left join Modulo md on  vou.Cd_MR=md.Cd_MR
			left join TipGasto tg on  vou.Cd_TG=tg.Cd_TG
			left join Moneda moor on  vou.Cd_MdOr=moor.Cd_Mda
			left join Moneda morg on  vou.Cd_MdRg=morg.Cd_Mda
			where vou.RucE=@RucE /*and vou.Ejer=@Ejer*/ and  vou.Cd_Vou=@Cd_Vou /*and left(NroCta,2)in ('42','12')*/ order by Cd_Vou 
		--	where vou.RucE=@RucE and vou.Ejer=@Eje and vou.Prdo between @PrdoIni and @PrdoFin order by Cd_Vou
		end
	
	end

print @msj

--Pruebas:
-- exec pvo.Tsr_JalaProvision_X_CdVou '11111111111','2010',19773,null




--PV: MIE 19/06/09 --> Creado,
--PV: VIE 22/01/2010 --> Mdf: Para que NO tome en cuenta el Ejer, xq sino no se puede jalar facturas de aÃƒÂ±os anteriores.
--PV: JUE 18/08/2010 --> Mdf: Para que no tome en cuenta left(NroCta,2)in ('42','12'), como ya se tiene el Cd_Vou ya no es necesario (esto mas depende de donde se cojio el Cd_Vou para enviarlo a este SP)
--MP: JUE 16/09/2010 --> Mdf:  Se quito las referencias a la tabla auxiliar y se relaciono con Cliente y Proveedor
--CM: RA01
--PV: JUE 18/11/2010 -- Pruebas Columnas Cd_Clt, Cd_Prv




GO
