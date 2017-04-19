SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create procedure [dbo].[Cfg_TablaConsCampoxTabla]
@tabla nvarchar(100)
as

select * from sys.columns where object_id = OBJECT_ID(@tabla)

GO
