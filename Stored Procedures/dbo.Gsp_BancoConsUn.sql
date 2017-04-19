SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE procedure [dbo].[Gsp_BancoConsUn]
@Itm_BC nvarchar(10),
@RucE nvarchar(11),
@Ejer varchar(4),
@msj varchar(100) output
as
	if not exists (select * from Banco where Itm_BC=@Itm_BC and RucE=@RucE and Ejer=@Ejer)
		set @msj = 'Banco no existe'
	else
	Begin
		--select b.*,c.NomCta from Banco b, PlanCtas c where b.RucE=@RucE and Itm_BC=@Itm_BC and b.Ejer=@Ejer and b.RucE=c.RucE and b.NroCta=c.NroCta
	select 	b.*,c.NomCta,a.CodSNT_, a.Nombre from Banco b left join PlanCtas c on  b.RucE=c.RucE and b.NroCta=c.NroCta 
		left join EntidadFinanciera a on a.Cd_EF=b.Cd_EF
	where b.RucE=@RucE and Itm_BC=@Itm_BC and b.Ejer=@Ejer
	end
print @msj 



GO
