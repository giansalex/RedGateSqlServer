SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create procedure [dbo].[Gsp_TasaHistConsUn]
@Cd_Ts nvarchar(3),
@EjerPrdoVig nchar(10),
@msj varchar(100) output
as


if not exists (select top 1 *from TasasHist Where Cd_Ts=@Cd_Ts and EjerPrdoVig=@EjerPrdoVig)
	set @msj='Historico de tasas no existe'
select *from TasasHist Where Cd_Ts=@Cd_Ts and EjerPrdoVig=@EjerPrdoVig
GO
