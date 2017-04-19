SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE proc [dbo].[Doc_ContratoMdf2]
@RucE nvarchar(11),
@Cd_Ctt int,
@Cd_Clt char(10),
@FecIni datetime,
@FecFin datetime,
@Descrip varchar(100),
@Obs varchar(200),
--@UsuCrea nvarchar(10),
@Estado bit,

--@FecMdf datetime,
@UsuMdf nvarchar(10),

@msj varchar(100) output,

@CA01 varchar(4000),
@CA02 varchar(4000),
@CA03 varchar(4000),
@CA04 varchar(4000),
@CA05 varchar(4000),
@CA06 varchar(4000),
@CA07 varchar(4000),
@CA08 varchar(4000),
@CA09 varchar(4000),
@CA10 varchar(4000),
@CA11 varchar(4000),
@CA12 varchar(4000),
@CA13 varchar(4000),
@CA14 varchar(4000),
@CA15 varchar(4000),
@CA16 varchar(4000),
@CA17 varchar(4000),
@CA18 varchar(4000),
@CA19 varchar(4000),
@CA20 varchar(4000),

@Cd_CC nvarchar(8),
@Cd_SC nvarchar(8),
@Cd_SS nvarchar(8),

@Cd_Prv char(7),
@Cd_Vdr char(7),
@Cd_Area char(6)

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
			CA20=@CA20,
			Cd_Clt=@Cd_Clt,
			Cd_Prv=@Cd_Prv,
			Cd_Vdr=@Cd_Vdr,
			Cd_Area=@Cd_Area
			
	Where RucE=@RucE and Cd_Ctt=@Cd_Ctt

if @@rowcount <= 0
	Set @msj = 'Error al modificar contrato'
End

-- Leyenda --
-- DI : 31/10/2011 <Se creo procedimiento almacenado>

GO
