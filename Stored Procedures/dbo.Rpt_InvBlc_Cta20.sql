SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,juan Antonio Saavedra Ortiz>
-- Create date: <Create Date,19/03/2013,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Rpt_InvBlc_Cta20]
@RucE nvarchar(30),
@Ejer varchar(30),
@Cd_Mda char(2),
@FecIni datetime,
@FecFin datetime,
@Nivel int,
@msj varchar(100) output
AS

--select * from voucher where RucE='20160000001' and NroCta like '20%'

	if not exists ( select top 1 *from voucher where RucE=@RucE and Ejer=@Ejer and NroCta like '20%')
		set @msj='No se encontraron Registros de Inventario de Balances para la Cuenta 16'
	else
	BEGIN

	/*
		Detalle
		---------
		-CÓDIGO DE LA EXISTENCIA 
		-TIPO DE EXISTENCIA (TABLA 5)
		-DESCRIPCIÓN
		-CÓDIGO DE LA UNIDAD DE MEDIDA (TABLA 6)
		-CANTIDAD
		-COSTO UNITARIO
		-COSTO TOTAL		
		*/	
		
		/******************* START PROPUESTA 01 ***************************/
		--SELECT				
		--		left(vou.NroCta,@Nivel),				
		--		p.Cd_Prod as 'CodExist',
		--		p.Cd_TE as 'TipoExist',			
		--        ISNULL(p.Nombre1,ISNULL(p.Nombre1,'')) AS Descripcion,
		--        te.CodSNT_ as 'CodUM',
		--        inv.Cant as Cantidad,
		--        case(@Cd_Mda) when '01' then (inv.CosUnt) when '02' then (inv.CosUnt_ME) end as CostoUntario,
		--        case(@Cd_Mda) when '01' then (inv.Total) when '02' then (inv.Total_ME) end as Total	
		--from dbo.Inventario inv 
		--LEFT JOIN dbo.Producto2 p on inv.RucE=p.RucE and inv.Cd_Prod=p.Cd_Prod 
		--left JOIN dbo.Prod_UM PM ON  p.RucE=PM.RucE and p.Cd_Prod=PM.Cd_Prod 
		--LEFT join dbo.UnidadMedida u ON PM.Cd_UM=u.Cd_UM
		--left join dbo.TipoExistencia te ON te.Cd_TE=p.Cd_TE
		--inner join dbo.Voucher vou on inv.RucE=vou.RucE and inv.RegCtb=vou.RegCtb
		--WHERE inv.RucE=@RucE and inv.Ejer=@Ejer and vou.NroCta like '20%' and inv.FecMov BETWEEN  @FecIni and @FecFin
		
		/******************* END PROPUESTA 01 ***************************/
		----------------------------------------------------------------------------------------------------------
		/******************* START PROPUESTA 02 ***************************/
		
		select i.CodExist,i.TipoExist,i.Descripcion,i.CodUM,i.Cantidad,i.CostoUntario,i.Total 
		from voucher as v
		inner join (
			SELECT	
				inv.RegCtb,
				inv.RucE,			
				p.Cd_Prod as 'CodExist',
				p.Cd_TE as 'TipoExist',			
		        ISNULL(p.Nombre1,ISNULL(p.Nombre1,'')) AS Descripcion,
		        u.Cd_UM as 'CodUM',
		        inv.Cant as Cantidad,
		        case(@Cd_Mda) when '01' then (inv.CosUnt) when '02' then (inv.CosUnt_ME) end as CostoUntario,
		        case(@Cd_Mda) when '01' then (inv.Total) when '02' then (inv.Total_ME) end as Total	
			from dbo.Inventario inv 
			LEFT JOIN dbo.Producto2 p on inv.RucE=p.RucE and inv.Cd_Prod=p.Cd_Prod 
			left JOIN dbo.Prod_UM PM ON  p.RucE=PM.RucE and p.Cd_Prod=PM.Cd_Prod 
			LEFT join dbo.UnidadMedida u ON PM.Cd_UM=u.Cd_UM
			left join dbo.TipoExistencia te ON te.Cd_TE=p.Cd_TE		
		) as i
		on  i.RucE = v.RucE and i.RegCtb = v.RegCtb
		where v.RucE = @RucE and v.Ejer=@Ejer  and left(v.NroCta,9) like '20%' and v.FecMov BETWEEN  @FecIni and @FecFin
		
	/******************* END PROPUESTA 02 ***************************/
	/*

	select * from producto2 where 

		cabecera
		---------
		-EJERCICIO: 
		-RUC:
		-APELLIDOS Y NOMBRES, DENOMINACIÓN O RAZÓN SOCIAL:
		-MÉTODO DE EVALUACIÓN APLICADO:
	*/
	--Cabecera
	select @RucE as RucE,@Ejer as Ejer,RSocial, 
		   case(@Cd_Mda) when '01' then 'EN SOLES' when '02' then 'EN DOLARES' end as Moneda,
		   'Desde '+Convert(nvarchar,@FecIni,103) +' Hasta '+ Convert(nvarchar,@FecFin,103) as 'Prdo'
	from Empresa Where Ruc=@RucE
	

	END
GO
