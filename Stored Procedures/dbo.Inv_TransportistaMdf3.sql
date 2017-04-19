SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE procedure [dbo].[Inv_TransportistaMdf3]
@RucE nvarchar(11),
@Cd_Tra char(7),
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
@Estado bit,
@CA01 varchar(100),
@CA02 varchar(100),
@CA03 varchar(100),
@CA04 varchar(100),
@CA05 varchar(100),
@UsuMdf nvarchar(10),
@msj varchar(100) output
as
if not exists (select * from Transportista where RucE=@RucE and Cd_Tra=@Cd_Tra)
	set @msj = 'Transportista no existe'
else
begin
	update Transportista set RSocial=@RSocial,ApPat=@ApPat,ApMat=@ApMat,Nom=@Nom,Cd_Pais=@Cd_Pais,
		Ubigeo=@Ubigeo,Direc=@Direc,Telf=@Telf,LicCond=@LicCond,NroPlaca=@NroPlaca,McaVeh=@McaVeh,
		@Obs=@Obs,Estado=@Estado,CA01=@CA01,CA02=@CA02,CA03=@CA03,CA04=@CA04,CA05=@CA05,UsuMdf=@UsuMdf,FecMdf=GETDATE()

	where RucE=@RucE and Cd_Tra=@Cd_Tra
	
	if @@rowcount <= 0
	set @msj = 'Transportista no pudo ser modificado'	
end
print @msj

-- Leyenda --
-- 02/02/2012 <Se agrego RucE  -> falto >
GO
