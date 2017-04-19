SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Com_ValidaOrdCompra]
@RucE nvarchar(11),
@NroOC nvarchar(15),
@Cd_OC nvarchar(10) output,
@FecEmi smalldatetime output,
@msj varchar(100) output
as
if not exists(select * from OrdCompra where RucE=@RucE and NroOC=@NroOC)
		set @msj = 'No existe la orden de compra ' + @NroOC
else 
	select @Cd_OC=Cd_OC,@FecEmi=FecE from OrdCompra where RucE=@RucE  and NroOC=@NroOC

print @msj
print @Cd_OC
print @FecEmi
-- Leyenda --
-- J : 13-12-2010 : <Creacion del procedimiento almacenado>
--Declare @Cd_OC nvarchar(10),@FecEmi smalldatetime
--exec dbo.Com_ValidaOrdCompra '11111111111','OC00000002',@Cd_OC out,@FecEmi out,null
GO
