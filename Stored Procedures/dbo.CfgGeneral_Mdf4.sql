SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create procedure [dbo].[CfgGeneral_Mdf4]
@RucE nvarchar(11),
@IB_MovVtaCtbLin bit,
@IB_MovComCtbLin bit,
@IB_MovInvCtbLin bit,
@IB_ElmCtbVtaLin bit,
@IB_ElmCtbComLin bit,
@IB_ElmCtbInvLin bit,
@NomC nvarchar(50),
@NomSC nvarchar(50),
@NomSSC nvarchar(50),
@IB_AgRet bit,
@MtoRet numeric(13,2),
@NivCC int,

@IB_MdfVou bit,
@IB_EjerAnt bit,
@msj varchar(100) output
as

if not exists (select top 1 *from CfgGeneral where RucE=@RucE)
	set @msj='Configuracion no existe'
else 
begin
	update CfgGeneral set IB_MovVtaCtbLin=@IB_MovVtaCtbLin, IB_MovComCtbLin=@IB_MovComCtbLin,
			      IB_MovInvCtbLin=@IB_MovInvCtbLin, IB_ElmCtbVtaLin=@IB_ElmCtbVtaLin,
			      IB_ElmCtbComLin=@IB_ElmCtbComLin, IB_ElmCtbInvLin=@IB_ElmCtbInvLin,NomC=@NomC,NomSC=@NomSC,NomSSC=@NomSSC,
			      IB_AgRet=@IB_AgRet, MtoRet=@MtoRet, NivCC=@NivCC,IB_MdfVou=@IB_MdfVou, IB_EjerAnt=@IB_EjerAnt
			  where RucE=@RucE
end
GO
