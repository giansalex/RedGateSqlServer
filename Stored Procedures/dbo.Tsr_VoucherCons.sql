SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Tsr_VoucherCons]
@RucE nvarchar(11),
@Eje nvarchar(4),
@PrdoIni nvarchar(2),
@PrdoFin nvarchar(2),
@msj varchar(100) output

as
if exists (select top 1 * from Voucher where RucE = @RucE and Ejer=@Eje) --and exists (select * from CampoV where RucE=@RucE) --> ESTO NO VAAAA
begin
	print 'entro'
select 
	vou.RucE, --Ruc de la empresa
	vou.Cd_Vou, --Codigo del voucher
	vou.RegCtb, --Registro Contable
	vou.Cd_Fte, --Codigo Fuente
	vou.NroCta, --Numero Cuenta
	pcta.NomCta, --Nombre de la cuenta
	vou.MtoD, --Monto Debe
	vou.MtoH, --Monto Haber
	vou.MtoD_ME, --Monto Debe Moneda Extranjera
	vou.MtoH_ME, --Monto Haber Moneda Extranjera
	vou.Cd_MdRg, --Codigo Moneda Registro
	morg.Simbolo as SimMdRg, --Simbolo de la moneda
	vou.CamMda, --Tipo de cambio 
	vou.IC_TipAfec, --Indicador Tipo Afecto
	vou.IB_EsProv, --Indicador si es provicion

	vou.Ejer, --Ejericio o aÃƒÆ’Ã‚Â±o de registro
	vou.Prdo, --Periodo de registro
	convert(varchar(10),vou.FecMov,103) as FecMov, --Fecha de movimiento del registro
	vou.Glosa, --Glosa
	convert(varchar(10),vou.FecCbr,103) as FecCbr, --Fecha de Cobro
	c2.Cd_TDI,c2.NDoc,vou.Cd_Clt as Cd_Aux, case(isnull(len(c2.RSocial),0))
					when 0 then c2.ApPat+' '+c2.ApMat+' '+c2.Nom
					else c2.RSocial end as NomComCte, --Datos del Cliente
	/*au.Cd_TDI,au.NDoc,vou.Cd_Aux,case(isnull(len(au.RSocial),0))
		         	     when 0 then au.ApPat+' '+au.ApMat+' '+au.Nom
			 	     else au.RSocial end as NomComCte, --Datos del cliente*/
	vou.Cd_TD, --Codigo tipo de documento
	td.Descrip as DescripTD, --Descripcion del tipo de documento
	td.NCorto as NCortoTD, --Descripcion corta del tipo de documento
	vou.NroSre, --Numero de serie
	vou.NroDoc, --Numero de documento
	vou.NroChke, --Numero de Cheque
	vou.Grdo, --Girado
	vou.IB_Conc, -- Indicador booleano conciliado
	convert(varchar(10),vou.FecED,103) as FecED, --Fecha emision del documento
	convert(varchar(10),vou.FecVD,103) as FecVD, --Fecha vencimiento del documento
	--vou.MtoOr, --Monto Origen del Documento
	--vou.Cd_MdOr, --Codigo de  moneda de origen
	--moor.Simbolo as SimMdOr,  --Simbolo de moneda de origen
	--vou.Cd_TG, --Codigo de tipo de gasto
	--tg.nombre as NomTGasto, --Nombre de tipo de gasto
	
	vou.Cd_CC, --Centro de costo
	vou.Cd_SC, --Sub Centro de Costo
	vou.Cd_SS, --Sub Sub Centro de Costo
	vou.Cd_Area, --Codigo de Area
	ar.NCorto as NCortoArea, --Nombre corta del Area
	vou.Cd_MR, --Codigo de Modulo
	md.Nombre as NomMR, --Nombre del Modulo
	
	
	--vou.FecReg,
	convert(varchar(10), vou.FecReg,103) as FecReg, 
	convert(varchar(10), vou.FecMdf,103) as FecMdf, --Fecha de Modificacion
	vou.UsuCrea, --Usuario que creo el movimiento
	vou.UsuModf, --usuario que modifico el movimiento
	convert(varchar,vou.FecReg,108) as HoraReg, --Hora de Registro del movimiento
	vou.IB_Anulado --Indicador si esta anulado
	

from Voucher vou
	left join Cliente2 c2 on c2.RucE=vou.RucE and c2.Cd_Clt=vou.Cd_Clt
	--left join Auxiliar au on vou.RucE=au.RucE and vou.Cd_Aux=au.Cd_Aux
	left join TipDoc td on vou.Cd_TD=td.Cd_TD	
	left join Area ar on vou.RucE=ar.RucE and vou.Cd_Area=ar.Cd_Area
	left join Modulo md on  vou.Cd_MR=md.Cd_MR
	left join TipGasto tg on  vou.Cd_TG=tg.Cd_TG
	left join Moneda moor on  vou.Cd_MdOr=moor.Cd_Mda
	left join Moneda morg on  vou.Cd_MdRg=morg.Cd_Mda
	left join PlanCtas pcta on vou.RucE=pcta.RucE and vou.NroCta=pcta.NroCta and pcta.Ejer=vou.Ejer
	inner join Banco ban on vou.RucE=ban.RucE and vou.NroCta=ban.NroCta and vou.Ejer=ban.Ejer
	--left join CCostos cc on  vou.Cd_CC= cc.Cd_CC
	--left join CCSub cs on  vou.Cd_SC= cs.Cd_SC
	--left join CCSubSub ss on  vou.Cd_SS= ss.Cd_SS
	where vou.RucE=@RucE and vou.Ejer=@Eje and vou.Prdo between @PrdoIni and @PrdoFin and vou.Cd_Fte='CB' order by Cd_Vou
end
print @msj

--DI: MIE  04/11/09 -->Creado : Se creo el procedimiento almacenado


GO
