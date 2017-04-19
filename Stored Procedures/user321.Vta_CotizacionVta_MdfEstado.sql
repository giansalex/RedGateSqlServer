SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
Create procedure [user321].[Vta_CotizacionVta_MdfEstado]
@RucE nvarchar(11),
@Cd_Cot char(10),
@Id_EstC char(2),
@msj varchar(100) output
as

--Actualizar el estado de la Cotización
update Cotizacion
set Id_EstC = @Id_EstC
where RucE = @RucE and Cd_Cot = @Cd_Cot

if(@@rowcount = 0)
	set @msj = 'No se pudo modificar el estado de la Cotizacón'


GO
