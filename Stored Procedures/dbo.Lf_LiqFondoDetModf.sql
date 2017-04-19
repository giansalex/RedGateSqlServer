SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Lf_LiqFondoDetModf]
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
@FecMdf datetime,
@UsuModf nvarchar (20),
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
as
if not exists (select * from LiquidacionDet where RucE=@RucE and Cd_Liq=@Cd_Liq)
	set @msj = 'Liquidacion no existe'
else

update LiquidacionDet set RegCtb=@RegCtb, FecMov = @FecMov, Cd_TD = @Cd_TD,NroSre = @NroSre,
						NroDoc = @NroDoc,FecED=@FecED,FecVD=@FecVD,Itm_BC=@Itm_BC,Cd_Prod =@Cd_Prod,ID_UMP = @ID_UMP,Cd_Srv=@Cd_Srv,ValorU=@ValorU,
						DsctoP =@DsctoP,DsctoI=@DsctoI,BIMU=@BIMU,IGVU=@IGVU,TotalU=@TotalU,Cantidad=@Cantidad,
						BIM =@BIM,IGV=@IGV,Total=@Total,IB_Cancelado=@IB_Cancelado,Cd_Prv=@Cd_Prv,Cd_Clt=@Cd_Clt,Cd_Area=@Cd_Area,Cd_CC=@Cd_CC,Cd_SC=@Cd_SC,Cd_SS=@Cd_SS,Cd_MIS=@Cd_MIS,Cd_Mda=@Cd_Mda,CamMda=@CamMda,FecMdf=@FecMdf,UsuModf=@UsuModf,
						CA01=@CA01,CA02=@CA02,CA03=@CA03,CA04 =@CA04,CA05=@CA05,CA06=@CA06,CA07=@CA07,CA08=@CA08,CA09=@CA09,CA10=@CA10,CA11=@CA11,CA12=@CA12,CA13=@CA13,CA14=@CA14,CA15=@CA15
						where RucE=@RucE and Cd_Liq=@Cd_Liq AND Item = @Item
print @msj

--Leyenda

--BG : 28/02/2013 <se creo el SP modificar>
--bg: 08/03/2013 <se agrego el where del update mi error> 

GO
