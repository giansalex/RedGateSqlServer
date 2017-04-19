SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE Procedure [dbo].[Vta_Producto2_ListUM_LP]
@RucE nvarchar(11),
@Cd_LP char(10),
@Cd_Prod char(7)
As
Declare @check bit
Set @check = 0
Select 
			@check As Sel,
			Um.Id_ump As Item,
			Um.Cd_Prod As CodPro,
			Um.Cd_UM As CodUM,
			Um.DescripAlt As Descrip,
			Um.EstadoUMP,
			Um.Factor
From		
			ListaPrecioDet  As Det
Inner Join
			Prod_Um as Um
On
			Det.RucE = Um.RucE And
			Det.Cd_Prod = Um.Cd_Prod And
			Det.UMP = ID_UMP
			
Where Det.RucE = @RucE And
		Det.Cd_Prod = @Cd_Prod And
		Det.Cd_LP = @Cd_LP And
		(Det.FechaInicio is null or (year(Det.FechaInicio) <= year(getdate()) and month(Det.FechaInicio) <= month(getdate()) and day(Det.FechaInicio) <= day(getdate()))) And
		(Det.FechaFin is null or (year(Det.FechaFin) >= year(getdate()) and month(Det.FechaFin) >= month(getdate()) and day(Det.FechaFin) >= day(getdate())))
GO
