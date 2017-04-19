SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
--declare @RucE nvarchar(11)
--declare @PrdoF varchar(2)
--declare @Ejer varchar(4)
--declare @Usu varchar(20)
--set @RucE='20001000001'
--set @PrdoF='06'
--set @Ejer='2011'
--set @Usu='jvega'

CREATE procedure [dbo].[Rpt_CtasxCbr_Vta]
@RucE nvarchar(11),
@PrdoF varchar(2),
@Ejer varchar(4),
@Usu varchar(20),
@FecF nvarchar(15)
as


/**************Data Origianal**************/
select 
	RegCtb,
	FecCbr,
	Cd_TD+'-'+NroSre+'-'+NroDoc as DocCbr,
	Cd_Clt,
	CA01+'-'+Cliente as Cliente,
	Cd_Vta,
	ProdServ as Cd_PrdSrv,
	TotItem as TotalItem,
	FecED,
	TotVenta as TotalVenta,
	null as Indicador,
	convert(nvarchar,year(FecED))+'-'+convert(nvarchar,month(FecED)) as MesED
from (
	select 
		v.*,
		ISNULL(c2.CA01,'') CA01,
		case(ISNULL(len(c2.RSocial),0)) when 0 then ISNULL(c2.ApPat,'')+' '+ISNULL(c2.ApMat,'')+' '+ISNULL(c2.Nom,'') else c2.RSocial end as Cliente
	from(
		select 
			*
		from (
			select 
				vd.*,v.Cd_TD,v.NroSre,v.NroDoc
			from voucher v inner join (
				select 
					v.RucE,
					v.Cd_Vta,
					v.Eje as Ejer,
					v.RegCtb,
					v.Cd_Clt,
					Case when LEN(ISNULL(vd.Cd_Prod,''))=0 then vd.Cd_Srv else vd.Cd_Prod end as ProdServ,
					CONVERT(nvarchar,v.FecED,103) FecED,
					CONVERT(nvarchar,v.FecCbr,103) FecCbr,
					vd.Total as TotItem,
					v.Total as TotVenta
				from 
					Venta v 
					inner join VentaDet vd on vd.RucE=v.RucE and vd.Cd_Vta=v.Cd_Vta 
				where 
					v.RucE=@RucE 
					--and v.Prdo<=@PrdoF
					and v.FecMov <= @FecF
				) as vd on vd.RucE=v.RucE and vd.Ejer=v.Ejer and vd.RegCtb=v.RegCtb
			where 
				v.RucE=@RucE
				--and v.Prdo<=@PrdoF
				and v.FecMov <= @FecF
				and len(v.Cd_TD)<>0 
				and len(v.NroSre)<>0 
				and len(v.NroDoc)<>0
			) as v 
		where 
			v.RucE=@RucE 
			and v.Cd_TD+''+v.NroSre+''+v.NroDoc not in(
		select 
			v.Cd_TD+''+v.NroSre+''+v.NroDoc
		from voucher v inner join (
			select 
				vd.*,v.Cd_TD,v.NroSre,v.NroDoc
			from voucher v inner join (
				select 
					v.RucE,
					v.Cd_Vta,
					v.Eje as Ejer,
					v.RegCtb,
					v.Cd_Clt,
					Case when LEN(ISNULL(vd.Cd_Prod,''))=0 then vd.Cd_Srv else vd.Cd_Prod end as ProdServ,
					vd.Total as TotItem,
					v.Total as TotVenta
				from 
					Venta v 
					inner join VentaDet vd on vd.RucE=v.RucE and vd.Cd_Vta=v.Cd_Vta 
				where 
					v.RucE=@RucE 
					and v.Eje=@Ejer
					--and v.Prdo<=@PrdoF
					and v.FecMov <= @FecF
				) as vd on vd.RucE=v.RucE and vd.Ejer=v.Ejer and vd.RegCtb=v.RegCtb
			where 
				v.RucE=@RucE
				and v.Ejer=@Ejer
				--and v.Prdo<=@PrdoF
				and v.FecMov <= @FecF
				and len(v.Cd_TD)<>0 
				and len(v.NroSre)<>0 
				and len(v.NroDoc)<>0
			) as vou on vou.RucE=v.RucE and vou.Ejer=v.Ejer 
						and vou.Cd_TD=v.Cd_TD and vou.NroSre=v.NroSre and vou.NroDoc=v.NroDoc
			where v.RucE=@RucE  and v.Cd_Fte='CB' /*and v.Ejer=@Ejer*/ 
				  --and v.Prdo<=@PrdoF
				  and v.FecMov <= @FecF
			group by v.Cd_TD,v.NroSre,v.NroDoc
		)
	) as v inner join Cliente2 c2 on c2.RucE=v.RucE and c2.Cd_Clt=v.Cd_Clt
) as v
/***********************Cantidad de Columnas a Crear para el reporte***************************/
select 
	ProdServ Cd_PrdSrv,MAX(NProdServ) NProdServ
