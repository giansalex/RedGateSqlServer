SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Com_ProveedorCrea]
@RucE nvarchar(11),
--@Cd_Aux nvarchar(7),
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
@Cta nvarchar(10),
--@Estado bit,

--Valores agregados
--******************
--@Cd_MR nvarchar(2),
@Usu nvarchar(10),
--******************

@msj varchar(100) output
as
if exists (select * from Auxiliar where RucE=@RucE and NDoc=@NDoc and left(Cd_Aux,3)='PRV')
	set @msj = 'Ya existe Proveedor con el mismo numero de documento'
else
begin
begin transaction
declare @cd_Aux varchar(7)
set @cd_Aux = (select user123.Cod_Prv(@RucE))

	insert into Auxiliar(RuCE,Cd_Aux,Cd_TDI,NDoc,RSocial,ApPat,ApMat,Nom,Cd_Pais,CodPost,
			    Ubigeo,Direc,Telf1,Telf2,Fax,Correo,PWeb,Obs,Cd_TA,Estado)
		     values(@RuCE,@cd_Aux,@Cd_TDI,@NDoc,@RSocial,@ApPat,@ApMat,@Nom,@Cd_Pais,@CodPost,
			    @Ubigeo,@Direc,@Telf1,@Telf2,@Fax,@Correo,@PWeb,@Obs,'02',1)
	if @@rowcount <= 0
	begin	   set @msj = 'Auxiliar no pudo ser registrado'
	   rollback transaction
	   return
	end
	insert into Proveedor(RucE,Cd_Aux,Cta,Estado)
		     values(@RucE,@cd_Aux,@Cta,1)

	if @@rowcount <= 0
	begin	   set @msj = 'Proveedor no pudo ser registrado'
	   rollback transaction
	   return
	end
	
	--INSERTANDO MOVIMIENTO DE REGISTRO
	-----------------------------------------------------------------------------------
	declare @NroReg int
	set @NroReg = (select isnull(max(NroReg),0)+1 from AuxiliarRM where RucE=@RucE)
	insert into AuxiliarRM(RucE,NroReg,Cd_Aux,Cd_TDI,NroDoc,Cd_TA,Cd_MR,Usu,FecMov,Cd_Est)
	        values(@RucE,@NroReg,@Cd_Aux,@Cd_TDI,@NDoc,'02','02',@Usu,getdate(),'01')
	-----------------------------------------------------------------------------------
commit transaction
end
print @msj
-- DI 20/01/2009

GO
