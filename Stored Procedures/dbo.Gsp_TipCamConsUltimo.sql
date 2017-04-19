SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Gsp_TipCamConsUltimo]

@Cd_Mda nvarchar(2),
@msj varchar(100) output
as

select top 1 * from tipcam where Cd_Mda=@Cd_Mda order by YEAR(FecTC) DESC, MONTH(FecTC) DESC, DAY(FecTC) desc

GO
