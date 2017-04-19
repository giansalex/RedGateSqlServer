SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE  procedure [dbo].[Inv_InventarioCons_SaldoxAlm_2]

@RucE nvarchar(11),
@Cd_Prod char(7),
@Cd_Alm varchar(10),
@Id_UMP int,
@msj varchar(100) output
as

declare @SumCantBase numeric(13, 3)
set @SumCantBase = (select isnull(SUM(cant),0) FROM dbo.Inventario 
where RucE = @RucE and Cd_Prod = @Cd_Prod and Cd_Alm = @Cd_Alm )

select isnull(SUM(Cant_ing),0)  as CantAlm,@SumCantBase as CantBase FROM dbo.Inventario
where RucE = @RucE and Cd_Prod = @Cd_Prod and Cd_Alm = @Cd_Alm and 
Id_UMP = @Id_UMP

/*
if exists (select * FROM dbo.Inventario where RucE = @RucE and Cd_Prod = @Cd_Prod and Cd_Alm = @Cd_Alm and Id_UMP = @Id_UMP)
select isnull(SUM(Cant_ing),0)  as CantAlm, isnull(SUM(cant),0) as CantBase FROM dbo.Inventario 
where RucE = @RucE and Cd_Prod = @Cd_Prod and Cd_Alm = @Cd_Alm and Id_UMP = @Id_UMP
GROUP BY ID_UMP
else
select 0.000 as CantAlm,0.000 as CantBase */

-- Leyenda
-- CAM <Creacion del SP><Fecha desconocida>
-- Inv_InventarioCons_SaldoxAlm_2 '11111111111','PD00001','A00',14,''
-- exec Inv_InventarioCons_SaldoxAlm_2 '11111111111','PD00084','A00',2,''
GO
