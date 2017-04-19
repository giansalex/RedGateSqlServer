SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [User123].[DamePeriodo](@Prdo nvarchar(2)) --Me devuelve el nombre del periodo
returns nvarchar(15) AS
begin 
	Declare @nombre nvarchar(15)  
	
	select  @nombre = ( Case(@Prdo) when '00' then 'Inicial'
			    when '01' then 'Enero'
			    when '02' then 'Febrero'
			    when '03' then 'Marzo'
			    when '04' then 'Abril'
			    when '05' then 'Mayo'
			    when '06' then 'Junio'
			    when '07' then 'Julio'
			    when '08' then 'Agosto'
			    when '09' then 'Setiembre'
			    when '10' then 'Octubre'
			    when '11' then 'Noviembre'
			    when '12' then 'Diciembre'
			    when '13' then 'Ajuste'
			    else 'Cierre'
			    end
			   )
	
	return @nombre 
end



GO
