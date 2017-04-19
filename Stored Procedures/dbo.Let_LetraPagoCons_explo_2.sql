SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE proc [dbo].[Let_LetraPagoCons_explo_2]
@RucE nvarchar(11),
@Cd_Cnj int,
@msj varchar(100) output
as
select 	lc.Cd_Cnj, lc.Cd_Ltr,lc.NroRenv,lc.NroLtr,lc.RefGdor,lc.LugGdor, lc.FecGiro,
		lc.FecVenc,lc.Plazo,lc.Imp,lc.Dsct,lc.Total,lc.FecReg,lc.FecMdf,lc.CA01,lc.CA02,
		lc.CA03,lc.CA04,lc.CA05,lc.CA06,lc.CA07,lc.CA08,lc.CA09,lc.CA10
from 	Letra_Pago lc
 inner join CanjePago can on  lc.RucE=can.RucE and can.Cd_Cnj = lc.Cd_Cnj 
 
where lc.RucE=@RucE and lc.Cd_Cnj=@Cd_Cnj
	print @msj
GO
