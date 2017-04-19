SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE proc [dbo].[Doc_ContratoConsUn]

@RucE nvarchar(11),
@Cd_Ctt int,
@msj varchar(100) output

AS

Select c.*,t.Cd_TDI From Contrato c
Left Join Cliente2 t On t.RucE=c.RucE and t.Cd_Clt=c.Cd_Clt
Where c.RucE=@RucE and c.Cd_Ctt=@Cd_Ctt

-- Leyenda --
-- DI : 29/10/2011 <Creacion del procedimiento>
-- DI : 07/03/2012 <Se relaciono con la tabla cliente2 y se mostro el Cd_TDI>



GO
