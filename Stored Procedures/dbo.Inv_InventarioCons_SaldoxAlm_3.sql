SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE  procedure [dbo].[Inv_InventarioCons_SaldoxAlm_3]

@RucE nvarchar(11),
@Cd_Prod char(7),
@Cd_Alm varchar(10),
@Id_UMP int,
@FecMov datetime,
@msj varchar(100) output
as

declare @SumCantBase numeric(13, 3)
set @SumCantBase = (select isnull(SUM(cant),0) FROM dbo.Inventario 
where RucE = @RucE and Cd_Prod = @Cd_Prod and Cd_Alm = @Cd_Alm and FecMov <= @FecMov and isnull(TipNC,'') != 'DS'  )

select isnull(SUM(Cant_ing),0)  as CantAlm,@SumCantBase as CantBase FROM dbo.Inventario
where RucE = @RucE and Cd_Prod = @Cd_Prod and Cd_Alm = @Cd_Alm and 
Id_UMP = @Id_UMP and FecMov <= @FecMov and isnull(TipNC,'') != 'DS' 

-- Leyenda
-- CAM <Creacion del SP><Fecha desconocida>
-- Inv_InventarioCons_SaldoxAlm_2 '11111111111','PD00001','A00',14,''
-- exec Inv_InventarioCons_SaldoxAlm_2 '11111111111','PD00084','A00',2,''
-- EPSILOWER < Se agrego la  fecha!  para  mejorar la consulta>
-- exec Inv_InventarioCons_SaldoxAlm_3 '11111111111','PD00001','A00',2,'01/01/2011', ''
/*
declare @valor datetime
set @valor = convert(datetime,'17/02/2012 05:31:53 p.m.')
exec Inv_InventarioCons_SaldoxAlm_3 '20516553112','PD00002','A01',1, @valor, ''
*/
GO
