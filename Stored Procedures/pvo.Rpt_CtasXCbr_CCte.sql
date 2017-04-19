SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [pvo].[Rpt_CtasXCbr_CCte]
@RucE nvarchar(11),
@Ejer nvarchar(4),
@Cd_Aux nvarchar(7),

@msj varchar(100) output
as
select NroCta, Cd_Aux, Cd_TD, NroSre, NroDoc, FecMov, FecCbr, sum(MtoD) Debe_MN, sum(MtoH) Haber_MN 
	from voucher where RucE=@RucE and Ejer=@Ejer and Cd_Aux=@Cd_Aux and left(NroCta,2)=12 
	group by NroCta, Cd_Aux, Cd_TD, NroSre, NroDoc, FecMov, FecCbr  
--> debe tener la misma fecha de emi


print @msj
GO
