SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Vta_Cliente2Mdf1]
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
@Direc	varchar(100),
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

@msj varchar(100) output
as
if not exists (select * from Cliente2 where RucE=@RucE and Cd_Clt=@Cd_Clt)
	set @msj = 'Cliente no existe'
else
begin
begin transaction
	update Cliente2 set Cd_TDI=@Cd_TDI, NDoc=@NDoc, RSocial=@RSocial, ApPat=@ApPat, ApMat=@ApMat,
			   Nom=@Nom, Cd_Pais=@Cd_Pais, CodPost=@CodPost, Ubigeo=@Ubigeo, Direc=@Direc,
			   Telf1=@Telf1, Telf2=@Telf2, Fax=@Fax, Correo=@Correo, PWeb=@PWeb,
			   Obs=@Obs,CtaCtb=@CtaCtb,DiasCbr=@DiasCbr,PerCbr=@PerCbr,CtaCte=@CtaCte,Estado=@Estado,Cd_CGC = @Cd_CGC,
			   CA01=@CA01,CA02=@CA02,CA03=@CA03,CA04=@CA04,CA05=@CA05,CA06=@CA06,CA07=@CA07,CA08=@CA08,CA09=@CA09,CA10=@CA10,Cd_TClt=@Cd_TClt
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


GO
