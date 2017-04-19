SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create procedure [dbo].[Rpt_InventarioKardex2]
@RucE nvarchar(11),
@Cd_Prod char(7),
@Cd_Mda char(2) = '01',
@Id_UMP int,
@Fed datetime,
@Feh datetime,
@Cd_CL char(3),
@Cd_CLS char(3),
@Cd_CLSS char(3),
@msj varchar(100) output
as

--exec Rpt_InventarioKardex '11111111111',null,'01',0,'01/12/2011','31/12/2011','','','',null
Declare @RSocial nvarchar(400)
set @RSocial = (select RSocial from Empresa Where Ruc=@RucE)
print @Feh
if(@Cd_Prod is null )
begin
			select @RucE as RucE,@RSocial as RSocial,'---------' as Cd_TE,'---------' as CodSNT_,'---------' as Nombre,'---------' as Cd_UM,
				'Del '+ Convert(nvarchar,@Fed,103) +  ' Al ' + Convert(nvarchar,@Feh,103) as Fecha
			set @Feh = dateadd(d, 1 , @Feh) 
	
			select Cd_Inv, Cd_Prod, NombreProducto,CodCom, isnull(convert(varchar,FecMov,103),'--/--/----') as FecMov, 
			Cd_TO, TipoOperacion,Cd_TDES, Cd_TD, NroSre,  otros, NroDoc, IC_ES, Descrip2, 
			ECant, ECosUnt, 	ETotal, SCant, SCosUnt, STotal, Suma_Cantidad, CProm, SCT from(
			select '--' as Cd_Inv, p.Cd_Prod, p.Nombre1 as NombreProducto,p.CodCo1_ as CodCom, convert(datetime,null) as FecMov, 
			'--' as Cd_TO, '--' as TipoOperacion, '--' as Cd_TDES, '--' as Cd_TD,'--' as NroSre,'--' otros,  '--' as NroDoc, '--' as IC_ES, '--' as Descrip2,
			'--' as ECant ,'--' as ECosUnt,'--' as ETotal,'--' as SCant ,'--' as SCosUnt,'--' as STotal,
			isnull(Suma_Cantidad,0) as Suma_Cantidad, isnull(CProm,0) as CProm, isnull(SCT,0) as SCT
			 from(
					select RucE, Cd_Prod, Sum(Cant) as Suma_Cantidad, 
					 case(sum(Cant))when 0 then 0 else case(@Cd_Mda) when '01' then sum(Total)/Sum(Cant) 
					 else sum(Total_ME)/Sum(Cant) end end as CProm,
					 case(sum(Cant))when 0 then 0 
					 else case(@Cd_Mda) when '01' then sum(Total) else sum(Total_ME) end end as SCT
					from Inventario 
					where RucE=@RucE and FecMov <= @Fed	group by RucE, Cd_Prod) as Inv 
					right join Producto2  as p on p.RucE= inv.RucE and p.Cd_Prod = inv.cd_Prod
					left join TipDoc  as n on inv.RucE= n.Cd_TD 
					where p.RucE =@RucE 		
					and (inv.Cd_Prod in (select a.Cd_Prod
					from Inventario a 
					where a.RucE=@RucE and  a.FecMov between @Fed and @Feh) or isnull(Suma_Cantidad,0) >0)
					
									
				union all
				
				select a.Cd_Inv, a.Cd_Prod, d.Nombre1 as NombreProducto ,d.CodCo1_ as CodCom, isnull(a.FecMov,'--/--/----') as FecMov, 				
					a.Cd_TO, tpo.Nombre as TipoOperacion, isnull(a.Cd_TDES,'--') as Cd_TDES, 
					
					--isnull(a.Cd_TD,'--') as Cd_TD, 
					[dbo].[TipoDocumento](Case when isnull(a.Cd_GR ,'')<>'' then isnull(gr.Cd_TD,'--') else case when isnull(a.Cd_Vta ,'')<>'' then isnull(vta.Cd_TD,'--') else case when isnull(a.Cd_Com ,'')<>'' then isnull(com.Cd_TD,'--') else '--' end end  end)  as Cd_TD,
					--isnull(a.NroSre,'--') as NroSre,
					Case when isnull(a.Cd_GR ,'')<>'' then isnull(gr.NroSre,'--') else case when isnull(a.Cd_Vta ,'')<>'' then isnull(vta.NroSre,'--') else case when isnull(a.Cd_Com ,'')<>'' then isnull(com.NroSre,'--') else '--' end end  end  as NroSre,
					--isnull(a.NroDoc, case(a.Cd_TDES) when 'OC' then oc.NroOC when 'OP' then op.NroOP else '--' end) otros,
					case when ISNULL(a.Cd_OC,'')<>'' then oc.NroOC else case when ISNULL(a.Cd_OP,'')<>'' then op.NroOP else '--' end end as otros,
					--case when isnull(a.Cd_GR ,'')<>'' then gr.NroGR else ''  end  as NroDoc,
					Case when isnull(a.Cd_GR ,'')<>'' then isnull(gr.NroGR,'--') else case when isnull(a.Cd_Vta ,'')<>'' then isnull(vta.NroDoc,'--') else case when isnull(a.Cd_Com ,'')<>'' then isnull(com.NroDoc,'--') else '--' end end  end  as NroDoc,
					
					
					Case(a.IC_ES) when 'E' then 'Entrada' else 'Salida' end as IC_ES,	i.Descrip as Descrip2, 
					Case(a.IC_ES) when 'E' then Convert(nvarchar,a.Cant) else '--' end as ECant ,
					Case(a.IC_ES) when 'E' then Convert(nvarchar,case(@Cd_Mda) when '01' then a.CosUnt else a.CosUnt_ME end) else '--' end as ECosUnt,
					Case(a.IC_ES) when 'E' then Convert(nvarchar,case(@Cd_Mda) when '01' then a.Total else a.Total_ME end) else '--' end as ETotal,
					Case(a.IC_ES) when 'S' then Convert(nvarchar,a.Cant*-1) else '--' end as SCant ,
					Case(a.IC_ES) when 'S' then Convert(nvarchar,case(@Cd_Mda) when '01' then a.CosUnt else a.CosUnt_ME end) else '--' end as SCosUnt,
					Case(a.IC_ES) when 'S' then Convert(nvarchar,case(@Cd_Mda) when '01' then a.Total*-1 else a.Total_ME*-1 end) else '--' end as STotal,
					
					a.SCant as Suma_Cantidad, 
					case(@Cd_Mda) when '01' then a.CProm else a.CProm_ME end, 
					case(@Cd_Mda) when '01' then a.SCT else a.SCT_ME end
					from Inventario a 
					inner join Producto2 d on d.Cd_Prod=a.Cd_Prod and d.RucE = a.RucE
					left join MtvoIngSal i on i.Cd_MIS=a.Cd_MIS and a.RucE=i.RucE
					left join TipoOperacion tpo on tpo.Cd_TO=a.Cd_TO
					left join TipDoc   n on a.Cd_TD= n.Cd_TD 
					left join OrdCompra oc on oc.RucE = a.RucE and  oc.Cd_OC = a.Cd_OC
					left join OrdPedido op on op.RucE = a.RucE and  op.Cd_OP = a.Cd_OP
					left join GuiaRemision gr on  gr.RucE=a.RucE and gr.Cd_GR=a.Cd_GR
					left join Venta vta on vta.RucE = a.RucE and vta.Cd_Vta = a.Cd_Vta and vta.Eje = a.Ejer
					left join Compra com on com.RucE = a.RucE and com.Cd_Com = a.Cd_Com and com.Ejer = a.Ejer
					where a.RucE=@RucE and  a.FecMov between @Fed and @Feh
					and Case when Isnull(@Cd_CL,'')='' then '' else d.Cd_CL end = Isnull(@Cd_CL,'')
					and Case when Isnull(@Cd_CLS,'')='' then '' else d.Cd_CLS end = Isnull(@Cd_CLS,'')
					and Case when Isnull(@Cd_CLSS,'')='' then '' else d.Cd_CLSS end = Isnull(@Cd_CLSS,'')
					) as kardex
	order by Cd_Prod, convert(datetime, FecMov), Cd_Inv 
