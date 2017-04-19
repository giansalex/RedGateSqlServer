SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROC [dbo].[Com_DocsComCons_X_Com]

@RucE nvarchar(11),
@Cd_Com char(10),
@msj varchar(100) output

AS

select * from DocsCom where RucE=@RucE and Cd_Com=@Cd_Com


-- Leyenda --

-- DI : 19/12/2010 <Creacion del procedimiento almacenado>




GO
