SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE proc [user321].[Inv_GuiaRemision_ConsXClt2]
@RucE nvarchar(11),
@Cd_Clt char(10),
@IC_ES nvarchar(4),
@IB_Anulado bit,
@msj varchar(100) output
--with encryption
as
Declare @Cd_GR char(10)
Declare @pendiente numeric (15,9)
Declare @cont int
Declare @Cant int
Declare @table table(
FecMov datetime,Cd_TD varchar(5),NroSre nvarchar(15),NroDoc nvarchar(25) 
,CodMov nvarchar(25),FecED datetime,Saldos int ) 
Set @cont = 1

if(@IB_Anulado=1)
	begin
		if (@Cd_Clt is not null)
		begin
			Set @Cant =(select count(*) from GuiaRemision where RucE = @RucE and IC_ES = @IC_ES and Cd_Clt = @Cd_Clt)
			while( @cont <= @Cant)
			begin
				Set @Cd_GR = (SELECT top 1 Cd_GR FROM 
				(SELECT TOP (@cont) Cd_GR FROM GuiaRemision WHERE RucE = @RucE and IC_ES = @IC_ES and Cd_Clt = @Cd_Clt
			    ORDER BY Cd_GR) as a order by Cd_GR desc 
				)
				begin try
				Set @pendiente = [dbo].[CalcularPendienteGRxINV](@RucE,@Cd_GR)
				end try
				begin catch
				Set @pendiente = 0
				end catch
				
				if(@pendiente > 0)
				begin
					insert into @table (FecMov,Cd_TD,NroSre,NroDoc,CodMov,FecED,Saldos) 
					select  convert(Nvarchar,  co.FecEmi,103) as FecMov, co.Cd_TD,co.NroSre,co.nroGR as NroDoc,
					co.Cd_GR as CodMov,  
					convert(Nvarchar,co.FecEmi,103) as FecED , @pendiente as Saldos from GuiaRemision co
					where co.RucE = @RucE and co.Cd_Clt = @Cd_Clt and IC_ES = @IC_ES and Cd_GR = @Cd_GR and @pendiente != 0
					order by  year(co.FecEmi) desc, month(co.FecEmi) desc, day(co.FecEmi) desc					
				end
				Set @Cont = @Cont + 1
			end						
		end
		else
		begin 
			Set @Cant =(select count(*) from GuiaRemision where RucE = @RucE and IC_ES = @IC_ES)
			while( @cont <= @Cant)
			begin
				Set @Cd_GR = (SELECT top 1 Cd_GR FROM 
				(SELECT TOP (@cont) Cd_GR FROM GuiaRemision WHERE RucE = @RucE and IC_ES = @IC_ES 
			    ORDER BY Cd_GR) as a order by Cd_GR desc 
				)
				begin try
				Set @pendiente = [dbo].[CalcularPendienteGRxINV](@RucE,@Cd_GR)
				end try
				begin catch
				Set @pendiente = 0
				end catch
				
				if(@pendiente > 0)
				begin
					insert into @table (FecMov,Cd_TD,NroSre,NroDoc,CodMov,FecED,Saldos) 
					select  convert(Nvarchar,  co.FecEmi,103) as FecMov, co.Cd_TD,co.NroSre,co.nroGR as NroDoc,
					co.Cd_GR as CodMov,  
					convert(Nvarchar,co.FecEmi,103) as FecED , @pendiente as Saldos from GuiaRemision co
					where co.RucE = @RucE and IC_ES = @IC_ES and Cd_GR=@Cd_GR and @pendiente != 0
					order by  year(co.FecEmi) desc, month(co.FecEmi) desc, day(co.FecEmi) desc
				end
				Set @Cont = @Cont + 1
			end				
		end
	end
