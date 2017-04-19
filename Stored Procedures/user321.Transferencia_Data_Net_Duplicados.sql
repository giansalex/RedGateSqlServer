SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
--exec user321.Transferencia_Data_Net_Duplicados '20379028455','2009'
CREATE Procedure [user321].[Transferencia_Data_Net_Duplicados]
@RucEReemp nvarchar(11),
@EjerReemp varchar(4)
as
declare @Var nvarchar(4000)
declare @var2 nvarchar(4000)

--planctas
print 'PlanCtas'
exec user321.Proc_Transf_PlanCtas @RucEReemp,@EjerReemp
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
print 'Centro Costo'
exec user321.Proc_Transf_CCosto @RucEReemp
print 'EndCentroCosto'
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
	
--if(@ImpNue=1)
--begin
--	print 'SubCentro'
--	exec user321.Proc_Transf_CCSub @RucEReemp
--	print 'EndSubCentro'

--	print 'SubSubCentro'
--	exec user321.Proc_Transf_CCSubSub @RucEReemp
--	print 'EndSubSubCentro'
	
--	print 'Insertando Motivo Ingreso Salida'
--	insert into MtvoIngSal(RucE,Cd_MIS,Descrip,Cd_TM,Estado,Tutorial,IC_ES)
--			values(@RucEReemp,'001','Venta','01',1,null,null)
--	print 'End Insertando Motivo Ingreso Salida'
--End
print 'Servicio'
exec user321.Proc_Transf_Servicio @RucEReemp
print 'EndServicio'
Print 'Precio Servicio'
exec user321.Proc_Transf_PrecioSrv @RucEReemp
Print 'End Precio Servicio'
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
exec user321.Proc_Trans_Venta_EmpDuplicadas @RucEReemp,@EjerReemp
--Modificar Cliente y Vendedor de la Cabecera de Venta
exec user321.Proc_Trans_Mod_CltVdr_VtaCab @RucEReemp,@EjerReemp
print 'EndVenta Cabecera'

 --Voucher

print 'Voucher'
--Importacion total Voucher
exec dbo.Proc_Transf_Voucher_Emp_Duplic @RucEReemp,@EjerReemp

----Actualizacion de Voucher
--exec dbo.Proc_Transf_Mod_Voucher @RucEReemp, @EjerReemp
print 'EndVoucher'

--Leyenda
--JJ  11/01/2011:<Creacion del Procedimiento>
--JJ  11/01/2011:<Modificacion del Procedimiento>: se reordeno el proceso de transferencia, 
--segun analisis revisado por marco y pablo
GO
