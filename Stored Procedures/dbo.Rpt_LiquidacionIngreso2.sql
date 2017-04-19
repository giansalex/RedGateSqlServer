SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
--declare @RucE nvarchar(11)
--declare @Ejer varchar(4)
--declare @PrdoI varchar(2)
--declare @PrdoF varchar(2)

----set @RucE='20504743561'
--set @RucE='20001000001'
--set @Ejer='2011'
--set @PrdoI='04'
--set @PrdoF='05'

CREATE procedure [dbo].[Rpt_LiquidacionIngreso2]
@RucE nvarchar(11),
@Ejer varchar(4),
@PrdoI varchar(2),
@PrdoF varchar(2),
@Usu nvarchar(10),
@FecI nvarchar(15),
@FecF nvarchar(15)
as


select 
	vou.RegCtb,
	vou.FecCbr,
	vou.DocCbr,
	vou.Cd_Clt,
	vou.CA01+'-'+vou.Cliente as Cliente,
	vou.Cd_Vta,
	vou.Cd_PrdSrv,
	vou.TotalItem,
	vou.FecED,
	vou.TotalVenta,
	case when month(vou.FecCbr)> Month(vou.FecED) then 'P' else 'A' end Indicador,
	convert(nvarchar,year(vou.FecED))+'-'+convert(nvarchar,month(vou.FecED)) as MesED

from( 
		select 
			vou.RegCtb,
			vou.FecCbr,
			vou.Cd_TD+'-'+vou.NroSre+'-'+vou.NroDoc DocCbr,
			vou.Cd_Clt,
			isnull(c2.CA01,'') CA01,
			case(isnull(len(c2.RSocial),0)) when 0 then isnull(c2.ApPat,'')+' '+isnull(c2.Nom,'') else c2.RSocial end as Cliente,
			vou.Cd_Vta,
			case(isnull(len(vd.Cd_Prod),0)) when 0 then vd.Cd_Srv else vd.Cd_Prod end as Cd_PrdSrv,
			vd.Total as TotalItem,
			vou.FecED,
			vou.TotalVenta	
		from (
				select 
					vou1.RucE,
					vou1.Ejer,
					vou1.RegCtb,
					Convert(nvarchar,vou1.FecMov,103) FecCbr,
					vou1.Cd_TD,
					vou1.NroSre,
					vou1.NroDoc,
					vou1.Cd_Clt,
					vou2.Cd_Vta,
					vou2.FecED,
					vou2.TotalVenta 
				from 
					voucher vou1
					inner join (
						select 
							Max(vou.RucE) RucE,
							Max(vou.Ejer) Ejer,
							vou.RegCtb,
							Max(vt.FecCbr) FecCbr,
							Max(vou.Cd_TD) Cd_TD,
							Max(vou.NroSre) NroSre,
							Max(vou.NroDoc) NroDoc,
							Max(vou.Cd_Clt) Cd_Clt,
							Max(vt.Cd_Vta) Cd_Vta,
							Max(vt.FecED) FecED,
							Max(vt.TotalVenta) TotalVenta
						from 
							voucher vou inner join (
							select 
								v.RucE, 
								v.Eje, 
								v.Cd_Vta, 
								v.RegCtb, 
								v.Total as TotalVenta,
								v.Cd_Clt, 
								Convert(nvarchar,v.FecED,103) FecED, 
								Convert(nvarchar,v.FecCbr,103) FecCbr,
								V.Cd_TD, 
								v.NroSre, 
								v.NroDoc
							from 
								Venta v 
							where 
								v.RucE=@RucE and v.Eje=@Ejer 
							) as vt on vt.RucE=vou.RucE and vt.Eje=vou.Ejer and vt.RegCtb=vou.RegCtb
						where 
							vou.RucE=@RucE
							and vou.Ejer=@Ejer 
							--and vou.Prdo between @PrdoI and @PrdoF
							--and vou.FecMov between @FecI and @FecF
							--and vou.IC_TipAfec is not null
							and vou.Cd_Fte='RV'
						group by vou.RegCtb
						) as vou2 on vou2.RucE=vou1.RucE and vou2.Ejer=vou1.Ejer and vou1.Cd_TD=Vou2.Cd_TD and vou1.NroSre=vou2.NroSre and vou1.NroDoc=vou2.NroDoc
				where 
					vou1.RucE=@RucE 
					and vou1.Ejer=@Ejer 
					and vou1.Cd_Fte='CB'
					--and vou1.Prdo between @PrdoI and @PrdoF
					and vou1.FecMov between @FecI and @FecF
				) as vou inner join Cliente2 c2 on c2.RucE=vou.RucE and c2.Cd_Clt=vou.Cd_Clt
				inner join VentaDet vd on vd.RucE=vou.RucE and vd.Cd_Vta=vou.Cd_Vta
		) as vou 

