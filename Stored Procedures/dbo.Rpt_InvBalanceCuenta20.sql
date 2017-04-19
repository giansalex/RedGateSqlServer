SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,juan Antonio Saavedra Ortiz>
-- Create date: <Create Date,19/03/2013,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Rpt_InvBalanceCuenta20]
@RucEmp nvarchar(30),
@Ejer varchar(30),
@Cd_Mda char(2),
@fechInicio datetime,
@fechFinal datetime,
@msj varchar(100) output
AS
BEGIN
		SELECT	
		
		        
		
				ISNULL(p.CodCo1_,ISNULL(p.CodCo2_,ISNULL(p.CodCo3_,''))) AS Cod_Comercial ,
		        ISNULL(p.Nombre1,ISNULL(p.Nombre1,'')) AS NombreProducto,
		        u.Nombre,
		        inv.Cant,
		        case(@Cd_Mda) when '01' then (inv.CosUnt) when '02' then (inv.CosUnt_ME) end as CostoUntario,
		        case(@Cd_Mda) when '01' then (inv.Total) when '02' then (inv.Total_ME) end as Total
		
		         

		from dbo.Inventario inv 
		LEFT JOIN dbo.Producto2 p on inv.RucE=p.RucE and inv.Cd_Prod=p.Cd_Prod 
		left JOIN dbo.Prod_UM PM ON  p.RucE=PM.RucE and p.Cd_Prod=PM.Cd_Prod 
		LEFT join dbo.UnidadMedida u ON PM.Cd_UM=u.Cd_UM
		WHERE inv.RucE=@RucEmp and inv.Ejer=@Ejer  and inv.FecMov BETWEEN  @fechInicio and @fechFinal
END
GO
