SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Vta_Servicio2ConsUn_CASAMARILLA]
@RucE nvarchar(11),
@Dato varchar(100),
@msj varchar(100) output

as
/*
DECLARE @RucE nvarchar(11)
DECLARE @Dato nvarchar(100)
DECLARE @msj varchar(100)
SET @RucE='20110154764'
SET @Dato='UNIFORMES'
*/
DECLARE @Cd_Srv varchar(10)
SET @Cd_Srv = ''
SET @Cd_Srv = (Select top 1 s.Cd_Srv From (Select @Dato As Dato,@RucE AS RucE ) As Tab Left Join Servicio2 s ON s.RucE=Tab.RucE Where ((ltrim(Tab.Dato) like '%'+ltrim(s.Nombre)+'%') or ltrim(s.Nombre) like '%'+ltrim(Tab.Dato)+'%') and isnull(IC_TipServ,'')='V' and isnull(Estado,0)=1)
PRINT @Cd_Srv
if not exists (Select * From Servicio2 Where RucE=@RucE and Cd_Srv=@Cd_Srv)
	set @msj = 'Servicio no existe'
else	Select * From Servicio2 Where RucE=@RucE and Cd_Srv=@Cd_Srv
print @msj


-- Leyenda --
-- DI : 15/04/2011 <Se credo procedimiento almacenado para la empresa CASA AMARILLA>
--		   <Se consultara la informacion del servicio a traves de palabra contenida en Nombre (Dato)>


GO
