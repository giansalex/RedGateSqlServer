SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Rpt_BalanceGeneral_Formulas]

@RucE nvarchar(11),
@Ejer nvarchar(4),
@msj varchar(100) output

AS

Select IN_Nivel As Nivel, Cd_Rb, Case When Descrip like 'PASIVO%' Then '    .'+Descrip Else Descrip End As Descrip,Formula, '1' As Autom,0 AS EsSum, 0 As TitP, 1 As TitS, 0 As Posi  From RubrosRpt Where Cd_TR='01'
UNION ALL Select 0 As Nivel,'' As Cd_Rb, 'ACTIVO' As Descrip, '' As Formula ,							0 As Autom,0 AS EsSum , 1 As TitP, 0 As TitS, 0 As Posi
UNION ALL Select 2 As Nivel,'' As Cd_Rb, '    .TOTAL ACTIVO CORRIENTE' As Descrip, 'Sum(A100)' As Formula ,	1 As Autom,1 AS EsSum , 0 As TitP, 1 As TitS, 5 As Posi
UNION ALL Select 4 As Nivel,'' As Cd_Rb, '    .TOTAL ACTIVO NO CORRIENTE' As Descrip, 'Sum(A200)' As Formula ,1 As Autom,1 AS EsSum , 0 As TitP, 1 As TitS, 5 As Posi
UNION ALL Select 5 As Nivel,'' As Cd_Rb, 'TOTAL ACTIVO' As Descrip, 'Sum(A100)+Sum(A200)' As Formula ,	1 As Autom,1 AS EsSum , 1 As TitP, 0 As TitS, 5 As Posi
UNION ALL Select 6 As Nivel,'' As Cd_Rb, 'PASIVO Y PATRIMONIO' As Descrip, '' As Formula ,				0 As Autom,0 AS EsSum , 1 As TitP, 0 As TitS, 0 As Posi
UNION ALL Select 7 As Nivel,'' As Cd_Rb, 'PASIVO' As Descrip, '' As Formula ,							0 As Autom,0 AS EsSum , 0 As TitP, 1 As TitS, 0 As Posi
UNION ALL Select 9 As Nivel,'' As Cd_Rb, '        .TOTAL PASIVO CORRIENTE' As Descrip, 'Sum(P100)' As Formula ,	1 As Autom,1 AS EsSum , 0 As TitP, 1 As TitS, 5 As Posi
UNION ALL Select 11 As Nivel,'' As Cd_Rb,'        .TOTAL PASIVO NO CORRIENTE' As Descrip, 'Sum(P200)' As Formula,1 As Autom,1 AS EsSum , 0 As TitP, 1 As TitS, 5 As Posi
UNION ALL Select 12 As Nivel,'' As Cd_Rb,'    .TOTAL PASIVO' As Descrip, 'Sum(P100)+Sum(P200)' As Formula ,	1 As Autom,1 AS EsSum , 0 As TitP, 1 As TitS, 5 As Posi
UNION ALL Select 14 As Nivel,'' As Cd_Rb,'    .TOTAL PATRIMONIO' As Descrip, 'Sum(PT10)' As Formula ,		1 As Autom,1 AS EsSum , 0 As TitP, 1 As TitS, 5 As Posi
UNION ALL Select 15 As Nivel,'' As Cd_Rb,'TOTAL PASIVO Y PATRIMONIO' As Descrip, 'Sum(P100)+Sum(P200)+Sum(PT10)' As Formula , 1 As Autom,1 AS EsSum , 1 As TitP, 0 As TitS, 5 As Posi

Order by 1

-- Leyenda --
-- DI : 08/08/2011 <Creacion del procedimiento>

GO
