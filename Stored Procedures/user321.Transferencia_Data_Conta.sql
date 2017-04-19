SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
--set @RucACt='20266194324'
--Logica
--exec Transferencia_Data_Conta '20507826467'(RucActual),'11111111111'(RucAReemplazar),'2010'(EjerActual),'2011'(EjerReemp)
--Ejecutar
--exec Transferencia_Data_Conta '20507826467','11111111111','2010','2010'
--20477951849
--[user321].[Transferencia_Data_Conta] '20477951849','2008',1
--[user321].[Transferencia_Data_Conta] '20477951849','2009',0
--[user321].[Transferencia_Data_Conta] '20477951849','2010',0
--[user321].[Transferencia_Data_Conta] '20477951849','2011',0
--[user321].[Transferencia_Data_Conta] '20477951849','2012',0
CREATE Procedure [user321].[Transferencia_Data_Conta]
@RucEReemp nvarchar(11),
@EjerReemp varchar(4),
@ImpNue bit
as
declare @Var nvarchar(4000)
declare @var2 nvarchar(4000)

--planctas
--Usu123_1
print 'PlanCtas'
exec user321.Proc_Transf_PlanCtas @RucEReemp,@RucEReemp,@EjerReemp,'NetServer','Usu123_1','user123'

print 'EndPlanCtas'
--AmarreCta
print 'AmarreCta'
exec user321.Proc_Transf_AmarreCta @RucEReemp,@EjerReemp

print 'EndAmarreCta'
--PlanCtasDef

print 'PlanCtasDef'
exec user321.Proc_Transf_PlanCtasDef @RucEReemp,@EjerReemp
print 'EndPlanCtasDef'


	
	print 'Cliente'
	exec user321.Proc_Transf_Cli @RucEReemp
	exec user321.Proc_Transf_ClienteRestantes @RucEReemp
	print 'EndCliente'

	print 'Proveedor'
	exec user321.Proc_Transf_Prov @RucEReemp
	print 'EndProveedor'

	print 'Vendedor'
	exec user321.Proc_Transf_Vend @RucEReemp
	print 'EndVendedor'


	print 'Area'
	exec user321.Proc_Transf_Area @RucEReemp
	print 'EndArea'
	
	print 'Serie'
	exec user321.Proc_Transf_Serie @RucEReemp
	print 'EndSerie'
	
	print 'Series por Area'
	exec user321.Proc_Transf_SeriesXArea @RucEReemp
	print 'End Series por Area'
	
	print 'Numeracion'
	exec user321.Proc_Transf_Numeracion @RucEReemp
	print 'EndNumeracion'
	
	print 'GrupoSrv'
	exec user321.Proc_Transf_GrupoSrv @RucEReemp
	print 'EndGrupoSrv'
	
if(@ImpNue=1)
begin


	print 'Centro Costo'
	exec user321.Proc_Transf_CCosto @RucEReemp
	print 'EndCentroCosto'
 
	print 'SubCentro'
	exec user321.Proc_Transf_CCSub @RucEReemp
	print 'EndSubCentro'

	print 'SubSubCentro'
	exec user321.Proc_Transf_CCSubSub @RucEReemp
	print 'EndSubSubCentro'
	
	print 'Insertando Motivo Ingreso Salida'
	insert into MtvoIngSal(RucE,Cd_MIS,Descrip,Cd_TM,Estado,Tutorial,IC_ES)
			values(@RucEReemp,'001','Venta','01',1,null,null)
	print 'End Insertando Motivo Ingreso Salida'
End

	print 'Servicio'
	exec user321.Proc_Transf_Servicio @RucEReemp
	print 'EndServicio'
	
if(@ImpNue=1)
Begin
	Print 'Precio Servicio'
	exec user321.Proc_Transf_PrecioSrv @RucEReemp
	Print 'End Precio Servicio'
End
	--Banco
print 'Banco'

exec user321.Proc_Transf_Banco @RucEReemp,@EjerReemp

print 'EndBanco'

-- Ventas

--Transfiriendo Ventas
--Cabecera
print 'Periodo'

exec user321.Proc_Transf_Prdo @RucEReemp,@EjerReemp

print 'endPeriodo'

print 'Venta Cabecera'
exec user321.Proc_Trans_VentaCab @RucEReemp,@EjerReemp
--Modificar Cliente y Vendedor de la Cabecera de Venta
exec user321.Proc_Trans_Mod_CltVdr_VtaCab @RucEReemp,@EjerReemp
print 'EndVenta Cabecera'

--Detalle Actualizado
print 'Venta Detalle'
exec user321.Proc_Transf_VentaDet @RucEReemp,@EjerReemp
print 'EndVenta Detalle'

 --Voucher

print 'Voucher'
--Importacion total Voucher
exec user321.Proc_Transf_Voucher @RucEReemp,@EjerReemp

--Actualizacion de Voucher
exec dbo.Proc_Transf_Mod_Voucher @RucEReemp, @EjerReemp

print 'EndVoucher'


--Proceso para modificar el ultimo ruc reemplazado, para saber que ruc es.
--set @Var=(select replace((select replace((select text from Syscomments a inner join SysObjects b on a.id=b.id where b.Name='Proc_Transf_UltRuc'),@RucAct,@RucEReemp)),'create','alter'))
--Exec (@Var)

--Series por Area
--set @var=(select replace((select replace((select text from Syscomments a inner join SysObjects b on a.id=b.id where b.Name='Proc_Transf_SeriesXArea'),@RucACt,@RucEReemp)),'create','alter'))
--exec(@var)
--exec Proc_Transf_SeriesXArea

--Producto
--set @var=(select replace((select replace((select text from Syscomments a inner join SysObjects b on a.id=b.id where b.Name='Proc_Transf_Producto'),@RucACt,@RucEReemp)),'create','alter'))
--exec(@var)
--exec Proc_Transf_Producto

--Clase
--set @var=(select replace((select replace((select text from Syscomments a inner join SysObjects b on a.id=b.id where b.Name='Proc_Transf_Clase'),@RucACt,@RucEReemp)),'create','alter'))
--exec(@var)
--exec Proc_Transf_Clase

--SubClase
--set @var=(select replace((select replace((select text from Syscomments a inner join SysObjects b on a.id=b.id where b.Name='Proc_Transf_ClaseSub'),@RucACt,@RucEReemp)),'create','alter'))
--exec(@var)
--exec Proc_Transf_ClaseSub

--SubSubClase
--set @var=(select replace((select replace((select text from Syscomments a inner join SysObjects b on a.id=b.id where b.Name='Proc_Transf_ClaseSubSub'),@RucACt,@RucEReemp)),'create','alter'))
--exec(@var)
--exec Proc_Transf_ClaseSubSub

--Leyenda
--JJ  11/01/2010:<Creacion del Procedimiento>
--JJ  11/01/2010:<Modificacion del Procedimiento>: se reordeno el proceso de transferencia, 
--segun analisis revisado por marco y pablo
GO
