SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROC [dbo].[Fab_FabricacionMdf]
@RucE nvarchar(11),
@Cd_Fab char(10),
@NroFab varchar(50),
@Cd_Flujo char(10),
@FecEmi smalldatetime,
@FecReq smalldatetime,
@Cd_Prod char(7),
@ID_UMP int,     	
@Asunto varchar(200),
@Obs varchar(1000),
@Lote varchar(100),
@Cd_Mda nvarchar(2),
@CamMda numeric(6,3),
@FecMdf smalldatetime,
@UsuModf nvarchar(10),
@Cd_CC nvarchar(8),
@Cd_SC nvarchar(8),
@Cd_SS nvarchar(8),
@CA01 nvarchar(100),
@CA02 nvarchar(100),
@CA03 nvarchar(100),
@CA04 nvarchar(100),
@CA05 nvarchar(100),
@CA06 nvarchar(100),
@CA07 nvarchar(100),
@CA08 nvarchar(100),
@CA09 nvarchar(300),
@CA10 nvarchar(300),
@CA11 nvarchar(300),
@CA12 nvarchar(300),
@CA13 nvarchar(300),
@CA14 nvarchar(300),
@CA15 nvarchar(300),
@Cd_Clt char(10),
@Cant decimal(13,7),
@msj varchar(100) output
        	
as
if not exists (select * from fabfabricacion where RucE=@RucE and Cd_fab=@Cd_fab and NroFab=@NroFab)
	Set @msj = 'No existe numero la fabricacion'
else
begin 
	update fabfabricacion set
	FecEmi=@FecEmi,FecReq=@FecReq,Cd_Prod=@Cd_Prod,ID_UMP=@ID_UMP,Asunto=@Asunto,Obs=@Obs,
	Lote=@Lote,Cd_Mda=@Cd_Mda,FecMdf=getdate(),UsuModf=@UsuModf,Cd_CC=@Cd_CC,Cd_SC=@Cd_SC,
	Cd_SS=@Cd_SS,CA01=@CA01,CA02=@CA02,CA03=@CA03,CA04=@CA04,CA05=@CA05,CA06=@CA06,CA07=@CA07,
	CA08=@CA08,CA09=@CA09,CA10=@CA10,CA11=@CA11,CA12=@CA12,CA13=@CA13,CA14=@CA14,CA15=@CA15,
	Cd_Clt = @Cd_Clt, Cant=@Cant
	where RucE=@RucE and Cd_fab=@Cd_fab and NroFab=@NroFab
	if @@rowcount <= 0
		Set @msj = 'Error al modificar la fabricacion'
end
-- Leyenda ---
-- CE: 11/01/2013 <creacion del sp>
-- CE: 31/01/2013 <Se adiciono la columna Cantidad>
GO
