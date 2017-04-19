SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE proc [dbo].[Seg_ValidarPrdo]
@RucE nvarchar(11),
@Ejer nvarchar(4),
@Prdo nvarchar(2),
@msj varchar(200) output
as

Declare @Estado bit 
	
select  @Estado = ( Case(@Prdo)
			    when '00' then P00
			    when '01' then P01
			    when '02' then P02
			    when '03' then P03
			    when '04' then P04
			    when '05' then P05
			    when '06' then P06
			    when '07' then P07
			    when '08' then P08
			    when '09' then P09
			    when '10' then P10
			    when '11' then P11
			    when '12' then P12
			    when '13' then P13
			    else P14
			end )
from Periodo 
where RucE=@RucE and Ejer=@Ejer

if (@Estado = 1)
begin
	Set @msj = 'Este proceso no se puede realizar, el mes de '+User123.DameFormPrdo(@Prdo,0,0)+' se encentra cerrado.'
end

-- Leyenda --
-- DI : 19/01/10 <Creacion del procedimiento almacenado>

GO