from (
	select 
		*
	from (
		select 
			vd.*,v.Cd_TD,v.NroSre,v.NroDoc
		from voucher v inner join (
			select 
				v.RucE,
				v.Cd_Vta,
				v.Eje as Ejer,
				v.RegCtb,
				v.Cd_Clt,
				Case when LEN(ISNULL(vd.Cd_Prod,''))=0 then vd.Cd_Srv else vd.Cd_Prod end as ProdServ,
				Case when LEN(ISNULL(vd.Cd_Prod,''))=0 then s2.Nombre else p2.Nombre1 end as NProdServ,
				vd.Total as TotItem,
				v.Total as TotVenta
			from 
				Venta v 
				inner join VentaDet vd on vd.RucE=v.RucE and vd.Cd_Vta=v.Cd_Vta 
				left join Producto2 p2 on p2.RucE=vd.RucE and p2.Cd_Prod=vd.Cd_Prod
				left join Servicio2 s2 on s2.RucE=vd.RucE and s2.Cd_Srv=vd.Cd_Srv
			where 
				v.RucE=@RucE 
				--and v.Prdo<=@PrdoF
				and v.FecMov <= @FecF
			) as vd on vd.RucE=v.RucE and vd.Ejer=v.Ejer and vd.RegCtb=v.RegCtb
		where 
			v.RucE=@RucE
			--and v.Prdo<=@PrdoF
			and v.FecMov <= @FecF
			and len(v.Cd_TD)<>0 
			and len(v.NroSre)<>0 
			and len(v.NroDoc)<>0
		) as v 
	where 
		v.RucE=@RucE 
		and v.Cd_TD+''+v.NroSre+''+v.NroDoc not in(
	select 
		v.Cd_TD+''+v.NroSre+''+v.NroDoc
	from voucher v inner join (
		select 
			vd.*,v.Cd_TD,v.NroSre,v.NroDoc
		from voucher v inner join (
			select 
				v.RucE,
				v.Cd_Vta,
				v.Eje as Ejer,
				v.RegCtb,
				v.Cd_Clt,
				Case when LEN(ISNULL(vd.Cd_Prod,''))=0 then vd.Cd_Srv else vd.Cd_Prod end as ProdServ,
				vd.Total as TotItem,
				v.Total as TotVenta
			from 
				Venta v 
				inner join VentaDet vd on vd.RucE=v.RucE and vd.Cd_Vta=v.Cd_Vta 
			where 
				v.RucE=@RucE 
				and v.Eje=@Ejer
				--and v.Prdo<=@PrdoF
				and v.FecMov <= @FecF
			) as vd on vd.RucE=v.RucE and vd.Ejer=v.Ejer and vd.RegCtb=v.RegCtb
		where 
			v.RucE=@RucE
			and v.Ejer=@Ejer
			--and v.Prdo<=@PrdoF
			and v.FecMov <= @FecF
			and len(v.Cd_TD)<>0 
			and len(v.NroSre)<>0 
			and len(v.NroDoc)<>0
		) as vou on vou.RucE=v.RucE and vou.Ejer=v.Ejer 
					and vou.Cd_TD=v.Cd_TD and vou.NroSre=v.NroSre and vou.NroDoc=v.NroDoc
		where v.RucE=@RucE and  v.Cd_Fte='CB'/*and v.Ejer=@Ejer*/ 
			  --and v.Prdo<=@PrdoF
			  and v.FecMov <= @FecF
		group by v.Cd_TD,v.NroSre,v.NroDoc
	)
) as v group by ProdServ 

	declare @NombCompleto varchar(50)
	set @NombCompleto = (select Usuario.NomComp from Usuario where NomUsu = @Usu)
	Select @RucE as RucE, @Ejer as Ejer, 'Hasta '+@PrdoF as Prdo,RSocial,@NombCompleto as Usuario  from Empresa where Ruc=@RucE	
	
--Se agrego pa que funcione con el metodo que convierte filas en columnas
select '04' as Prdo, 0.00 as SaldoAnt 

----------------Leyenda----------------------
-- JJ & JA <01/06/2011>:Creacion del procedimiento almacenado
--Rpt_CtasxCbr_Vta '20001000001','06','2011','jacho','30/06/2011' 
GO
