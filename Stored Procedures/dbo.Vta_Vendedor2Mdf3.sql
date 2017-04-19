SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Vta_Vendedor2Mdf3]
@RucE nvarchar(11),
@Cd_Vdr char(7),
/***********/
@Cd_TDI nvarchar(2),
@NDoc nvarchar(15),
/**********/
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
--Valores agregados
--******************
@UsuMdf nvarchar(10),
@UsuVdr nvarchar(20),
@Cd_Caja nvarchar(20),
--******************
@msj varchar(100) output
as
if not exists (select * from Vendedor2 where RucE=@RucE and Cd_Vdr=@Cd_Vdr)
	set @msj = 'Vendedor no existe'
else
begin

	Update Vendedor2 set ApPat=@ApPat,ApMat=@ApMat,Nom=@Nom,Cd_Pais=@Cd_Pais,Ubigeo=@Ubigeo,Direc=@Direc,Telf1=@Telf1,Telf2=@Telf2,
			Correo=@Correo,Cargo=@Cargo,Obs=@Obs,Cd_CGV=@Cd_CGV,Cd_CT=@Cd_CT,Estado=@Estado,CA01=@CA01,CA02=@CA02,Cd_TDI=@Cd_TDI,NDoc=@NDoc,
			CA03=@CA03,CA04=@CA04,CA05=@CA05,CA06=@CA06,CA07=@CA07,CA08=@CA08,CA09=@CA09,CA10=@CA10,UsuMdf=@UsuMdf,FecMdf=GETDATE(),
			UsuVdr=@UsuVdr,Cd_Caja=@Cd_Caja
	Where RucE=@RucE and Cd_Vdr=@Cd_Vdr
	if @@rowcount <= 0
	set @msj = 'Vendedor no pudo ser modificado'	



end
print @msj
-- J 12/03/10 -> creacion
-- MP : 17/02/2012 : <Modifiacion del procedimiento almacenado>


GO
