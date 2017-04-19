SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Gsp_TipAuxConsUn]
@Cd_TA nvarchar(2),
@msj varchar(100) output
as
if not exists (select * from TipAux where Cd_TA=@Cd_TA)
	set @msj = 'Tipo Auxiliar no existe'
else	select * from TipAux where Cd_TA=@Cd_TA
print @msj
GO
