SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create proc [dbo].[Inv_GuiaRemision_ConsXPrvOrd1]
@RucE nvarchar(11),
@Cd_Prv char(7),
@IC_ES nvarchar(4),
@Colum nvarchar(15),
@IB_Anulado bit,
@msj varchar(100) output
as
declare @consulta varchar(8000)
if(@IB_Anulado=1)
	begin
		if (@Cd_Prv is not null)
		begin
		set @consulta=	'select convert(Nvarchar,  co.FecEmi,103) as FecMov, co.Cd_TD,co.NroSre,co.nroGR as NroDoc,
			co.Cd_GR as CodMov,  
			convert(Nvarchar,co.FecEmi,103) as FecED from GuiaRemision co
			where co.RucE = '''+@RucE+''' and co.Cd_Prv = '''+@Cd_Prv+''' and IC_ES = '''+@IC_ES+'''
			order by  '+@Colum+' desc'
			print @consulta
			exec (@consulta)
			print @msj
		end
		else
		begin 
		set @consulta=	'select convert(Nvarchar,  co.FecEmi,103) as FecMov, co.Cd_TD,co.NroSre,co.nroGR as NroDoc,
			co.Cd_GR as CodMov,  
			convert(Nvarchar,co.FecEmi,103) as FecED from GuiaRemision co
			where co.RucE = '''+@RucE+''' and IC_ES = '''+@IC_ES+'''
			order by  '+@Colum+' desc'
			print @consulta
			exec (@consulta)
			print @msj
		end
	end
else if(@IB_Anulado=0)
	begin
		if (@Cd_Prv is not null)
		begin
		set @consulta=	'select convert(Nvarchar,  co.FecEmi,103) as FecMov, co.Cd_TD,co.NroSre,co.nroGR as NroDoc,
			co.Cd_GR as CodMov,  
			convert(Nvarchar,co.FecEmi,103) as FecED from GuiaRemision co
			where co.RucE = '''+@RucE+''' and IB_Anulado=0 and co.Cd_Prv = '''+@Cd_Prv+''' and IC_ES = '''+@IC_ES+'''
			order by  '+@Colum+' desc'
			print @consulta
			exec (@consulta)
			print @msj
		end
		else
		begin 
		set @consulta=	'select convert(Nvarchar,  co.FecEmi,103) as FecMov, co.Cd_TD,co.NroSre,co.nroGR as NroDoc,
			co.Cd_GR as CodMov,  
			convert(Nvarchar,co.FecEmi,103) as FecED from GuiaRemision co
			where co.RucE = '''+@RucE+''' and IB_Anulado=0 and IC_ES = '''+@IC_ES+'''
			order by  '+@Colum+' desc'
			print @consulta
			exec (@consulta)
			print @msj
		end
	end
-- Leyenda --
-- FL : 19/04/2011 : <Creacion del procedimiento almacenado>
--Pruebas:
-- exec Inv_GuiaRemision_ConsXPrvOrd '11111111111',null,'E','FecEmi',null
-- exec Inv_GuiaRemision_ConsXPrvOrd '11111111111','PRV0008','E','FecEmi',null




GO
