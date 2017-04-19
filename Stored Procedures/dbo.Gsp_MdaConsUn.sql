SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Gsp_MdaConsUn]
@Cd_Mda nvarchar(2),
@msj varchar(100) output
as
if not exists (select * from Moneda where Cd_Mda=@Cd_Mda)
	set @msj = 'Moneda no existe'
else	select * from Moneda where Cd_Mda=@Cd_Mda
print @msj
GO
