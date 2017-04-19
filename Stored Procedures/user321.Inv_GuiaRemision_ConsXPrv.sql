SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE proc [user321].[Inv_GuiaRemision_ConsXPrv]
@RucE nvarchar(11),
@Cd_Prv char(7),
@IC_ES nvarchar(4),
@IB_Anulado bit,
@msj varchar(100) output
as
begin
if(@IB_Anulado=1)
	begin
		if (@Cd_Prv is not null)
		begin
			select  convert(Nvarchar,  co.FecEmi,103) as FecMov, co.Cd_TD,co.NroSre,co.nroGR as NroDoc,
			co.Cd_GR as CodMov,  
			convert(Nvarchar,co.FecEmi,103) as FecED from GuiaRemision co
			where co.RucE = @RucE and co.Cd_Prv = @Cd_Prv and IC_ES = @IC_ES
			order by  year(co.FecEmi) desc, month(co.FecEmi) desc, day(co.FecEmi) desc
			print @msj
		end
		else
		begin 
			select  convert(Nvarchar,  co.FecEmi,103) as FecMov, co.Cd_TD,co.NroSre,co.nroGR as NroDoc,
			co.Cd_GR as CodMov,  
			convert(Nvarchar,co.FecEmi,103) as FecED from GuiaRemision co
			where co.RucE = @RucE and IC_ES = @IC_ES
			order by  year(co.FecEmi) desc, month(co.FecEmi) desc, day(co.FecEmi) desc
			print @msj
		end
	end
else if(@IB_Anulado=0)
	begin
		if (@Cd_Prv is not null)
		begin
			select  convert(Nvarchar,  co.FecEmi,103) as FecMov, co.Cd_TD,co.NroSre,co.nroGR as NroDoc,
			co.Cd_GR as CodMov,  
			convert(Nvarchar,co.FecEmi,103) as FecED from GuiaRemision co
			where co.RucE = @RucE and co.Cd_Prv = @Cd_Prv and IC_ES = @IC_ES and IB_Anulado=0
			order by  year(co.FecEmi) desc, month(co.FecEmi) desc, day(co.FecEmi) desc
			print @msj
		end
		else
		begin 
			select  convert(Nvarchar,  co.FecEmi,103) as FecMov, co.Cd_TD,co.NroSre,co.nroGR as NroDoc,
			co.Cd_GR as CodMov,  
			convert(Nvarchar,co.FecEmi,103) as FecED from GuiaRemision co
			where co.RucE = @RucE and IC_ES = @IC_ES and IB_Anulado=0
			order by  year(co.FecEmi) desc, month(co.FecEmi) desc, day(co.FecEmi) desc
			print @msj
		end
	end

end
-- Leyenda --
-- CAM : 22/11/2010 : <Creacion del procedimiento almacenado>
--Pruebas:
-- exec Inv_GuiaRemision_ConsXPrv '11111111111',null,'E',''
-- exec Inv_GuiaRemision_ConsXPrv '11111111111','PRV0001','E',''
-- select * from GuiaRemision where RucE = '11111111111' and IC_ES = 'E'
GO
