SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create procedure [dbo].[Cfg_TablaConsCA]
@estado bit
as

select * from Tabla where EsCA = @estado

GO
