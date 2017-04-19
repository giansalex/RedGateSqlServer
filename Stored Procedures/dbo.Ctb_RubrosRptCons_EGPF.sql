SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Ctb_RubrosRptCons_EGPF]
As
Select '0000' as Cod, '----- No especificado -----' as CodNom, 0 as Pos
Union ALL
Select Cd_Rb as Cod, Cd_Rb+' - '+Descrip as CodNom, Case(left(Cd_Rb,1)) when 'I' then 1 else 2 end as Pos From RubrosRpt Where Cd_TR='02' Order by 3
GO
