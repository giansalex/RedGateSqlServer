SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Rpt_InventarioKardexNoValXFecha]
@RucE nvarchar(11),-- = '20102028687',
@Cd_Prod char(7),-- = 'PD00052',
@Cd_Mda char(2),-- = '01',
@Id_UMP int,-- = '01',
@Fed datetime,-- = '01/01/2012',
@Feh datetime,-- = '31/01/2013',
@Cd_CL char(3),-- = '',
@Cd_CLS char(3),-- = '',
@Cd_CLSS char(3)-- = ''

--exec Rpt_InventarioKardexNoValXFecha '20102028687','','01',1,'01/01/2012','31/01/2013','','',''

as
select Ruc as RucE,RSocial, 'Del '+ Convert(nvarchar,@Fed,103) +  ' Al ' + Convert(nvarchar,@Feh,103) as Fecha from Empresa where Ruc = @RucE 
set @Feh = dateadd(d, 1 , @Feh) 

select a.Cd_Inv, a.Cd_Prod, d.Nombre1 as NombreProducto ,d.CodCo1_ as CodCom, isnull(convert(nvarchar,a.FecMov,103),'--/--/----') as FecMov, 				
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
Case(a.IC_ES) when 'E' then a.Cant else 0.00 end as ECant ,
Case(a.IC_ES) when 'E' then case(@Cd_Mda) when '01' then a.CosUnt else a.CosUnt_ME end else 0.00 end as ECosUnt,
Case(a.IC_ES) when 'E' then case(@Cd_Mda) when '01' then a.Total else a.Total_ME end else 0.00 end as ETotal,
Case(a.IC_ES) when 'S' then a.Cant*-1 else 0.00 end as SCant ,
Case(a.IC_ES) when 'S' then case(@Cd_Mda) when '01' then a.CosUnt else a.CosUnt_ME end else 0.00 end as SCosUnt,
Case(a.IC_ES) when 'S' then case(@Cd_Mda) when '01' then a.Total*-1 else a.Total_ME*-1 end else 0.00 end as STotal,

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
where a.RucE=@RucE 
and case when isnull(@Cd_Prod,'') <> '' then d.Cd_Prod else '' end = isnull(@Cd_Prod,'')
and a.FecMov between @Fed and @Feh
and Case when Isnull(@Cd_CL,'')='' then '' else d.Cd_CL end = Isnull(@Cd_CL,'')
and Case when Isnull(@Cd_CLS,'')='' then '' else d.Cd_CLS end = Isnull(@Cd_CLS,'')
and Case when Isnull(@Cd_CLSS,'')='' then '' else d.Cd_CLSS end = Isnull(@Cd_CLSS,'')
order by year(isnull(a.FecMov,'--/--/----'))asc ,month(isnull(a.FecMov,'--/--/----')) asc ,day(isnull(a.FecMov,'--/--/----')) asc
--<Creado: JA> <12/02/2013>
--Creado Exclusivamente para Nefusac porque solo quieren kardex en una fecha especifica sin considerar saldos iniciales.





GO
