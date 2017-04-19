SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Gsp_TasaCon]
@msj varchar(100) output
as
/*if not exists (select top 1 * from Tasas)
	set @msj = 'Tasa no existe'
else*/	select * from Tasas
print @msj
GO
