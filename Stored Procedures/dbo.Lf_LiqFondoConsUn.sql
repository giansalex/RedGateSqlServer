SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Lf_LiqFondoConsUn]
@RucE nvarchar(11),
@Cd_Liq char(10),
@msj varchar(100) output
as
if not exists (select  Cd_Liq from Liquidacion where Cd_Liq=@Cd_Liq and RucE = @RucE)
	set @msj = 'Liquidacion de Fondo no existe'
else	
	select RucE,Cd_Liq,RegCtb,FechaAper,FechaCierre,UsuAper,FecAper,FecCierre,Cd_Area,Cd_CC,Cd_SC,Cd_SS,Cd_MIS,
	Cd_Mda,CamMda,
			MtoAnt,MtoAsig,MtoAper,MtoCierre,MtoAnt_ME,MtoAsig_ME,MtoAper_ME,MtoCierre_ME,CA01,CA02,CA03,CA04,CA05,
			CA06,CA07,CA08,CA09,CA10
	 from Liquidacion
	WHERE RucE = @RucE and Cd_Liq=@Cd_Liq
	
print @msj

--Leyenda
--BG :	28/02/2013 <se creo el SP--/(.)(.)\>
GO
