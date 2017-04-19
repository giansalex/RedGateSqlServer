SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE procedure [dbo].[Inv_Producto2Cons_paInv21]
@RucE nvarchar(11),
@Cd_Com nvarchar(10),
@Cd_Vta nvarchar(10),
@Cd_OC nvarchar(10),
@Cd_OP nvarchar(10),
@Cd_GR char(10),
@Cd_SR char(10),
@Cd_OF char(10),
@Cd_IP char(7),
@Cd_Mda char(2),
@Cd_FAB char(10),
@FecMov datetime,
@msj varchar(100) output
--with encryption

as
set language 'spanish'
declare @Cd_TD nvarchar(2), @NroSre varchar(5) , @NroDoc nvarchar(15)--,@FecMov datetime
-------------------  C O M P R A   ----------------------
if(@Cd_Com != '' or @Cd_Com is not null)
begin
	select @Cd_TD=Cd_TD, @NroSre=NroSre, @NroDoc=NroDoc, @Cd_OC=Cd_OC from Compra where RucE=@RucE and Cd_Com=@Cd_Com
	select distinct
	com.Cd_Com, null as Cd_Vta, @Cd_OC as Cd_OC, null as Cd_OP,null as Cd_GR, @Cd_TD as Cd_TD, @NroSre as NroSre, @NroDoc as NroDoc,
	Item, c.Cd_Prod,P.CodCo1_ as CodCom, c.Cd_Alm,P.Nombre1,P.Descrip,UMP.ID_UMP,UMP.DescripAlt,c.Cant, 
	isnull((select sum(Cant_Ing) from Inventario i where i.RucE = c.RucE and i.Cd_Com = c.Cd_Com and i.Cd_Prod=c.Cd_Prod and i.Item = c.Item),0 ) as Cant_Ing,
	Abs(c.Cant)-isnull((select sum(abs(Cant_Ing)) from Inventario i where i.RucE = c.RucE and i.Cd_Com = c.Cd_Com and i.Cd_Prod=c.Cd_Prod and i.Item = c.Item),0 ) as Pendiente,
	c.Imp as Costo,c.Cd_CC,c.Cd_SC, c.Cd_SS,
	null as Cd_Clt, prv.Cd_Prv, null as Cd_SR,null as Cd_OF,--
	convert(int,case(pc.Cd_ProdB) when P.Cd_Prod then '1' else '0' end) as EsGrupo,
	P.IB_Srs, UMP.Factor,null as Cd_IP, com.CamMda
	from CompraDet c 
	left join Producto2 as P on P.RucE = c.RucE and P.Cd_Prod = c.Cd_Prod  
	left join Prod_UM as UMP on UMP.RucE = c.RucE and UMP.Cd_Prod = c.Cd_Prod and UMP.ID_UMP = c.ID_UMP
	left join Compra as com on com.RucE = c.RucE and com.Cd_Com = c.Cd_Com -->>> NUEVO
	left join Proveedor2 as prv on prv.RucE = c.RucE and prv.Cd_Prv = com.Cd_Prv -->>> NUEVO
	left join ProdCombo pc on P.RucE=pc.RucE and P.Cd_Prod=pc.Cd_ProdB and UMP.Id_UMP = pc.Id_UMP
	where c.RucE = @RucE and c.Cd_Com = @Cd_Com and c.Cd_Prod is not null
