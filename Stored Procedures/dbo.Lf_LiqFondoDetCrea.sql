SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROC [dbo].[Lf_LiqFondoDetCrea]
@RucE nvarchar(11),
@Cd_Liq char(10),
@Item int,
@RegCtb NVARCHAR(15),
@FecMov smalldatetime,
@Cd_TD nvarchar (2),
@NroSre varchar (5),
@NroDoc nvarchar (15),
@FecED smalldatetime,
@FecVD smalldatetime,
@Itm_BC NVARCHAR(20),
@Cd_Prod char(7),
@ID_UMP int,
@Cd_Srv char (7),
@ValorU numeric (15,7),
@DsctoP numeric (5,2),
@DsctoI numeric (15,7),
@BIMU numeric (15,7),
@IGVU numeric (15,7),
@TotalU numeric (15,7),
@Cantidad decimal (13,3),
@BIM numeric (15,7),
@IGV numeric (15,7),
@Total numeric (15,7),
@IB_Cancelado BIT,
@Cd_Prv char (7),
@Cd_Clt char (10),
@Cd_Area nvarchar (12),
@Cd_CC nvarchar (8),
@Cd_SC nvarchar (8),
@Cd_SS nvarchar (8),
@Cd_MIS CHAR(3),
@Cd_Mda nvarchar (2),
@CamMda numeric (6,3),
@FecReg datetime,
@FecMdf datetime,
@Usucrea nvarchar (10),
@UsuModf nvarchar (10),
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
@CA11 varchar (100),
@CA12 varchar (100),
@CA13 varchar (100),
@CA14 varchar (100),
@CA15 varchar (100),
@msj varchar(100) output
	AS
	if exists (select * from LiquidacionDet where RucE=@RucE and Cd_Liq=@Cd_Liq AND Item = @Item)
		Set @msj = 'Ya existe numero de liquidación'
	else
	begin 
		insert into LiquidacionDet(RucE,Cd_Liq,Item,RegCtb,FecMov,Cd_TD,NroSre,NroDoc,FecED,FecVD,Itm_BC,Cd_Prod,ID_UMP,
				Cd_Srv,ValorU,DsctoP,DsctoI,BIMU,IGVU,TotalU,Cantidad,BIM,IGV,Total,IB_Cancelado,
				Cd_Prv,Cd_Clt,Cd_Area,Cd_CC,Cd_SC,Cd_SS,Cd_MIS,Cd_Mda,CamMda,FecReg,FecMdf,UsuCrea,UsuModf,CA01,CA02,CA03,CA04,CA05,CA06,CA07,CA08,CA09,CA10,CA11,CA12,CA13,CA14,CA15)
		values(@RucE,@Cd_Liq,@Item,@RegCtb,getdate(),@Cd_TD,@NroSre,@NroDoc,@FecED,@FecVD,@Itm_BC,@Cd_Prod,@ID_UMP,
				@Cd_Srv,@ValorU,@DsctoP,@DsctoI,@BIMU,@IGVU,@TotalU,@Cantidad,@BIM,@IGV,@Total,@IB_Cancelado,
				@Cd_Prv,@Cd_Clt,@Cd_Area,@Cd_CC,@Cd_SC,@Cd_SS,@Cd_MIS,@Cd_Mda,@CamMda,@FecReg,@FecMdf,@UsuCrea,@UsuModf,@CA01,@CA02,@CA03,@CA04,@CA05,@CA06,@CA07,@CA08,@CA09,@CA10,@CA11,@CA12,@CA13,@CA14,@CA15)
		if @@rowcount <= 0
			Set @msj = 'Error al registrar liquidacion'
	end
	--- Leyenda ---
	--- BG 28/02/2013: Se creo sp de crea liquidaciondet







GO
