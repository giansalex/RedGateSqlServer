SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE procedure [user321].[Inv_PlanCtasConsTodos]
(
	@RucE nvarchar (11)
)
as
select nrocta from planctas
where RucE = @RucE
GO
