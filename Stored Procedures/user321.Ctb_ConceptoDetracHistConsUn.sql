SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create procedure [user321].[Ctb_ConceptoDetracHistConsUn]
@RucE nvarchar(11),
@Cd_CDtr char(4),
@FecVig smalldatetime,
@msj varchar(100) output
as
if not exists(select top 1 *from ConceptoDetracHist Where RucE=@RucE and Cd_CDtr=@Cd_CDtr and FecVig=@FecVig)
		set @msj='Concepto de detraccion no existe'
else
	begin
		select top 1 *from ConceptoDetracHist where RucE=@RucE and Cd_CDtr=@Cd_CDtr and FecVig=@FecVig
	end
GO