end
else
--------------------- V E N T A -------------------------
if(@Cd_Vta != '' or @Cd_Vta is not null)
begin
	select @Cd_TD=Cd_TD, @NroSre=NroSre, @NroDoc=NroDoc, @Cd_OP=Cd_OP from Venta where RucE=@RucE and Cd_Vta=@Cd_Vta
	select distinct
	null as Cd_Com, vt.Cd_Vta, null as Cd_OC, @Cd_OP as Cd_OP,null as Cd_GR, @Cd_TD as Cd_TD, @NroSre as NroSre, @NroDoc as NroDoc,
	Nro_RegVdt as Item, c.Cd_Prod,P.CodCo1_ as CodCom,c.Cd_Alm,P.Nombre1,P.Descrip,UMP.ID_UMP,UMP.DescripAlt,c.Cant, 
	ABS(isnull((select sum(Cant_Ing) from Inventario i where i.RucE = c.RucE and i.Cd_Vta = c.Cd_Vta and i.Cd_Prod=c.Cd_Prod and i.Item = c.Nro_RegVdt),0 ))as Cant_Ing,
	c.Cant-ABS(isnull((select sum(Cant_Ing) from Inventario i where i.RucE = c.RucE and i.Cd_Vta = c.Cd_Vta and i.Cd_Prod=c.Cd_Prod and i.Item = c.Nro_RegVdt),0 ))as Pendiente,
	dbo.CostSal3(@RucE, c.Cd_Prod, c.ID_UMP, @FecMov, @Cd_Mda) as Costo, c.Cd_CC,c.Cd_SC, c.Cd_SS,
	ct.Cd_Clt,null as Cd_Prv, null as Cd_SR, null as Cd_OF,--
	convert(int,case(pc.Cd_ProdB) when P.Cd_Prod then '1' else '0' end) as EsGrupo,
	P.IB_Srs, UMP.Factor,null as Cd_IP, vt.CamMda
	from VentaDet c 
	left join Producto2 as P on P.RucE = c.RucE and P.Cd_Prod = c.Cd_Prod  
	left join Prod_UM as UMP on UMP.RucE = c.RucE and UMP.Cd_Prod = c.Cd_Prod and UMP.ID_UMP = c.ID_UMP
	left join Venta as vt on vt.RucE = c.RucE and vt.Cd_Vta = c.Cd_Vta -->>> NUEVO
	left join Cliente2 as ct on ct.RucE = c.RucE and ct.Cd_Clt = vt.Cd_Clt -->>> NUEVO
	left join ProdCombo pc on P.RucE=pc.RucE and P.Cd_Prod=pc.Cd_ProdB and UMP.Id_UMP = pc.Id_UMP
	where c.RucE = @RucE and c.Cd_Vta = @Cd_Vta and c.Cd_Prod is not null
end
else
------------- O R D E N     DE    C O M P R A --------------
if(@Cd_OC != '' or @Cd_OC is not null)
begin
	select @Cd_Com = Cd_Com from Compra where RucE=@RucE and Cd_OC=@Cd_OC

	select distinct
	@Cd_Com as Cd_Com, null as Cd_Vta, c.Cd_OC, null as Cd_OP,null as Cd_GR, null as Cd_TD, null as NroSre, NroOC as NroDoc,
	Item, c.Cd_Prod,P.CodCo1_ as CodCom,c.Cd_Alm,P.Nombre1,P.Descrip,UMP.ID_UMP,UMP.DescripAlt,c.Cant, 
	isnull((select sum(Cant_Ing) from Inventario i where i.RucE = c.RucE and i.Cd_OC = c.Cd_OC and i.Cd_Prod=c.Cd_Prod and i.Item = c.Item),0 )as Cant_Ing,
	c.Cant-isnull((select sum(Cant_Ing) from Inventario i where i.RucE = c.RucE and i.Cd_OC = c.Cd_OC and i.Cd_Prod=c.Cd_Prod and i.Item = c.Item),0 )as Pendiente,
	/*PU*/ c.BIM as Costo, oc.Cd_CC,oc.Cd_SC, oc.Cd_SS,
	null as Cd_Clt, prv.Cd_Prv, null as Cd_SR, null as Cd_OF,--
	convert(int,case(pc.Cd_ProdB) when P.Cd_Prod then '1' else '0' end) as EsGrupo,
	P.IB_Srs, UMP.Factor,null as Cd_IP, oc.CamMda as CamMda
	from OrdCompraDet c 
	left join OrdCompra as oc on oc.RucE = c.RucE and oc.Cd_OC = c.Cd_OC
	left join Producto2 as P on P.RucE = c.RucE and P.Cd_Prod = c.Cd_Prod  
	left join Prod_UM as UMP on UMP.RucE = c.RucE and UMP.Cd_Prod = c.Cd_Prod and UMP.ID_UMP = c.ID_UMP
	left join Proveedor2 as prv on prv.RucE = c.RucE and prv.Cd_Prv = oc.Cd_Prv -->>> NUEVO
	left join ProdCombo pc on P.RucE=pc.RucE and P.Cd_Prod=pc.Cd_ProdB and UMP.Id_UMP = pc.Id_UMP
	where c.RucE = @RucE and c.Cd_OC = @Cd_OC  and c.Cd_Prod is not null
