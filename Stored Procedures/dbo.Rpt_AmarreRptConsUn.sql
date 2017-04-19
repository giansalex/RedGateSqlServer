SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Rpt_AmarreRptConsUn]
@RucE nvarchar(11),
@NroCta nvarchar(10),
@msj varchar(100) output
as
if not exists (select * from AmarreRpt where RucE=@RucE and NroCta=@NroCta)
	set @msj = 'No se encontro dicha relacion'
else	select * from AmarreRpt where RucE=@RucE and NroCta=@NroCta
print @msj
GO
