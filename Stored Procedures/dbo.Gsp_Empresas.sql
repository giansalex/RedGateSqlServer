SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Gsp_Empresas]
@TipCons int,
@msj varchar(100) output
as
/*if not exists (select top 1 * from Banco where RucE=@RucE)
	set @msj = 'No se encontro Banco'
else */	
begin
	if(@TipCons = 0) /* CONSULTA GENERAL */
	begin
		select * from Empresa
	end
	else if(@TipCons = 3) /* CONSULTA AYUDA*/
	begin
		select
			
			e.Ruc,e.Ruc,e.RSocial
		from	Empresa	e
	end
	Else if (@TipCons = 4)--Edificios Inrepco
	begin
		select Ruc,Ruc,RSocial from Empresa e
		inner join AccesoE a on e.Ruc = a.RucE and a.Cd_Prf = '119'
	end
end
print @msj
GO
