SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Inv_MarcaConsUn]
@RucE nvarchar(11),
@Cd_Mca char(3),
@msj varchar(100) output
as
if not exists (select * from Marca where RucE = @RucE and Cd_Mca=@Cd_Mca)
	set @msj = 'Marca no existe'
else	select * from Marca where RucE = @RucE and Cd_Mca=@Cd_Mca 
print @msj
GO
