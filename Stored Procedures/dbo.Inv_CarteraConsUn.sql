SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Inv_CarteraConsUn]
@RucE nvarchar(11),
@Cd_Ct char(3),
@msj varchar(100) output
as
if not exists (select * from CarteraProd where RucE=@RucE and Cd_Ct=@Cd_Ct)
	set @msj = 'Cartera de Productos no existe'
else	select * from CarteraProd where RucE=@RucE and Cd_Ct=@Cd_Ct

GO