end
else
------------- O R D E N    D E    P E D I D O ----------
if(@Cd_OP != '' or @Cd_OP is not null)
begin
	select @Cd_Vta=Cd_Vta from Venta where RucE=@RucE and Cd_OP=@Cd_OP
	select distinct
	null as Cd_Com, @Cd_Vta as Cd_Vta, null as Cd_OC, c.Cd_OP,null as Cd_GR, null as Cd_TD, null as NroSre, op.NroOP as NroDoc,
	Item, c.Cd_Prod,P.CodCo1_ as CodCom,c.Cd_Alm,P.Nombre1,P.Descrip,UMP.ID_UMP,UMP.DescripAlt,c.Cant, 
	ABS(isnull((select sum(Cant_Ing) from Inventario i where i.RucE = c.RucE and i.Cd_OP = c.Cd_OP and i.Cd_Prod=c.Cd_Prod and i.Item = c.Item),0 ))as Cant_Ing,
	c.Cant-ABS(isnull((select sum(Cant_Ing) from Inventario i where i.RucE = c.RucE and i.Cd_OP = c.Cd_OP and i.Cd_Prod=c.Cd_Prod and i.Item = c.Item),0 ))as Pendiente,
	isnull(dbo.CostSal3(@RucE,UMP.Cd_Prod,UMP.ID_UMP,@FecMov, @Cd_Mda), .0000000) as Costo, null as Cd_CC, null as Cd_SC, null as Cd_SS, 
	op.Cd_Clt,null as Cd_Prv, null as Cd_SR, null as Cd_OF,--
	convert(int,case(pc.Cd_ProdB) when P.Cd_Prod then '1' else '0' end) as EsGrupo,
	P.IB_Srs, UMP.Factor,null as Cd_IP, op.CamMda as CamMda
	from OrdPedidoDet c 
	left join OrdPedido as op on op.RucE = c.RucE and op.Cd_OP = c.Cd_OP
	left join Producto2 as P on P.RucE = c.RucE and P.Cd_Prod = c.Cd_Prod  
	left join Prod_UM as UMP on UMP.RucE = c.RucE and UMP.Cd_Prod = c.Cd_Prod and UMP.ID_UMP = c.ID_UMP
	left join Cliente2 as ct on ct.RucE = c.RucE and ct.Cd_Clt = op.Cd_Clt -->>> NUEVO
	left join ProdCombo pc on P.RucE=pc.RucE and P.Cd_Prod=pc.Cd_ProdB and UMP.Id_UMP = pc.Id_UMP
	where c.RucE = @RucE and c.Cd_OP = @Cd_OP and c.Cd_Prod is not null
