SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROC [dbo].[Vta_DocsVtaCons_X_Vta]

@RucE nvarchar(11),
@Cd_Vta nvarchar(10),
@msj varchar(100) output

AS

select * from DocsVta where RucE=@RucE and Cd_Vta=@Cd_Vta



-- Leyenda --

-- DI : 18/12/2010 <Creacion del procedimiento almacenado>

GO
