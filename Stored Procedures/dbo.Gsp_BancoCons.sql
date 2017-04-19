SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Gsp_BancoCons]
@RucE nvarchar(11),
@Ejer varchar(4),
@TipCons int,
@msj varchar(100) output
as
/*if not exists (select top 1 * from Banco where RucE=@RucE)
	set @msj = 'No se encontro Banco' 
else */	
begin
	if(@TipCons = 0) /* CONSULTA GENERAL */
	begin
		select a.Itm_BC, a.RucE, a.NroCta, a.NCtaB, a.NCorto, b.Nombre as 'Moneda', a.Estado 
		from Banco a, Moneda b 
		where RucE=@RucE and a.Ejer=@Ejer and a.Cd_Mda=b.Cd_Mda
	end
	else if(@TipCons = 1) /* CONSULTA COMOBOX */
	begin
		select
			'-1' as Itm_BC,
			'00.0.0.00  |  --------------- SELECCIONAR BANCO ---------------' as CodNom,
			'' as NCtaB
		UNION ALL
		select
			b.Itm_BC,
			b.NroCta + '  |  ' + c.NomCta as CodNom,
			b.NCtaB
		from	Banco b, PlanCtas c
		where	b.RucE=@RucE and b.Ejer=@Ejer and b.RucE=c.RucE and b.Ejer=c.Ejer and b.NroCta=c.NroCta and b.Estado='1'
	end
	else if(@TipCons = 2) /* CONSULTA GENERAL ESTADO*/
	begin
		select a.Itm_BC, a.RucE, a.NroCta, a.NCtaB, a.NCorto, b.Nombre as 'Moneda', a.Estado 
		from Banco a, Moneda b 
		where RucE=@RucE and a.Ejer=@Ejer and a.Cd_Mda=b.Cd_Mda and a.Estado = '1'		
	end
	else if(@TipCons = 3) /* CONSULTA AYUDA*/
	begin
		select
			b.Itm_BC,
			b.NroCta,c.NomCta
		from	Banco b, PlanCtas c
		where	b.RucE=@RucE and b.Ejer=@Ejer and b.RucE=c.RucE and b.Ejer=c.Ejer and b.NroCta=c.NroCta and b.Estado='1'		
	end
end
print @msj
GO
