SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE proc [dbo].[Inv_Lote_Explo_PagSig]
@RucE nvarchar(11),
@NroLote varchar(10),
----------------------
@msj varchar(100) output
as
if(@NroLote is null or @NroLote = '')
begin
	select l.RucE,l.Cd_Lote,l.NroLote,l.Descripcion,isnull(l.FecCaducidad,'01/01/1900') as FecCaducidad,
	i.RegCtb,
	isnull(i.Cd_Prod,'-') as Cd_Prod, isnull(p.CodCo1_,'-') as CodCo1_, isnull(p.Descrip,'-') as Descrip, SUM( isnull(i.cant,0)) as Cant
	from Lote l
	left join Inventario i on l.RucE=i.RucE and l.Cd_Lote = i.Cd_Lote
	left join Producto2 p on p.RucE = l.RucE and p.Cd_Prod = i.Cd_Prod
	where l.RucE = @RucE
	group by l.RucE,l.Cd_Lote,l.NroLote,l.Descripcion, l.FecCaducidad,i.RegCtb,
	i.Cd_Prod, p.CodCo1_, p.Descrip, i.cant
end
else
begin
	select l.RucE,l.Cd_Lote,l.NroLote,l.Descripcion,isnull(l.FecCaducidad,'01/01/1900') as FecCaducidad,
	i.RegCtb,
	isnull(i.Cd_Prod,'-') as Cd_Prod, isnull(p.CodCo1_,'-') as CodCo1_, isnull(p.Descrip,'-') as Descrip, SUM( isnull(i.cant,0)) as Cant
	from Lote l
	left join Inventario i on l.RucE=i.RucE and l.Cd_Lote = i.Cd_Lote
	left join Producto2 p on p.RucE = l.RucE and p.Cd_Prod = i.Cd_Prod
	where l.RucE = @RucE and l.NroLote = @NroLote
	group by l.RucE,l.Cd_Lote,l.NroLote,l.Descripcion, l.FecCaducidad,i.RegCtb,
	i.Cd_Prod, p.CodCo1_, p.Descrip, i.cant
end
-- LEYENDA
-- CAM
-- exec Inv_Lote_Explo_PagSig '11111111111','',''
GO
