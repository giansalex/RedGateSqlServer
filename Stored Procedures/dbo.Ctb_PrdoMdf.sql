SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Ctb_PrdoMdf]
@RucE nvarchar(11),
@Ejer nvarchar(4),
@P00 bit,
@P01 bit,
@P02 bit,
@P03 bit,
@P04 bit,
@P05 bit,
@P06 bit,
@P07 bit,
@P08 bit,
@P09 bit,
@P10 bit,
@P11 bit,
@P12 bit,
@P13 bit,
@P14 bit,
@msj varchar(100) output
as
if not exists (select * from Periodo where RucE=@RucE and Ejer=@Ejer)
	set @msj = 'Ejercicio no existe'
else
begin
	update Periodo set P00=@P00, P01=@P01, P02=@P02,
			   P03=@P03, P04=@P04, P05=@P05,
			   P06=@P06, P07=@P07, P08=@P08,
			   P09=@P09, P10=@P10, P11=@P11,
			   P12=@P12, P13=@P13, P14=@P14
	where RucE=@RucE and Ejer=@Ejer

	if @@rowcount <= 0
	   set @msj = 'Ejercicio no pudo ser modificado'
end
print @msj
GO
