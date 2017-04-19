SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Vta_VendedorMdf]
@RucE nvarchar(11),
@Cd_Aux nvarchar(7),
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
@Estado bit,

--Valores agregados
--******************
--@Cd_MR nvarchar(2),
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
			   Obs=@Obs, Estado=@Estado
	where RucE=@RucE and Cd_Aux=@Cd_Aux

	if @@rowcount <= 0
	begin	   set @msj = 'Auxiliar no pudo ser modificado'
	   rollback transaction
	   return
	end

	update Vendedor set Cta=@Cta, Estado=@Estado
	where RucE=@RucE and Cd_Aux=@Cd_Aux

	if @@rowcount <=0
	begin
	   set @msj = 'Vendedor no pudo ser modificado'
	   rollback transaction
	   return
	end

	--INSERTANDO MOVIMIENTO DE REGISTRO
	-----------------------------------------------------------------------------------
	declare @NroReg int
	set @NroReg = (select isnull(max(NroReg),0)+1 from AuxiliarRM where RucE=@RucE)
	insert into AuxiliarRM(RucE,NroReg,Cd_Aux,Cd_TDI,NroDoc,Cd_TA,Cd_MR,Usu,FecMov,Cd_Est)
	        values(@RucE,@NroReg,@Cd_Aux,@Cd_TDI,@NDoc,'03','01',@Usu,getdate(),'02')
	-----------------------------------------------------------------------------------

commit transaction
end
print @msj
--DI 20/01/2009
GO
