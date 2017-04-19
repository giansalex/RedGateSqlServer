SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Gsp_TipDocConsUn]
@Cd_TD nvarchar(2),
@msj varchar(100) output
as
if not exists (select top 1 * from TipDoc where Cd_TD=@Cd_TD)
	set @msj = 'No se encontro Tipo Documento'
else select * from TipDoc where Cd_TD=@Cd_TD
print @msj
GO
