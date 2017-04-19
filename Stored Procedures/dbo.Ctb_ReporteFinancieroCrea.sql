SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE PROC [dbo].[Ctb_ReporteFinancieroCrea]

@RucE nvarchar(11),
@Ejer nvarchar(4),
@Cd_REF nvarchar(5),
@Nombre varchar(100),
@Descrip varchar(200),
@NCorto	nvarchar(10),
@Estado	bit,
@msj varchar(100) output		

AS

if exists (Select * From ReporteFinanciero Where RucE=@RucE and Ejer=@Ejer and Cd_REF=@Cd_REF)
	Set @msj = 'Ya existe informacion con el mismo codigo indicado'
else
begin
	insert into ReporteFinanciero(RucE,Ejer,Cd_REF,Nombre,Descrip,NCorto,Estado)
		                   values(@RucE,@Ejer,@Cd_REF,@Nombre,@Descrip,@NCorto,@Estado)
		                   
	if @@rowcount <= 0
		Set @msj = 'No se pudo crear reporte financiero'
end

-- Leyenda --
-- DI : 10/09/2012 <Creacion del SP>

GO
