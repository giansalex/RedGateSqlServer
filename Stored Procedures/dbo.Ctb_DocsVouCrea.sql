SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROC [dbo].[Ctb_DocsVouCrea]

@RucE nvarchar(11),
--@Id_Doc int,
@RegCtb nvarchar(15),
@Titulo varchar(100),
@Obs varchar(1000),
@Img image,
@Ruta varchar(256),

@msj varchar(100) output

AS

-- Insertando valores

	Declare @Id_Doc int
	Set @Id_Doc = (Select (isnull(max(Id_Doc),0)+1) As Id_Doc from DocsVou where RucE=@RucE and RegCtb=@RegCtb)

	Insert into dbo.DocsVou(RucE,Id_Doc,RegCtb,Titulo,Obs,Img,Ruta)
			 Values(@RucE,@Id_Doc,@RegCtb,@Titulo,@Obs,@Img,@Ruta)

	If @@rowcount <= 0
	begin
		set @msj = 'Error al insertar documento del voucher '+@RegCtb
	end
	
-- Leyedan --
-- DI : 19/12/2010 <Creacion del procedimiento almacenado>
GO
