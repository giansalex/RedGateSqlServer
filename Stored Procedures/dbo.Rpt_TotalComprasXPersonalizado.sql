SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE	Procedure [dbo].[Rpt_TotalComprasXPersonalizado]
	@RucE nvarchar(11),@Ejer nvarchar(4),@FecIni datetime,@FecFin datetime,@Cd_Prod nvarchar(7),@msj varchar(100) output
	--set @RucE = '11111111111'
	--set @Ejer = '2012'
	--set @FecIni = '01/08/2012'
	--set @FecFin = '31/08/2012'
	--set @Cd_Prod = ''
as
if not exists(select top 1 * from Venta where RucE = @RucE and Eje = @Ejer and Fecmov between @FecIni and @FecFin + ' 23:59:29')
set @msj='No existen ventas'
else
begin
	select e.RSocial,@Ejer as Ejer,'DEL '+Convert(nvarchar,@FecIni,103)+' AL '+Convert(nvarchar,@FecFin,103) as Fecha, @RucE as RucE 
	from Empresa e where Ruc = @RucE
	
	select 
	cd.RucE
	,cd.Cd_Com
	,cd.Cant
	,cd.Valor
	,cd.DsctoP	
	,cd.DsctoI
	,case c.Cd_Mda when '01' then (cd.Total-(cd.IGV*cd.Cant))
					when '02' then (((cd.Total-(cd.IGV*cd.Cant)))*c.CamMda) end as IMP
					
	,case c.Cd_Mda when '01' then cd.IGV
					when '02' then (cd.IGV*c.CamMda) end as IGV
					
	,case c.Cd_Mda when '02' then cd.IMPTot 
					when '01' then (cd.IMPTot/c.CamMda) end as IMP_ME
	,case c.Cd_Mda when '02' then cd.IGV
					when '01' then (cd.IGV/c.CamMda) end as IGV_ME
	
	,cd.DsctoP
	,cd.Cd_CC
	,cd.Cd_SC
	,cd.Cd_SS
	,cd.Cd_Prod
	,cd.Cd_Srv
	,cd.Cd_Alm
	,case when isnull(prv.RSocial,'') <>'' then prv.RSocial else prv.ApPat+' '+prv.ApMat+' '+prv.Nom end as Proveedor
	,c.CamMda
	,c.FecMov,case when c.Cd_Mda = '01'then 'S/.' else 'US$' end as Moneda
	,case c.Cd_Mda when '01' then cd.Total 
					when '02' then (cd.Total*c.CamMda) end as TotalDet
	,case c.Cd_Mda when '02' then cd.Total 
					when '01' then (cd.Total/c.CamMda) end as TotalDetME
					
	--,isnull(p.Cd_Prod,isnull(p.CodCo1_,isnull(s.CodCo,''))) as CodCom1
	,isnull(p.Cd_Prod,isnull(s.Cd_Srv,isnull(p.CodCo1_,isnull(s.CodCo,'')))) as CodCom1
	,p.CodCo2_ as CodCom2
	,p.CodCo2_ as CodCom3
	,isnull(s.Nombre,'') as NomSrv
	,isnull(p.Nombre1,isnull(s.Nombre,'')) as Nombre1
	,p.Nombre2
	,DATENAME(month, c.FecMov) as Mes
	,c.UsuCrea
	,case c.Cd_Mda when '01' then (case when isnull(cd.Igv,0)<> 0 then cast((cd.PU/1.18) as dec(10,2)) else cd.PU end)
					when '02' then cast((case when isnull(cd.Igv,0)<> 0 then cast((cd.PU/1.18) as dec(10,2)) else cd.PU end)*c.CamMda as dec(10,2))
					end as PU
	,c.Cd_TD
	,c.NroSre
	,c.NroDoc
	,c.FecED as FechaEmision
	,c.RegCtb
	 from CompraDet cd
	inner join Compra c on c.RucE = cd.RucE and c.Cd_Com = cd.Cd_Com
    left join Producto2 p on p.RucE = cd.RucE and p.Cd_Prod = cd.Cd_Prod
    left join Servicio2 s on s.RucE = cd.RucE and s.Cd_Srv = cd.Cd_Srv 
	Left Join Prod_UM ump on ump.RucE=cd.RucE and ump.ID_UMP = cd.ID_UMP and  ump.Cd_Prod = p.Cd_Prod
	Left Join UnidadMedida um on um.Cd_UM = ump.Cd_UM
	left join Proveedor2 prv on prv.RucE = cd.RucE and prv.Cd_Prv = c.Cd_Prv
	Where c.RucE = @RucE and c.Ejer=@Ejer and c.FecMov between @FecIni and @FecFin + ' 23:59:29' 
end
print @msj
--Creado x JA <20/08/2012>
--Prueba exec Rpt_TotalComprasXPersonalizado '20527146136','2012','01/01/2012','31/12/2012','',null

--select * from Empresa where Rsocial like '%inge%'
--select * from Compra where RucE = '20506704490' and cd_Com = 'CM00003118'
--select * from CompraDet where RucE = '20506704490' and cd_Com = 'CM00003118'





GO