end
else 
begin
	select top 1 p2.RucE,@RSocial as RSocial,p2.Cd_TE, te.CodSNT_,te.Nombre, pm.Cd_UM,
		'Del '+ Convert(nvarchar,@Fed,103) +  ' Al ' + Convert(nvarchar,@Feh,103) as Fecha from producto2 p2  
		left join tipoexistencia te on te.Cd_TE=p2.Cd_TE
		inner join Prod_UM pm on pm.Cd_Prod=p2.Cd_Prod and pm.RucE=p2.RucE and pm.factor = 1
		where p2.Cd_Prod=@Cd_Prod and p2.RucE=@RucE
	set @Feh = dateadd(d, 1 , @Feh) 
	
	select Cd_Inv, Cd_Prod, NombreProducto,CodCom, isnull(convert(varchar,FecMov,103),'--/--/----') as FecMov, 
		Cd_TO, TipoOperacion,Cd_TDES, Cd_TD, NroSre,  
		Otros,
		NroDoc, IC_ES, Descrip2, 
		ECant, ECosUnt, ETotal, SCant, SCosUnt, STotal, Suma_Cantidad, CProm, SCT from(
		select '--' as Cd_Inv, p.Cd_Prod, p.Nombre1 as NombreProducto,p.CodCo1_ as CodCom, convert(datetime,null) as FecMov, 
			'--' as Cd_TO, '--' as TipoOperacion, '--' as Cd_TDES, '--' as Cd_TD,'--' as NroSre, '' otros , '--' as NroDoc, '--' as IC_ES, '--' as Descrip2,
			'--' as ECant ,'--' as ECosUnt,'--' as ETotal,'--' as SCant ,'--' as SCosUnt,'--' as STotal,
			isnull(Suma_Cantidad,0) as Suma_Cantidad, isnull(CProm,0) as CProm, isnull(SCT,0) as SCT from(
			select RucE, Cd_Prod, Sum(Cant) as Suma_Cantidad,  case(sum(Cant))when 0 then 0 else case(@Cd_Mda) when '01' then sum(Total)/Sum(Cant) else sum(Total_ME)/Sum(Cant) end end as CProm, case(sum(Cant))when 0 then 0 else case(@Cd_Mda) when '01' then sum(Total) else sum(Total_ME) end end as SCT
				from Inventario 
				where RucE= @RucE and Cd_Prod= @Cd_Prod and FecMov <= @Fed
				group by RucE, Cd_Prod) as Inv right join Producto2  as p on p.RucE= inv.RucE and p.Cd_Prod = inv.cd_Prod
			where p.RucE =@RucE and p.Cd_Prod= @Cd_Prod
		union all
		select a.Cd_Inv, a.Cd_Prod, d.Nombre1 as NombreProducto ,d.CodCo1_ as CodCom, isnull(a.FecMov,'--/--/----') as FecMov, 				
					a.Cd_TO, tpo.Nombre as TipoOperacion, isnull(a.Cd_TDES,'--')as Cd_TDES, 
					
			--isnull(a.Cd_TD,'--') as Cd_TD, 
			--isnull(a.NroSre,'--') as NroSre,			
			--isnull(a.NroDoc, case(a.Cd_TDES) when 'OC' then oc.NroOC when 'OP' then op.NroOP else '--' end) Otros,
			--case when isnull(a.Cd_GR ,'')<>'' then gr.NroGR else ''  end  as NroDoc,
			
			--isnull(a.Cd_TD,'--') as Cd_TD, 
			[dbo].[TipoDocumento](Case when isnull(a.Cd_GR ,'')<>'' then isnull(gr.Cd_TD,'--') else case when isnull(a.Cd_Vta ,'')<>'' then isnull(vta.Cd_TD,'--') else case when isnull(a.Cd_Com ,'')<>'' then isnull(com.Cd_TD,'--') else '--' end end  end ) as Cd_TD,
			--isnull(a.NroSre,'--') as NroSre,
			Case when isnull(a.Cd_GR ,'')<>'' then isnull(gr.NroSre,'--') else case when isnull(a.Cd_Vta ,'')<>'' then isnull(vta.NroSre,'--') else case when isnull(a.Cd_Com ,'')<>'' then isnull(com.NroSre,'--') else '--' end end  end  as NroSre,
			--isnull(a.NroDoc, case(a.Cd_TDES) when 'OC' then oc.NroOC when 'OP' then op.NroOP else '--' end) otros,
			case when ISNULL(a.Cd_OC,'')<>'' then oc.NroOC else case when ISNULL(a.Cd_OP,'')<>'' then op.NroOP else '--' end end as otros,
			--case when isnull(a.Cd_GR ,'')<>'' then gr.NroGR else ''  end  as NroDoc,
			Case when isnull(a.Cd_GR ,'')<>'' then isnull(gr.NroGR,'--') else case when isnull(a.Cd_Vta ,'')<>'' then isnull(vta.NroDoc,'--') else case when isnull(a.Cd_Com ,'')<>'' then isnull(com.NroDoc,'--') else '--' end end  end  as NroDoc,
			
			Case(a.IC_ES) when 'E' then 'Entrada' else 'Salida' end as IC_ES,	i.Descrip as Descrip2, 
			Case(a.IC_ES) when 'E' then Convert(nvarchar,a.Cant) else '--' end as ECant ,
			Case(a.IC_ES) when 'E' then Convert(nvarchar,case(@Cd_Mda) when '01' then a.CosUnt else a.CosUnt_ME end) else '--' end as ECosUnt,
			Case(a.IC_ES) when 'E' then Convert(nvarchar,case(@Cd_Mda) when '01' then a.Total else a.Total_ME end) else '--' end as ETotal,
			Case(a.IC_ES) when 'S' then Convert(nvarchar,a.Cant*-1) else '--' end as SCant ,
			Case(a.IC_ES) when 'S' then Convert(nvarchar,case(@Cd_Mda) when '01' then a.CosUnt else a.CosUnt_ME end) else '--' end as SCosUnt,
			Case(a.IC_ES) when 'S' then Convert(nvarchar,case(@Cd_Mda) when '01' then a.Total*-1 else a.Total_ME*-1 end) else '--' end as STotal,
			a.SCant as Suma_Cantidad, 
			case(@Cd_Mda) when '01' then a.CProm else a.CProm_ME end, 
			case(@Cd_Mda) when '01' then a.SCT else a.SCT_ME end
			from Inventario a 
			inner join Producto2 d on d.Cd_Prod=a.Cd_Prod and d.RucE = a.RucE
			left join MtvoIngSal i on i.Cd_MIS=a.Cd_MIS and a.RucE=i.RucE
			left join TipoOperacion tpo on tpo.Cd_TO=a.Cd_TO
			left join OrdCompra oc on oc.RucE = a.RucE and  oc.Cd_OC = a.Cd_OC
			left join OrdPedido op on op.RucE = a.RucE and  op.Cd_OP = a.Cd_OP
			left join GuiaRemision gr on  gr.RucE=a.RucE and gr.Cd_GR=a.Cd_GR
			left join Venta vta on vta.RucE = a.RucE and vta.Cd_Vta = a.Cd_Vta and vta.Eje = a.Ejer
			left join Compra com on com.RucE = a.RucE and com.Cd_Com = a.Cd_Com and com.Ejer = a.Ejer
			where a.RucE=@RucE and d.Cd_Prod= @Cd_Prod and  a.FecMov between @Fed and @Feh
			and Case when Isnull(@Cd_CL,'')='' then '' else d.Cd_CL end = Isnull(@Cd_CL,'')
			and Case when Isnull(@Cd_CLS,'')='' then '' else d.Cd_CLS end = Isnull(@Cd_CLS,'')
			and Case when Isnull(@Cd_CLSS,'')='' then '' else d.Cd_CLSS end = Isnull(@Cd_CLSS,'')
		) as kardex
	order by Cd_Prod, convert(datetime, FecMov), Cd_Inv 
end

-- Leyenda --
-- JJ : 2010-08-09 	: <Creacion del procedimiento almacenado>
-- JJ : 2010-12-30 	: <Modificiacion del procedimiento almacenado>
-- Epsilower 14/04/2011 11:31:10:083 : Modificacion Correcccion del la cabecera,  verificacion y   correcion del  inventario
-- PP : 03/07/2011 :  Modificacion para   moneda  extranjera 

GO
