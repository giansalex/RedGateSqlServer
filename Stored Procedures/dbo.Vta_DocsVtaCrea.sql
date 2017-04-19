SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROC [dbo].[Vta_DocsVtaCrea]

@RucE nvarchar(11),
--@Id_Doc int,
@Cd_Vta nvarchar(10),
@Titulo varchar(100),
@Obs varchar(1000),
@Img image,
@Ruta varchar(256),

@msj varchar(100) output

AS

-- Insertando valores

	Declare @Id_Doc int
	Set @Id_Doc = (Select (isnull(max(Id_Doc),0)+1) As Id_Doc from DocsVta where RucE=@RucE/* and Cd_Vta=@Cd_Vta*/)

	Insert into dbo.DocsVta(RucE,Id_Doc,Cd_Vta,Titulo,Obs,Img,Ruta)
			 Values(@RucE,@Id_Doc,@Cd_Vta,@Titulo,@Obs,@Img,@Ruta)

	If @@rowcount <= 0
	begin
		set @msj = 'Error al insertar documento a la venta '+@Cd_Vta
	end
	
-- Leyedan --
-- DI : 17/12/2010 <Creacion del procedimiento almacenado>


GO
