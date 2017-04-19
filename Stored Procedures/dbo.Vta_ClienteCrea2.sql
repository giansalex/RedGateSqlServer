SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Vta_ClienteCrea2]
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
@CA01 varchar(100),
@CA02 varchar(100),
@CA03 varchar(100),
@CA04 varchar(100),
@CA05 varchar(100),
@CA06 varchar(100),
@CA07 varchar(100),
@CA08 varchar(100),
@CA09 varchar(100),
@CA10 varchar(100),
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
			    Ubigeo,Direc,Telf1,Telf2,Fax,Correo,PWeb,Obs,Cd_TA,Estado,CA01,CA02,CA03,CA04,CA05,CA06,CA07,CA08,CA09,CA10)
		     values(@RuCE,@Cd_Aux,@Cd_TDI,@NDoc,@RSocial,@ApPat,@ApMat,@Nom,@Cd_Pais,@CodPost,
			    @Ubigeo,@Direc,@Telf1,@Telf2,@Fax,@Correo,@PWeb,@Obs,'01',1,@CA01,@CA02,@CA03,@CA04,@CA05,@CA06,@CA07,@CA08,@CA09,@CA10)

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
--JJ 01/09/2010
GO
