SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Gsp_CCostosCons_Grupo]
@RucE nvarchar(11),
@msj varchar(100) output
as

select Cd_CC, Cd_CC, NCorto, Descrip  from CCostos where RucE=@RucE

-- Leyenda --
-- DI : 15/10/2012 <Creacion del SP>

GO
