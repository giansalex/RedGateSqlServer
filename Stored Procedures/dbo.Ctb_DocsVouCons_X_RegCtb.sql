SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROC [dbo].[Ctb_DocsVouCons_X_RegCtb]

@RucE nvarchar(11),
@RegCtb nvarchar(15),
@msj varchar(100) output

AS

select * from DocsVou where RucE=@RucE and RegCtb=@RegCtb


-- Leyenda --

-- DI : 19/12/2010 <Creacion del procedimiento almacenado>



GO
