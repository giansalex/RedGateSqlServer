SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROC [dbo].[Crd_CreditoAnalisisConsUn]

@RucE nvarchar(11),
@Ejer nvarchar(4),
@Cd_ACrd int,

@msj varchar(100) output

AS

Select * From CreditoAnalisis Where RucE=@RucE and Ejer=@Ejer and Cd_ACrd=@Cd_ACrd

-- Leyenda --
-- DI : 24/11/2011 <Creacion del SP>

GO
