SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE proc [dbo].[Doc_ContratoCrea]
@RucE nvarchar(11),
@Cd_Ctt int output,
@Cd_Clt char(10),
@FecIni datetime,
@FecFin datetime,
@Descrip varchar(100),
@Obs varchar(200),
@UsuCrea nvarchar(10),
@Estado bit,
--@FecMdf datetime,
--@UsuModf nvarchar(10),
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
set @Cd_Ctt = dbo.Cd_Ctt(@RucE)
begin 
	insert into Contrato(RucE,Cd_Ctt,Cd_Clt,FecIni,FecFin,Descrip,Obs,FecReg,UsuCrea,Estado,Cd_CC,Cd_SC,Cd_SS,CA01,CA02,CA03,CA04,CA05,CA06,
			   CA07,CA08,CA09,CA10,CA11,CA12,CA13,CA14,CA15,CA16,CA17,CA18,CA19,CA20)
			values(@RucE,@Cd_Ctt,@Cd_Clt,@FecIni,@FecFin,@Descrip,@Obs,getdate(),@UsuCrea,@Estado,@Cd_CC,@Cd_SC,@Cd_SS,@CA01,
			       @CA02,@CA03,@CA04,@CA05,@CA06,@CA07,@CA08,@CA09,@CA10,@CA11,@CA12,@CA13,@CA14,@CA15,@CA16,@CA17,@CA18,
			       @CA19,@CA20)
	if @@rowcount <= 0
		Set @msj = 'Error al registrar contrato'

end
-- Leyenda --
-- CAM 21/10/2011 
-- DI : 25/10/2011 <Se agrego la funcion Cd_Ctt>

--select * from Contrato where RucE = '11111111111'
--select * from Anexo where RucE = '11111111111' 
GO
