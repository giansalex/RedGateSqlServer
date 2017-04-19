SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create procedure [dbo].[Com_Proveedor2Mdf4]
@RucE nvarchar(11),
@Cd_Prv char(7),
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
@FecMdf DateTime,
@UsuMdf nvarchar(10),
--
@Grupo nvarchar(100),
@DiasCobro nvarchar(100),
@LimiteCredito nvarchar(100),
@PerCobro nvarchar(100),
@CtasCrtes nvarchar(100),

@msj varchar(100) output
as
if not exists (select * from Proveedor2 where RucE=@RucE and Cd_Prv=@Cd_Prv)
	set @msj = 'Proveedor no existe'
else
begin
	update Proveedor2 set Cd_TDI=@Cd_TDI,NDoc=@NDoc,RSocial=@RSocial,ApPat=@ApPat,ApMat=@ApMat,
		Nom=@Nom,Cd_Pais=@Cd_Pais,CodPost=@CodPost,Ubigeo=@Ubigeo,Direc=@Direc,Telf1=@Telf1,
		Telf2=@Telf2,Fax=@Fax,Correo=@Correo,PWeb=@PWeb,Obs=@Obs,CtaCtb=@CtaCtb,Estado=@Estado,
		CA01=@CA01,CA02=@CA02,CA03=@CA03,CA04=@CA04,CA05=@CA05,
		CA06=@CA06,CA07=@CA07,CA08=@CA08,CA09=@CA09,CA10=@CA10,
		IB_SjDet=@IB_SjDet,Cd_TPrv=@Cd_TPrv,FecMdf=@FecMdf,UsuMdf=@UsuMdf,
		Grupo = @Grupo, DiasCobro = @DiasCobro, LimiteCredito = @LimiteCredito, PerCobro = @PerCobro,CtasCrtes = @CtasCrtes
	where RucE=@RucE and Cd_Prv=@Cd_Prv
	if @@rowcount <= 0	   set @msj = 'Proveedor no pudo ser modificado'


end
print @msj

-- Leyenda --
-- PP : 2010-02-18 : <Creacion del procedimiento almacenado>
-- PP : 2011-02-09 : <Modificiacion del procedimiento almacenado>
-- FL : 2011-07-14 : <Modificiacion del procedimiento almacenado>

-- KJ : 2011-11-14 : <Modificiacion del procedimiento almacenado a nueva version. Se agrego usucrea y usumdf>
--cam agregue informacion comercial 08/12/2011
GO