/****************CAntidad de Columnas a Crear para el reporte*****************/	

select Cd_PrdSrv,Max(NProdServ) NProdServ
from
(select 
	vou.RegCtb,
	vou.FecCbr,
	vou.DocCbr,
	vou.Cd_Clt,
	vou.CA01+'-'+vou.Cliente as Cliente,
	vou.Cd_Vta,
	vou.Cd_PrdSrv,
	vou.NProdServ,
	vou.TotalItem,
	vou.FecED,
	vou.TotalVenta
from( 
		select 
			vou.RegCtb,
			vou.FecCbr,
			vou.Cd_TD+'-'+vou.NroSre+'-'+vou.NroDoc DocCbr,
			vou.Cd_Clt,
			isnull(c2.CA01,'') CA01,
			case(isnull(len(c2.RSocial),0)) when 0 then isnull(c2.ApPat,'')+' '+isnull(c2.Nom,'') else c2.RSocial end as Cliente,
			vou.Cd_Vta,
			case(isnull(len(vd.Cd_Prod),0)) when 0 then vd.Cd_Srv else vd.Cd_Prod end as Cd_PrdSrv,
			case(isnull(len(vd.Cd_Prod),0)) when 0 then s2.Nombre else p2.Nombre1 end as NProdServ,
			vd.Total as TotalItem,
			vou.FecED,
			vou.TotalVenta	
		from (
				select 
					vou1.RucE,
					vou1.Ejer,
					vou1.RegCtb,
					Convert(nvarchar,vou1.FecMov,103) FecCbr,
					vou1.Cd_TD,
					vou1.NroSre,
					vou1.NroDoc,
					vou1.Cd_Clt,
					vou2.Cd_Vta,
					vou2.FecED,
					vou2.TotalVenta 
				from 
					voucher vou1
					inner join (
						select 
							Max(vou.RucE) RucE,
							Max(vou.Ejer) Ejer,
							vou.RegCtb,
							Max(vt.FecCbr) FecCbr,
							Max(vou.Cd_TD) Cd_TD,
							Max(vou.NroSre) NroSre,
							Max(vou.NroDoc) NroDoc,
							Max(vou.Cd_Clt) Cd_Clt,
							Max(vt.Cd_Vta) Cd_Vta,
							Max(vt.FecED) FecED,
							Max(vt.TotalVenta) TotalVenta
						from 
							voucher vou inner join (
							select 
								v.RucE, 
								v.Eje, 
								v.Cd_Vta, 
								v.RegCtb, 
								v.Total as TotalVenta,
								v.Cd_Clt, 
								Convert(nvarchar,v.FecED,103) FecED, 
								Convert(nvarchar,v.FecCbr,103) FecCbr,
								V.Cd_TD, 
								v.NroSre, 
								v.NroDoc
							from 
								Venta v 
							where 
								v.RucE=@RucE and v.Eje=@Ejer 
							) as vt on vt.RucE=vou.RucE and vt.Eje=vou.Ejer and vt.RegCtb=vou.RegCtb
						where 
							vou.RucE=@RucE
							and vou.Ejer=@Ejer 
							--and vou.Prdo between @PrdoI and @PrdoF
							and vou.FecMov between @FecI and @FecF
							--and vou.IC_TipAfec is not null
							and vou.Cd_Fte='RV'
						group by vou.RegCtb
						) as vou2 on vou2.RucE=vou1.RucE and vou2.Ejer=vou1.Ejer and vou1.Cd_TD=Vou2.Cd_TD and vou1.NroSre=vou2.NroSre and vou1.NroDoc=vou2.NroDoc
				where 
					vou1.RucE=@RucE 
					and vou1.Ejer=@Ejer 
					and vou1.Cd_Fte='CB'
					--and vou1.Prdo between @PrdoI and @PrdoF
					and vou1.FecMov between @FecI and @FecF
					
				) as vou inner join Cliente2 c2 on c2.RucE=vou.RucE and c2.Cd_Clt=vou.Cd_Clt
				inner join VentaDet vd on vd.RucE=vou.RucE and vd.Cd_Vta=vou.Cd_Vta
				left join Producto2 p2 on p2.RucE=vd.RucE and p2.Cd_Prod=vd.Cd_Prod
				left join Servicio2 s2 on s2.RucE=vd.RucE and s2.Cd_Srv=vd.Cd_Srv
		) as vou 
	)as t 
	group by Cd_PrdSrv
	
	/*************************Cabecera*********************************/
	declare @NombCompleto varchar(50)
	set @NombCompleto = (select Usuario.NomComp from Usuario where NomUsu = @Usu)
	Select @RucE as RucE, @Ejer as Ejer, 'Del: '+@FecI +' al '+@FecF as Prdo,RSocial,@NombCompleto as Usuario  from Empresa where Ruc=@RucE	
	
	/************************Calculo del PrdoAnterior*****************/
	
	declare @num int 
	set @num=convert(int,@PrdoI)
	if(@num=0)
		set @PrdoI='00'
	else
	begin
		set @num=@num-1
		if(@num>9)
		set @PrdoI=convert(nvarchar,@num)
		else
		set @PrdoI='0'+Convert(nvarchar,@num)
	end

	/************************Saldo Anterior*****************************/

