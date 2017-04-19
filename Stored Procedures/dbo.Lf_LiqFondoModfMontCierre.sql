SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROC [dbo].[Lf_LiqFondoModfMontCierre]
@RucE nvarchar(11),
@Cd_Liq char(10),
@Cd_Area nvarchar(6),
@Cd_CC nvarchar(8),
@Cd_SC nvarchar(8),
@Cd_SS nvarchar(8),
@FechaCierre datetime,
@UsuCierre VARCHAR(50),
@FecCierre DATETIME,
@Cd_MIS CHAR(3),
@MtoCierre numeric (18,3),
@MtoCierre_ME numeric (18,3),
@msj VARCHAR(100) output
as
if not exists (select * from Liquidacion where RucE=@RucE and Cd_Liq=@Cd_Liq)
	set @msj = 'Liquidacion no existe'
else

update Liquidacion set @Cd_Area=Cd_Area,Cd_CC=@Cd_CC,Cd_SC=@Cd_SC,Cd_SS=@Cd_SS,FechaCierre=@FechaCierre,MtoCierre=@MtoCierre,MtoCierre_ME =@MtoCierre_ME
WHERE RucE = @RucE AND Cd_Liq=@Cd_Liq

print @msj
GO
