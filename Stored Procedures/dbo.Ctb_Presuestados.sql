SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE proc [dbo].[Ctb_Presuestados]
@RucE nvarchar(11),
@Ejer nvarchar(4),
@msj varchar(100) output
as

select  1 as nivel,
	p.NroCta,
	--left(ltrim(p.NroCta)+'    ',11)+'  |  '+p.NomCta as NomCta,
	'' as Cd_CC,'' as Cd_SC,'' as Cd_SS
from PlanCtas p
left join Voucher v on p.RucE=v.RucE and p.NroCta=v.NroCta and p.Ejer=v.Ejer
where v.RucE=@RucE and v.Ejer=@Ejer and p.IB_Psp='1' and p.Ejer=@Ejer
Group by p.NroCta,p.NroCta,p.NomCta
Union all
select  2 as nivel,
	p.NroCta,
	--left(ltrim(p.NroCta)+'    ',11)+'  |  '+p.NomCta as NomCta,
	v.Cd_CC,'' as Cd_SC,'' as Cd_SS
from PlanCtas p
left join Voucher v on p.RucE=v.RucE and p.NroCta=v.NroCta and p.Ejer=v.Ejer
where v.RucE=@RucE and v.Ejer=@Ejer and p.IB_Psp='1' and p.Ejer=@Ejer
Group by p.NroCta,p.NroCta,p.NomCta,v.Cd_CC
Union all
select  3 as nivel,
	p.NroCta,
	--left(ltrim(p.NroCta)+'    ',11)+'  |  '+p.NomCta as NomCta,
	v.Cd_CC,v.Cd_SC,'' as Cd_SS
from PlanCtas p
left join Voucher v on p.RucE=v.RucE and p.NroCta=v.NroCta and p.Ejer=v.Ejer
where v.RucE=@RucE and v.Ejer=@Ejer and p.IB_Psp='1' and p.Ejer=@Ejer
Group by p.NroCta,p.NroCta,p.NomCta,v.Cd_CC,v.Cd_SC
Union all
select  4 as nivel,
	p.NroCta,
	--left(ltrim(p.NroCta)+'    ',11)+'  |  '+p.NomCta as NomCta,
	v.Cd_CC,v.Cd_SC,v.Cd_SS
from PlanCtas p
left join Voucher v on p.RucE=v.RucE and p.NroCta=v.NroCta and p.Ejer=v.Ejer
where v.RucE=@RucE and v.Ejer=@Ejer and p.IB_Psp='1' and p.Ejer=@Ejer
Group by p.NroCta,p.NroCta,p.NomCta,v.Cd_CC,v.Cd_SC,v.Cd_SS
Order by 2,3,4,5

----------------------PRUEBA------------------------
--exec Ctb_Presuestados '11111111111','2009',null

------CODIGO DE MODIFICACION--------
--CM=RE01

----------------------LEYENDA----------------------
-- DI 31/12/09 : Creacion del procediminto almacenado
--FL: 17/09/2010 <se agrego ejercicio>
GO
