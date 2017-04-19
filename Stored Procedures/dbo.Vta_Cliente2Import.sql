SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE procedure [dbo].[Vta_Cliente2Import]
@RucE	nvarchar(11),
@Ejer varchar(4),
@Cd_Clt	char(10) output,
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
@CtaCtb	nvarchar(15),
@DiasCbr varchar(30),
@PerCbr	varchar(30),
@CtaCte	varchar(20),
@Cd_CGC	char(3),
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
@Usu nvarchar(10),
@Cd_MR nvarchar(2),
@Cd_TClt char(3),
@UsuCrea nvarchar(10),
@msj varchar(100) output
as


if(@RucE = '20520727192')
	set @Estado = 1


/******* start Validacion ****************/

if not exists (select * from TipDocIdn where  Cd_TDI=@Cd_TDI) and (ISNULL(@Cd_TDI,'')<>'')
begin
	set @msj = ' No existe Tipo Documento de Identidad : '+@Cd_TDI
	return
end

if not exists (select * from TipClt where RucE=@RucE and Cd_TClt=@Cd_TClt) and (ISNULL(@Cd_TClt,'')<>'')
begin
	set @msj = ' No existe código Tipo Cliente : '+@Cd_TClt
	return
end


if not exists (select * from PlanCtas where RucE=@RucE  and Ejer=@Ejer and NroCta=@CtaCtb) and (ISNULL(@CtaCtb,'')<>'') 
begin
	set @msj = ' No existe Cuenta Contable: '+isnull(@CtaCtb,'Vacio') 
	return
end

if not exists (select * from UDist where Cd_UDt=@Ubigeo) and (ISNULL(@Ubigeo,'')<>'') 
begin
	set @msj = ' No existe Ubigeo: '+isnull(@Ubigeo,'Vacio') 
	return
end


if not  exists (select * from Pais where Cd_Pais=@Cd_Pais)  and  (ISNULL(@Cd_Pais,'')<>'') 
begin
	set @msj = ' No existe Codigo Pais'+isnull(@Cd_Pais,'Vacio') 
	return
end

if not exists (select * from ComisionGrupCte where  RucE=@RucE and Cd_CGC=@Cd_CGC) and (ISNULL(@Cd_CGC,'')<>'')
begin
	set @msj = ' No existe código Comisión Grupo Cuenta : '+@Cd_CGC
	return
end



/**********end Validacion ******************/

	
if exists (select * from Cliente2 where RucE=@RucE and Cd_TDI=@Cd_TDI and NDoc=@NDoc)
begin
	--set @msj = 'Ya existe Cliente con el mismo numero de documento'
	Update Cliente2 set
				RSocial=@RSocial,ApPat=@ApPat,ApMat=@ApMat,Nom=@Nom,Cd_Pais=@Cd_Pais,CodPost=@CodPost,Ubigeo=@Ubigeo,
				Direc=@Direc,Telf1=@Telf1,Telf2=@Telf2,Fax=@Fax,Correo=@Correo,PWeb=@PWeb,Obs=@Obs,CtaCtb=@CtaCtb,
				DiasCbr=@DiasCbr,PerCbr=@PerCbr,CtaCte=@CtaCte,Cd_CGC=@Cd_CGC,Estado=@Estado,CA01=@CA01,CA02=@CA02,
				CA03=@CA03,CA04=@CA04,CA05=@CA05,CA06=@CA06,CA07=@CA07,CA08=@CA08,CA09=@CA09,CA10=@CA10,Cd_TClt=@Cd_TClt,
				FecMdf=getdate(),UsuMdf=@UsuCrea
	Where RucE=@RucE and Cd_TDI=@Cd_TDI and NDoc=@NDoc
	set @Cd_Clt=''
end
else
begin
begin transaction
--declare @Cd_Clt char (10)
	set @Cd_Clt = (select dbo.Cod_Clt2(@RucE))

	insert into Cliente2(RucE,Cd_Clt,Cd_TDI,NDoc,RSocial,ApPat,ApMat,Nom,Cd_Pais,CodPost,Ubigeo,Direc,Telf1,Telf2,Fax,Correo,PWeb,
			     Obs,CtaCtb,DiasCbr,PerCbr,CtaCte,Cd_CGC,Estado,CA01,CA02,CA03,CA04,CA05,CA06,CA07,CA08,CA09,CA10,Cd_TClt,FecReg,UsuCrea)

		     values(@RucE,@Cd_Clt,@Cd_TDI,@NDoc,@RSocial,@ApPat,@ApMat,@Nom,@Cd_Pais,@CodPost,@Ubigeo,@Direc,@Telf1,@Telf2,@Fax,@Correo,@PWeb,
			    @Obs,@CtaCtb,@DiasCbr,@PerCbr,@CtaCte,@Cd_CGC,@Estado,@CA01,@CA02,@CA03,@CA04,@CA05,@CA06,@CA07,@CA08,@CA09,@CA10,@Cd_TClt,getdate(),@UsuCrea)
	if @@rowcount <= 0
	begin	   set @msj = 'Cliente no pudo ser registrado'
    	   rollback transaction
	   return
	end

	--INSERTANDO MOVIMIENTO DE REGISTRO
	-----------------------------------------------------------------------------------
	declare @NroReg int
	set @NroReg = (select isnull(max(NroReg),0)+1 from AuxiliarRM where RucE=@RucE)
	--Cd_MR : Codigo de Area
	--Cd_Estado : Tipo de Movimiento(Insertar = 01)
	--Cd_TA : Codigo de Tipo de Auxiliat (Cliente = 01)
	insert into AuxiliarRM(RucE,NroReg,Cd_Aux,Cd_TDI,NroDoc,Cd_TA,Cd_MR,Usu,FecMov,Cd_Est)
	        values(@RucE,@NroReg,@Cd_Clt,@Cd_TDI,@NDoc,'01',@Cd_MR,@Usu,getdate(),'01')
	-----------------------------------------------------------------------------------
commit transaction
end
print @msj

-- LEYENDA:
-- 04/02/2013 : Se amplio @Direc a varchar(200)
-- 05/12/2016 : Se agrego validacion para el reporte de error en blog de nota que se exportara autor : GG
GO
