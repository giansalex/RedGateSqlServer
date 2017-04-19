SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Gsp_TipDocIdnConsUn]
@Cd_TDI nvarchar(2),
@msj varchar(100) output
as
if not exists (select * from TipDocIdn where Cd_TDI=@Cd_TDI)
	set @msj = 'Tipo Documento Identidad no existe'
else	select * from TipDocIdn where Cd_TDI=@Cd_TDI
print @msj
GO
