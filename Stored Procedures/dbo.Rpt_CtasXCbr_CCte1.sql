SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Rpt_CtasXCbr_CCte1]
@RucE nvarchar(11),
@Ejer nvarchar(4),
@Cd_Aux nvarchar(7),
@FechaAl datetime,
@msj varchar(100) output

as
select 	v.RucE, v.NroCta, v.Cd_Aux, v.Cd_TD, v.NroSre, v.NroDoc, convert(varchar,v.FecMov,103) as FecMov, v.FecVD, datediff(day,v.FecMov,@FechaAl) as Saldo_Dias, sum(v.MtoD) Debe_MN, sum(v.MtoH) Haber_MN,
	(sum(v.MtoD)-sum(v.MtoH)) as saldo, v.Cd_MdRg
	--sum(MtoD_ME) Debe_ME, sum(MtoH_ME) Haber_ME
	from voucher as v
	left join Auxiliar as a on a.RucE=v.RucE and a.Cd_Aux=v.Cd_Aux
	inner join TipDoc d on d.Cd_TD=v.Cd_TD
	where v.RucE=@RucE and v.Ejer=@Ejer and a.cd_aux=@Cd_Aux and left(v.NroCta,2)=12 
	group by v.RucE, v.NroCta, v.Cd_Aux, v.Cd_TD, v.NroSre, v.NroDoc, convert(varchar,v.FecMov,103), v.FecVD, datediff(day,v.FecMov,@FechaAl), v.Cd_MdRg 
--> debe tener la misma fecha de emi
print @msj

-- Leyenda
--CAM 17/09/2010 NO SE MODIFICO. SE VA A COMPROBAR SI SE USA.
/*
exec sp_help Rpt_CtasXCbr_CCte1
select * from CLiente2
exec Rpt_CtasXCbr_CCte1 '11111111111','2010','CLI0019','17/09/2010',''
select * from Auxiliar where RucE = '11111111111'
*/

GO
