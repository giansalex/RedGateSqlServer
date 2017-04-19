SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [pvo].[Vta_MayorizaCobro]
@RucE nvarchar(11),
@Ejer nvarchar(4),
@Prdo nvarchar(2),
--@RegCtb nvarchar(15),
@msj varchar(100) output
as

--declare @RegCtb nvarchar(15), @NomEmp varchar(200)
declare @ItmCo int, @Cd_Vta nvarchar(10), @NomEmp varchar(200), @resum varchar(4000), @n int
declare @RegCtbGen nvarchar(15) --> recojera el registro contable generado

select @NomEmp = RSocial from Empresa where Ruc=@RucE
print 'PROCESO DE MAYORIZACION MASIVO DE COBRANZAS'
print 'Empresa: ' + @RucE + ' - ' + @NomEmp
print 'Ejercicio: ' + @Ejer
print 'Periodo: ' + @Prdo
print '---------------------'
print ' '

set @resum = ''
set @n = 0
		declare Cur_Vta cursor for select ItmCo, c.Cd_Vta from Cobro c, Venta v where c.RucE=@RucE and c.RucE=v.RucE and c.Cd_Vta=v.Cd_Vta and v.Eje=@Ejer and v.Prdo=@Prdo -- and c.Cd_Vta='VT00000104'
		open Cur_Vta	
		     fetch Cur_Vta into @ItmCo, @Cd_Vta
			-- mientras haya datos
			while (@@fetch_status=0)
			begin
				set @RegCtbGen = 'xxxxx'
				set @msj = ''

				print '---------------------------------------  MAYORIZANDO COBRANZA --> ' + convert(varchar,@ItmCo) + ' ---------------------------------------------'-- + @RegCtb
				exec pvo.Vta_MayorizaCobroUn @RucE, @Ejer, @ItmCo, @RegCtbGen output, @msj output
				print 'Result: ' +  @msj
				print ' '
				set @n = @n + 1				
				set @resum = @resum  + convert(varchar,@ItmCo) +' - '+  @Cd_Vta + ' ----> ' + @RegCtbGen +  ',' + char(10)
			fetch Cur_Vta into @ItmCo, @Cd_Vta
			end
		close Cur_Vta
		deallocate Cur_Vta


print 'RESUMEN COBRANZAS PROCESADAS: ' + convert(varchar,@n)
print '----------------------------'
print 'ItmCo -  Cd_Vta  ----> RegCtb Generado '
print @resum


------------------------
--PV: MAR 04/08/09  --> Creado
GO
