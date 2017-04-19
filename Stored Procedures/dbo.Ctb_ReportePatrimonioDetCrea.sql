SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROC [dbo].[Ctb_ReportePatrimonioDetCrea]

@RucE nvarchar(11),
@Ejer nvarchar(4),
@Nombre varchar(100),
@Cd_CPtr varchar(200),
@NroCta varchar(15),
@IB_esTitulo bit,
@Formula varchar(50),
@Estado bit,
@msj varchar(100) output

AS
--if exists (Select * From ReportePatrimonioDet Where RucE=@RucE and Ejer=@Ejer and Nombre=@Nombre)
--	Set @msj = 'Existe otro registro con el mismo nombre ingresado'
--else
begin

	Declare @Cd_CPtrD nvarchar(5) Set @Cd_CPtrD=''
	Set @Cd_CPtrD = (Select right('00000'+ltrim(Convert(int,isnull(Max(Cd_CPtrD),'00000'))+1),5) From ReportePatrimonioDet Where RucE=@RucE and Ejer=@Ejer)
	
	insert into ReportePatrimonioDet(RucE,Ejer,Cd_CPtrD,Nombre,Cd_CPtr,NroCta,IB_esTitulo,Formula,Estado)
	values(@RucE,@Ejer,@Cd_CPtrD,@Nombre,@Cd_CPtr,@NroCta,@IB_esTitulo,@Formula,@Estado)
	
	if @@rowcount <= 0
	begin
		Set @msj = 'Error al registrar concepto de Detalle Estados de Cambio de Patrimonio Neto'
	end
	
end

-- Leyenda --
-- DI : 05/12/2012 <Creacion del SP>

GO
