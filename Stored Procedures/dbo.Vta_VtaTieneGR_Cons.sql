SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE Proc [dbo].[Vta_VtaTieneGR_Cons](
	@RucE nvarchar(11),
	@Cd_Vta nvarchar(10),
	@GRs varchar(100) output
)
As
select @GRs = coalesce(@GRs,'')+ LTRIM(rtrim(Cd_Gr)) From GuiaXVenta Where RucE = @RucE And Cd_Vta = @Cd_Vta
GO
