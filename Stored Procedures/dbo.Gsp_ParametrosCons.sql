SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Gsp_ParametrosCons]
@RucE nvarchar(11),
@msj varchar(100) output

as

Select user123.IGV() as IGV

-- LEYENDA --
-- DI : 25/03/2010 <Creacion del procedimiento>

GO
