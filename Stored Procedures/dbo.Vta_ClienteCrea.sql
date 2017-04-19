SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Vta_ClienteCrea]
@RucE nvarchar(11),
--@Cd_Aux nvarchar(7),
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
@Cta nvarchar(10),
--@Estado bit,

--Valores agregados
--******************
--@Cd_MR nvarchar(2),
@Usu nvarchar(10),
--******************

@msj varchar(100) output
as
if exists (select * from Auxiliar where RucE=@RucE and Cd_TDI=@Cd_TDI and NDoc=@NDoc)
	set @msj = 'Ya existe Cliente con el mismo numero de documento'
else
begin
begin transaction
declare @Cd_Aux varchar(7)
	--set @Cd_Aux = (select user123.Cod_Cte(@RucE))
	set @Cd_Aux =( dbo.Cod_Cte2(@RucE))
	insert into Auxiliar(RuCE,Cd_Aux,Cd_TDI,NDoc,RSocial,ApPat,ApMat,Nom,Cd_Pais,CodPost,
			    Ubigeo,Direc,Telf1,Telf2,Fax,Correo,PWeb,Obs,Cd_TA,Estado)
		     values(@RuCE,@Cd_Aux,@Cd_TDI,@NDoc,@RSocial,@ApPat,@ApMat,@Nom,@Cd_Pais,@CodPost,
			    @Ubigeo,@Direc,@Telf1,@Telf2,@Fax,@Correo,@PWeb,@Obs,'01',1)

	if @@rowcount <= 0
	begin	   set @msj = 'Auxiliar no pudo ser registrado'
    	   rollback transaction
	   return
	end

	insert into Cliente(RucE,Cd_Aux,Cta,Estado)
		     values(@RucE,@Cd_Aux,@Cta,1)

	if @@rowcount <= 0
	begin	   set @msj = 'Cliente no pudo ser registrado'
	   rollback transaction
	   return
	end

	--INSERTANDO MOVIMIENTO DE REGISTRO
	-----------------------------------------------------------------------------------
	declare @NroReg int
	set @NroReg = (select isnull(max(NroReg),0)+1 from AuxiliarRM where RucE=@RucE)
	insert into AuxiliarRM(RucE,NroReg,Cd_Aux,Cd_TDI,NroDoc,Cd_TA,Cd_MR,Usu,FecMov,Cd_Est)
	        values(@RucE,@NroReg,@Cd_Aux,@Cd_TDI,@NDoc,'01','01','Admin',getdate(),'01')
	-----------------------------------------------------------------------------------
commit transaction
end
print @msj
------CODIGO DE MODIFICACION--------
--CM=MG01

--DI 20/01/2009
GO
