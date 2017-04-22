SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Vta_Cliente2Mdf8]
@RucE	nvarchar(11),
@Cd_Clt	char(10),
@Cd_TDI	nvarchar(2),
@NDoc	varchar(15),
@RSocial varchar(150),
@ApPat	varchar(20),
@ApMat	varchar(20),
@Nom	varchar(20),
@Cd_Pais nvarchar(4),
@CodPost varchar(10),
@Ubigeo	nvarchar(6),
@Direc	varchar(200),
@Telf1	varchar(20),
@Telf2	varchar(20),
@Fax	varchar(20),
@Correo	varchar(50),
@PWeb	varchar(100),
@Obs	varchar(200),
@CtaCtb	nvarchar(10),
@DiasCbr varchar(30),
@PerCbr	varchar(30),
@CtaCte	varchar(20),
@Estado bit,
@CA01	varchar(100),
@CA02	varchar(100),
@CA03	varchar(100),
@CA04	varchar(100),
@CA05	varchar(100),
@CA06	varchar(100),
@CA07	varchar(100),
@CA08	varchar(100),
@CA09	varchar(300),
@CA10	varchar(300),
@Cd_CGC char(3),

--Valores agregados
--******************
@Usu nvarchar(10),
@Cd_MR nvarchar(2),
@Cd_TClt char(3),
--******************
--Valores agregados 14-11-2011
--******************
--@FecMdf datetime,
@NComercial varchar(150),
@UsuMdf nvarchar(10),
@NDocVdr nvarchar(15),
@Cd_VdrTD varchar(4),
--******************
@IB_AgRet bit,

-- GONZ : CAMPOS AGREGADOS 01/03/2017
@snt_TipCntrb varchar(100),
@snt_FecInscrip smalldatetime,
@snt_FecIniAct smalldatetime,
@snt_FecBaja smalldatetime,
@snt_EstCntrb varchar(50),
@snt_CondCntrb varchar(50),
@snt_SisEmiComp varchar(50),
@snt_SisContab varchar(50),
@snt_LstActsEcono varchar(1000),      
@snt_LstCompsPago varchar(300),
@snt_ActComExt varchar(100),
@snt_LstSisEmiElec varchar(500),
@snt_FecEmiElec smalldatetime,
@snt_LstCompsElec varchar(300),
@snt_FecInsPLE smalldatetime, --deberia ser smalldatetime
@snt_NroTrab int,
@snt_NroPresSrv int,
@snt_LstRprsLegs varchar(2000),
@TelfBusc varchar(2000),
@msj varchar(100) output
as
if not exists (select * from Cliente2 where RucE=@RucE and Cd_Clt=@Cd_Clt)
	set @msj = 'Cliente no existe'
else
begin
begin transaction
	declare @Cd_Vdr char(10)
	
	set @Cd_Vdr = (select top 1 Cd_Vdr from Vendedor2 where RucE = @RucE and Cd_TDI=@Cd_VdrTD and NDoc=@NDocVdr)

	update Cliente2 set Cd_TDI=@Cd_TDI, NDoc=@NDoc, RSocial=@RSocial, ApPat=@ApPat, ApMat=@ApMat,
			   Nom=@Nom, Cd_Pais=@Cd_Pais, CodPost=@CodPost, Ubigeo=@Ubigeo, Direc=@Direc,
			   Telf1=@Telf1, Telf2=@Telf2, Fax=@Fax, Correo=@Correo, PWeb=@PWeb,
			   Obs=@Obs,CtaCtb=@CtaCtb,DiasCbr=@DiasCbr,PerCbr=@PerCbr,CtaCte=@CtaCte,Estado=@Estado,Cd_CGC = @Cd_CGC,
			   CA01=@CA01,CA02=@CA02,CA03=@CA03,CA04=@CA04,CA05=@CA05,CA06=@CA06,CA07=@CA07,CA08=@CA08,CA09=@CA09,CA10=@CA10,Cd_TClt=@Cd_TClt,UsuMdf=@UsuMdf,FecMdf=getdate()
			   , NComercial=@NComercial,IB_AgRet=@IB_AgRet,Cd_Vdr=@Cd_Vdr,			   
				snt_TipCntrb=@snt_TipCntrb,snt_FecInscrip=@snt_FecInscrip,snt_FecIniAct=@snt_FecIniAct,snt_FecBaja=@snt_FecBaja,
				snt_EstCntrb=@snt_EstCntrb,snt_CondCntrb=@snt_CondCntrb,snt_SisEmiComp=@snt_SisEmiComp,snt_SisContab=@snt_SisContab,snt_LstActsEcono=@snt_LstActsEcono,snt_LstCompsPago=@snt_LstCompsPago,
				snt_LstSisEmiElec=@snt_LstSisEmiElec,snt_FecEmiElec=@snt_FecEmiElec,
				snt_LstCompsElec=@snt_LstCompsElec,snt_NroTrab=@snt_NroTrab,snt_LstRprsLegs=@snt_LstRprsLegs,snt_ActComExt=@snt_ActComExt,Snt_FecInsPLE=@Snt_FecInsPLE, Telf_Busc = @TelfBusc, Snt_NroPresSrv = @snt_NroPresSrv
	where RucE=@RucE and Cd_Clt=@Cd_Clt
	if @@rowcount <= 0
	begin	   set @msj = 'Cliente no pudo ser modificado'
	   rollback transaction
	   return
	end


	--INSERTANDO MOVIMIENTO DE REGISTRO
	-----------------------------------------------------------------------------------
	declare @NroReg int
	set @NroReg = (select isnull(max(NroReg),0)+1 from AuxiliarRM where RucE=@RucE)
	--Cd_MR : Codigo de Area
	--Cd_Estado : Tipo de Movimiento(Modificar = 02)
	--Cd_TA : Codigo de Tipo de Auxiliar (Cliente = 01)
	insert into AuxiliarRM(RucE,NroReg,Cd_Aux,Cd_TDI,NroDoc,Cd_TA,Cd_MR,Usu,FecMov,Cd_Est)
	        values(@RucE,@NroReg,@Cd_Clt,@Cd_TDI,@NDoc,'01',@Cd_MR,@Usu,getdate(),'02')
	-----------------------------------------------------------------------------------

commit transaction
end
print @msj
-- FL : 14/07/2011 <creacion del procedimiento almacenado>
-- 04/02/2013 : Se amplio @Direc a varchar(200)
-- GS : 20/04/2017 : Se agrego @TelfBusc
GO
