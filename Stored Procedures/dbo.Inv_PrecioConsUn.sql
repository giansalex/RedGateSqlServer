SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Inv_PrecioConsUn]
@RucE nvarchar(11),
@Id_Prec int,
@msj varchar(100) output
as
if not exists (select * from Precio where RucE=@RucE and Id_Prec = @Id_Prec)
	set @msj = 'Precio no existe'
else	select * from Precio where RucE=@RucE and Id_Prec = @Id_Prec
print @msj

-- Leyenda --
-- PP : 2010-03-04		: <Creacion del procedimiento almacenado>
-- PP : 2010-03-19 11:12:37.640	: <Modificacion del procedimiento almacenado por el Id_Prec>
GO
