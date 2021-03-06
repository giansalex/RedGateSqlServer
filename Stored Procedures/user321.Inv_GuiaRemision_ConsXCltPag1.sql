SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create proc [user321].[Inv_GuiaRemision_ConsXCltPag1]
@RucE nvarchar(11),
@Cd_Clt char(10),
@IC_ES nvarchar(4),
@TamPag int,
@IB_Anulado bit,
@msj varchar(100) output
as
declare @consulta varchar(8000)
if(@IB_Anulado=1)
	begin
		if (@Cd_Clt is not null)
		begin
		set @consulta='select top '+convert(nvarchar,@TamPag)+'  convert(Nvarchar,  co.FecEmi,103) as FecMov, co.Cd_TD,co.NroSre,co.nroGR as NroDoc,
			co.Cd_GR as CodMov,  
			convert(Nvarchar,co.FecEmi,103) as FecED from GuiaRemision co
			where co.RucE = '''+@RucE+''' and co.Cd_Clt = '''+@Cd_Clt+''' and IC_ES = '''+@IC_ES+'''
			order by  year(co.FecEmi) desc, month(co.FecEmi) desc, day(co.FecEmi) desc'
			print @consulta
			exec (@consulta)
			print @msj
		end
		else
		begin 
		set @consulta=	'select top '+convert(nvarchar,@TamPag)+'  convert(Nvarchar, co.FecEmi,103) as FecMov, co.Cd_TD,co.NroSre,co.nroGR as NroDoc,
			co.Cd_GR as CodMov,  
			convert(Nvarchar,co.FecEmi,103) as FecED from GuiaRemision co
			where co.RucE = '''+@RucE+''' and IC_ES = '''+@IC_ES+'''
			order by  year(co.FecEmi) desc, month(co.FecEmi) desc, day(co.FecEmi) desc'
			print @consulta
			exec (@consulta)
			print @msj
		end
	end
else if(@IB_Anulado=0)
	begin
		if (@Cd_Clt is not null)
		begin
		set @consulta='select top '+convert(nvarchar,@TamPag)+'  convert(Nvarchar,  co.FecEmi,103) as FecMov, co.Cd_TD,co.NroSre,co.nroGR as NroDoc,
			co.Cd_GR as CodMov,  
			convert(Nvarchar,co.FecEmi,103) as FecED from GuiaRemision co
			where co.RucE = '''+@RucE+''' and IB_Anulado=0 and co.Cd_Clt = '''+@Cd_Clt+''' and IC_ES = '''+@IC_ES+'''
			order by  year(co.FecEmi) desc, month(co.FecEmi) desc, day(co.FecEmi) desc'
			print @consulta
			exec (@consulta)
			print @msj
		end
		else
		begin 
		set @consulta=	'select top '+convert(nvarchar,@TamPag)+'  convert(Nvarchar, co.FecEmi,103) as FecMov, co.Cd_TD,co.NroSre,co.nroGR as NroDoc,
			co.Cd_GR as CodMov,  
			convert(Nvarchar,co.FecEmi,103) as FecED from GuiaRemision co
			where co.RucE = '''+@RucE+''' and IB_Anulado=0 and IC_ES = '''+@IC_ES+'''
			order by  year(co.FecEmi) desc, month(co.FecEmi) desc, day(co.FecEmi) desc'
			print @consulta
			exec (@consulta)
			print @msj
		end
	end
-- Leyenda --
-- FL : 22/02/2011 : <Creacion del procedimiento almacenado>
--Pruebas:
-- exec Inv_GuiaRemision_ConsXClt '11111111111',null,'S',''
-- exec Inv_GuiaRemision_ConsXClt '11111111111','CLT0000009','S',''
-- select * from GuiaRemision where RucE = '11111111111' and IC_ES = 'S'
GO
