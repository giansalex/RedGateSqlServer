SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE procedure [pvo].[Vta_MayorizaVenta]
@RucE nvarchar(11),
@Ejer nvarchar(4),
@Prdo nvarchar(2),
--@RegCtb nvarchar(15),
@msj varchar(100) output
as

declare @RegCtb nvarchar(15), @NomEmp varchar(200)
declare  @Cd_Vta nvarchar(10), @resum varchar(4000), @n int, @Ind_OK varchar(10)
select @NomEmp = RSocial from Empresa where Ruc=@RucE


print 'PROCESO DE MAYORIZACION MASIVO'
print 'Empresa: ' + @RucE + ' - ' + @NomEmp
print 'Ejercicio: ' + @Ejer
print 'Periodo: ' + @Prdo
print '---------------------'
print ' '


set @resum = ''
set @n = 0
		declare Cur_Vta cursor for select RegCtb, Cd_Vta from Venta where RucE=@RucE and Eje=@Ejer and Prdo=@Prdo
		open Cur_Vta	
		     fetch Cur_Vta into @RegCtb, @Cd_Vta
			-- mientras haya datos
			while (@@fetch_status=0)
			begin

				--set @RegCtbGen = 'xxxxx'
				set @Ind_OK = 'xxxxx'
				set @msj = ''

				print '---------------------------------------  MAYORIZANDO VENTA --> ' + @RegCtb + ', ' + @Cd_Vta + ' ---------------------------------------------'
				exec pvo.Vta_MayorizaVentaUn @RucE, @Ejer, @RegCtb, @Ind_OK output, @msj output
				print 'Result: ' +  @msj
				print ' '
				set @n = @n + 1				
				set @resum = @resum  + @Cd_Vta + ' ----> ' + @RegCtb +' - '+  @Ind_OK + ' ,' + char(10)


		
			fetch Cur_Vta into @RegCtb, @Cd_Vta
			end
		close Cur_Vta
		deallocate Cur_Vta



print 'RESUMEN VENTAS PROCESADAS: ' + convert(varchar,@n)
print '----------------------------'
print 'Cd_Vta   ----> RegCtb Generado '
print @resum



------------------------
--PV: VIE 31/07/09  --> Creado
--PV: MIE 05/07/09  --> Mdf: reporte Proceso
GO
