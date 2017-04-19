SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE Procedure [user321].[Rpt_OrdFabricacion]
/*
declare @RucE nvarchar(11)
declare @Ejer nvarchar(4)
declare @cd_of char(10)
SET @RucE ='11111111111'
set @Ejer ='2010'
set @cd_of ='OF00000027'
*/
@RucE nvarchar(11),
@Cd_Of char(10) output 
as

select @Cd_Of = max(Cd_OF) from OrdFabricacion where RucE = @RucE 

--Ejemplo
--exec Rpt_OrdFabricacion '11111111111','OF00000027'

/*****Leyenda**************/
--Creado JAvier: --> 12/03/2011
GO
