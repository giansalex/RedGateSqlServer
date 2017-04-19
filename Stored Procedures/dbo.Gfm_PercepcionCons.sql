SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Gfm_PercepcionCons] 
@RucE nvarchar(11),
@TipCons int,
@msj varchar(100) output

as

	if(@TipCons=0)
	   select mp.Cd_PercepItem,mp.Cd_Prod,p.Nombre1,mp.PorcentajePercep,mp.TieneFechaVigencia,mp.FechaVigenciaInicio,mp.FechaVigenciaFin from MaestraPercepciones as mp 
	   left join Producto2 as p on mp.Cd_Prod=p.Cd_Prod and mp.RucE=p.RucE
	   where mp.RucE=@RucE
	  
	   
print @msj
GO
