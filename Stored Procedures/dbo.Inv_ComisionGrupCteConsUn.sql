SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Inv_ComisionGrupCteConsUn]
@RucE nvarchar(11),
@Cd_CGC char(3),
@msj varchar(100) output
as
if not exists (select * from ComisionGrupCte where RucE = @RucE and Cd_CGC=@Cd_CGC)
	set @msj = 'Comision Grupo de Cliente no existe'
else	select * from ComisionGrupCte where RucE = @RucE and Cd_CGC=@Cd_CGC
GO
