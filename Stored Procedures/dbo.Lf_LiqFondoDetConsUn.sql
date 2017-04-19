SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Lf_LiqFondoDetConsUn]
@RucE nvarchar(11),
@Cd_Liq char(10),
@msj varchar(100) output
as
if not exists (select  Cd_Liq,Item from Liquidaciondet where Cd_Liq=@Cd_Liq and RucE = @RucE)
	set @msj = 'Liquidacion de Fondo no existe'
else	
	select RucE,Cd_Liq,Item,RegCtb,FecMov,Cd_TD,NroSre,NroDoc,FecED,FecVD,Itm_BC,Cd_Prod,ID_UMP,Cd_Srv,ValorU,DsctoP,DsctoI,BIMU,IGVU,
			TotalU,Cantidad,BIM,IGV,Total,IB_Cancelado,Cd_Prv,Cd_Clt,Cd_Area,Cd_CC,Cd_SC,Cd_SS,Cd_MIS,CamMda,FecReg,FecMdf,UsuCrea,UsuModf,
			CA01,CA02,CA03,CA04,CA05,CA06,CA07,CA08,CA09,CA10,CA11,CA12,CA13,CA14,CA15
	 from LiquidacionDet
	where Cd_Liq=@Cd_Liq and RucE = @RucE
	
print @msj

--Leyenda
--BG :	28/02/2013 <se creo el SP--/(.)(.)\>
GO