end
else
------------------ G U I A    R E M I S I O N -------------------
if(@Cd_GR != '' or @Cd_GR is not null)
begin
	-- PARA ENTRADAS
	if (select IC_ES from GuiaRemision where RucE = @RucE and Cd_GR = @Cd_GR) = 'E'
	begin
		select  distinct
		com.Cd_Com, null as Cd_Vta, com.Cd_OC, null as Cd_OP, c.Cd_GR, gr.Cd_TD, gr.NroSre, gr.NroGR as NroDoc,
		c.Item, c.Cd_Prod, P.CodCo1_ as CodCom,null as Cd_Alm, P.Nombre1,P.Descrip,UMP.ID_UMP,UMP.DescripAlt,c.Cant, 
		ABS(isnull((select sum(Cant_Ing) from Inventario i where i.RucE = c.RucE and i.Cd_GR = c.Cd_GR and i.Cd_Prod=c.Cd_Prod and i.Item = c.Item),0 ))as Cant_Ing,
		c.Cant-ABS(isnull((select sum(Cant_Ing) from Inventario i where i.RucE = c.RucE and i.Cd_GR = c.Cd_GR and i.Cd_Prod=c.Cd_Prod and i.Item = c.Item),0 ))as Pendiente,
		case(isnull(len(com.Cd_Com),0)) when 0 
  			then dbo.CostEnt2(@RucE ,c.Cd_Prod ,c.ID_UMP, getdate(), @Cd_Mda) 
  			else comdet.IMP end as Costo,
		gr.Cd_CC as Cd_CC, gr.Cd_SC as Cd_SC, gr.Cd_SS as Cd_SS,-- CENTRO DE COSTOS
		null as Cd_Clt, prv.Cd_Prv, null as Cd_SR, null as Cd_OF,--
		convert(int,case(pc.Cd_ProdB) when P.Cd_Prod then '1' else '0' end) as EsGrupo,
		P.IB_Srs, UMP.Factor,null as Cd_IP, 0.0 as CamMda
		from GuiaRemisionDet c 
		left join GuiaRemision gr on c.RucE = gr.RucE and c.Cd_GR = gr.Cd_GR
		left join Producto2 as P on P.RucE = c.RucE and P.Cd_Prod = c.Cd_Prod  
		left join Prod_UM as UMP on UMP.RucE = c.RucE and UMP.Cd_Prod = c.Cd_Prod and UMP.ID_UMP = c.ID_UMP
		left join Compra as com on com.RucE = c.RucE and com.Cd_Com = c.Cd_Com -->>> NUEVO
		left join CompraDet as comdet  on comdet.RucE = c.RucE and comdet.Cd_Com = com.Cd_Com and comdet.Cd_Prod = P.Cd_Prod and UMP.ID_UMP = comdet.ID_UMP
		left join Proveedor2 as prv on prv.RucE = c.RucE and prv.Cd_Prv = com.Cd_Prv -->>> NUEVO
		left join ProdCombo pc on P.RucE=pc.RucE and P.Cd_Prod=pc.Cd_ProdB and UMP.Id_UMP = pc.Id_UMP
		where c.RucE = @RucE and c.Cd_GR = @Cd_GR and c.Cd_Prod is not null
	end
	else --PARA SALIDAS
	begin
		select distinct
		null as Cd_Com, vt.Cd_Vta, null as Cd_OC, vt.Cd_OP, c.Cd_GR, gr.Cd_TD, gr.NroSre, gr.NroGR as NroDoc,
		Item, c.Cd_Prod, P.CodCo1_ as CodCom,null as Cd_Alm, P.Nombre1,P.Descrip,UMP.ID_UMP,UMP.DescripAlt,c.Cant, 
		ABS(isnull((select sum(Cant_Ing) from Inventario i where i.RucE = c.RucE and i.Cd_GR = c.Cd_GR and i.Cd_Prod=c.Cd_Prod and i.Item = c.Item),0 ))as Cant_Ing,
		c.Cant-ABS(isnull((select sum(Cant_Ing) from Inventario i where i.RucE = c.RucE and i.Cd_GR = c.Cd_GR and i.Cd_Prod=c.Cd_Prod and i.Item = c.Item),0 ))as Pendiente,
		case(isnull(len(vt.Cd_Vta),0)) when 0 
  			then dbo.CostSal3(@RucE ,c.Cd_Prod ,c.ID_UMP, @FecMov, @Cd_Mda) 
  			else isnull(vtadet.CU,dbo.CostSal3(@RucE ,c.Cd_Prod ,c.ID_UMP, @FecMov, @Cd_Mda)) end as Costo,
		gr.Cd_CC as Cd_CC, gr.Cd_SC as Cd_SC, gr.Cd_SS as Cd_SS,-- CENTRO DE COSTOS
		vt.Cd_Clt,null as Cd_Prv, null as Cd_SR, null as Cd_OF,
		convert(int,case(pc.Cd_ProdB) when P.Cd_Prod then '1' else '0' end) as EsGrupo,
		P.IB_Srs, UMP.Factor,null as Cd_IP, 0.0 as CamMda
		from GuiaRemisionDet c 
		left join GuiaRemision gr on c.RucE = gr.RucE and c.Cd_GR = gr.Cd_GR
		left join Producto2 as P on P.RucE = c.RucE and P.Cd_Prod = c.Cd_Prod  
		left join Prod_UM as UMP on UMP.RucE = c.RucE and UMP.Cd_Prod = c.Cd_Prod and UMP.ID_UMP = c.ID_UMP
		left join Venta as vt on vt.RucE = c.RucE and vt.Cd_Vta = c.Cd_Vta --and vt.Cd_Vta = vtadet.Cd_Vta-->>> NUEVO
		left join VentaDet as vtadet  on vtadet.RucE = c.RucE and vtadet.Cd_Vta = vt.Cd_Vta and vtadet.Cd_Prod = P.Cd_Prod and UMP.ID_UMP = vtadet.ID_UMP
		left join Cliente2 as ct on ct.RucE = c.RucE and ct.Cd_Clt = vt.Cd_Clt -->>> NUEVO
		left join ProdCombo pc on P.RucE=pc.RucE and P.Cd_Prod=pc.Cd_ProdB and UMP.Id_UMP = pc.Id_UMP
		where c.RucE = @RucE and c.Cd_GR = @Cd_GR and c.Cd_Prod is not null
	end

