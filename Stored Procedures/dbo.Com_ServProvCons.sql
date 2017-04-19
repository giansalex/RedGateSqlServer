SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
--select * from Servicio2
CREATE procedure [dbo].[Com_ServProvCons]
@RucE nvarchar(11),
@Cd_Prv nvarchar(10),
@msj varchar(100) output
as
declare @check bit
set @check = 0

declare @tip char(1)

if(LEFT(@Cd_Prv,3) = 'PRV')
	set @tip = 'C'
else
	set @tip = 'V'
	
if(LEN(@Cd_Prv)>0)
	begin
		if(@tip = 'C')
		begin
			select @check as sel ,sp.Cd_Srv,se.CodCo CodigoAlt, se.Nombre,se.Descrip ,sp.DescripAlt from ServProv sp
			inner join Servicio2 se on sp.RucE = se.RucE and sp.Cd_Srv = se.Cd_Srv 
			where sp.RucE=@RucE and sp.Cd_Prv=@Cd_Prv and IC_TipServ=@tip and Estado = 1
		end
		else
		begin
			select @check as sel ,sp.Cd_Srv,sp.CodCo CodigoAlt, sp.Nombre,sp.Descrip ,'' DescripAlt from Servicio2 sp
			where sp.RucE=@RucE and IC_TipServ=@tip and Estado = 1
		end
	end
else 
	begin		
		select distinct @check as sel ,se.Cd_Srv,se.CodCo CodigoAlt, se.Nombre,se.Descrip,sp.DescripAlt
		from Servicio2 se
		left join ServProv sp on sp.RucE = se.RucE-- and sp.Cd_Srv = se.Cd_Srv 
		where se.RucE=@RucE and IC_TipServ='C' and Estado = 1 -- and sp.Cd_Prv=@Cd_Prv 
		order by se.Cd_Srv asc
	end

print @msj


select @check as sel ,sp.Cd_Srv,se.CodCo CodigoAlt, se.Nombre,se.Descrip ,sp.DescripAlt from ServProv sp
		inner join Servicio2 se on sp.RucE = se.RucE and sp.Cd_Srv = se.Cd_Srv 
		where sp.RucE='' and sp.Cd_Prv=@Cd_Prv and IC_TipServ=@tip and Estado = 1
GO
