SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE proc [dbo].[Doc_AnexoCons_X_Ctt]

@RucE nvarchar(11),
@Cd_Ctt int,
@msj varchar(100) output

AS

Select 'Ver' As Ver,'Editar' As Edit,* From Anexo Where RucE=@RucE and Cd_Ctt=@Cd_Ctt

-- Leyenda --
-- DI : 29/10/2011 <Creacion del procedimiento>

GO
