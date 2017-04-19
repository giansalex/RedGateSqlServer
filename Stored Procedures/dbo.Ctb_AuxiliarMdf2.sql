SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Ctb_AuxiliarMdf2]
@RucE nvarchar(11),
@Cd_Aux nvarchar(7),
@Cd_TDI nvarchar(2),
@NDoc nvarchar(15),
@RSocial varchar(150),
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
@CtaCli nvarchar(12),
@CtaPro nvarchar(12),
@Estado bit,

--Valores agregados
--******************
--@Cd_MR nvarchar(2),
@Cd_TA nvarchar(2),
@Usu nvarchar(10),

@msj varchar(100) output
as
if not exists (select * from Auxiliar where RucE=@RucE and Cd_Aux=@Cd_Aux)
	set @msj = 'Auxiliar no existe'
else
begin
begin transaction
	update Auxiliar set Cd_TDI=@Cd_TDI, NDoc=@NDoc, RSocial=@RSocial, ApPat=@ApPat, ApMat=@ApMat,
			   Nom=@Nom, Cd_Pais=@Cd_Pais, CodPost=@CodPost, Ubigeo=@Ubigeo, Direc=@Direc,
			   Telf1=@Telf1, Telf2=@Telf2, Fax=@Fax, Correo=@Correo, PWeb=@PWeb,
			   Obs=@Obs, Cd_TA=@Cd_TA, Estado=@Estado
	where RucE=@RucE and Cd_Aux=@Cd_Aux
	if @@rowcount <= 0
	begin	   set @msj = 'Auxiliar no pudo ser modificado'
	   rollback transaction
	   return
	end

	--VERIFICANDO INFORMACION DE ACUERDO AL TIPO DE AUXILIAR
	-----------------------------------------------------------------------------------
	if(@Cd_TA='01')
	begin
		if exists (select * from Proveedor where RucE=@RucE and Cd_Aux=@Cd_Aux)
			delete from Proveedor where RucE=@RucE and Cd_Aux=@Cd_Aux
		if exists (select * from Cliente where RucE=@RucE and Cd_Aux=@Cd_Aux)
			update Cliente set Cta=@CtaCli, Estado=@Estado where RucE=@RucE and Cd_Aux=@Cd_Aux
		else	insert into Cliente(RucE,Cd_Aux,Cta,Estado) Values(@RucE,@Cd_Aux,@CtaCli,@Estado)
	end
	if(@Cd_TA='02')
	begin
		if exists (select * from Cliente where RucE=@RucE and Cd_Aux=@Cd_Aux)
			delete from Cliente where RucE=@RucE and Cd_Aux=@Cd_Aux
		if exists (select * from Proveedor where RucE=@RucE and Cd_Aux=@Cd_Aux)
			update Proveedor set Cta=@CtaPro, Estado=@Estado where RucE=@RucE and Cd_Aux=@Cd_Aux
		else	insert into Proveedor(RucE,Cd_Aux,Cta,Estado) Values(@RucE,@Cd_Aux,@CtaPro,@Estado)
	end
	if(@Cd_TA='98')
	begin
		if exists (select * from Cliente where RucE=@RucE and Cd_Aux=@Cd_Aux)
			update Cliente set Cta=@CtaCli, Estado=@Estado where RucE=@RucE and Cd_Aux=@Cd_Aux
		else	insert into Cliente(RucE,Cd_Aux,Cta,Estado) Values(@RucE,@Cd_Aux,@CtaCli,@Estado)
		if exists (select * from Proveedor where RucE=@RucE and Cd_Aux=@Cd_Aux)
			update Proveedor set Cta=@CtaPro, Estado=@Estado where RucE=@RucE and Cd_Aux=@Cd_Aux
		else	insert into Proveedor(RucE,Cd_Aux,Cta,Estado) Values(@RucE,@Cd_Aux,@CtaPro,@Estado)
	end

	--INSERTANDO MOVIMIENTO DE REGISTRO
	-----------------------------------------------------------------------------------
	declare @NroReg int
	set @NroReg = (select isnull(max(NroReg),0)+1 from AuxiliarRM where RucE=@RucE)
	insert into AuxiliarRM(RucE,NroReg,Cd_Aux,Cd_TDI,NroDoc,Cd_TA,Cd_MR,Usu,FecMov,Cd_Est)
	        values(@RucE,@NroReg,@Cd_Aux,@Cd_TDI,@NDoc,@Cd_TA,'03',@Usu,getdate(),'02')
	-----------------------------------------------------------------------------------

commit transaction
end
print @msj
-- DI 23/01/2009
-- DI 05/03/2009 MOTIDICACIONES: Realizar los cambios (Cliente y Proveedor) de acuerdo al tipo auxiliar
-- J  05/03/2009 MODIFICACION ->SE CAMBIO LA CUENTA @CTACLI X @CTAPRO EN LAS CONSULTAS DE PROVEEDORES 

GO
