SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Vta_VentaValida_NDNR]
@RucE nvarchar(11),
@Ejer nvarchar(4),
@Cd_TD nvarchar(2),
@NroSre nvarchar(5),
@NroDoc nvarchar(15),
@RegCtb nvarchar(15),
@msj varchar(100) output,
@Cd_Vta nvarchar(10) output
as

Declare @Cd_Sr nvarchar(5)
if(len(@NroDoc) > 0)
	begin
		--select @Cd_Sr=Cd_Sr from Serie where RucE=@RucE and NroSerie=@NroSre and Cd_TD = @Cd_TD
		select @Cd_Vta= Cd_Vta from Venta where RucE=@RucE and Cd_TD=@Cd_TD and NroSre=@NroSre and NroDoc=@NroDoc
		if (isnull(len(@Cd_Vta),0) <= 0)
			set @msj = 'Nro Documento no pertenece a ninguna venta'
	end
else
	begin
		select @Cd_Vta= Cd_Vta from Venta where RucE=@RucE and Eje=@Ejer and RegCtb=@RegCtb
		if (isnull(len(@Cd_Vta),0) <= 0)
			set @msj = 'Nro de registro no pertenece a ninguna venta'
	end
print @msj


-- Leyenda --
-- PP : 2010-04-05 12:45:00.650	: <Creacion del procedimiento almacenda>
-- PP : 2010-04-07 13:14:47.020	: <Modificacion debido a @Cd_Vta>
GO