end
------------- S O L I C I T U D    D E   R E Q U E R I M I E N T O ----------
else if(@Cd_SR != '' or @Cd_SR is not null)
begin  -- MM: VERIFICACION DE SALDO
	select	null as Cd_Com, null as Cd_Vta, null as Cd_OC, null as Cd_OP,null as Cd_GR, null as Cd_TD, null as NroSre, 
			sr.NroSR as NroDoc, Item, srd.Cd_Prod, pr.CodCo1_ as CodCom, null as Cd_Alm, pr.Nombre1, pr.Descrip, ump.ID_UMP, ump.DescripAlt,
			srd.Cant, srd.Cant - t2.Saldo as Cant_Ing ,t2.Saldo as Pendiente, [dbo].[CostEnt3](@RucE ,srd.Cd_Prod , UMP.ID_UMP , sr.FecEmi , @Cd_Mda ) as Costo, sr.Cd_CC, sr.Cd_SC, sr.Cd_SS, 
			null as Cd_Clt, null as Cd_Prv, srd.Cd_SR, null as Cd_OF, convert(int,case(pc.Cd_ProdB) when srd.cd_Prod then '1' else '0' end) as EsGrupo,
			pr.IB_Srs, UMP.Factor,null as Cd_IP, 0.0 as CamMda
	from (
		select RucE, Cd_SR, Cd_Prod, ID_UMP, sum(case when (Cant<0) then 0 else Cant end) as 'Total', sum(Cant) as 'Saldo' from(
			select RucE, Cd_SR, Cd_Prod, isnull(Cant,0) as Cant, ID_UMP
			from SolicitudReqDet where RucE = @RucE and Cd_SR = @Cd_SR and Cd_Prod is not null
			union all
			select RucE, Cd_SR, Cd_Prod, isnull(-Cant,0) as Cant, ID_UMP
			from SolicitudComDet where RucE = @RucE and Cd_SR = @Cd_SR and Cd_Prod is not null
			union all
			select RucE, Cd_SR, Cd_Prod, isnull(-Cant_Ing,0) as Cant, ID_UMP
			from Inventario where RucE = @RucE and Cd_SR = @Cd_SR and Cd_Prod is not null
		) as t1
		group by RucE, Cd_SR, Cd_Prod, ID_UMP
	) as t2
	join SolicitudReq sr on sr.RucE = t2.RucE
	join SolicitudReqDet srd on srd.RucE = sr.RucE and sr.Cd_SR = srd.Cd_SR and srd.Cd_Prod = t2.Cd_Prod
	join Producto2 pr on pr.RucE = t2.RucE and pr.Cd_Prod = t2.Cd_Prod
	left join Prod_UM as UMP on UMP.RucE = t2.RucE and UMP.Cd_Prod = t2.Cd_Prod and UMP.ID_UMP = t2.ID_UMP
	left join ProdCombo pc on pr.RucE=pc.RucE and pr.Cd_Prod=pc.Cd_ProdB and UMP.Id_UMP = pc.Id_UMP
	where sr.Cd_SR = @Cd_SR
end

