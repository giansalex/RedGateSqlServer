SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Prd_ProdDesConsxFrmla]
@RucE nvarchar(11),
@Cd_Prod char(7),
@ID_UMP int,
@TipCons int,
@msj varchar(100) output
as
if (@TipCons =3)
begin
	select F.ID_Fmla,convert(varchar(10),F.Fecha,103) as Fecha,F.Descrip
	from Formula F 
	where F.RucE=@RucE and F.Cd_Prod=@Cd_Prod and F.ID_UMP=@ID_UMP
	order by  F.IB_Prin desc
end
print @msj
-- Leyenda --
-- FL : 2011-02-21 : <creacion del sp para ayuda del textbox de formula>



GO
