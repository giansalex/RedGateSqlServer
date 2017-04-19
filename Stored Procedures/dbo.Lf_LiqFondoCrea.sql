SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROC [dbo].[Lf_LiqFondoCrea]
@RucE nvarchar(11),
@Cd_Liq char(10) OUTPUT,
@RegCtb nvarchar (15),
@FechaAper datetime,
@FechaCierre datetime,
@UsuAper varchar (50),
@FecAper datetime,
@UsuCierre varchar (50),
@FecCierre datetime,
@Cd_Area nvarchar(6),
@Cd_CC nvarchar (8),
@Cd_SC nvarchar (8),
@Cd_SS nvarchar (8),
@Cd_MIS char(3),
@Cd_Mda nvarchar (2),
@CamMda numeric (6,3),
@MtoAnt numeric (18,3),
@MtoAsig numeric (18,3),
@MtoAper numeric (18,3),
@MtoCierre numeric (18,3),
@MtoAnt_ME numeric (18,3),
@MtoAsig_ME numeric (18,3),
@MtoAper_ME numeric (18,3),
@MtoCierre_ME numeric (18,3),
@CA01 varchar (100),
@CA02 varchar (100),
@CA03 varchar (100),
@CA04 varchar (100),
@CA05 varchar (100),
@CA06 varchar (100),
@CA07 varchar (100),
@CA08 varchar (100),
@CA09 varchar (100),
@CA10 varchar (100),
@msj varchar(100) output
	as
        
	Set @Cd_Liq = dbo.Cd_Liq(@RucE)	
    if exists (select * from Liquidacion where RucE=@RucE and Cd_Liq=@Cd_Liq)
		Set @msj = 'Ya existe numero de liquidación'
	else
	begin 
		insert into Liquidacion(RucE,Cd_Liq,RegCtb,FechaAper,FechaCierre,UsuAper,FecAper,UsuCierre,FecCierre,Cd_Area,Cd_CC,
				Cd_SC,Cd_SS,Cd_MIS,Cd_Mda,CamMda,MtoAnt,MtoAsig,MtoAper,MtoCierre,MtoAnt_ME,MtoAsig_ME,MtoAper_ME,MtoCierre_ME,
        		CA01,CA02,CA03,CA04,CA05,CA06,CA07,CA08,CA09,CA10)
		values(@RucE,@Cd_Liq,@RegCtb,getdate(),null,@UsuAper,@FecAper,@UsuCierre,@FecCierre,@Cd_Area,@Cd_CC ,@Cd_SC,
				@Cd_SS,@Cd_MIS,@Cd_Mda,@CamMda,@MtoAnt,@MtoAsig,@MtoAper,@MtoCierre,@MtoAnt_ME,@MtoAsig_ME,@MtoAper_ME,@MtoCierre_ME,
        		@CA01,@CA02,@CA03,@CA04,@CA05,@CA06,@CA07,@CA08,@CA09,@CA10)
		if @@rowcount <= 0
			Set @msj = 'Error al registrar liquidacion'
	end
	--- Leyenda ---
	--- BG 27/02/2013: Se creo sp de crea liquidacion
	--BG 01/03/2013: Se agrego 2 nuevos campos Cd_Mda y CamMda
GO
