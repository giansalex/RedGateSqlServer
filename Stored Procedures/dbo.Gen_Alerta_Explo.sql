SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[Gen_Alerta_Explo]
@RucE char(11),
@Ejer varchar(4),
@msj varchar(100) output
AS
BEGIN
	
	DECLARE @TempDETRACCION TABLE ( 
				RucE nvarchar(12),
				Cd_TA char(2),
				DescripTA varchar(150),	
				usuario nvarchar(100),			
				Pendiente int,
				Vencido int
			)
	DECLARE @Temp TABLE ( 		
				Nro int )

	DECLARE @Temp1 TABLE ( 		
				Nro int )
	DECLARE @Temp2 TABLE ( 		
					Nro int )
	DECLARE @Temp3 TABLE ( 		
						Nro int )


	INSERT INTO @TempDETRACCION (Pendiente,Vencido)  exec Rpt_Detraccion_Alerta @RucE,@Ejer
	UPDATE @TempDETRACCION set RucE=@RucE , Cd_TA='02', DescripTA='Alerta de Detracciones'

	INSERT INTO @Temp(Nro)  exec Rpt_CtasXCbr_Detallada_CtbNroVR @RucE,@Ejer,'01',null,null,null,0
	INSERT INTO @Temp1(Nro)  exec Rpt_CtasXCbr_Detallada_CtbNroVN @RucE,@Ejer,'01',null,null,null,0
	INSERT INTO @Temp2(Nro)	 exec Rpt_CtasXPag_Detallada_CtbNroVR @RucE,@Ejer,'01',null,null,null,0
	INSERT INTO @Temp3(Nro)	 exec Rpt_CtasXPag_Detallada_CtbNroVN @RucE,@Ejer,'01',null,null,null,0

	SET NOCOUNT ON;

	select au.RucE,au.Cd_TA,au.DescripTA as DescripTA,NomUsu as usuario,tg.Nro as DocProdAfec,au.IB_NoRecordar as NRecordar, au.IB_RecProxIni as RInicio, au.IB_RecCada as RCada,au.IB_RecDentro as RDentro
	from(Select au.RucE,au.Cd_TA,ta.Descrip as DescripTA ,au.NomUsu, case IB_NoRecordar When 1 Then 'Inactiva' Else 'Activa' End as 'Activa', au.IB_NoRecordar, au.IB_RecProxIni, au.IB_RecCada, au.IB_RecDentro, au.RecordarCada, au.RecordarDentro, au.CampoConfg
	from AlertXUsu au join TipAlert ta on (au.Cd_TA = ta.Cd_TA)
	Where RucE = @RucE )as au
		inner join (
			--::::::::::::: CONTRATO "Alerta de Contratos" ::::::::::::::::::::::::::::::::::::::::::::::::::::::
		    --TABLA GENERAL
			--PENDIENTES and VENCIDOS Doc_ContratoPendienteNroCons1
			select Cd_TA, Descrip as 'DescripTA',usuario, Nro from (select ta.Cd_TA as Cd_TA,ta.Descrip ,u.NomUsu as usuario, count(c.RucE) as 'Nro'
			from contrato c 
				 inner join Area a on a.Cd_Area = c.Cd_Area
				 inner join AreaXUsuario au on au.Cd_Area=a.Cd_Area
				 inner join Usuario u on u.NomUsu=au.NomUsu
				 inner join AlertXUsu aleru on aleru.NomUsu=u.NomUsu
				 inner join TipAlert ta on ta.Cd_TA=aleru.Cd_TA
			where (c.RucE=@RucE and datediff(d,getdate(),fecfin)<convert(int,8) and datediff(d,getdate(),fecfin)>-1) or 
				  (c.RucE=@RucE and datediff(d,getdate(),fecfin)<0 and datediff(d,getdate(),fecfin)>-31)
			group by ta.Cd_TA,ta.Descrip,u.NomUsu) GContrato				
			
			union all
			--::::::::::::: DETRACCION "Alerta de Detracciones" ::::::::::::::::::::::::::::::::::::::::::::::::::::::
			select Cd_TA,DescripTA,usuario,(isnull(Pendiente,0)+isnull(Vencido,0)) as Nro from( SELECT td.RucE,td.Cd_TA,DescripTA,au.NomUsu as usuario,Pendiente,Vencido 
																						FROM @TempDETRACCION td
																						     inner join (Select DISTINCT RucE,NomUsu  from AlertXUsu where RucE=@RucE and Cd_TA='02') au  on au.RucE=td.RucE) as Detraccion  

			union all		

			--::::::::::::: COTIZACION "Alerta de Autorizaciones Cotizacion" ::::::::::::::::::::::::::::::::::::::::::::::::::::::
			select Cd_TA,DescripTA,usuario,Count(DOC) as Nro from(
			select ta.Cd_TA,ta.Descrip as 'DescripTA',cau.NomUsu as usuario , ct.cd_cot as 'DOC',
			case (niv) when 1 then (case (dbo.verificarAutNvl(@RucE, ct.cd_cot, 1, ib_autcomniv, 5)) when 1 then 'NO' else 'SI' end) 
			else ( case (dbo.verificarAutNvl(@RucE, ct.cd_cot, niv, ib_autcomniv, 5)) when 1 then 'NO' 
			else (case (dbo.verificarAutNvl(@RucE, ct.cd_cot, niv-1, ib_autcomniv, 5)) when 1 then 'SI' else 'NO' end) end) end
			as 'Autoriza'
			from cotizacion ct
			join CfgAutorizacion ca on ct.RucE = ca.RucE and ca.Cd_DMA = 'CT' and ca.Tipo = ct.TipAut 
			join cfgnivelaut cna on cna.Id_Aut = ca.id_aut
			join cfgAutsXUsuario cau on cau.id_niv = cna.id_niv	
			left join autcot act on ct.RucE = act.RucE and act.CD_Cot = ct.Cd_Cot and cau.nomusu = act.nomusu 
			inner join AlertXUsu au on au.RucE=ca.RucE and au.Cd_TA='03' and  cau.NomUsu=au.NomUsu
			inner join TipAlert ta on ta.Cd_TA='03' and ta.Cd_TA=au.Cd_TA 
			where ct.RucE = @RucE and (IB_Aut is null or IB_Aut = 0) and TipAut !=0 and YEAR(ct.FecEmi)<=@Ejer
			and act.nomusu is null
			) as tabla 
			where Autoriza = 'SI'
			group by Cd_TA,DescripTA,usuario

			union all
			--::::::::::::: ORDEN DE COMPRA "Alerta de Autorizaciones Orden de Compra" ::::::::::::::::::::::::::::::::::::::::::::::::::::::


			select Cd_TA,DescripTA,usuario,Count(DOC) as Nro from(
			select ta.Cd_TA,ta.Descrip as 'DescripTA',cau.NomUsu as usuario , oc.cd_OC as 'DOC',
			case (niv) when 1 then (case (dbo.verificarAutNvl(@RucE, oc.cd_oc, 1, ib_autcomniv, 0)) when 1 then 'NO' else 'SI' end) 
			else (case (dbo.verificarAutNvl(@RucE, oc.cd_oc, niv, ib_autcomniv, 0)) when 1 then 'NO' 
			else (case (dbo.verificarAutNvl(@RucE, oc.cd_oc, niv-1, ib_autcomniv, 0)) when 1 then 'SI' else 'NO' end) end) end
			as 'Autoriza'
			from ordCompra oc 
			join CfgAutorizacion ca on oc.RucE = ca.RucE and ca.Cd_DMA = 'OC' and ca.Tipo = oc.TipAut 
			join cfgnivelaut cna on cna.Id_Aut = ca.id_aut
			join cfgAutsXUsuario cau on cau.id_niv = cna.id_niv 
			left join autoc aoc on oc.RucE = aoc.RucE and aoc.CD_OC = oc.Cd_OC and cau.nomusu = aoc.nomusu 
			inner join AlertXUsu au on au.RucE=ca.RucE and au.Cd_TA='04' and  cau.NomUsu=au.NomUsu
			inner join TipAlert ta on ta.Cd_TA='04' and ta.Cd_TA=au.Cd_TA 
			where oc.RucE = @RucE and (IB_Aut is null or IB_Aut = 0) and TipAut !=0 and YEAR(oc.FecE)<=@Ejer
			 and aoc.nomusu is null
			) as tabla 
			where Autoriza = 'SI'
			group by Cd_TA,DescripTA,usuario
			
			union all
			--::::::::::::: FABRICACION "Alerta de Autorizaciones de Fabricacion" ::::::::::::::::::::::::::::::::::::::::::::::::::::::
			select Cd_TA,DescripTA,usuario,Count(DOC) as Nro from(
			select ta.Cd_TA,ta.Descrip as 'DescripTA',cau.NomUsu as usuario , ofb.Cd_OF as 'DOC',
			case (niv) when 1 then (case (dbo.verificarAutNvl(@RucE, ofb.Cd_OF, 1, ib_autcomniv, 4)) when 1 then 'NO' else 'SI' end) 
			else (case (dbo.verificarAutNvl(@RucE, ofb.Cd_OF, niv, ib_autcomniv, 5)) when 1 then 'NO' 
			else (case (dbo.verificarAutNvl(@RucE, ofb.Cd_OF, niv-1, ib_autcomniv, 5)) when 1 then 'SI' else 'NO' end) end) end
			as 'Autoriza'
			from OrdFabricacion ofb
			join CfgAutorizacion ca on ofb.RucE = ca.RucE and ca.Cd_DMA = 'OF' and ca.Tipo = ofb.TipAut 
			join cfgnivelaut cna on cna.Id_Aut = ca.id_aut
			join cfgAutsXUsuario cau on cau.id_niv = cna.id_niv 
			left join autof aof on ofb.RucE = aof.RucE and aof.Cd_OF = ofb.Cd_OF and cau.nomusu = aof.nomusu 
			inner join AlertXUsu au on au.RucE=ca.RucE and au.Cd_TA='05' and  cau.NomUsu=au.NomUsu
			inner join TipAlert ta on ta.Cd_TA='05' and ta.Cd_TA=au.Cd_TA 
			where ofb.RucE = @RucE and (IB_Aut is null or IB_Aut = 0) and TipAut !=0 and YEAR(ofb.FecE)<=@Ejer
			and aof.nomusu is null

			) as tabla 
			where Autoriza = 'SI'
			group by Cd_TA,DescripTA,usuario

			union all
			--::::::::::::: ORDEN PEDIDO "Alerta de Autorizaciones Orden de Pedido" ::::::::::::::::::::::::::::::::::::::::::::::::::::::

			select Cd_TA,DescripTA,usuario, Count(DOC) as Nro from(
			select ta.Cd_TA,ta.Descrip as 'DescripTA',cau.NomUsu as usuario ,op.cd_OP as 'DOC',
			case (niv) when 1 then (case (dbo.verificarAutNvl(@RucE, op.cd_op, 1, ib_autcomniv, 1)) when 1 then 'NO' else 'SI' end) 
			else ( case (dbo.verificarAutNvl(@RucE, op.cd_op, niv, ib_autcomniv, 1)) when 1 then 'NO' 
			else (case (dbo.verificarAutNvl(@RucE, op.cd_op, niv-1, ib_autcomniv, 1)) when 1 then 'SI' else 'NO' end) end) end
			as 'Autoriza'
			from ordPedido op 
			join CfgAutorizacion ca on op.RucE = ca.RucE and ca.Cd_DMA = 'OP' and ca.Tipo = op.TipAut 
			join cfgnivelaut cna on cna.Id_Aut = ca.id_aut
			join cfgAutsXUsuario cau on cau.id_niv = cna.id_niv 
			left join autop aop on op.RucE = aop.RucE and aop.CD_OP = op.Cd_OP and cau.nomusu = aop.nomusu 
			inner join AlertXUsu au on au.RucE=ca.RucE and au.Cd_TA='06' and  cau.NomUsu=au.NomUsu
			inner join TipAlert ta on ta.Cd_TA='06' and ta.Cd_TA=au.Cd_TA 
			where op.RucE = @RucE and (IB_Aut is null or IB_Aut = 0) and TipAut !=0 and YEAR(op.FecE)<=@Ejer
			and aop.nomusu is null

			) as tabla 
			where Autoriza = 'SI'
			group by Cd_TA,DescripTA,usuario

			union all
			--::::::::::::: SOLICITUD COMPRA "Alerta de Autorizaciones Solicitud de Compra" ::::::::::::::::::::::::::::::::::::::::::::::::::::::

			select Cd_TA,DescripTA,usuario,Count(DOC) as Nro from(
			select ta.Cd_TA,ta.Descrip as 'DescripTA',cau.NomUsu as usuario , sc.cd_SCo as 'DOC',
			case (niv) when 1 then (case (dbo.verificarAutNvl(@RucE, sc.cd_sco, 1, ib_autcomniv, 2)) when 1 then 'NO' else 'SI' end) 
			else ( case (dbo.verificarAutNvl(@RucE, sc.cd_sco, niv, ib_autcomniv, 2)) when 1 then 'NO' 
			else (case (dbo.verificarAutNvl(@RucE, sc.cd_sco, niv-1, ib_autcomniv, 2)) when 1 then 'SI' else 'NO' end) end) end
			as 'Autoriza'
			from solicitudCom sc 
			join CfgAutorizacion ca on sc.RucE = ca.RucE and ca.Cd_DMA = 'SC' and ca.Tipo = sc.TipAut 
			join cfgnivelaut cna on cna.Id_Aut = ca.id_aut
			join cfgAutsXUsuario cau on cau.id_niv = cna.id_niv 
			left join autsc asco on sc.RucE = asco.RucE and asco.CD_SCo = sc.Cd_SCo and cau.nomusu = asco.nomusu 
			inner join AlertXUsu au on au.RucE=ca.RucE and au.Cd_TA='07' and  cau.NomUsu=au.NomUsu
			inner join TipAlert ta on ta.Cd_TA='07' and ta.Cd_TA=au.Cd_TA 
			where sc.RucE = @RucE and (IB_Aut is null or IB_Aut = 0) and TipAut !=0 and YEAR(sc.FecEmi)<=@Ejer
			and asco.nomusu is null

			) as tabla 
			where Autoriza = 'SI'
			group by Cd_TA,DescripTA,usuario
			union all
			--::::::::::::: SOLICITUD REQUERIMIENTO "Alerta de Autorizaciones Solicitud de Requerimientos" ::::::::::::::::::::::::::::::::::::::::::::::::::::::

			select Cd_TA,DescripTA,usuario,Count(DOC) as Nro from(
			select ta.Cd_TA,ta.Descrip as 'DescripTA',cau.NomUsu as usuario , sr.cd_SR as 'DOC', 
			case (niv) when 1 then (case (dbo.verificarAutNvl(@RucE, sr.cd_sr, 1, ib_autcomniv, 3)) when 1 then 'NO' else 'SI' end) 
				else ( case (dbo.verificarAutNvl(@RucE, sr.cd_sr, niv, ib_autcomniv, 3)) when 1 then 'NO' 
				else (case (dbo.verificarAutNvl(@RucE, sr.cd_sr, niv-1, ib_autcomniv, 3)) when 1 then 'SI' else 'NO' end) end) end
				as 'Autoriza'
				from solicitudReq sr
				join CfgAutorizacion ca on sr.RucE = ca.RucE and ca.Cd_DMA = 'SR' and ca.Tipo = sr.TipAut 
				join cfgnivelaut cna on cna.Id_Aut = ca.id_aut
				join cfgAutsXUsuario cau on cau.id_niv = cna.id_niv 
				left join autsr asr on sr.RucE = asr.RucE and asr.CD_SR = sr.Cd_SR and cau.nomusu = asr.nomusu 
				inner join AlertXUsu au on au.RucE=ca.RucE and au.Cd_TA='08' and  cau.NomUsu=au.NomUsu
				inner join TipAlert ta on ta.Cd_TA='08' and ta.Cd_TA=au.Cd_TA 
				where sr.RucE = @RucE and (IB_Aut is null or IB_Aut = 0) and TipAut !=0 and YEAR(sr.FecEmi)<=@Ejer
				and asr.nomusu is null
			) as tabla 
			where Autoriza = 'SI'
			group by Cd_TA,DescripTA,usuario

			union all
			--::::::::::::: STOCK PRODUCTOS "Alerta de Stock de Productos" ::::::::::::::::::::::::::::::::::::::::::::::::::::::
			Select au.Cd_TA,au.Descrip as DescripTA,au.NomUsu as usuario,Nro from (select RucE,count(Alm.cd_Alm) as Nro from (select distinct i.RucE,i.cd_Alm
			from inventario i join producto2 p on i.Cd_Prod = p.Cd_Prod and i.RucE=p.RucE
			where i.RucE = @RucE
			Group By i.RucE,i.cd_Alm, p.StockAlerta
			having Sum(i.Cant)<p.StockAlerta) as Alm
			Group By RucE ) as alm
			inner join 
			(select a.RucE,t.Cd_TA,t.Descrip,a.NomUsu from AlertXUsu a inner join TipAlert t on t.Cd_TA=a.Cd_TA  where a.Cd_TA='09') as au
			 on au.RucE=alm.RucE
			
			union all
			----::::::::::::: FECHA VENCIMIENTO POR COBRAR "Alerta de Fecha de Vencimiento de Factura por Cobrar por Vencer" ::::::::::::::::::::::::::::::::::::::::::::::::::::::
			
			select Cd_TA,DescripTA,NomUsu as usuario,Nro from
			(SELECT @RucE as RucE,'10' as Cd_TA,'Alerta de Fecha de Vencimiento de Factura por Cobrar por Vencer' as DescripTA,Nro  fROM @Temp)as Temp
			inner join (select  distinct NomUsu,RucE from AlertXUsu where RucE=@RucE and Cd_TA='10') au on  au.RucE=Temp.RucE 
			
			union all
			----::::::::::::: FECHA VENC. FAC. X Cobrar VENC ""Alerta de Fecha de Vencimiento de Factura por Cobrar Vencida"" ::::::::::::::::::::::::::::::::::::::::::::::::::::::
			
			select Cd_TA,DescripTA,NomUsu as usuario,Nro from
			(SELECT @RucE as RucE,'11' as Cd_TA,'Alerta de Fecha de Vencimiento de Factura por Cobrar Vencida' as DescripTA,Nro  fROM @Temp1)as Temp1
			inner join (select  distinct NomUsu,RucE from AlertXUsu where RucE=@RucE and Cd_TA='11') au on  au.RucE=Temp1.RucE 
			----::::::::::::: FECHA VENC. FAC. X Pagar VENCER "Alerta de Fecha de Vencimiento de Factura por Pagar por Vencer" ::::::::::::::::::::::::::::::::::::::::::::::::::::::
			union all

			select Cd_TA,DescripTA,NomUsu as usuario,Nro from
			(SELECT @RucE as RucE,'12' as Cd_TA,'Alerta de Fecha de Vencimiento de Factura por Pagar por Vencer' as DescripTA,Nro  fROM @Temp2)as Temp2
			inner join (select  distinct NomUsu,RucE from AlertXUsu where RucE=@RucE and Cd_TA='12') au on  au.RucE=Temp2.RucE 

			----::::::::::::: FECHA VENC. FAC. X Pagar  VENCIDAS "Alerta de Fecha de Vencimiento de Factura por Pagar Vencidar" ::::::::::::::::::::::::::::::::::::::::::::::::::::::

			union all

			select Cd_TA,DescripTA,NomUsu as usuario,Nro from
			(SELECT @RucE as RucE,'13' as Cd_TA,'Alerta de Fecha de Vencimiento de Factura por Pagar Vencida' as DescripTA,Nro  fROM @Temp3)as Temp3
			inner join (select  distinct NomUsu,RucE from AlertXUsu where RucE=@RucE and Cd_TA='13') au on  au.RucE=Temp3.RucE 

			) tg on  tg.Cd_TA = au.Cd_TA and tg.usuario=au.NomUsu and tg.DescripTA=au.DescripTA

						
	Set @msj = ''






END		
		
	




	
GO
