SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Gsp_TipGastoConsUn]
@Cd_TG nvarchar(2),
@msj varchar(100) output
as
if not exists (select * from TipGasto where Cd_TG=@Cd_TG)
	set @msj = 'No existe Tipo Gasto'
else	select * from TipGasto where Cd_TG=@Cd_TG
print @msj
-- DI 13/02/2009
GO
