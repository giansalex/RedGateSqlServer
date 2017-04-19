SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Prd_OrdFabricacion_FormulaConsUn]
@RucE nvarchar(11),
@Cd_OF char(10),
@msj varchar(100) output
as
select form.ID_Fmla,form.Cd_Prod,form.Descrip, form.Obs from OrdFabricacion op left join
Formula form on op.RucE=form.RucE and op.ID_Fmla=form.ID_Fmla
where op.RucE = @RucE and op.Cd_OF = @Cd_OF
GO
