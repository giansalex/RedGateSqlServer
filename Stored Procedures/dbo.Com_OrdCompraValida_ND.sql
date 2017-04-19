SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE proc [dbo].[Com_OrdCompraValida_ND]

@RucE nvarchar(11),
@NroOC varchar(50),
@msj varchar(100) output,
@Cd_OC char(10) output

as
select @Cd_OC = Cd_OC from Ordcompra where RucE = @RucE and NroOC = @NroOC
if (isnull(len(@Cd_OC),0) <= 0)
	set @msj = 'Nro Documento no pertenece a ninguna Orden de Compra'
print @msj

-- Leyenda --
-- PP : 2010-08-02 15:57:00.190	: <Creacion del procedimiento almacenado>


GO