----------------  O R D E N    D E    F A B R I C A C I O N  --------------
else if(@Cd_OF != '' or @Cd_OF is not null)
begin
select distinct
	null as Cd_Com, null as Cd_Vta, null as Cd_OC, null as Cd_OP,null as Cd_GR, null as Cd_TD, null as NroSre, ordf.NroOF as NroDoc,
	Item, f.Cd_Prod, P.CodCo1_ as CodCom,ordf.Cd_Alm,P.Nombre1,P.Descrip,UMP.ID_UMP,UMP.DescripAlt,(f.Cant * ordf.Cant) as Cant, 
	ABS(isnull((select sum(Cant_Ing) from Inventario i where i.RucE = f.RucE and i.Cd_OF = f.Cd_OF and i.Cd_Prod=f.Cd_Prod and i.Item = f.Item),0 ))as Cant_Ing,
	(f.Cant * ordf.Cant)-ABS(isnull((select sum(Cant_Ing) from Inventario i where i.RucE = f.RucE and i.Cd_OF = f.Cd_OF and i.Cd_Prod=f.Cd_Prod and i.Item = f.Item),0 ))as Pendiente,
	isnull(dbo.CostSal3(@RucE,UMP.Cd_Prod,UMP.ID_UMP,ordf.FecE, @Cd_Mda), .0000000) as Costo, ordf.Cd_CC, ordf.Cd_SC, ordf.Cd_SS,
	null as Cd_Clt, null as Cd_Prv, null as Cd_SR, ordf.Cd_OF,--
	convert(int,case(pc.Cd_ProdB) when P.Cd_Prod then '1' else '0' end) as EsGrupo,
	P.IB_Srs, UMP.Factor,null as Cd_IP, ordf.CamMda as CamMda
	from FrmlaOF f 
	left join OrdFabricacion as ordf on ordf.RucE = f.RucE and ordf.Cd_OF = f.Cd_OF
	left join Producto2 as P on P.RucE = f.RucE and P.Cd_Prod = f.Cd_Prod  
	left join Prod_UM as UMP on UMP.RucE = f.RucE and UMP.Cd_Prod = f.Cd_Prod and UMP.ID_UMP = f.ID_UMP
	left join ProdCombo pc on P.RucE=pc.RucE and P.Cd_Prod=pc.Cd_ProdB and UMP.Id_UMP = pc.Id_UMP
	where f.RucE = @RucE and f.Cd_OF = @Cd_OF  and f.Cd_Prod is not null
union
select distinct
	null as Cd_Com, null as Cd_Vta, null as Cd_OC, null as Cd_OP,null as Cd_GR, null as Cd_TD, null as NroSre, ordf.NroOF as NroDoc,
	Item, f.Cd_Prod, P.CodCo1_ as CodCom, ordf.Cd_Alm,P.Nombre1,P.Descrip,UMP.ID_UMP,UMP.DescripAlt,(f.Cant * ordf.Cant) as Cant, 
	ABS(isnull((select sum(Cant_Ing) from Inventario i where i.RucE = f.RucE and i.Cd_OF = f.Cd_OF and i.Cd_Prod=f.Cd_Prod and i.Item = f.Item),0 ))as Cant_Ing,
	(f.Cant * ordf.Cant)-ABS(isnull((select sum(Cant_Ing) from Inventario i where i.RucE = f.RucE and i.Cd_OF = f.Cd_OF and i.Cd_Prod=f.Cd_Prod and i.Item = f.Item),0 ))as Pendiente,
	isnull(dbo.CostSal3(@RucE,UMP.Cd_Prod,UMP.ID_UMP,ordf.FecE, @Cd_Mda), .0000000) as Costo, ordf.Cd_CC, ordf.Cd_SC, ordf.Cd_SS,
	null as Cd_Clt, null as Cd_Prv, null as Cd_SR, ordf.Cd_OF,--
	convert(int,case(pc.Cd_ProdB) when P.Cd_Prod then '1' else '0' end) as EsGrupo,
	P.IB_Srs, UMP.Factor,null as Cd_IP, ordf.CamMda as CamMda
	from EnvEmbOF f 
	left join OrdFabricacion as ordf on ordf.RucE = f.RucE and ordf.Cd_OF = f.Cd_OF
	left join Producto2 as P on P.RucE = f.RucE and P.Cd_Prod = f.Cd_Prod  
	left join Prod_UM as UMP on UMP.RucE = f.RucE and UMP.Cd_Prod = f.Cd_Prod and UMP.ID_UMP = f.ID_UMP
	left join ProdCombo pc on P.RucE=pc.RucE and P.Cd_Prod=pc.Cd_ProdB and UMP.Id_UMP = pc.Id_UMP
	where f.RucE = @RucE and f.Cd_OF = @Cd_OF  and f.Cd_Prod is not null
