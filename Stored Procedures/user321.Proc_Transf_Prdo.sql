SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [user321].[Proc_Transf_Prdo]
@RucE nvarchar(11),
@Ejer varchar(4)
as

declare @Consulta varchar(4000)



set @Consulta='
			insert into Periodo (RucE,Ejer,P00,P01,P02,P03,P04,P05,P06,P07,P08,P09,P10,P11,P12,P13,P14)
			SELECT 
				RucE,Ejer,P00,P01,P02,P03,P04,P05,P06,P07,P08,P09,P10,P11,P12,P13,P14
			from OPENROWSET(''SQLOLEDB'',''netserver'';''Usu123_1'';''user123'',
		''SELECT 
			* from 
		dbo.Periodo where RucE='''''+@RucE+''''' and Ejer='''''+@Ejer+''''' '')
		where Ejer not in (select Ejer from periodo where RucE='''+@RucE+''' and Ejer='''+@Ejer+''')
'
		
print @Consulta
exec(@Consulta)
--[user321].[Proc_Transf_Prdo] '20509242977','2008'
-- Leyenda
--JJ <11/01/2011>: creacion de procedimiento
GO