select 
	@PrdoI as Prdo, 
	SUM(vou.TotalItem) SaldoAnt
from( 
		select 
			vou.RegCtb,
			vou.FecCbr,
			vou.DocCbr,
			vou.Cd_Clt,
			vou.CA01+'-'+vou.Cliente as Cliente,
			vou.Cd_Vta,
			vou.Cd_PrdSrv,
			vou.TotalItem,
			vou.FecED,
			vou.TotalVenta
		from( 
				select 
					vou.RegCtb,
					vou.FecCbr,
					vou.Cd_TD+'-'+vou.NroSre+'-'+vou.NroDoc DocCbr,
					vou.Cd_Clt,
					isnull(c2.CA01,'') CA01,
					case(isnull(len(c2.RSocial),0)) when 0 then isnull(c2.ApPat,'')+' '+isnull(c2.Nom,'') else c2.RSocial end as Cliente,
					vou.Cd_Vta,
					case(isnull(len(vd.Cd_Prod),0)) when 0 then vd.Cd_Srv else vd.Cd_Prod end as Cd_PrdSrv,
					vd.Total as TotalItem,
					vou.FecED,
					vou.TotalVenta	
				from (
						select 
							vou1.RucE,
							vou1.Ejer,
							vou1.RegCtb,
							Convert(nvarchar,vou1.FecMov,103) FecCbr,
							vou1.Cd_TD,
							vou1.NroSre,
							vou1.NroDoc,
							vou1.Cd_Clt,
							vou2.Cd_Vta,
							vou2.FecED,
							vou2.TotalVenta 
						from 
							voucher vou1
							inner join (
								select 
									Max(vou.RucE) RucE,
									Max(vou.Ejer) Ejer,
									vou.RegCtb,
									Max(vt.FecCbr) FecCbr,
									Max(vou.Cd_TD) Cd_TD,
									Max(vou.NroSre) NroSre,
									Max(vou.NroDoc) NroDoc,
									Max(vou.Cd_Clt) Cd_Clt,
									Max(vt.Cd_Vta) Cd_Vta,
									Max(vt.FecED) FecED,
									Max(vt.TotalVenta) TotalVenta
								from 
									voucher vou inner join (
									select 
										v.RucE, 
										v.Eje, 
										v.Cd_Vta, 
										v.RegCtb, 
										v.Total as TotalVenta,
										v.Cd_Clt, 
										Convert(nvarchar,v.FecED,103) FecED, 
										Convert(nvarchar,v.FecCbr,103) FecCbr,
										V.Cd_TD, 
										v.NroSre, 
										v.NroDoc
									from 
										Venta v 
									where 
										v.RucE=@RucE and v.Eje=@Ejer 
									) as vt on vt.RucE=vou.RucE and vt.Eje=vou.Ejer and vt.RegCtb=vou.RegCtb
								where 
									vou.RucE=@RucE
									and vou.Ejer=@Ejer 
									and vou.Prdo between @PrdoI and @PrdoI
									--and vou.IC_TipAfec is not null
									and vou.Cd_Fte='RV'
								group by vou.RegCtb
								) as vou2 on vou2.RucE=vou1.RucE and vou2.Ejer=vou1.Ejer and vou1.Cd_TD=Vou2.Cd_TD and vou1.NroSre=vou2.NroSre and vou1.NroDoc=vou2.NroDoc
						where 
							vou1.RucE=@RucE 
							and vou1.Ejer=@Ejer 
							and vou1.Cd_Fte='CB'
							and vou1.Prdo between @PrdoI and @PrdoI
						) as vou inner join Cliente2 c2 on c2.RucE=vou.RucE and c2.Cd_Clt=vou.Cd_Clt
						inner join VentaDet vd on vd.RucE=vou.RucE and vd.Cd_Vta=vou.Cd_Vta
				) as vou
		) as vou
--Prueba --[dbo].[Rpt_LiquidacionIngreso2] '20001000001','2011','04','04','jacho','01/06/2011','30/06/2011'
--Creado por JA & JJ: 17/05/2011
--Modificado por JA  18/05/2011  ---> Se agrego la cantidad de servicios,se agrego la cabecera 
--Modificado por JJ  19/05/2011  ---> Se agrego Campo adicional de Cliente  & Saldo del Prdo Anterior
GO
