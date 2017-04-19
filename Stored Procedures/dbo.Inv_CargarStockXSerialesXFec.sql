SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE procedure [dbo].[Inv_CargarStockXSerialesXFec]
@RucE nvarchar(11),
@FecD Datetime,
@FecH Datetime,
@msj nvarchar(100) output

as

begin try

--select * from producto2 where Cd_Prod = 'PD00001' and ruce='11111111111'
--select * from inventario where Cd_Prod = 'PD00001' and ruce='11111111111'
--select * from Prod_UM where Cd_Prod = 'PD00001' and ruce='11111111111'

----------CABECERA--------------
select row_number() over (order by p.Cd_Prod asc) as sel,p.Cd_Prod,isnull(p.CodCo1_,'')as CodCo,p.Nombre1 as Nombre,'' as DescripAlt,
/*case when count(p.Nombre1) = 1 then sm.Serial else '' end*/'' as Serial,
Convert(nvarchar,count(p.Nombre1))+'.00' as [Stock Actual]
from producto2 as p 
inner join Prod_UM as pu on pu.RucE = p.RucE and pu.Cd_Prod = p.Cd_Prod
inner join inventario as i on i.RucE = p.RucE and i.Cd_Prod = p.Cd_Prod and i.ID_UMP = pu.ID_UMP
inner join Serial as s on s.RucE = p.RucE and s.RucE = i.RucE and s.Cd_Prod = p.Cd_Prod
inner join SerialMov as sm on sm.RucE = s.RucE and sm.Cd_Prod = p.Cd_Prod and sm.Serial = s.Serial and sm.Cd_Inv = i.Cd_Inv
where p.RucE = @RucE and i.Cant > 0 and s.FecSal is null and i.FecMov between @FecD and @FecH
Group by p.Cd_Prod,p.Nombre1,p.CodCo1_,i.Cant--,sm.Serial

----------DETALLE--------------
select '-->',p.Cd_Prod,isnull(p.CodCo1_,'') as CodCo,p.Nombre1 as Nombre,pu.DescripAlt,sm.Serial,'' as [Stock Actual]
from producto2 as p 
inner join Prod_UM as pu on pu.RucE = p.RucE and pu.Cd_Prod = p.Cd_Prod
inner join inventario as i on i.RucE = p.RucE and i.Cd_Prod = p.Cd_Prod and i.ID_UMP = pu.ID_UMP
inner join Serial as s on s.RucE = p.RucE and s.RucE = i.RucE and s.Cd_Prod = p.Cd_Prod
inner join SerialMov as sm on sm.RucE = s.RucE and sm.Cd_Prod = p.Cd_Prod and sm.Serial = s.Serial and sm.Cd_Inv = i.Cd_Inv
where p.RucE =@RucE and i.Cant > 0 and s.FecSal is null and i.FecMov between @FecD and @FecH
Group by p.Cd_Prod,p.Nombre1,p.CodCo1_,i.Cant,pu.DescripAlt,sm.Serial
end try

begin catch
	
	set @msj = 'Error al Cargar Stock con Seriales'
	
end catch
GO
