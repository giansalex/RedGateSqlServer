SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [User123].[DameFormPrdo](@Prdo nvarchar(2),@May bit,@Abr bit) --Me devuelve el nombre del periodo
		         --(Mes/Mayuscula/Abreviado)
returns nvarchar(15) AS
begin 
	Declare @nombre nvarchar(15)  
	
	select  @nombre = ( Case(@Prdo) 
			    when '00' then Case(@May) when 1 then Case(@Abr) when 1 then Upper(left('Inicial',3)) else Upper('Inicial') end else Case(@Abr) when 1 then left('Inicial',3) else 'Inicial' end end
			    when '01' then Case(@May) when 1 then Case(@Abr) when 1 then Upper(left('Enero',3)) else Upper('Enero') end else Case(@Abr) when 1 then left('Enero',3) else 'Enero' end end
			    when '02' then Case(@May) when 1 then Case(@Abr) when 1 then Upper(left('Febrero',3)) else Upper('Febrero') end else Case(@Abr) when 1 then left('Febrero',3) else 'Febrero' end end
			    when '03' then Case(@May) when 1 then Case(@Abr) when 1 then Upper(left('Marzo',3)) else Upper('Marzo') end else Case(@Abr) when 1 then left('Marzo',3) else 'Marzo' end end
			    when '04' then Case(@May) when 1 then Case(@Abr) when 1 then Upper(left('Abril',3)) else Upper('Abril') end else Case(@Abr) when 1 then left('Abril',3) else 'Abril' end end
			    when '05' then Case(@May) when 1 then Case(@Abr) when 1 then Upper(left('Mayo',3)) else Upper('Mayo') end else Case(@Abr) when 1 then left('Mayo',3) else 'Mayo' end end
			    when '06' then Case(@May) when 1 then Case(@Abr) when 1 then Upper(left('Junio',3)) else Upper('Junio') end else Case(@Abr) when 1 then left('Junio',3) else 'Junio' end end
			    when '07' then Case(@May) when 1 then Case(@Abr) when 1 then Upper(left('Julio',3)) else Upper('Julio') end else Case(@Abr) when 1 then left('Julio',3) else 'Julio' end end
			    when '08' then Case(@May) when 1 then Case(@Abr) when 1 then Upper(left('Agosto',3)) else Upper('Agosto') end else Case(@Abr) when 1 then left('Agosto',3) else 'Agosto' end end
			    when '09' then Case(@May) when 1 then Case(@Abr) when 1 then Upper(left('Septiembre',3)) else Upper('Septiembre') end else Case(@Abr) when 1 then left('Septiembre',3) else 'Septiembre' end end
			    when '10' then Case(@May) when 1 then Case(@Abr) when 1 then Upper(left('Octubre',3)) else Upper('Octubre') end else Case(@Abr) when 1 then left('Octubre',3) else 'Octubre' end end
			    when '11' then Case(@May) when 1 then Case(@Abr) when 1 then Upper(left('Noviembre',3)) else Upper('Noviembre') end else Case(@Abr) when 1 then left('Noviembre',3) else 'Noviembre' end end
			    when '12' then Case(@May) when 1 then Case(@Abr) when 1 then Upper(left('Diciembre',3)) else Upper('Diciembre') end else Case(@Abr) when 1 then left('Diciembre',3) else 'Diciembre' end end
			    when '13' then Case(@May) when 1 then Case(@Abr) when 1 then Upper(left('Ajuste',3)) else Upper('Ajuste') end else Case(@Abr) when 1 then left('Ajuste',3) else 'Ajuste' end end
			    else Case(@May) when 1 then Case(@Abr) when 1 then Upper(left('Cierre',3)) else Upper('Cierre') end else Case(@Abr) when 1 then left('Cierre',3) else 'Cierre' end end
			    end
			   )
	
	return @nombre 
end




GO
