SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Gsp_TipoPago]
	@msj varchar(100) output
AS

BEGIN
	Declare @lmax int
		Set @lmax = (select Max(len(Cd_FPC)) from FormaPc where  Estado='True')
		select left(Cd_FPC+'__________',@lmax)+'  |  '+Nombre as CodNom, Cd_FPC, Nombre from FormaPc where Estado='True'	
END
GO