end
else
-----------------------  I M P O R T A C I O N   ---------------------------------
if(@Cd_IP != '' or @Cd_IP is not null)
begin
	select @NroDoc=NroImp  from Importacion where RucE=@RucE and Cd_IP=@Cd_IP
	select distinct
	c.Cd_Com as Cd_Com, null as Cd_Vta, @Cd_OC as Cd_OC, null as Cd_OP,null as Cd_GR, @Cd_TD as Cd_TD, @NroSre as NroSre, @NroDoc as NroDoc,
	Item, c.Cd_Prod,P.CodCo1_ as CodCom,null as Cd_Alm,P.Nombre1,P.Descrip,UMP.ID_UMP,UMP.DescripAlt,c.Cant, 
	--isnull((select sum(Cant_Ing) from Inventario i where i.RucE = c.RucE and i.Cd_Com = c.Cd_Com and i.Cd_Prod=c.Cd_Prod and i.Item = c.Item),0 )as Cant_Ing,
	0.0 as Pendiente,--c.Cant-isnull((select sum(Cant_Ing) from Inventario i where i.RucE = c.RucE and i.Cd_Com = c.Cd_Com and i.Cd_Prod=c.Cd_Prod and i.Item = c.Item),0 )as Pendiente,
	/*PU*/ c.CU as Costo,ip.Cd_CC,ip.Cd_SC, ip.Cd_SS,
	null as Cd_Clt, null as Cd_Prv, null as Cd_SR,null as Cd_OF,--
	convert(int,case(pc.Cd_ProdB) when P.Cd_Prod then '1' else '0' end) as EsGrupo,
	--null as EsGrupo,
	P.IB_Srs, UMP.Factor,ip.Cd_IP, cp.CamMda, convert(numeric(18,3),(ip.Total / ip.Total_ME)) as CamMda2
	from ImportacionDet c 
	left join Producto2 as P on P.RucE = c.RucE and P.Cd_Prod = c.Cd_Prod  
	left join Prod_UM as UMP on UMP.RucE = c.RucE and UMP.Cd_Prod = c.Cd_Prod and UMP.ID_UMP = c.ID_UMP
	left join Importacion as ip on ip.RucE = c.RucE and ip.Cd_IP = c.Cd_IP -->>> NUEVO
	--left join Proveedor2 as prv on prv.RucE = c.RucE and prv.Cd_Prv = com.Cd_Prv -->>> NUEVO
	left join ProdCombo pc on P.RucE=pc.RucE and P.Cd_Prod=pc.Cd_ProdB and UMP.Id_UMP = pc.Id_UMP
	left join Compra cp on cp.RucE = c.RucE and cp.Cd_Com = c.Cd_Com
	where c.RucE = @RucE and c.Cd_IP = @Cd_IP and c.Cd_Prod is not null
