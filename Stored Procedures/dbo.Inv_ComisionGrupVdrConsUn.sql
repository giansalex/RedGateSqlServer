SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Inv_ComisionGrupVdrConsUn]
@RucE nvarchar(11),
@Cd_CGV char(3),
@msj varchar(100) output
as
if not exists (select * from ComisionGrupVdr Where RucE=@RucE and Cd_CGV=@Cd_CGV)
	set @msj = 'Comision Grupo de Vendedor no existe'
else	select * from ComisionGrupVdr Where RucE=@RucE and Cd_CGV=@Cd_CGV
GO
