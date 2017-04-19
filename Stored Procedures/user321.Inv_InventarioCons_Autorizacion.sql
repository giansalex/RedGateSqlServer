SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [user321].[Inv_InventarioCons_Autorizacion]
@RucE nvarchar(11),
@Ejer varchar(4),
@Cd_Doc char(10),
@Cd_TDES char(2),
@msj varchar(100) output
as
--if (@CD_TDES != 'OC' and @CD_TDES != 'OP' and @CD_TDES != 'SR')
--begin
--	set @msj = 'El Tipo de Documento solo permite OC, OP y SR por el momento.'
--end
--else
--begin
	if (@Cd_TDES = 'OC')
	begin
		if(@RucE = '20504743561')--SOLO PARA GMC
		begin
			select 1 as IB_Aut 
		end
		else--PARA LAS OTRAS EMPRESAS
			select case(isnull(TipAut,0)) when 0 then 1 else isnull(IB_Aut,0) end as IB_Aut from OrdCompra where RucE = @RucE and Cd_OC = @Cd_Doc
	end
	else if (@Cd_TDES = 'OP')
	begin
		select case(isnull(TipAut,0)) when 0 then 1 else isnull(IB_Aut,0) end as IB_Aut from OrdPedido where RucE = @RucE and Cd_OP = @Cd_Doc
	end
	else if (@Cd_TDES = 'SR')
	begin
		select case(isnull(TipAut,0)) when 0 then 1 else isnull(IB_Aut,0) end as IB_Aut from SolicitudReq where RucE = @RucE and Cd_SR = @Cd_Doc
	end
	else if (@Cd_TDES = 'OF')
	begin
		select case(isnull(TipAut,0)) when 0 then 1 else isnull(IB_Aut,0) end as IB_Aut from OrdFabricacion where RucE = @RucE and Cd_OF = @Cd_Doc
	end
--end
print @msj
-- CAM <Fecha de Creacion 19/01/11>
--	<El parametro @Ejer esta solo por si se llega a necesitar para los documentos que tengan ese campo. Por el momento
--	no se usa>

-- CAM 15/12/2011 se deshabilito la validacion para GMC en OC
-- Pruebas:
-- exec user321.Inv_InventarioCons_Autorizacion '20516553112',null,'OC00000004','OC',''
-- exec user321.Inv_InventarioCons_Autorizacion '11111111111',null,'OC00000060','OC',''
-- exec Inv_InventarioCons_Autorizacion '11111111111',null,'OF00000001','OF',''
-- select * from OrdFabricacion

--select * from OrdCompra where RucE = '20516553112'

GO
