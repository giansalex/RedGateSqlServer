SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create proc [dbo].[combo_fabri]
as
select year(fecfabricacion) from lote
GO
