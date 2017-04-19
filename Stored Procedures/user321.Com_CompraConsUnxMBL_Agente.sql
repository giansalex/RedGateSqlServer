SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [user321].[Com_CompraConsUnxMBL_Agente]
@RucE nvarchar(11),
@MBL varchar(100),
@msj varchar(100) output
as

if not exists (select top 1 *from Compra where RucE = @RucE and CA01 = @MBL and CA16 = 'Agente')
	set @msj='No se encontro Agentes'
else
begin
	--select * from Compra where RucE = @RucE and CA01 = @MBL and CA16 = 'Flete'
	
	select * from Compra where RucE = @RucE and CA01 = @MBL and CA16 = 'Agente'
end

-- Leyenda --
-- MP : 2011-04-29 : <Creacion del procedimiento almacenado>

GO
