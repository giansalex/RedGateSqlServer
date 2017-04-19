SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create proc [user321].[Inv_GuiaRemision_ConsXClt_1]
@RucE nvarchar(11),
@Cd_Clt char(10),
@IC_ES nvarchar(4),
@IB_Anulado bit,
@msj varchar(100) output
--with encryption
as
if(@IB_Anulado=1)
	begin
		if (@Cd_Clt is not null)
		begin
			select  convert(Nvarchar,  co.FecEmi,103) as FecMov, co.Cd_TD,co.NroSre,co.nroGR as NroDoc,
			co.Cd_GR as CodMov,  
			convert(Nvarchar,co.FecEmi,103) as FecED from GuiaRemision co
			where co.RucE = @RucE and co.Cd_Clt = @Cd_Clt and IC_ES = @IC_ES
			order by  year(co.FecEmi) desc, month(co.FecEmi) desc, day(co.FecEmi) desc
			print @msj
		end
		else
		begin 
			select  convert(Nvarchar, co.FecEmi,103) as FecMov, co.Cd_TD,co.NroSre,co.nroGR as NroDoc,
			co.Cd_GR as CodMov,  
			convert(Nvarchar,co.FecEmi,103) as FecED from GuiaRemision co
			where co.RucE = @RucE and IC_ES = @IC_ES
			order by  year(co.FecEmi) desc, month(co.FecEmi) desc, day(co.FecEmi) desc
			print @msj
		end
	end
else if(@IB_Anulado=0)
	begin
		if (@Cd_Clt is not null)
		begin
			select  convert(Nvarchar,  co.FecEmi,103) as FecMov, co.Cd_TD,co.NroSre,co.nroGR as NroDoc,
			co.Cd_GR as CodMov,  
			convert(Nvarchar,co.FecEmi,103) as FecED from GuiaRemision co
			where co.RucE = @RucE and co.Cd_Clt = @Cd_Clt and IC_ES = @IC_ES and IB_Anulado=0
			order by  year(co.FecEmi) desc, month(co.FecEmi) desc, day(co.FecEmi) desc
			print @msj
		end
		else
		begin 
			select  convert(Nvarchar, co.FecEmi,103) as FecMov, co.Cd_TD,co.NroSre,co.nroGR as NroDoc,
			co.Cd_GR as CodMov,  
			convert(Nvarchar,co.FecEmi,103) as FecED ,
			c.Cant-ABS(isnull((select sum(Cant_Ing) 
			from Inventario i 
			where i.RucE = c.RucE and i.Cd_GR = c.Cd_GR and i.Cd_Prod=c.Cd_Prod and i.Item = c.Item),0 )) as Pendiente
			from GuiaRemision co
			left join GuiaRemisionDet c on c.RucE = co.RucE and c.Cd_GR = co.Cd_GR
			where co.RucE = @RucE and IC_ES = @IC_ES and IB_Anulado=0
			-- and CalcularPendienteGRxINV(@RucE,co.Cd_GR) = 0
			order by  year(co.FecEmi) desc, month(co.FecEmi) desc, day(co.FecEmi) desc
			print @msj
		end
	end
-- Leyenda --
-- CAM : 02/12/2010 : <Creacion del procedimiento almacenado>
-- Pruebas:
-- exec user321.Inv_GuiaRemision_ConsXClt '11111111111',null,'S',0,''
-- exec Inv_GuiaRemision_ConsXClt '11111111111','GR00000292','S',''

-- select * from GuiaRemision where RucE = '11111111111' and IC_ES = 'S'
GO
