SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE proc [dbo].[Doc_AnexoCrea]
@RucE nvarchar(11),
@Cd_Ctt int,
@Cd_Anx int,
@Ruta varchar(100),
@Estado bit,
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
@CA15 varchar(100)

as
begin 
	insert into Anexo(RucE,Cd_Ctt,Cd_Anx,Ruta,Estado,CA01,CA02,CA03,CA04,CA05,CA06,CA07,CA08,CA09,CA10,CA11,CA12,CA13,CA14,CA15)
			values(@RucE,@Cd_Ctt,@Cd_Anx,@Ruta,@Estado,@CA01,@CA02,@CA03,@CA04,@CA05,@CA06,@CA07,@CA08,@CA09,@CA10,@CA11,@CA12,@CA13,@CA14,@CA15)
	if @@rowcount <= 0
		Set @msj = 'Error al registrar Anexo'
end
-- Leyenda --
-- CAM 25/10/2011 

--select * from Contrato where RucE = '11111111111'
--select * from Anexo where RucE = '11111111111' 
GO
