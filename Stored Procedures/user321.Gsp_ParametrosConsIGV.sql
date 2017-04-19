SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [user321].[Gsp_ParametrosConsIGV]
@RucE nvarchar(11),
@Fecha varchar(12),
@msj varchar(100) output

as

Select user321.DameIGVPrc(@Fecha) as IGV

-- LEYENDA --
-- DI : 25/03/2010 <Creacion del procedimiento>
GO
