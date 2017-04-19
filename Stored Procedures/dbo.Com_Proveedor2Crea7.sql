SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE procedure [dbo].[Com_Proveedor2Crea7]
@RucE nvarchar(11),
@Cd_Prv char(7) output,
@Cd_TDI nvarchar(2),
@NDoc nvarchar(15),
@RSocial varchar(50),
@ApPat varchar(20),
@ApMat varchar(20),
@Nom varchar(20),
@Cd_Pais nvarchar(4),
@CodPost varchar(10),
@Ubigeo nvarchar(6),
@Direc varchar(100),
@Telf1 nvarchar(15),
@Telf2 nvarchar(15),
@Fax nvarchar(15),
@Correo varchar(50),
@PWeb varchar(100),
@Obs varchar(200),
@CtaCtb nvarchar(10),
@Estado bit,
@CA01 varchar(100),
@CA02 varchar(100),
@CA03 varchar(100),
@CA04 varchar(100),
@CA05 varchar(100),
@CA06 varchar(100),
@CA07 varchar(100),
@CA08 varchar(100),
@CA09 varchar(300),
@CA10 varchar(300),
@IB_SjDet bit,
@Cd_TPrv char(3),
--Keyner
--@FecReg DateTime,
@UsuCrea nvarchar(10),
--
@Grupo nvarchar(100),
@DiasCobro nvarchar(100),
@LimiteCredito nvarchar(100),
@PerCobro nvarchar(100),
@CtasCrtes nvarchar(100),

@msj varchar(100) output

as
-----agregado
if (@NDoc LIKE '%[^0-9A-Za-z]%')
	set @msj = 'Proveedor no pudo ser registrado porque numero de documento esta mal registrado.'
-----	
else if exists (select * from Proveedor2 where RucE=@RucE and NDoc=@NDoc)
	begin
	update Proveedor2 set RSocial=@RSocial, ApPat=@ApPat, ApMat=@ApMat, Nom=@Nom, Cd_Pais=@Cd_Pais, 
	CodPost=@CodPost, Ubigeo=@Ubigeo, Direc=@Direc, Telf1=@Telf1, Telf2=@Telf2, Fax=@Fax, Correo=@Correo, PWeb=@PWeb,
	Obs=@Obs, CtaCtb=@CtaCtb, Estado=@Estado, CA01=@CA01,CA02=@CA02,CA03=@CA03,CA04=@CA04,CA05=@CA05,CA06=@CA06,
	CA07=@CA07, CA08=@CA08, CA09=@CA09, CA10=@CA10, IB_SjDet=@IB_SjDet, Cd_TPrv=@Cd_TPrv, FecReg=GETDATE(), UsuCrea=@UsuCrea, Grupo=@Grupo,
	DiasCobro=@DiasCobro, LimiteCredito=@LimiteCredito, PerCobro=@PerCobro, CtasCrtes=@CtasCrtes where RucE=@RucE and Cd_TDI=@Cd_TDI and NDoc=@NDoc
	--set @msj = 'Ya existe Proveedor con el mismo numero de documento.'
	end
else
	begin
		set @Cd_Prv = dbo.Cod_Prv2(@RucE)
		insert into Proveedor2(RucE,Cd_Prv,Cd_TDI,NDoc,RSocial,ApPat,ApMat,Nom,Cd_Pais,CodPost,Ubigeo,Direc,Telf1,Telf2,Fax,Correo,PWeb,Obs,CtaCtb,Estado,CA01,CA02,CA03,CA04,CA05,CA06,CA07,CA08,CA09,CA10,IB_SjDet,Cd_TPrv,FecReg,UsuCrea,Grupo,DiasCobro,LimiteCredito,PerCobro,CtasCrtes)
		       values(@RucE, @Cd_Prv,@Cd_TDI,@NDoc,@RSocial,@ApPat,@ApMat,@Nom,@Cd_Pais,@CodPost,@Ubigeo,@Direc,@Telf1,@Telf2,@Fax,@Correo,@PWeb,@Obs,@CtaCtb,@Estado,@CA01,@CA02,@CA03,@CA04,@CA05,@CA06,@CA07,@CA08,@CA09,@CA10,@IB_SjDet,@Cd_TPrv,GETDATE(),@UsuCrea,@Grupo,@DiasCobro,@LimiteCredito,@PerCobro,@CtasCrtes)
		if @@rowcount <= 0		   set @msj = 'Proveedor no pudo ser registrado.'
	end

print @msj

-- LEYENDA
-- KJ: creacion de nueva version. Se agrego usuario creador y mdf
--cam agregue informacion comercial 08/12/2011
--MP : <09/07/2012> : <Se modifico la validacion regex para aceptar letras>
GO
