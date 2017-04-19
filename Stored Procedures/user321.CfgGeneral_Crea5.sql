SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [user321].[CfgGeneral_Crea5]
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
@IB_AlertCD bit,

@Cd_TDIClt char(2),
@Cd_TDIPrv char(2),
@Cd_TDIVdr char(2),
@Cd_TDITra char(2),

@msj varchar(100) output 
as
if exists (select top 1 *from CfgGeneral where RucE=@RucE)
	set @msj='Configuracion ya existe'
else 
begin
	insert into CfgGeneral(RucE, IB_MovVtaCtbLin,IB_MovComCtbLin,IB_MovInvCtbLin,
				IB_ElmCtbVtaLin,IB_ElmCtbComLin,IB_ElmCtbInvLin,NomC,NomSC,NomSSC,IB_AgRet,MtoRet,NivCC,IB_MdfVou,IB_EjerAnt,IB_AlertCD,Cd_TDIClt,Cd_TDIPrv,Cd_TDIVdr,Cd_TDITra) values
			      (@RucE,@IB_MovVtaCtbLin,@IB_MovComCtbLin,@IB_MovInvCtbLin,
				@IB_ElmCtbVtaLin,@IB_ElmCtbComLin,@IB_ElmCtbInvLin,@NomC,@NomSC,@NomSSC,@IB_AgRet,@MtoRet,@NivCC,@IB_MdfVou,@IB_EjerAnt,@IB_AlertCD,@Cd_TDIClt,@Cd_TDIPrv,@Cd_TDIVdr,@Cd_TDITra)
end

GO
