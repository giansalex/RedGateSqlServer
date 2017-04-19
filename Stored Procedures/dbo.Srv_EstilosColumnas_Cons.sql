SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create proc [dbo].[Srv_EstilosColumnas_Cons] 
@RucE nvarchar(11),
@TareaID char(10)
As

Select * From View_EstiloColumnas
Where RucE = @RucE And TareaProgramadaID = @TareaID
GO
