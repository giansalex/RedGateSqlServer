SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE Proc [dbo].[Vta_PrecioConsXProd_LP] 
@RucE nvarchar(11),
@Cd_LP char(10),
@Cd_Prod char(7),
@Id_UMP int,
@Cant numeric(13,2)
As
Declare @check bit
Set @check = 0

Select 
			@check As Sel,
			Det.Cd_Prod As Cd_Prod, 
			Prec.ID_Prec As Item,
			Prec.Descrip As Descrip,
			Det.Cd_Mda,
			Mda.Simbolo,
			Ump.ID_UMP As ID_UMP,
			Ump.DescripAlt As UndMed,
			Ump.Factor As Factor,
			Det.Precio As ValVta, 
			Det.* 
			
From 
			ListaPrecioDet As Det
Inner Join
			Moneda As Mda
On
			Det.Cd_Mda = Mda.Cd_Mda
Inner Join
			Precio As Prec
On
			Prec.RucE = Det.RucE And
			Prec.Cd_Prod = Det.Cd_Prod
Inner Join
			Prod_UM As Ump
On
			Ump.RucE = Det.RucE And
			Ump.Cd_Prod = Det.Cd_Prod And
			Ump.ID_UMP = Det.UMP
Where
			(Det.FechaInicio is null or (year(Det.FechaInicio) <= year(getdate()) and month(Det.FechaInicio) <= month(getdate()) and day(Det.FechaInicio) <= day(getdate()))) And
			(Det.FechaFin is null or (year(Det.FechaFin) >= year(getdate()) and month(Det.FechaFin) >= month(getdate()) and day(Det.FechaFin) >= day(getdate()))) And
			Det.Cd_LP = @Cd_LP And
			Det.RucE = @RucE And
			Det.Desde <= @Cant And
			Det.Hasta >= @Cant And Det.UMP = @Id_UMP
GO
