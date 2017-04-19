SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE proc [dbo].[Inv_CotizacionElim2]

@RucE nvarchar(11),
@NroCot varchar(15),
@UsuCrea varchar(15),
@msj varchar(100) output

as

declare @Cd_Cot char(10)
set @Cd_Cot = (select Cd_Cot from Cotizacion where RucE=@RucE and NroCot=@NroCot)

if not exists (select * from Cotizacion where RucE=@RucE and Cd_Cot=@Cd_Cot)
	begin
		set @msj = 'No existe cotizacion con el codigo :'+@Cd_Cot
	end
else if exists (select * from Ordpedido where RucE=@RucE and Cd_Cot=@Cd_Cot)
	begin
		set @msj='Cotizacion tiene Orden de Pedido Relacionada'
		
	end
else if(@UsuCrea!= (select UsuCrea from Cotizacion Where Ruce=@RucE and Cd_Cot=@Cd_Cot))
	begin
		set @msj = 'No puede eliminar la cotizacion creada por otro usuario'
	end
	else
	begin
		begin transaction	
		delete from CotizacionProdDet where RucE=@RucE and Cd_Cot=@Cd_Cot
		delete from CotizacionDet where RucE=@RucE and Cd_Cot=@Cd_Cot
		delete from AutCot where RucE=@RucE and Cd_Cot=@Cd_Cot
		delete from Cotizacion where RucE=@RucE and Cd_Cot=@Cd_Cot
		if @@rowcount <= 0
		begin
			Set @msj = 'Error al eliminar cotizacion'
			rollback transaction
			return
		end
		commit transaction
	end

print @msj
--exec Inv_CotizacionElim2 '11111111111','NRO-00000000341','acarpio',null
--select Cd_Cot from Cotizacion where RucE='11111111111' and NroCot='NRO-00000000341'

-- Leyenda --
-- DI : 05/03/2010 : <Creacion del procedimiento almacenado>
-- CO : 12/06/2012 : <correcion>
-- AC : 19/09/2012 : <correcion sangrienta>
GO
