SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[Inv_CantAlmAlert]
(
@RucE char(11),
@msj varchar(100) output
)
AS
BEGIN
	SET NOCOUNT ON;
	
	select count(Alm.cd_Alm) as Almacen from (select distinct i.cd_Alm
	from inventario i join producto2 p on i.Cd_Prod = p.Cd_Prod and i.RucE=p.RucE
	where i.RucE = @RucE
	Group By i.cd_Alm, p.StockAlerta
	having Sum(i.Cant)<p.StockAlerta) as Alm
	set @msj=''
END
GO
