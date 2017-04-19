SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Com_CompraValida_NDNR]
@RucE nvarchar(11),
@Ejer nvarchar(4),
@Cd_TD nvarchar(2),
@NroSre nvarchar(5),
@NroDoc nvarchar(15),
@RegCtb nvarchar(15),
@msj varchar(100) output,
@Cd_Com char(10) output
as
if(len(@NroDoc) > 0)
	begin
		select @Cd_Com=  Cd_Com from Compra where RucE=@RucE and Cd_TD=@Cd_TD and isnull(NroSre,'')=isnull(@NroSre,'') and NroDoc=@NroDoc
		if (isnull(len(@Cd_Com),0) <= 0)
			set @msj = 'Nro Documento no pertenece a ninguna Compra'
	end
else
	begin
		select @Cd_Com=  Cd_Com from Compra where RucE=@RucE and Ejer=@Ejer and RegCtb=@RegCtb
		if (isnull(len(@Cd_Com),0) <= 0)
			set @msj = 'Nro de registro no pertenece a ninguna Compra'
	end
print @msj

-- Leyenda --
-- PP : 2010-09-03 11:38:43.777	: <Creacion del procedimiento almacenda>



GO
