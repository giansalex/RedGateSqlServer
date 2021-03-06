SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROC [dbo].[Fab_FabricacionCrea]

@RucE nvarchar(11),
@Cd_Fab char(10) output,
@Cd_Flujo char(10),
@NroFab varchar(50),
@FecEmi smalldatetime,
@FecReq smalldatetime,
@Cd_Prod char(7),
@ID_UMP int,     	
@Asunto varchar(200),
@Obs varchar(1000),
@Lote varchar(100),
@Cd_Mda nvarchar(2),
@CamMda numeric(6,3),
@FecReg smalldatetime,
@FecMdf smalldatetime,
@UsuCrea nvarchar(10),
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
@CA11 nvarchar(100),
@CA12 nvarchar(100),
@CA13 nvarchar(100),
@CA14 nvarchar(100),
@CA15 nvarchar(100),
@Cd_Clt char(10),
@Cant decimal(13,7),
@msj varchar(100) output
	as
        
	Set @Cd_Fab = dbo.Cd_Fab(@RucE)	
    if exists (select * from fabfabricacion where RucE=@RucE and Cd_Fab=@Cd_Fab and NroFab=@NroFab)
		Set @msj = 'Ya existe numero de fabricación'
	else
	begin 
		insert into fabfabricacion(RucE,Cd_Fab,Cd_Flujo,NroFab,FecEmi,FecReq,Cd_Prod,ID_UMP,Asunto,Obs,Lote,
				Cd_Mda,CamMda,FecReg,FecMdf,UsuCrea,UsuModf,Cd_CC,Cd_SC,Cd_SS,
        		CA01,CA02,CA03,CA04,CA05,CA06,CA07,CA08,CA09,CA10,CA11,CA12,CA13,CA14,CA15,Cd_Clt,Cant)
		values(@RucE,@Cd_Fab,@Cd_Flujo,@NroFab,@FecEmi,@FecReq,@Cd_Prod,@ID_UMP,@Asunto,@Obs,@Lote,
				@Cd_Mda,@CamMda,getdate(),null,@UsuCrea,null,@Cd_CC,@Cd_SC,@Cd_SS,
        		@CA01,@CA02,@CA03,@CA04,@CA05,@CA06,@CA07,@CA08,@CA09,@CA10,@CA11,@CA12,@CA13,@CA14,@CA15, @Cd_Clt,@Cant)
		if @@rowcount <= 0
			Set @msj = 'Error al registrar fabricación'
	end
	--- Leyenda ---
	--- CE: 2013-01-11 <creacion del sp>
	--- CE: 2013-01-31 <se adiciono la columna Cantidad>







GO
