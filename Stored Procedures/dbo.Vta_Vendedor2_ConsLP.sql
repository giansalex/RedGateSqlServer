SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

/*
 * Stored Procedure: stproc_TestProcedure 
 * Created By: CONTANET\carlos.vega
 * Created At: 2012/10/13 09:38:51
 * Comments: Inserts values into TestTable
 */
CREATE PROCEDURE [dbo].[Vta_Vendedor2_ConsLP]
  @rucE nvarchar(11)
AS

SELECT * FROM [dbo].[Vendedor2] WHERE [RucE] = @rucE --And [UsuVdr] IS NOT NULL

--SELECT * FROM [dbo].[Vendedor2] WHERE [RucE] = '11111111111'And [UsuVdr] IS NOT NULL
GO
