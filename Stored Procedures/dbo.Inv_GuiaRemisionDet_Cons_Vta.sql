SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Inv_GuiaRemisionDet_Cons_Vta]
@RucE nvarchar(11),
@Cd_GR char(10),
@msj varchar(100) output
as
begin
		select Cd_TD,FecEmi,Cd_Clt,Cd_Area,Obs,Cd_CC,Cd_SC,Cd_SS from GuiaRemision 
		where RucE = @RucE and Cd_GR=@Cd_GR
end
--print @msj
GO
