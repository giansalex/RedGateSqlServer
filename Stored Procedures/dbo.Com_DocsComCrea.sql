SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROC [dbo].[Com_DocsComCrea]

@RucE nvarchar(11),
--@Id_Doc int,
@Cd_Com char(10),
@Titulo varchar(100),
@Obs varchar(1000),
@Img image,
@Ruta varchar(256),

@msj varchar(100) output

AS

-- Insertando valores

	Declare @Id_Doc int
	Set @Id_Doc = (Select (isnull(max(Id_Doc),0)+1) As Id_Doc from DocsCom where RucE=@RucE and Cd_Com=@Cd_Com)

	Insert into dbo.DocsCom(RucE,Id_Doc,Cd_Com,Titulo,Obs,Img,Ruta)
			 Values(@RucE,@Id_Doc,@Cd_Com,@Titulo,@Obs,@Img,@Ruta)

	If @@rowcount <= 0
	begin
		set @msj = 'Error al insertar documento a la compra '+@Cd_Com
	end
	
-- Leyedan --
-- DI : 19/12/2010 <Creacion del procedimiento almacenado>





GO
