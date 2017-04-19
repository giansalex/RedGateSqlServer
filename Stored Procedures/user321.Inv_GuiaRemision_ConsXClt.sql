SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE proc [user321].[Inv_GuiaRemision_ConsXClt]
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
			convert(Nvarchar,co.FecEmi,103) as FecED from GuiaRemision co
			where co.RucE = @RucE and IC_ES = @IC_ES and IB_Anulado=0
			order by  year(co.FecEmi) desc, month(co.FecEmi) desc, day(co.FecEmi) desc
			print @msj
		end
	end
-- Leyenda --
-- CAM : 02/12/2010 : <Creacion del procedimiento almacenado>
--Pruebas:
-- exec Inv_GuiaRemision_ConsXClt '11111111111',null,'S',''
-- exec Inv_GuiaRemision_ConsXClt '11111111111','CLT0000009','S',''
-- select * from GuiaRemision where RucE = '11111111111' and IC_ES = 'S'
GO
