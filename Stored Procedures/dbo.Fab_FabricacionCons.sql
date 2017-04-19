SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE procedure [dbo].[Fab_FabricacionCons]
@RucE nvarchar(11),
@msj varchar(100) output
as
if not exists (select * from FabFabricacion where RucE = @RucE)
	set @msj = 'La Fabricación no existe.'
else	
	select RucE,
		Cd_Fab as CodMov,
		NroFab as NroDoc,
		Cd_Flujo,
		Cd_Prod,
		ID_UMP,
		Cant,
		FecEmi,
		FecReq,
		Cd_Clt,
		Cd_CC,
		Cd_SC,
		Cd_SS,
		Asunto,
		Obs,
		Lote,
		Cd_Mda,
		CamMda,
		FecReg,
		FecMdf,
		UsuCrea,
		UsuModf,
		CA01,
		CA02,
		CA03,
		CA04,
		CA05,
		CA06,
		CA07,
		CA08,
		CA09,
		CA10,
		CA11 from FabFabricacion where RucE = @RucE
print @msj

--exec Fab_FabricacionCons '11111111111',''
-- cam
GO
