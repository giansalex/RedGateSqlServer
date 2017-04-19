SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Vta_Vendedor2Crea3]
@RucE nvarchar(11),
@Cd_TDI nvarchar(2),
@NDoc nvarchar(15),
@ApPat varchar(20),
@ApMat varchar(20),
@Nom varchar(20),
@Cd_Pais nvarchar(4),
@Ubigeo nvarchar(6),
@Direc varchar(100),
@Telf1 varchar(20),
@Telf2 varchar(20),
@Correo varchar(50),
@Cargo varchar(100),
@Obs varchar(200),
@Cd_CGV char(3),
@Cd_CT char(3),
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
--Valores agregados
--******************
@UsuCrea nvarchar(10),
@UsuVdr nvarchar(20),
@Cd_Caja nvarchar(20),
--******************
@Cd_Vdr char(7) output,
@msj varchar(100) output
as
if exists (select * from Vendedor2 where RucE=@RucE and NDoc=@NDoc)
	set @msj = 'Ya existe Vendedor con el mismo numero de documento'
else
begin
	set @Cd_Vdr = user123.Cod_Vnd2(@RucE)
	insert into Vendedor2(RucE,Cd_Vdr,Cd_TDI,NDoc,ApPat,ApMat,Nom,Cd_Pais,Ubigeo,Direc,Telf1,Telf2,Correo,Cargo,Obs,Cd_CGV,Cd_CT,Estado,CA01,CA02,CA03,CA04,CA05,CA06,CA07,CA08,CA09,CA10,UsuCrea,FecReg,UsuVdr,Cd_Caja)
		   Values(@RucE,@Cd_Vdr,@Cd_TDI,@NDoc,@ApPat,@ApMat,@Nom,@Cd_Pais,@Ubigeo,@Direc,@Telf1,@Telf2,@Correo,@Cargo,@Obs,@Cd_CGV,@Cd_CT,1,@CA01,@CA02,@CA03,@CA04,@CA05,@CA06,@CA07,@CA08,@CA09,@CA10,@UsuCrea,GETDATE(),@UsuVdr,@Cd_Caja)
	if @@rowcount <= 0
	set @msj = 'Vendedor no pudo ser registrado'	



end
print @msj
-- J 12/03/10 -> creacion
-- MP: 16-02-2011 : <Modificacion del procedimiento almacenado>


GO
