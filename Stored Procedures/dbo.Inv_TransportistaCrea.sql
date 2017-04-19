SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Inv_TransportistaCrea]
@RucE nvarchar(11),
@Cd_TDI nvarchar(2),
@NDoc nvarchar(15),
@RSocial varchar(100),
@ApPat varchar(20),
@ApMat varchar(20),
@Nom varchar(20),
@Cd_Pais nvarchar(4),
@Ubigeo nvarchar(6),
@Direc varchar(100),
@Telf varchar(20),
@LicCond varchar(50),
@NroPlaca varchar(10),
@McaVeh varchar(50),
@Obs varchar(100),
@CA01 varchar(100),
@CA02 varchar(100),
@CA03 varchar(100),
@CA04 varchar(100),
@CA05 varchar(100),

--Valores agregados
--******************
--@UsuCrea nvarchar(10),
--******************

@msj varchar(100) output,
@Cd_Tra char(7 ) output
as
if exists (select * from Transportista where RucE = @RucE and NDoc=@NDoc)
	set @msj = 'Ya existe transportista con este numero de documento'
else
begin
	set @Cd_Tra = dbo.Cd_Tra(@RucE)
	insert into Transportista(RucE,Cd_Tra,Cd_TDI,NDoc,RSocial,ApPat,ApMat,Nom,Cd_Pais,Ubigeo,Direc,Telf,LicCond,NroPlaca,McaVeh,Obs,Estado,CA01,CA02,CA03,CA04,CA05)--,UsuCrea,FecReg)
		    values(@RucE,@Cd_Tra,@Cd_TDI,@NDoc,@RSocial,@ApPat,@ApMat,@Nom,@Cd_Pais,@Ubigeo,@Direc,@Telf,@LicCond,@NroPlaca,@McaVeh,@Obs,1,@CA01,@CA02,@CA03,@CA04,@CA05)--,@UsuCrea, GETDATE())

	if @@rowcount <= 0
	   set @msj = 'El transportista no pudo ser creado'
end
print @msj


-- MP : 16-02-2011 : <Modificacion del procedimiento almacenado>

GO