else if(@IB_Anulado=0)
	begin
		if (@Cd_Clt is not null)
		begin
			Set @Cant =(select count(*) from GuiaRemision where RucE = @RucE and IC_ES = @IC_ES and Cd_Clt = @Cd_Clt and IB_Anulado=0)
			while( @cont <= @Cant)
			begin
				Set @Cd_GR = (SELECT top 1 Cd_GR FROM 
				(SELECT TOP (@cont) Cd_GR FROM GuiaRemision WHERE RucE = @RucE and IC_ES = @IC_ES and Cd_Clt = @Cd_Clt and IB_Anulado=0
			    ORDER BY Cd_GR) as a order by Cd_GR desc 
				)
				begin try
				Set @pendiente = [dbo].[CalcularPendienteGRxINV](@RucE,@Cd_GR)
				--print 'pendiente GR =' + @pendiente
				end try
				begin catch
				Set @pendiente = 0
				end catch
				
				if(@pendiente > 0)
				begin
					insert into @table (FecMov,Cd_TD,NroSre,NroDoc,CodMov,FecED,Saldos) 
					select  convert(Nvarchar,  co.FecEmi,103) as FecMov, co.Cd_TD,co.NroSre,co.nroGR as NroDoc,
					co.Cd_GR as CodMov,  
					convert(Nvarchar,co.FecEmi,103) as FecED , @pendiente as Saldos from GuiaRemision co
					where co.RucE = @RucE and co.Cd_Clt = @Cd_Clt and IC_ES = @IC_ES and IB_Anulado=0 and Cd_GR = @Cd_GR and @pendiente != 0
					order by  year(co.FecEmi) desc, month(co.FecEmi) desc, day(co.FecEmi) desc					
				end
				Set @Cont = @Cont + 1
			end				
		end
		else
		begin 
			Set @Cant =(select count(*) from GuiaRemision where RucE = @RucE and IC_ES = @IC_ES and IB_Anulado=0)
			while( @cont <= @Cant)
			begin
				Set @Cd_GR = (SELECT top 1 Cd_GR FROM 
				(SELECT TOP (@cont) Cd_GR FROM GuiaRemision WHERE RucE = @RucE and IC_ES = @IC_ES and IB_Anulado=0
			    ORDER BY Cd_GR) as a order by Cd_GR desc 
				)
				begin try
				Set @pendiente = [dbo].[CalcularPendienteGRxINV](@RucE,@Cd_GR)
				--print 'pendiente GR =' + @pendiente
				end try
				begin catch
				Set @pendiente = 0
				end catch
				
				if(@pendiente > 0)
				begin
					insert into @table (FecMov,Cd_TD,NroSre,NroDoc,CodMov,FecED,Saldos)
					select  convert(Nvarchar,  co.FecEmi,103) as FecMov, co.Cd_TD,co.NroSre,co.nroGR as NroDoc,
					co.Cd_GR as CodMov,
					convert(Nvarchar,co.FecEmi,103) as FecED , @pendiente as Saldos from GuiaRemision co
					where co.RucE = @RucE and IC_ES = @IC_ES and IB_Anulado=0 and Cd_GR = @Cd_GR and @pendiente != 0
					order by  year(co.FecEmi) desc, month(co.FecEmi) desc, day(co.FecEmi) desc
				end
				Set @Cont = @Cont + 1
			end
		end
	end

select convert(Nvarchar,  a.FecMov,103) as FecMov, a.Cd_TD,a.NroSre,a.NroDoc,a.CodMov,  
convert(Nvarchar,a.FecED,103) as FecED ,a.Saldos from  @table a order by 
a.FecMov desc
print @msj		

-- Leyenda --
-- CAM : 02/12/2010 : <Creacion del procedimiento almacenado>
--Pruebas:
-- exec Inv_GuiaRemision_ConsXClt '11111111111',null,'S',''
-- exec user321.Inv_GuiaRemision_ConsXClt2 '20102028687',CLT0000013,'S',0,''
-- select * from GuiaRemision where RucE = '11111111111' and IC_ES = 'S'
GO
