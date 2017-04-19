SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Com_TipoMovCons]
@RucE nvarchar(11),
@TipMov int,
@msj varchar(100) output
as
declare @check bit
	set @check=0
if(@TipMov=0)
	select distinct @check as Sel,c.FecMov,c.RegCtb,c.Cd_Mis,m.Descrip,c.Cd_TD,c.NroSre,c.NroDoc,c.Cd_Com,c.Ejer from compra c
	inner join MtvoIngSal as m on m.RucE=c.RucE and m.Cd_Mis=c.Cd_Mis
	where c.RucE=@RucE
else if(@TipMov=1) 
	select distinct @check as Sel,i.FecMov,i.RegCtb,i.Cd_MIS,m.Descrip,i.Cd_TD,i.NroSre,i.NroDoc,i.Cd_Com,i.Ejer from inventario i
	inner join MtvoIngSal as m on m.RucE=i.RucE and m.Cd_Mis=i.Cd_Mis
	where i.RucE=@RucE
else if(@TipMov=2)
	--Falta Agregar La de Ventas
	
print @msj

-- Leyenda --
-- FL : 2010-08-25 : <Creacion del procedimiento almacenado>
GO
