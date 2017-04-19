SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[CfgCargaEstadoOC] 

as
Select '00' as Id_EstOC, 'Ninguno' as Descrip , 1 as IB_Activo
union all
Select  * from EstadoOC eoc where isnull(eoc.IB_Activo, '''') = 1 
GO
