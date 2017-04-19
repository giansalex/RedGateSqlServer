SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Rpt_EstadoGP_Formulas]

@RucE nvarchar(11),
@Ejer nvarchar(4),
@Opc varchar(1),
@msj varchar(100) output

AS

Declare @TipoRpt nvarchar(2) Set @TipoRpt = '02' -- FUNCION
If (@Opc = 'N') Set @TipoRpt = '03' -- NATURALEZA

If (@Opc = 'F')
Begin
	(
	Select IN_Nivel As Nivel,Cd_Rb,Descrip, Cd_Rb As Formula From RubrosRpt Where Cd_TR='02' and Estado=1 
	UNION ALL Select 5 As Nivel,'' As Cd_Rb,'UTILIDAD BRUTA' As Descrip, 'IF01 + IF02 - EF01 - EF02' As Formula
	UNION ALL Select 8 As Nivel,'' As Cd_Rb,'UTILIDAD OPERATIVA' As Descrip, '(IF01 + IF02 - EF01 - EF02) - EF03 - EF04' As Formula
	UNION ALL Select 15 As Nivel,'' As Cd_Rb,'RESULTADO ANTES DE IMPUESTO' As Descrip, '((IF01 + IF02 - EF01 - EF02) - EF03 - EF04) + IF03 + IF04 - EF05 - EF06 + IF05 - EF07' As Formula
	)
	ORDER By 1
End
Else
Begin
	(
	Select IN_Nivel As Nivel,Cd_Rb,Descrip, Cd_Rb As Formula From RubrosRpt Where Cd_TR='03' and Estado=1 
	UNION ALL Select 4 As Nivel,'' As Cd_Rb,'VENTAS NETAS' As Descrip, 'IN01 + IN02 - EN01' As Formula
	UNION ALL Select 8 As Nivel,'' As Cd_Rb,'MARGEN COMERCIAL' As Descrip, '(IN01 + IN02 - EN01) - EN02 + IN03 - EN03' As Formula
	UNION ALL Select 10 As Nivel,'' As Cd_Rb,'VALOR AGREGADO' As Descrip, '((IN01 + IN02 - EN01) - EN02 + IN03 - EN03) - EN04' As Formula
	UNION ALL Select 13 As Nivel,'' As Cd_Rb,'EXCEDENTE BRUTO DE EXPLOTACION' As Descrip, '(((IN01 + IN02 - EN01) - EN02 + IN03 - EN03) - EN04) - EN05 - EN06' As Formula
	UNION ALL Select 18 As Nivel,'' As Cd_Rb,'RESULTADO DE EXPLOTACION' As Descrip, '((((IN01 + IN02 - EN01) - EN02 + IN03 - EN03) - EN04) - EN05 - EN06) - EN07 - EN08 + IN04 + IN05' As Formula
	UNION ALL Select 23 As Nivel,'' As Cd_Rb,'RESULTADO ANTES DE IMPUESTO' As Descrip, '(((((IN01 + IN02 - EN01) - EN02 + IN03 - EN03) - EN04) - EN05 - EN06) - EN07 - EN08 + IN04 + IN05) - EN09 - EN10 + IN06 + IN07' As Formula
	)
	ORDER By 1
End
GO
