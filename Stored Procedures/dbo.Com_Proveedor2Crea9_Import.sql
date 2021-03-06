SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO






CREATE procedure [dbo].[Com_Proveedor2Crea9_Import]

@RucE nvarchar(11),
@Ejer varchar(4),
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
@NComercial varchar(150),
@IB_AgRet bit,
@IB_AgPercep bit = null,
@IB_BuenContrib bit = null,
@msj varchar(100) output
as



/******* Validacion ****************/



if not exists (select * from TipDocIdn where  Cd_TDI=@Cd_TDI) and (Isnull(@Cd_TDI,'')<>'')
begin
	set @msj = 'No existe Tipo Documento de Identidad : '+@Cd_TDI
	return
end

--if(isnull(@CtaCtb,' ')<> ' ')  
if not exists (select * from PlanCtas where RucE=@RucE  and Ejer=@Ejer and NroCta=@CtaCtb) and (Isnull(@Ejer,'')<>'') and (Isnull(@CtaCtb,'')<>'') --Se valida que el @@CtaCtb es un campo obligatorio
begin
	set @msj = 'No existe Cuenta Contable : ' +@CtaCtb
	return
end



if  not exists (select * from UDist where Cd_UDt=@Ubigeo) and (Isnull(@Ubigeo,'')<>'') --Se valida que el @ubigeo no sea null xq es un campo no obligatorio
begin
	set @msj = 'No existe Ubigeo : '+isnull(@Ubigeo,'Vacio')  --Se coloca asi xq el SQL no concatena nulos
	return
end


if not exists (select * from Pais where Cd_Pais=@Cd_Pais) and (Isnull(@Cd_Pais,'')<>'')  --Se valida que el @ubigeo no sea null xq es un campo no obligatorio
begin
	set @msj = 'No existe Codigo Pais : ' + isnull(@Cd_Pais,'Vacio') --Se coloca asi xq el SQL no concatena nulos
	return
end

if not exists (select * from TipProv where Cd_TPrv=@Cd_TPrv) and (Isnull(@Cd_TPrv,'')<>'') --Se valida que el @ubigeo no sea null xq es un campo no obligatorio
begin
	set @msj = 'No existe Codigo Tipo Proveedor : ' + isnull(@Cd_TPrv,'Vacio') --Se coloca asi xq el SQL no concatena nulos
	return
end

/**********end Validacion ******************/



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
	DiasCobro=@DiasCobro, LimiteCredito=@LimiteCredito, PerCobro=@PerCobro, CtasCrtes=@CtasCrtes, NComercial=@NComercial,IB_AgRet=@IB_AgRet
	 where RucE=@RucE and Cd_TDI=@Cd_TDI and NDoc=@NDoc
	
	--set @msj = 'Ya existe Proveedor con el mismo numero de documento.'
	end
else
	begin
		set @Cd_Prv = dbo.Cod_Prv2(@RucE)
		insert into Proveedor2(RucE,Cd_Prv,Cd_TDI,NDoc,RSocial,ApPat,ApMat,Nom,Cd_Pais,CodPost,Ubigeo,Direc,Telf1,Telf2,Fax,Correo,PWeb,Obs,CtaCtb,Estado,CA01,CA02,CA03,CA04,CA05,CA06,CA07,CA08,CA09,CA10,IB_SjDet,Cd_TPrv,FecReg,UsuCrea,Grupo,DiasCobro,LimiteCredito,PerCobro,CtasCrtes,NComercial,IB_AgRet,IB_AgPercep,IB_BuenContrib)
		       values(@RucE, @Cd_Prv,@Cd_TDI,@NDoc,@RSocial,@ApPat,@ApMat,@Nom,@Cd_Pais,@CodPost,@Ubigeo,@Direc,@Telf1,@Telf2,@Fax,@Correo,@PWeb,@Obs,@CtaCtb,@Estado,@CA01,@CA02,@CA03,@CA04,@CA05,@CA06,@CA07,@CA08,@CA09,@CA10,@IB_SjDet,@Cd_TPrv,GETDATE(),@UsuCrea,@Grupo,@DiasCobro,@LimiteCredito,@PerCobro,@CtasCrtes,@NComercial,@IB_AgRet,@IB_AgPercep,@IB_BuenContrib)
		if @@rowcount <= 0
		   set @msj = 'Proveedor no pudo ser registrado.'
	end

print @msj

-- LEYENDA
-- KJ: creacion de nueva version. Se agrego usuario creador y mdf
--cam agregue informacion comercial 08/12/2011
--MP : <09/07/2012> : <Se modifico la validacion regex para aceptar letras>
--JV : <20/03/2012> : <Se agregan parametros de Agente Percepcion y Buen contribuyente>
--GG : <05/12/2016> : Se agrego validaciones .
GO