end
else
-----------------------  F A B R I C A C I O N   ---------------------------------
if(@Cd_FAB != '' or @Cd_FAB is not null)
begin
	select @NroDoc=NroFab from FabFabricacion where RucE=@RucE and Cd_Fab=@Cd_FAB
	select distinct
	null as Cd_com, null as Cd_Vta, null as Cd_OC, null as Cd_OP,null as Cd_GR, null as Cd_TD, null as NroSre, @NroDoc as NroDoc,
	null  as Item, c.Cd_Prod,P.CodCo1_ as CodCom, null as Cd_Alm,P.Nombre1,P.Descrip,UMP.ID_UMP,UMP.DescripAlt,c.Cant, 
	null as Cant_Ing,
	null as Pendiente,
	[dbo].[CostEnt3](@RucE ,c.Cd_Prod , UMP.ID_UMP , c.FecEmi , @Cd_Mda ) as Costo,c.Cd_CC,c.Cd_SC, c.Cd_SS,
	ct.Cd_Clt, null as Cd_Prv, null as Cd_SR,null as Cd_OF,--
	convert(int,case(pc.Cd_ProdB) when P.Cd_Prod then '1' else '0' end) as EsGrupo,
	P.IB_Srs, UMP.Factor,null as Cd_IP, c.CamMda
	from FabFabricacion c 
	left join Producto2 as P on P.RucE = c.RucE and P.Cd_Prod = c.Cd_Prod  
	left join Prod_UM as UMP on UMP.RucE = c.RucE and UMP.Cd_Prod = c.Cd_Prod and UMP.ID_UMP = c.ID_UMP
	--left join Compra as com on com.RucE = c.RucE and com.Cd_Com = c.Cd_Com -->>> NUEVO
	--left join Proveedor2 as prv on prv.RucE = c.RucE and prv.Cd_Prv = com.Cd_Prv -->>> NUEVO
	left join Cliente2 as ct on ct.RucE = c.RucE and ct.Cd_Clt = c.Cd_Clt -->>> NUEVO
	left join ProdCombo pc on P.RucE=pc.RucE and P.Cd_Prod=pc.Cd_ProdB and UMP.Id_UMP = pc.Id_UMP
	where c.RucE = @RucE and c.Cd_Fab = @Cd_FAB and c.Cd_Prod is not null
end
--select * from Importacion where RucE = '11111111111' and Cd_IP = 'IP00086'

-- CAM <Fecha: 10/09/2012><Creacion del sp><Agrego camMda en todos>


-- PARA COMPRAS
-- exec Inv_Producto2Cons_paInv20 '20538349730','CM00000090',null,null,null,null,null,null,'','',''
-- PARA VENTAS
-- EXEC Inv_Producto2Cons_paInv20 '20538349730',NULL, 'VT00000291', NULL, NULL, NULL, NULL, NULL, '','',''
-- PARA ORDEN DE COMPRA
-- EXEC [dbo].[Inv_Producto2Cons_paInv16] '11111111111',NULL, NULL, 'OC00000032', NULL, NULL, NULL, NULL, ''
-- PARA ORDEN DE PEDIDO
-- EXEC [dbo].[Inv_Producto2Cons_paInv16] '11111111111',NULL, NULL, NULL, 'OP00000054', NULL, NULL, NULL, ''
-- PARA GUIA REMISION
-- Compra: exec Inv_Producto2Cons_paInv20 '11111111111',null,null,null,null,'GR00000084','',null,'',''
-- Venta : exec Inv_Producto2Cons_paInv21 '20102028687',null,null,null,null,'GR00001009','','','','','','',''
-- PARA SOLICITUD DE REQUERIMIENTO
-- exec Inv_Producto2Cons_paInv20 '11111111111',null,null,null,null,null,'SR00000167','','','','',''
-- PARA ORDEN DE FABRICACION
-- exec Inv_Producto2Cons_paInv20 '11111111111',null,null,null,null,null,null,'OF00000001','','','',''
-- PARA IMPORTACION
-- exec Inv_Producto2Cons_paInv20 '11111111111',null,null,null,null,null,null,null,'IP00086','','',''
/*
exec Inv_Producto2Cons_paInv20 '11111111111',null,null,null,null,null,null,null,'IP00086','','',''
select * from Inventario where RucE = '11111111111' and regctb = 'INGE_LD09-00012'
select * from Importaciondet where RucE = '11111111111' and Cd_IP='IP00089'

select * from GuiaRemision where RucE = '20102028687' and NroGR like '%55994%'--'%56491%'

select * from GuiaRemision where RucE = '20102028687' and Cd_GR in('GR00000332','GR00000534')
--and Cd_Prod = 'PD00125' or Cd_Prod = 'PD00126'
GR00000332
GR00000534

select * from OrdCompradet where RucE = '20102028687' and Cd_OC = 'OC00000034'

select * from Inventario where RucE = '20102028687' and Cd_OC = 'OC00000034'


select * from OrdCompra where RucE = '11111111111'
*/
GO
