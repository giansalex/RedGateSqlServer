SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Com_SolicitudCom_NroSCGenera]
@RucE nvarchar(11),
@Cd_SCo nvarchar(10) output,
@NroSC nvarchar(15) output,
@msj varchar(100) output

as

set @Cd_SCo = user123.Cd_SC(@RucE)--Funcion que genera el codigo de la solicitud de compra
set @NroSC = user123.Nro_SC(@RucE)--Funcion que genera el numero de la solicitud de compra

select @Cd_SCo as Cd_SCo,@NroSC as NroSC
-- Leyenda --
-- J : 07/05/2010 <Creacion del procedimiento>
--Ejemplo--
/*
Declare @Cd_SCo nvarchar(10),@NroSC nvarchar(15)
exec Com_SolicitudCom_NroSCGenera '11111111111',@Cd_SCo out,@NroSC out,null
print @Cd_SCo
print @NroSC
*/
GO
