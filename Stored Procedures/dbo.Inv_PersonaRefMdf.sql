SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Inv_PersonaRefMdf]--Actualizacion de datos de Persona referencia
@RucE nvarchar(11),
@Cd_Clt char(10),
@Cd_Per char(7),
@Cd_TDI nvarchar(2),
@NDoc nvarchar(15),
@ApPat varchar(20),
@ApMat varchar(20),
@Nom varchar(20),
@Cd_Vin char(2),
@CA01 varchar(100),
@CA02 varchar(100),
@CA03 varchar(100),
@CA04 varchar(100),
@CA05 varchar(100),
@msj varchar(100) output
as
if not exists (select * from PersonaRef where RucE= @RucE and @Cd_Per=@Cd_Per)
	set @msj = 'Persona de Referencia no existe'
else
begin
	update PersonaRef 
	set Cd_Clt=@Cd_Clt,Cd_TDI=@Cd_TDI,NDoc=@NDoc,ApPat=@ApPat,ApMat=@ApPat,Nom=@Nom,Cd_Vin=@Cd_Vin,
	CA01=@CA01,CA02=@CA02,CA03=@CA03,CA04=@CA04,CA05=@CA05
	where RucE= @RucE and Cd_Per=@Cd_Per

	if @@rowcount <= 0
	set @msj = 'Persona de Referencia no pudo ser modificada'	
end
----
--J: 09-04-2010 -> <Creado>
--CAM 27/09/2010  -> Modificado PR03 : Parametro cambiado de Cd_Cte a Cd_Clt. Tbn se cambio su longitud

GO
