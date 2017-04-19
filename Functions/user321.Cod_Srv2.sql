SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [user321].[Cod_Srv2](@RucE nvarchar(11))
returns nvarchar(7) AS
begin 
    declare @c nvarchar(7), @n int
    select @c = count(Cd_Srv) from Servicio2 where RucE=@RucE and IC_TipServ = 'V'
    if @c=0
		set @c='SRV0001'
    else
	begin
		select @c=max(Cd_Srv) from Servicio2 where RucE=@RucE and (IC_TipServ = 'V' or IC_TipServ is null) and Cd_Srv like 'SRV%'
		and Cd_Srv like 'SRV%'
		
		if(isnull(@c,'') != '')
		begin
			set @c= right(@c,4)  --> solo es necesario si lleva una letra adelante
			set @n =convert(int, @c)+1
			set @c = 'SRV'+right('0000'+ltrim(str(@n)), 4)
		end
		else
		begin
			set @c='SRV0001'
		end
	end
    return @c
end
/*
print User321.Cod_Srv2('20492317251')
select * from Servicio2 where RucE = '20492317251'

declare @c nvarchar(7), @n int
select @c=max(Cd_Srv) from Servicio2 
where RucE='20492317251' and (IC_TipServ = 'V' or IC_TipServ is null) and Cd_Srv like 'SRV%'
print @c


--MP : 24/08/2011 : Se modifico para que siempre lea los codigos que empiezan con SRV

select * from Empresa where Ruc in 
(
	select distinct RucE from Servicio2 where LEFT(Cd_Srv,3) NOT in ('SRV','SRC')
)
*/
GO
