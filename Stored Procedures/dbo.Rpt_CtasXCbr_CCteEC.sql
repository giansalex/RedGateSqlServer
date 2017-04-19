SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Rpt_CtasXCbr_CCteEC]
@RucE nvarchar(11),
@Ejer nvarchar(4),
@Cd_Aux nvarchar(7),
--@FechaAl datetime,

@msj varchar(100) output
as
select  RucE, NroCta, Cd_Aux, Cd_TD, NroSre, NroDoc, convert(varchar,FecMov,103) as FecMov, FecVD, MtoD as Debe, MtoH as Haber,
	Cd_MdRg
--	sum(MtoD_ME) Debe_ME, sum(MtoH_ME) Haber_ME
	from voucher 
	where RucE=@RucE and Ejer=@Ejer and cd_aux=@Cd_Aux and left(NroCta,2)=12 
--> debe tener la misma fecha de emi

print @msj
GO
