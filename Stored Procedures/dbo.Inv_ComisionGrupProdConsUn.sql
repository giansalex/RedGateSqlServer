SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Inv_ComisionGrupProdConsUn]
@RucE nvarchar(11),
@Cd_CGP char(3),
@msj varchar(100) output
as
if not exists (select * from ComisionGrupProd Where RucE=@RucE and Cd_CGP=@Cd_CGP)
	set @msj = 'Comision Grupo de Producto no existe'
else	select * from ComisionGrupProd Where RucE=@RucE and Cd_CGP=@Cd_CGP
GO
