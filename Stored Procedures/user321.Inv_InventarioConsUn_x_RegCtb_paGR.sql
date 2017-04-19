SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [user321].[Inv_InventarioConsUn_x_RegCtb_paGR]
@RucE nvarchar(11),
@RegCtb char(15),
@Ejer nvarchar(4),
@msj varchar(100) output
-- MENSAJES:
-- compruebo si hay varios clientes/proveedores
-- OJO: ver tema si hay clientes con NULL y otros sin NULL
as
declare @IC_ES char(1) 
select top 1 @IC_ES = IC_ES from Inventario Where RucE=@RucE and Ejer=@Ejer and RegCtb=@RegCtb
--select distinct Cd_CC,Cd_SC,Cd_SS from Inventario Where RucE=@RucE and Ejer=@Ejer and RegCtb=@RegCtb
------------
if(User123.VPrdo(@RucE,@Ejer,SubString(@RegCtb,8,2)) = 1)
	set @msj = 'Inventario no puede generar el periodo '+User123.DamePeriodo(SubString(@RegCtb,8,2))+' no se encuentra habilitado.'
------------
else if(@IC_ES is not null or @IC_ES != '')
begin
	if(@IC_ES = 'S')
  		begin
			if (select count(*) as NroClientes from (select Cd_Clt from Inventario where RucE=@RucE and Ejer=@Ejer and RegCtb=@RegCtb group by Cd_Clt) as XX) > 1
			begin 
				declare @Cd_Clt char(10),@Cd_TDI nvarchar(4), @NDoc varchar(15), @NomClt nvarchar(300)
				declare @Cd_OP char(10),@NroOP varchar(50)
				set @NomClt = 'Varios'
				set @Cd_Clt = null
				set @Cd_TDI = '00'
				set @NDoc = null

				select i.Cd_TO, i.Cd_Area, @Cd_Clt as Cd_Clt, @Cd_TDI as Cd_TDI, @NDoc as nDoc,
				@NomClt as NomClt, 
				i.Item, i.Cd_Prod, P.Nombre1, P.Descrip, UMP.ID_UMP, UM.Nombre, UMP.DescripAlt, ABS(i.Cant_Ing) as Cant,
				UMP.PesoKg,i.IC_ES, i.Cd_Vta,i.Cd_CC,i.Cd_SC,i.Cd_SS,P.CodCo1_,isnull(i.Cd_OP,'')as Cd_OP
				from Inventario as i
				left join Cliente2 as c on c.Cd_Clt = i.Cd_Clt and i.RucE = c.RucE
				left join Producto2 as P on P.RucE = i.RucE and P.Cd_Prod = i.Cd_Prod  
				left join Prod_UM as UMP on UMP.RucE = i.RucE and UMP.Cd_Prod = i.Cd_Prod and UMP.ID_UMP = i.ID_UMP
				left join UnidadMedida as UM  on UM.Cd_UM = UMP.Cd_UM
				where i.RucE = @RucE and i.Ejer = @Ejer and i.RegCtb = @RegCtb and i.Cd_Prod is not null
			end
			else 
			begin
				select i.Cd_TO, i.Cd_Area, i.Cd_Clt, c.Cd_TDI, c.NDoc,
				case(isnull(len(c.RSocial),0)) when 0 then c.ApPat +' '+ c.ApMat +' '+ c.Nom else c.RSocial end as NomClt, 
				i.Item, i.Cd_Prod, P.Nombre1, P.Descrip, UMP.ID_UMP, UM.Nombre, UMP.DescripAlt,  ABS(i.Cant_Ing) as Cant,
				--ABS(isnull((select sum(i.Cant) from GuiaRemisionDet i where i.RucE = c.RucE and i.Cd_Vta = c.Cd_Vta and i.Cd_Prod=c.Cd_Prod and i.Item = c.Nro_RegVdt),0 ))as Cant_Ing,
				--c.cant - ABS(isnull((select sum(i.Cant) from GuiaRemisionDet i where i.RucE = c.RucE and i.Cd_Vta = c.Cd_Vta and i.Cd_Prod=c.Cd_Prod and i.Item = c.Nro_RegVdt),0 ))as Pendiente,
				UMP.PesoKg,i.IC_ES,i.Cd_Vta,i.Cd_CC,i.Cd_SC,i.Cd_SS,P.CodCo1_,i.Cd_OP
				from Inventario as i
				left join Cliente2 as c on c.Cd_Clt = i.Cd_Clt and i.RucE = c.RucE
				left join Producto2 as P on P.RucE = i.RucE and P.Cd_Prod = i.Cd_Prod  
				left join Prod_UM as UMP on UMP.RucE = i.RucE and UMP.Cd_Prod = i.Cd_Prod and UMP.ID_UMP = i.ID_UMP
				left join UnidadMedida as UM  on UM.Cd_UM = UMP.Cd_UM
				where i.RucE = @RucE and i.Ejer = @Ejer and i.RegCtb = @RegCtb-- and i.Cd_Prod is not null
			end 
  		end
  	else if (@IC_ES = 'E')
  	begin
		--Aqui va el codigo para Guia de Remision de Entrada (COMPRA)
				select i.Cd_TO, i.Cd_Area, i.Cd_Prv, c.Cd_TDI, c.NDoc,
				case(isnull(len(c.RSocial),0)) when 0 then c.ApPat +' '+ c.ApMat +' '+ c.Nom else c.RSocial end as NomClt, 
				i.Item, i.Cd_Prod, P.Nombre1, P.Descrip, UMP.ID_UMP, UM.Nombre, UMP.DescripAlt,  ABS(i.Cant_Ing) as Cant,
				--ABS(isnull((select sum(i.Cant) from GuiaRemisionDet i where i.RucE = c.RucE and i.Cd_Vta = c.Cd_Vta and i.Cd_Prod=c.Cd_Prod and i.Item = c.Nro_RegVdt),0 ))as Cant_Ing,
				--c.cant - ABS(isnull((select sum(i.Cant) from GuiaRemisionDet i where i.RucE = c.RucE and i.Cd_Vta = c.Cd_Vta and i.Cd_Prod=c.Cd_Prod and i.Item = c.Nro_RegVdt),0 ))as Pendiente,
				UMP.PesoKg,i.IC_ES,i.Cd_Com,i.Cd_CC,i.Cd_SC,i.Cd_SS,P.CodCo1_
				from Inventario as i
				left join Proveedor2 as c on c.Cd_Prv = i.Cd_Prv and i.RucE = c.RucE
				left join Producto2 as P on P.RucE = i.RucE and P.Cd_Prod = i.Cd_Prod  
				left join Prod_UM as UMP on UMP.RucE = i.RucE and UMP.Cd_Prod = i.Cd_Prod and UMP.ID_UMP = i.ID_UMP
				left join UnidadMedida as UM  on UM.Cd_UM = UMP.Cd_UM
				where i.RucE = @RucE and i.Ejer = @Ejer and i.RegCtb = @RegCtb-- and i.Cd_Prod is not null

		--set @msj = 'Funcion en contruccion para Indicador E/S = ''E'''
		print @msj
  	end
	else 
	begin
		set @msj = 'El Indicador E/S es invalido'
		print @msj
	end
end
else
	begin
  		set @msj = 'No se ha definido el indicador E/S para el movimiento ingresado.'
		print @msj
	end
-- LEYENDA
-- CAM <Fecha: 29/12/2010> <Creacion del sp>
-- FL  <Fecha: 15/02/2011> <se agrego centros de costos para la guia de remision>
-- CE: 20/08/2012 Mdf: Antes de Elim/crear/Modf verificar si el periodo esta habilitado en el cierre de periodo

-- PRUEBAS
-- Para Movimiento de salida de Inventario con VARIOS clientes:
-- exec Inv_InventarioConsUn_x_RegCtb_paGR '11111111111','INGE_LD12-00183','2010',null
-- Para Movimiento de salida de Inventario con UN solo cliente
-- exec Inv_InventarioConsUn_x_RegCtb_paGR '11111111111','INGE_LD08-00057','2010',null

-- exec user321.Inv_InventarioConsUn_x_RegCtb_paGR '11111111111','INGE_LD09-00011','2012',''



-- select * from Inventario where RucE = '11111111111' and IC_ES = 'S'

GO
