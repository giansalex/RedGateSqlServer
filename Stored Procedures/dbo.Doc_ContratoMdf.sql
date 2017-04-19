SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE proc [dbo].[Doc_ContratoMdf]
@RucE nvarchar(11),
@Cd_Ctt int,
--@Cd_Clt char(10),
@FecIni datetime,
@FecFin datetime,
@Descrip varchar(100),
@Obs varchar(200),
--@UsuCrea nvarchar(10),
@Estado bit,

--@FecMdf datetime,
@UsuMdf nvarchar(10),

@msj varchar(100) output,

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
@CA11 varchar(100),
@CA12 varchar(100),
@CA13 varchar(100),
@CA14 varchar(100),
@CA15 varchar(100),
@CA16 varchar(100),
@CA17 varchar(100),
@CA18 varchar(100),
@CA19 varchar(100),
@CA20 varchar(100),

@Cd_CC nvarchar(8),
@Cd_SC nvarchar(8),
@Cd_SS nvarchar(8)

as

if not exists (Select * From Contrato Where RucE=@RucE and Cd_Ctt=@Cd_Ctt)
	Set @msj = 'No se encontro contrato'
else
Begin
	Update Contrato Set
			FecIni=@FecIni,
			FecFin=@FecFin,
			Descrip=@Descrip,
			Obs=@Obs,
			FecMdf=getdate(),
			UsuMdf=@UsuMdf,
			Estado=@Estado,
			
			Cd_CC=@Cd_CC,
			Cd_SC=@Cd_SC,
			Cd_SS=@Cd_SS,
			
			CA01=@CA01,
			CA02=@CA02,
			CA03=@CA03,
			CA04=@CA04,
			CA05=@CA05,
			CA06=@CA06,
			CA07=@CA07,
			CA08=@CA08,
			CA09=@CA09,
			CA10=@CA10,
			CA11=@CA11,
			CA12=@CA12,
			CA13=@CA13,
			CA14=@CA14,
			CA15=@CA15,
			CA16=@CA16,
			CA17=@CA17,
			CA18=@CA18,
			CA19=@CA19,
			CA20=@CA20
	Where RucE=@RucE and Cd_Ctt=@Cd_Ctt

if @@rowcount <= 0
	Set @msj = 'Error al modificar contrato'
End

-- Leyenda --
-- DI : 31/10/2011 <Se creo procedimiento almacenado>

GO
