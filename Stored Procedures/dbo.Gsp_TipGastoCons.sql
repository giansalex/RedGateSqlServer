SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Gsp_TipGastoCons]
@TipCons int,
@msj varchar(100) output
as
/*if not exists (select * from TipGasto )
	set @msj = 'No existe Tipo Gasto'
else*/	
	--select * from TipGasto


	if(@TipCons=0)
		select * from TipGasto
	else select Cd_TG, Cd_TG+ '  |  ' + Nombre as CodNom from TipGasto

print @msj

-- DI 13/02/2009

-- PV 17/02/2009  --> no tenia Tipo Cons
GO
