SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [user321].[Com_SolicitudCom_Cons_Para_EnvioPorExplo]
@RucE nvarchar(11),
@Cd_SCo char(10),
@msj varchar(100) output
as

if((select count(*) from SCxProv where RucE = @RucE and Cd_SCo = @Cd_SCo) = 0)
begin
	set @msj = 'La solicitud no tiene proveedores anexados.'
	return
end

declare @id_Aut int
set @id_Aut = (select TipAut from solicitudCom where RucE = @RucE and Cd_SCo = @Cd_SCo)

if(@id_Aut is null or @id_Aut = 0) return

declare @IB_Aut bit
set @IB_Aut = (select IB_Aut from solicitudCom where RucE = @RucE and Cd_SCo = @Cd_SCo)

if(@IB_Aut is null or @IB_Aut = 0)
begin
	set @msj = 'Para enviar la solicitud primero debe autorizarla.'
	return
end

declare @Estado char(2)
set @Estado = (select Id_EstSC from solicitudCom where RucE = @RucE and Cd_SCo = @Cd_SCo)
/*
if(@Estado='07' or @Estado='08' or @Estado='09' or @Estado='10')
begin
	set @msj = 'El estado de la solicitud'
end
*/
-- MM	04/04/2011	<Creacion del SP>
GO
